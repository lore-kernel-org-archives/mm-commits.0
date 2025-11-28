Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35419252904
	for <mm-commits@vger.kernel.org>; Fri, 28 Nov 2025 18:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764354898; cv=none; b=UBrXL9SkPEx07N/VZnwsgBfHOkdIQ1rKAYtBHfGCRAsK9fuN/MbUqoor3se449Isf0fSTY4va+rSOBCvL4PfZjYhFxnxcVcFes49CyNeG/d3mzG5YtiTUiobfXMv7HVVAtrgpTurdJArCDJoSUF/F1tk943s2DatQlDyrlpw7dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764354898; c=relaxed/simple;
	bh=GGZo+qW3CcKdad++EzpR/0Ed0I+TMlXli6FaQ3yJq8Y=;
	h=Date:To:From:Subject:Message-Id; b=Q8wneLiEVrTEgKVGNW5O9f6tn6xUDmIxU5LyrQgrd6yAUp/bSxuFE96ncc1LmFvdSjepII6bPRRknAm1i+E6GDXz3f7QiYeYbgF922nxwoPGK18B4MITOaXClnMzhuOVE02it8iVbiZ/OREb/ekZyGdqBVA62LRlEL5e0Q8Ovb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lnj1Pv2R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lnj1Pv2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1ADC4CEF1;
	Fri, 28 Nov 2025 18:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764354897;
	bh=GGZo+qW3CcKdad++EzpR/0Ed0I+TMlXli6FaQ3yJq8Y=;
	h=Date:To:From:Subject:From;
	b=lnj1Pv2RrDvfVvL3H7ndFyOmuEjSFJd7sMVM+BOJyRA+lndcwqMZ/vSkjVT+6Aa1O
	 QZFHj8A0FhIIwDJqc3NIJY/R619wKE3JkibXMl+pzUJc0MgpZneCPxU4hirFqwcIY7
	 ohMHKoJlPR6TuGNK+PRBcyMhjbeCFkdfa+M/VpwA=
Date: Fri, 28 Nov 2025 10:34:56 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-replace-deprecated-strcpy-with-strscpy.patch added to mm-nonmm-unstable branch
Message-Id: <20251128183457.AB1ADC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: replace deprecated strcpy with strscpy
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-replace-deprecated-strcpy-with-strscpy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-replace-deprecated-strcpy-with-strscpy.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: ocfs2: replace deprecated strcpy with strscpy
Date: Wed, 26 Nov 2025 12:44:15 +0100

strcpy() has been deprecated [1] because it performs no bounds checking on
the destination buffer, which can lead to buffer overflows.  Replace it
with the safer strscpy().  No functional changes.

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strcpy [1]
Link: https://lkml.kernel.org/r/20251126114419.92539-1-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c               |    5 +++--
 fs/ocfs2/cluster/nodemanager.c |    3 ++-
 fs/ocfs2/dir.c                 |   10 +++++-----
 fs/ocfs2/namei.c               |    3 ++-
 fs/ocfs2/stackglue.c           |    3 ++-
 fs/ocfs2/suballoc.c            |    3 ++-
 6 files changed, 16 insertions(+), 11 deletions(-)

--- a/fs/ocfs2/alloc.c~ocfs2-replace-deprecated-strcpy-with-strscpy
+++ a/fs/ocfs2/alloc.c
@@ -10,6 +10,7 @@
 #include <linux/fs.h>
 #include <linux/types.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/highmem.h>
 #include <linux/swap.h>
 #include <linux/quotaops.h>
