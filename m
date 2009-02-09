From: akpm@linux-foundation.org
Subject: + fs-jffs2-mallocc-kmem_cache_alloc-memset-kmem_cache_zalloc.patch added to -mm tree
Date: Mon, 09 Feb 2009 14:08:11 -0800
Message-ID: <200902092208.n19M8BcL031810@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755817AbZBIWIv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 17:08:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yjwei@cn.fujitsu.com, dwmw2@infradead.org


The patch titled
     fs/jffs2/malloc.c: kmem_cache_alloc/memset -> kmem_cache_zalloc
has been added to the -mm tree.  Its filename is
     fs-jffs2-mallocc-kmem_cache_alloc-memset-kmem_cache_zalloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
scsi-used-kmem_cache_zalloc-instead-of-kmem_cache_alloc-memset.patch
fs-jffs2-mallocc-kmem_cache_alloc-memset-kmem_cache_zalloc.patch

