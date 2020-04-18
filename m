From: akpm@linux-foundation.org
Subject: +
 mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch added to -mm
 tree
Date: Fri, 17 Apr 2020 18:12:27 -0700
Message-ID: <20200418011227.6r9yDVp0K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725298AbgDRBMb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Apr 2020 21:12:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, dongli.zhang@oracle.com, iamjoonsoo.kim@lge.com, joe.jin@oracle.com, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com


The patch titled
     Subject: mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix
has been added to the -mm tree.  Its filename is
     mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix

fix build with CONFIG_SLAB_DEBUG=n

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dongli Zhang <dongli.zhang@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

--- a/mm/slub.c~mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix
+++ a/mm/slub.c
@@ -662,6 +662,20 @@ static void slab_fix(struct kmem_cache *
 	va_end(args);
 }
 
+static bool freelist_corrupted(struct kmem_cache *s, struct page *page,
+			       void *freelist, void *nextfree)
+{
+	if ((s->flags & SLAB_CONSISTENCY_CHECKS) &&
+	    !check_valid_pointer(s, page, nextfree)) {
+		object_err(s, page, freelist, "Freechain corrupt");
+		freelist = NULL;
+		slab_fix(s, "Isolate corrupted freechain");
+		return true;
+	}
+
+	return false;
+}
+
 static void print_trailer(struct kmem_cache *s, struct page *page, u8 *p)
 {
 	unsigned int off;	/* Offset of last byte */
@@ -1400,6 +1414,11 @@ static inline void inc_slabs_node(struct
 static inline void dec_slabs_node(struct kmem_cache *s, int node,
 							int objects) {}
 
+static bool freelist_corrupted(struct kmem_cache *s, struct page *page,
+			       void *freelist, void *nextfree)
+{
+	return false;
+}
 #endif /* CONFIG_SLUB_DEBUG */
 
 /*
@@ -2083,19 +2102,13 @@ static void deactivate_slab(struct kmem_
 		void *prior;
 		unsigned long counters;
 
-		if ((s->flags & SLAB_CONSISTENCY_CHECKS) &&
-		    !check_valid_pointer(s, page, nextfree)) {
-			/*
-			 * If 'nextfree' is invalid, it is possible that
-			 * the object at 'freelist' is already corrupted.
-			 * Therefore, all objects starting at 'freelist'
-			 * are isolated.
-			 */
-			object_err(s, page, freelist, "Freechain corrupt");
-			freelist = NULL;
-			slab_fix(s, "Isolate corrupted freechain");
+		/*
+		 * If 'nextfree' is invalid, it is possible that the object at
+		 * 'freelist' is already corrupted.  So isolate all objects
+		 * starting at 'freelist'.
+		 */
+		if (freelist_corrupted(s, page, freelist, nextfree))
 			break;
-		}
 
 		do {
 			prior = page->freelist;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-add-an-entry-for-kfifo-fix.patch
maintainers-add-an-entry-for-kfifo-fix-fix.patch
mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled-v4-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
linux-next-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