@@ -1037,7 +1038,7 @@ static int ocfs2_create_new_meta_bhs(han
 			memset(bhs[i]->b_data, 0, osb->sb->s_blocksize);
 			eb = (struct ocfs2_extent_block *) bhs[i]->b_data;
 			/* Ok, setup the minimal stuff here. */
-			strcpy(eb->h_signature, OCFS2_EXTENT_BLOCK_SIGNATURE);
+			strscpy(eb->h_signature, OCFS2_EXTENT_BLOCK_SIGNATURE);
 			eb->h_blkno = cpu_to_le64(first_blkno);
 			eb->h_fs_generation = cpu_to_le32(osb->fs_generation);
 			eb->h_suballoc_slot =
@@ -6746,7 +6747,7 @@ static int ocfs2_reuse_blk_from_dealloc(
 		/* We can't guarantee that buffer head is still cached, so
 		 * polutlate the extent block again.
 		 */
-		strcpy(eb->h_signature, OCFS2_EXTENT_BLOCK_SIGNATURE);
+		strscpy(eb->h_signature, OCFS2_EXTENT_BLOCK_SIGNATURE);
 		eb->h_blkno = cpu_to_le64(bf->free_blk);
 		eb->h_fs_generation = cpu_to_le32(osb->fs_generation);
 		eb->h_suballoc_slot = cpu_to_le16(real_slot);
--- a/fs/ocfs2/cluster/nodemanager.c~ocfs2-replace-deprecated-strcpy-with-strscpy
+++ a/fs/ocfs2/cluster/nodemanager.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/configfs.h>
@@ -590,7 +591,7 @@ static struct config_item *o2nm_node_gro
 	if (node == NULL)
 		return ERR_PTR(-ENOMEM);
 
-	strcpy(node->nd_name, name); /* use item.ci_namebuf instead? */
+	strscpy(node->nd_name, name); /* use item.ci_namebuf instead? */
 	config_item_init_type_name(&node->nd_item, name, &o2nm_node_type);
 	spin_lock_init(&node->nd_lock);
 
--- a/fs/ocfs2/dir.c~ocfs2-replace-deprecated-strcpy-with-strscpy
+++ a/fs/ocfs2/dir.c
@@ -136,7 +136,7 @@ static void ocfs2_init_dir_trailer(struc
 	struct ocfs2_dir_block_trailer *trailer;
 
 	trailer = ocfs2_trailer_from_bh(bh, inode->i_sb);
-	strcpy(trailer->db_signature, OCFS2_DIR_TRAILER_SIGNATURE);
+	strscpy(trailer->db_signature, OCFS2_DIR_TRAILER_SIGNATURE);
 	trailer->db_compat_rec_len =
 			cpu_to_le16(sizeof(struct ocfs2_dir_block_trailer));
 	trailer->db_parent_dinode = cpu_to_le64(OCFS2_I(inode)->ip_blkno);
@@ -2213,14 +2213,14 @@ static struct ocfs2_dir_entry *ocfs2_fil
 	de->name_len = 1;
 	de->rec_len =
 		cpu_to_le16(OCFS2_DIR_REC_LEN(de->name_len));
-	strcpy(de->name, ".");
+	strscpy(de->name, ".");
 	ocfs2_set_de_type(de, S_IFDIR);
 
 	de = (struct ocfs2_dir_entry *) ((char *)de + le16_to_cpu(de->rec_len));
 	de->inode = cpu_to_le64(OCFS2_I(parent)->ip_blkno);
 	de->rec_len = cpu_to_le16(size - OCFS2_DIR_REC_LEN(1));
 	de->name_len = 2;
-	strcpy(de->name, "..");
+	strscpy(de->name, "..");
 	ocfs2_set_de_type(de, S_IFDIR);
 
 	return de;
@@ -2378,7 +2378,7 @@ static int ocfs2_dx_dir_attach_index(str
 
 	dx_root = (struct ocfs2_dx_root_block *)dx_root_bh->b_data;
 	memset(dx_root, 0, osb->sb->s_blocksize);
-	strcpy(dx_root->dr_signature, OCFS2_DX_ROOT_SIGNATURE);
+	strscpy(dx_root->dr_signature, OCFS2_DX_ROOT_SIGNATURE);
 	dx_root->dr_suballoc_slot = cpu_to_le16(meta_ac->ac_alloc_slot);
 	dx_root->dr_suballoc_loc = cpu_to_le64(suballoc_loc);
 	dx_root->dr_suballoc_bit = cpu_to_le16(dr_suballoc_bit);
@@ -2454,7 +2454,7 @@ static int ocfs2_dx_dir_format_cluster(s
 		dx_leaf = (struct ocfs2_dx_leaf *) bh->b_data;
 
 		memset(dx_leaf, 0, osb->sb->s_blocksize);
-		strcpy(dx_leaf->dl_signature, OCFS2_DX_LEAF_SIGNATURE);
+		strscpy(dx_leaf->dl_signature, OCFS2_DX_LEAF_SIGNATURE);
 		dx_leaf->dl_fs_generation = cpu_to_le32(osb->fs_generation);
 		dx_leaf->dl_blkno = cpu_to_le64(bh->b_blocknr);
 		dx_leaf->dl_list.de_count =
--- a/fs/ocfs2/namei.c~ocfs2-replace-deprecated-strcpy-with-strscpy
+++ a/fs/ocfs2/namei.c
@@ -23,6 +23,7 @@
 #include <linux/fs.h>
 #include <linux/types.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/highmem.h>
 #include <linux/quotaops.h>
 #include <linux/iversion.h>
@@ -568,7 +569,7 @@ static int __ocfs2_mknod_locked(struct i
 	ocfs2_set_links_count(fe, inode->i_nlink);
 
 	fe->i_last_eb_blk = 0;
-	strcpy(fe->i_signature, OCFS2_INODE_SIGNATURE);
+	strscpy(fe->i_signature, OCFS2_INODE_SIGNATURE);
 	fe->i_flags |= cpu_to_le32(OCFS2_VALID_FL);
 	ktime_get_coarse_real_ts64(&ts);
 	fe->i_atime = fe->i_ctime = fe->i_mtime =
--- a/fs/ocfs2/stackglue.c~ocfs2-replace-deprecated-strcpy-with-strscpy
+++ a/fs/ocfs2/stackglue.c
@@ -10,6 +10,7 @@
 
 #include <linux/list.h>
 #include <linux/spinlock.h>
+#include <linux/string.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/kmod.h>
@@ -670,7 +671,7 @@ static int __init ocfs2_stack_glue_init(
 {
 	int ret;
 
-	strcpy(cluster_stack_name, OCFS2_STACK_PLUGIN_O2CB);
+	strscpy(cluster_stack_name, OCFS2_STACK_PLUGIN_O2CB);
 
 	ocfs2_table_header = register_sysctl("fs/ocfs2/nm", ocfs2_nm_table);
 	if (!ocfs2_table_header) {
--- a/fs/ocfs2/suballoc.c~ocfs2-replace-deprecated-strcpy-with-strscpy
+++ a/fs/ocfs2/suballoc.c
@@ -11,6 +11,7 @@
 #include <linux/fs.h>
 #include <linux/types.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/highmem.h>
 
 #include <cluster/masklog.h>
@@ -372,7 +373,7 @@ static int ocfs2_block_group_fill(handle
 	}
 
 	memset(bg, 0, sb->s_blocksize);
-	strcpy(bg->bg_signature, OCFS2_GROUP_DESC_SIGNATURE);
+	strscpy(bg->bg_signature, OCFS2_GROUP_DESC_SIGNATURE);
 	bg->bg_generation = cpu_to_le32(osb->fs_generation);
 	bg->bg_size = cpu_to_le16(ocfs2_group_bitmap_size(sb, 1,
 						osb->s_feature_incompat));
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

ocfs2-replace-deprecated-strcpy-with-strscpy.patch

