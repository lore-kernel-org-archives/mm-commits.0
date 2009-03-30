From: akpm@linux-foundation.org
Subject: [merged] fs-jffs2-mallocc-kmem_cache_alloc-memset-kmem_cache_zalloc.patch removed from -mm tree
Date: Mon, 30 Mar 2009 12:05:49 -0700
Message-ID: <200903301905.n2UJ5ntr018779@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759297AbZC3TI5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 15:08:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yjwei@cn.fujitsu.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     fs/jffs2/malloc.c: kmem_cache_alloc/memset -> kmem_cache_zalloc
has been removed from the -mm tree.  Its filename was
     fs-jffs2-mallocc-kmem_cache_alloc-memset-kmem_cache_zalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/jffs2/malloc.c: kmem_cache_alloc/memset -> kmem_cache_zalloc
From: Wei Yongjun <yjwei@cn.fujitsu.com>

Used kmem_cache_zalloc instead of kmem_cache_alloc/memset.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/malloc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/jffs2/malloc.c~fs-jffs2-mallocc-kmem_cache_alloc-memset-kmem_cache_zalloc fs/jffs2/malloc.c
--- a/fs/jffs2/malloc.c~fs-jffs2-mallocc-kmem_cache_alloc-memset-kmem_cache_zalloc
+++ a/fs/jffs2/malloc.c
@@ -284,10 +284,9 @@ void jffs2_free_inode_cache(struct jffs2
 struct jffs2_xattr_datum *jffs2_alloc_xattr_datum(void)
 {
 	struct jffs2_xattr_datum *xd;
-	xd = kmem_cache_alloc(xattr_datum_cache, GFP_KERNEL);
+	xd = kmem_cache_zalloc(xattr_datum_cache, GFP_KERNEL);
 	dbg_memalloc("%p\n", xd);
 
-	memset(xd, 0, sizeof(struct jffs2_xattr_datum));
 	xd->class = RAWNODE_CLASS_XATTR_DATUM;
 	xd->node = (void *)xd;
 	INIT_LIST_HEAD(&xd->xindex);
@@ -303,10 +302,9 @@ void jffs2_free_xattr_datum(struct jffs2
 struct jffs2_xattr_ref *jffs2_alloc_xattr_ref(void)
 {
 	struct jffs2_xattr_ref *ref;
-	ref = kmem_cache_alloc(xattr_ref_cache, GFP_KERNEL);
+	ref = kmem_cache_zalloc(xattr_ref_cache, GFP_KERNEL);
 	dbg_memalloc("%p\n", ref);
 
-	memset(ref, 0, sizeof(struct jffs2_xattr_ref));
 	ref->class = RAWNODE_CLASS_XATTR_REF;
 	ref->node = (void *)ref;
 	return ref;
_

Patches currently in -mm which might be from yjwei@cn.fujitsu.com are

origin.patch
linux-next.patch
scsi-used-kmem_cache_zalloc-instead-of-kmem_cache_alloc-memset.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix-checkpatch-fixes.patch

