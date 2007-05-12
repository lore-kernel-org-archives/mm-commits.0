From: akpm@linux-foundation.org
Subject: - replace-pid_t-in-autofs-with-struct-pid-reference.patch removed from -mm tree
Date: Fri, 11 May 2007 22:34:48 -0700
Message-ID: <200705120534.l4C5YmXk002227@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39569 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755309AbXELFe7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:34:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@us.ibm.com, clg@fr.ibm.com, ebiederm@xmission.com, haveblue@us.ibm.com, raven@themaw.net, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Replace pid_t in autofs with struct pid reference
has been removed from the -mm tree.  Its filename was
     replace-pid_t-in-autofs-with-struct-pid-reference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Replace pid_t in autofs with struct pid reference
From: Sukadev Bhattiprolu <sukadev@us.ibm.com>

Make autofs container-friendly by caching struct pid reference rather than
pid_t and using pid_nr() to retreive a task's pid_t.

ChangeLog:
	- Fix Eric Biederman's comments - Use find_get_pid() to hold a
	  reference to oz_pgrp and release while unmounting; separate out
	  changes to autofs and autofs4.
	- Fix Cedric's comments: retain old prototype of parse_options()
	  and move necessary change to its caller.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: containers@lists.osdl.org
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs/autofs_i.h |    4 ++--
 fs/autofs/inode.c    |   20 ++++++++++++++++----
 fs/autofs/root.c     |    6 ++++--
 3 files changed, 22 insertions(+), 8 deletions(-)

diff -puN fs/autofs/autofs_i.h~replace-pid_t-in-autofs-with-struct-pid-reference fs/autofs/autofs_i.h
--- a/fs/autofs/autofs_i.h~replace-pid_t-in-autofs-with-struct-pid-reference
+++ a/fs/autofs/autofs_i.h
@@ -101,7 +101,7 @@ struct autofs_symlink {
 struct autofs_sb_info {
 	u32 magic;
 	struct file *pipe;
-	pid_t oz_pgrp;
+	struct pid *oz_pgrp;
 	int catatonic;
 	struct super_block *sb;
 	unsigned long exp_timeout;
@@ -122,7 +122,7 @@ static inline struct autofs_sb_info *aut
    filesystem without "magic".) */
 
 static inline int autofs_oz_mode(struct autofs_sb_info *sbi) {
-	return sbi->catatonic || process_group(current) == sbi->oz_pgrp;
+	return sbi->catatonic || task_pgrp(current) == sbi->oz_pgrp;
 }
 
 /* Hash operations */
diff -puN fs/autofs/inode.c~replace-pid_t-in-autofs-with-struct-pid-reference fs/autofs/inode.c
--- a/fs/autofs/inode.c~replace-pid_t-in-autofs-with-struct-pid-reference
+++ a/fs/autofs/inode.c
@@ -37,6 +37,8 @@ void autofs_kill_sb(struct super_block *
 	if (!sbi->catatonic)
 		autofs_catatonic_mode(sbi); /* Free wait queues, close pipe */
 
+	put_pid(sbi->oz_pgrp);
+
 	autofs_hash_nuke(sbi);
 	for (n = 0; n < AUTOFS_MAX_SYMLINKS; n++) {
 		if (test_bit(n, sbi->symlink_bitmap))
@@ -139,6 +141,7 @@ int autofs_fill_super(struct super_block
 	int pipefd;
 	struct autofs_sb_info *sbi;
 	int minproto, maxproto;
+	pid_t pgid;
 
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
@@ -150,7 +153,6 @@ int autofs_fill_super(struct super_block
 	sbi->pipe = NULL;
 	sbi->catatonic = 1;
 	sbi->exp_timeout = 0;
-	sbi->oz_pgrp = process_group(current);
 	autofs_initialize_hash(&sbi->dirhash);
 	sbi->queues = NULL;
 	memset(sbi->symlink_bitmap, 0, sizeof(long)*AUTOFS_SYMLINK_BITMAP_LEN);
@@ -171,7 +173,7 @@ int autofs_fill_super(struct super_block
 
 	/* Can this call block?  - WTF cares? s is locked. */
 	if (parse_options(data, &pipefd, &root_inode->i_uid,
-				&root_inode->i_gid, &sbi->oz_pgrp, &minproto,
+				&root_inode->i_gid, &pgid, &minproto,
 				&maxproto)) {
 		printk("autofs: called with bogus options\n");
 		goto fail_dput;
@@ -184,13 +186,21 @@ int autofs_fill_super(struct super_block
 		goto fail_dput;
 	}
 
-	DPRINTK(("autofs: pipe fd = %d, pgrp = %u\n", pipefd, sbi->oz_pgrp));
+	DPRINTK(("autofs: pipe fd = %d, pgrp = %u\n", pipefd, pgid));
+	sbi->oz_pgrp = find_get_pid(pgid);
+
+	if (!sbi->oz_pgrp) {
+		printk("autofs: could not find process group %d\n", pgid);
+		goto fail_dput;
+	}
+
 	pipe = fget(pipefd);
 	
 	if (!pipe) {
 		printk("autofs: could not open pipe file descriptor\n");
-		goto fail_dput;
+		goto fail_put_pid;
 	}
+
 	if (!pipe->f_op || !pipe->f_op->write)
 		goto fail_fput;
 	sbi->pipe = pipe;
@@ -205,6 +215,8 @@ int autofs_fill_super(struct super_block
 fail_fput:
 	printk("autofs: pipe file descriptor does not contain proper ops\n");
 	fput(pipe);
+fail_put_pid:
+	put_pid(sbi->oz_pgrp);
 fail_dput:
 	dput(root);
 	goto fail_free;
diff -puN fs/autofs/root.c~replace-pid_t-in-autofs-with-struct-pid-reference fs/autofs/root.c
--- a/fs/autofs/root.c~replace-pid_t-in-autofs-with-struct-pid-reference
+++ a/fs/autofs/root.c
@@ -213,8 +213,10 @@ static struct dentry *autofs_root_lookup
 	sbi = autofs_sbi(dir->i_sb);
 
 	oz_mode = autofs_oz_mode(sbi);
-	DPRINTK(("autofs_lookup: pid = %u, pgrp = %u, catatonic = %d, oz_mode = %d\n",
-		 current->pid, process_group(current), sbi->catatonic, oz_mode));
+	DPRINTK(("autofs_lookup: pid = %u, pgrp = %u, catatonic = %d, "
+				"oz_mode = %d\n", pid_nr(task_pid(current)),
+				process_group(current), sbi->catatonic,
+				oz_mode));
 
 	/*
 	 * Mark the dentry incomplete, but add it. This is needed so
_

Patches currently in -mm which might be from sukadev@us.ibm.com are

origin.patch
