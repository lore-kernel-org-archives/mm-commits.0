From: akpm@linux-foundation.org
Subject: - git-gfs2-nmw.patch removed from -mm tree
Date: Thu, 08 May 2008 13:30:14 -0700
Message-ID: <200805082030.m48KUEZv004373@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754957AbYEHUas (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 16:30:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, andy@andrewprice.me.uk, rpeterso@redhat.com, swhiteho@redhat.com, mm-commits@vger.kernel.org


The patch titled
     git-gfs2-nmw.patch
has been removed from the -mm tree.  Its filename was
     git-gfs2-nmw.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-gfs2-nmw.patch

GIT 7766286a9fb4dd22c7fce867268180b9fe3eb199 git+ssh://master.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git

commit 7766286a9fb4dd22c7fce867268180b9fe3eb199
Author: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date:   Fri May 2 14:25:22 2008 +0100

    [GFS2] Fix use of English
    
    According to the OED and also confirmed by the British Computer Society
    folks the correct verb form is "to journali[sz]e". The US favours the "s"
    form and the BCS likewise. Bring GFS2 into line with English.
    
    Documentation changes only
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

commit 2d97a97da7d6511cd556c5f20ba05b3ff7acfe14
Author: Andrew Price <andy@andrewprice.me.uk>
Date:   Thu May 1 11:55:38 2008 +0100

    [GFS2] Fix cast from unsigned int to s64
    
    This fixes bz 444829 where allocating a new block caused gfs2 file systems to
    report 0 bytes used in df. It was caused by a broken cast from an unsigned int
    in gfs2_block_alloc() to a negative s64 in gfs2_statfs_change(). This patch
    casts the unsigned int to an s64 before the unary minus is applied.
    
    Signed-off-by: Andrew Price <andy@andrewprice.me.uk>
    Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

commit f8ff518eae51d5a4b0619ffa8f59b71551ccfabc
Author: Bob Peterson <rpeterso@redhat.com>
Date:   Tue Apr 29 12:35:48 2008 -0500

    [GFS2] filesystem consistency error from do_strip
    
    This patch fixes a GFS2 filesystem consistency error reported from
    function do_strip.  The problem was caused by a timing window
    that allowed two vfs inodes to be created in memory that point
    to the same file.  The problem is fixed by making the vfs's
    iget_test, iget_set mechanism check and set a new bit in the
    in-core gfs2_inode structure while the vfs inode spin_lock is held.
    
    Signed-off-by: Bob Peterson <rpeterso@redhat.com>
    Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
 fs/gfs2/bmap.c      |    4 ++--
 fs/gfs2/glops.c     |    2 +-
 fs/gfs2/incore.h    |    5 +++--
 fs/gfs2/inode.c     |   10 +++++-----
 fs/gfs2/log.c       |    8 ++++----
 fs/gfs2/lops.c      |    2 +-
 fs/gfs2/meta_io.c   |    6 ++++--
 fs/gfs2/ops_file.c  |    2 +-
 fs/gfs2/ops_super.c |   16 +++++++++-------
 fs/gfs2/rgrp.c      |    2 +-
 10 files changed, 31 insertions(+), 26 deletions(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index c19184f..0bb71cd 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1025,11 +1025,11 @@ static int trunc_start(struct gfs2_inode *ip, u64 size)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct buffer_head *dibh;
-	int journaled = gfs2_is_jdata(ip);
+	int journalised = gfs2_is_jdata(ip);
 	int error;
 
 	error = gfs2_trans_begin(sdp,
-				 RES_DINODE + (journaled ? RES_JDATA : 0), 0);
+			 RES_DINODE + (journalised ? RES_JDATA : 0), 0);
 	if (error)
 		return error;
 
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index d31bada..07d84d1 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -249,7 +249,7 @@ static int inode_go_lock(struct gfs2_holder *gh)
 	struct gfs2_inode *ip = gl->gl_object;
 	int error = 0;
 
-	if (!ip)
+	if (!ip || (gh->gh_flags & GL_SKIP))
 		return 0;
 
 	if (test_bit(GIF_INVALID, &ip->i_flags)) {
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 9c2c0b9..eabb5c2 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -236,6 +236,7 @@ enum {
 	GIF_INVALID		= 0,
 	GIF_QD_LOCKED		= 1,
 	GIF_SW_PAGED		= 3,
+	GIF_USER                = 4, /* user inode, not metadata addr space */
 };
 
 struct gfs2_dinode_host {
@@ -478,7 +479,7 @@ struct gfs2_sbd {
 	u32 sd_fsb2bb_shift;
 	u32 sd_diptrs;	/* Number of pointers in a dinode */
 	u32 sd_inptrs;	/* Number of pointers in a indirect block */
-	u32 sd_jbsize;	/* Size of a journaled data block */
+	u32 sd_jbsize;	/* Size of a journalised data block */
 	u32 sd_hash_bsize;	/* sizeof(exhash block) */
 	u32 sd_hash_bsize_shift;
 	u32 sd_hash_ptrs;	/* Number of pointers in a hash block */
@@ -486,7 +487,7 @@ struct gfs2_sbd {
 	u32 sd_max_dirres;	/* Max blocks needed to add a directory entry */
 	u32 sd_max_height;	/* Max height of a file's metadata tree */
 	u64 sd_heightsize[GFS2_MAX_META_HEIGHT + 1];
-	u32 sd_max_jheight; /* Max height of journaled file's meta tree */
+	u32 sd_max_jheight; /* Max height of journalised file's meta tree */
 	u64 sd_jheightsize[GFS2_MAX_META_HEIGHT + 1];
 
 	struct gfs2_args sd_args;	/* Mount arguments */
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 3a9ef52..09453d0 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -47,8 +47,7 @@ static int iget_test(struct inode *inode, void *opaque)
 	struct gfs2_inode *ip = GFS2_I(inode);
 	u64 *no_addr = opaque;
 
-	if (ip->i_no_addr == *no_addr &&
-	    inode->i_private != NULL)
+	if (ip->i_no_addr == *no_addr && test_bit(GIF_USER, &ip->i_flags))
 		return 1;
 
 	return 0;
@@ -61,6 +60,7 @@ static int iget_set(struct inode *inode, void *opaque)
 
 	inode->i_ino = (unsigned long)*no_addr;
 	ip->i_no_addr = *no_addr;
+	set_bit(GIF_USER, &ip->i_flags);
 	return 0;
 }
 
@@ -86,7 +86,7 @@ static int iget_skip_test(struct inode *inode, void *opaque)
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_skip_data *data = opaque;
 
-	if (ip->i_no_addr == data->no_addr && inode->i_private != NULL){
+	if (ip->i_no_addr == data->no_addr && test_bit(GIF_USER, &ip->i_flags)){
 		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE)){
 			data->skipped = 1;
 			return 0;
@@ -105,6 +105,7 @@ static int iget_skip_set(struct inode *inode, void *opaque)
 		return 1;
 	inode->i_ino = (unsigned long)(data->no_addr);
 	ip->i_no_addr = data->no_addr;
+	set_bit(GIF_USER, &ip->i_flags);
 	return 0;
 }
 
@@ -166,7 +167,7 @@ void gfs2_set_iop(struct inode *inode)
  * Returns: A VFS inode, or an error
  */
 
-struct inode *gfs2_inode_lookup(struct super_block *sb, 
+struct inode *gfs2_inode_lookup(struct super_block *sb,
 				unsigned int type,
 				u64 no_addr,
 				u64 no_formal_ino, int skip_freeing)
@@ -187,7 +188,6 @@ struct inode *gfs2_inode_lookup(struct super_block *sb,
 
 	if (inode->i_state & I_NEW) {
 		struct gfs2_sbd *sdp = GFS2_SB(inode);
-		inode->i_private = ip;
 		ip->i_no_formal_ino = no_formal_ino;
 
 		error = gfs2_glock_get(sdp, no_addr, &gfs2_inode_glops, CREATE, &ip->i_gl);
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 548264b..443d2be 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -380,7 +380,7 @@ static inline unsigned int log_distance(struct gfs2_sbd *sdp, unsigned int newer
  *
  * This is complex.  We need to reserve room for all our currently used
  * metadata buffers (e.g. normal file I/O rewriting file time stamps) and 
- * all our journaled data buffers for journaled files (e.g. files in the 
+ * all our journalised data buffers for journalised files (e.g. files in the 
  * meta_fs like rindex, or files for which chattr +j was done.)
  * If we don't reserve enough space, gfs2_log_refund and gfs2_log_flush
  * will count it as free space (sd_log_blks_free) and corruption will follow.
@@ -389,9 +389,9 @@ static inline unsigned int log_distance(struct gfs2_sbd *sdp, unsigned int newer
  * type gets its own log header, for which we need to reserve a block.
  * In fact, each type has the potential for needing more than one header 
  * in cases where we have more buffers than will fit on a journal page.
- * Metadata journal entries take up half the space of journaled buffer entries.
- * Thus, metadata entries have buf_limit (502) and journaled buffers have
- * databuf_limit (251) before they cause a wrap around.
+ * Metadata journal entries take up half the space of journalised buffer
+ * entries. Thus, metadata entries have buf_limit (502) and journalised
+ * buffers have databuf_limit (251) before they cause a wrap around.
  *
  * Also, we need to reserve blocks for revoke journal entries and one for an
  * overall header for the lot.
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 4390f6f..76b9f75 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -484,7 +484,7 @@ static void rg_lo_after_commit(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
  * i) In ordered write mode
  *    We put the data buffer on a list so that we can ensure that its
  *    synced to disk at the right time
- * ii) In journaled data mode
+ * ii) In journalised data mode
  *    We need to journal the data block in the same way as metadata in
  *    the functions above. The difference is that here we have a tag
  *    which is two __be64's being the block number (as per meta data)
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 85aea27..78d75f8 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2004-2008 Red Hat, Inc.  All rights reserved.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
@@ -69,13 +69,15 @@ static const struct address_space_operations aspace_aops = {
 struct inode *gfs2_aspace_get(struct gfs2_sbd *sdp)
 {
 	struct inode *aspace;
+	struct gfs2_inode *ip;
 
 	aspace = new_inode(sdp->sd_vfs);
 	if (aspace) {
 		mapping_set_gfp_mask(aspace->i_mapping, GFP_NOFS);
 		aspace->i_mapping->a_ops = &aspace_aops;
 		aspace->i_size = ~0ULL;
-		aspace->i_private = NULL;
+		ip = GFS2_I(aspace);
+		clear_bit(GIF_USER, &ip->i_flags);
 		insert_inode_hash(aspace);
 	}
 	return aspace;
diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
index e1b7d52..e092b28 100644
--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -535,7 +535,7 @@ static int gfs2_close(struct inode *inode, struct file *file)
  * @dentry: the dentry that points to the inode to sync
  *
  * The VFS will flush "normal" data for us. We only need to worry
- * about metadata here. For journaled data, we just do a log flush
+ * about metadata here. For journalised data, we just do a log flush
  * as we can't avoid it. Otherwise we can just bale out if datasync
  * is set. For stuffed inodes we must flush the log in order to
  * ensure that all data is on disk.
diff --git a/fs/gfs2/ops_super.c b/fs/gfs2/ops_super.c
index 2278c68..0b7cc92 100644
--- a/fs/gfs2/ops_super.c
+++ b/fs/gfs2/ops_super.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2004-2008 Red Hat, Inc.  All rights reserved.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
@@ -52,7 +52,7 @@ static int gfs2_write_inode(struct inode *inode, int sync)
 	struct gfs2_inode *ip = GFS2_I(inode);
 
 	/* Check this is a "normal" inode */
-	if (inode->i_private) {
+	if (test_bit(GIF_USER, &ip->i_flags)) {
 		if (current->flags & PF_MEMALLOC)
 			return 0;
 		if (sync)
@@ -297,8 +297,9 @@ static int gfs2_remount_fs(struct super_block *sb, int *flags, char *data)
  */
 static void gfs2_drop_inode(struct inode *inode)
 {
-	if (inode->i_private && inode->i_nlink) {
-		struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_inode *ip = GFS2_I(inode);
+
+	if (test_bit(GIF_USER, &ip->i_flags) && inode->i_nlink) {
 		struct gfs2_glock *gl = ip->i_iopen_gh.gh_gl;
 		if (gl && test_bit(GLF_DEMOTE, &gl->gl_flags))
 			clear_nlink(inode);
@@ -314,12 +315,13 @@ static void gfs2_drop_inode(struct inode *inode)
 
 static void gfs2_clear_inode(struct inode *inode)
 {
+	struct gfs2_inode *ip = GFS2_I(inode);
+
 	/* This tells us its a "real" inode and not one which only
 	 * serves to contain an address space (see rgrp.c, meta_io.c)
 	 * which therefore doesn't have its own glocks.
 	 */
-	if (inode->i_private) {
-		struct gfs2_inode *ip = GFS2_I(inode);
+	if (test_bit(GIF_USER, &ip->i_flags)) {
 		ip->i_gl->gl_object = NULL;
 		gfs2_glock_schedule_for_reclaim(ip->i_gl);
 		gfs2_glock_put(ip->i_gl);
@@ -419,7 +421,7 @@ static void gfs2_delete_inode(struct inode *inode)
 	struct gfs2_holder gh;
 	int error;
 
-	if (!inode->i_private)
+	if (!test_bit(GIF_USER, &ip->i_flags))
 		goto out;
 
 	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 7e8f0b1..6387523 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1495,7 +1495,7 @@ u64 gfs2_alloc_block(struct gfs2_inode *ip, unsigned int *n)
 
 	al->al_alloced += *n;
 
-	gfs2_statfs_change(sdp, 0, -*n, 0);
+	gfs2_statfs_change(sdp, 0, -(s64)*n, 0);
 	gfs2_quota_change(ip, *n, ip->i_inode.i_uid, ip->i_inode.i_gid);
 
 	spin_lock(&sdp->sd_rindex_spin);

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
sxc-fix-printk-warnings-on-sparc32.patch
linux-next.patch
revert-vt-fix-background-color-on-line-feed.patch
git-gfs2-nmw.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
iphase-fix-64bit-warning.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
vt-fix-vcs-sysfs-file-creation-race.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

