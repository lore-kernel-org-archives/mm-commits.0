From: akpm@osdl.org
Subject: - jffs2-replace-kmallocmemset-with-kzalloc.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:56:05 -0800
Message-ID: <200612130656.kBD6u5gP030693@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57908 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965038AbWLMG4N (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:56:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: burman.yan@gmail.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     jffs2: replace kmalloc+memset with kzalloc
has been removed from the -mm tree.  Its filename was
     jffs2-replace-kmallocmemset-with-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: jffs2: replace kmalloc+memset with kzalloc
From: Yan Burman <burman.yan@gmail.com>

Replace kmalloc+memset with kzalloc

Signed-off-by: Yan Burman <burman.yan@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/jffs2/fs.c        |    3 +--
 fs/jffs2/readinode.c |    3 +--
 fs/jffs2/scan.c      |    3 +--
 fs/jffs2/summary.c   |    4 +---
 4 files changed, 4 insertions(+), 9 deletions(-)

diff -puN fs/jffs2/fs.c~jffs2-replace-kmallocmemset-with-kzalloc fs/jffs2/fs.c
--- a/fs/jffs2/fs.c~jffs2-replace-kmallocmemset-with-kzalloc
+++ a/fs/jffs2/fs.c
@@ -502,12 +502,11 @@ int jffs2_do_fill_super(struct super_blo
 	if (ret)
 		return ret;
 
-	c->inocache_list = kmalloc(INOCACHE_HASHSIZE * sizeof(struct jffs2_inode_cache *), GFP_KERNEL);
+	c->inocache_list = kcalloc(INOCACHE_HASHSIZE, sizeof(struct jffs2_inode_cache *), GFP_KERNEL);
 	if (!c->inocache_list) {
 		ret = -ENOMEM;
 		goto out_wbuf;
 	}
-	memset(c->inocache_list, 0, INOCACHE_HASHSIZE * sizeof(struct jffs2_inode_cache *));
 
 	jffs2_init_xattr_subsystem(c);
 
diff -puN fs/jffs2/readinode.c~jffs2-replace-kmallocmemset-with-kzalloc fs/jffs2/readinode.c
--- a/fs/jffs2/readinode.c~jffs2-replace-kmallocmemset-with-kzalloc
+++ a/fs/jffs2/readinode.c
@@ -944,13 +944,12 @@ int jffs2_do_read_inode(struct jffs2_sb_
 int jffs2_do_crccheck_inode(struct jffs2_sb_info *c, struct jffs2_inode_cache *ic)
 {
 	struct jffs2_raw_inode n;
-	struct jffs2_inode_info *f = kmalloc(sizeof(*f), GFP_KERNEL);
+	struct jffs2_inode_info *f = kzalloc(sizeof(*f), GFP_KERNEL);
 	int ret;
 
 	if (!f)
 		return -ENOMEM;
 
-	memset(f, 0, sizeof(*f));
 	init_MUTEX_LOCKED(&f->sem);
 	f->inocache = ic;
 
diff -puN fs/jffs2/scan.c~jffs2-replace-kmallocmemset-with-kzalloc fs/jffs2/scan.c
--- a/fs/jffs2/scan.c~jffs2-replace-kmallocmemset-with-kzalloc
+++ a/fs/jffs2/scan.c
@@ -128,12 +128,11 @@ int jffs2_scan_medium(struct jffs2_sb_in
 	}
 
 	if (jffs2_sum_active()) {
-		s = kmalloc(sizeof(struct jffs2_summary), GFP_KERNEL);
+		s = kzalloc(sizeof(struct jffs2_summary), GFP_KERNEL);
 		if (!s) {
 			JFFS2_WARNING("Can't allocate memory for summary\n");
 			return -ENOMEM;
 		}
-		memset(s, 0, sizeof(struct jffs2_summary));
 	}
 
 	for (i=0; i<c->nr_blocks; i++) {
diff -puN fs/jffs2/summary.c~jffs2-replace-kmallocmemset-with-kzalloc fs/jffs2/summary.c
--- a/fs/jffs2/summary.c~jffs2-replace-kmallocmemset-with-kzalloc
+++ a/fs/jffs2/summary.c
@@ -26,15 +26,13 @@
 
 int jffs2_sum_init(struct jffs2_sb_info *c)
 {
-	c->summary = kmalloc(sizeof(struct jffs2_summary), GFP_KERNEL);
+	c->summary = kzalloc(sizeof(struct jffs2_summary), GFP_KERNEL);
 
 	if (!c->summary) {
 		JFFS2_WARNING("Can't allocate memory for summary information!\n");
 		return -ENOMEM;
 	}
 
-	memset(c->summary, 0, sizeof(struct jffs2_summary));
-
 	c->summary->sum_buf = vmalloc(c->sector_size);
 
 	if (!c->summary->sum_buf) {
_

Patches currently in -mm which might be from burman.yan@gmail.com are

origin.patch
git-mtd.patch

