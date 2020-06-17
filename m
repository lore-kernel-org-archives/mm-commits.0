From: akpm@linux-foundation.org
Subject: + mm-ksize-should-silently-accept-a-null-pointer.patch
 added to -mm tree
Date: Tue, 16 Jun 2020 19:13:21 -0700
Message-ID: <20200617021321.tA-6u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726253AbgFQCN3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Jun 2020 22:13:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, willy@infradead.org, rientjes@google.com, penberg@kernel.org, iamjoonsoo.kim@lge.com, cl@linux.com, william.kucharski@oracle.com


The patch titled
     Subject: mm: ksize() should silently accept a NULL pointer
has been added to the -mm tree.  Its filename is
     mm-ksize-should-silently-accept-a-null-pointer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-ksize-should-silently-accept-a-null-pointer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-ksize-should-silently-accept-a-null-pointer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: William Kucharski <william.kucharski@oracle.com>
Subject: mm: ksize() should silently accept a NULL pointer

Other mm routines such as kfree() and kzfree() silently do the right thing
if passed a NULL pointer, so ksize() should do the same.

Link: http://lkml.kernel.org/r/20200616225409.4670-1-william.kucharski@oracle.com
Signed-off-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/mm/slab_common.c~mm-ksize-should-silently-accept-a-null-pointer
+++ a/mm/slab_common.c
@@ -1660,10 +1660,9 @@ static __always_inline void *__do_kreall
 					   gfp_t flags)
 {
 	void *ret;
-	size_t ks = 0;
+	size_t ks;
 
-	if (p)
-		ks = ksize(p);
+	ks = ksize(p);
 
 	if (ks >= new_size) {
 		p = kasan_krealloc((void *)p, new_size, flags);
@@ -1723,10 +1722,9 @@ void kfree_sensitive(const void *p)
 	size_t ks;
 	void *mem = (void *)p;
 
-	if (unlikely(ZERO_OR_NULL_PTR(mem)))
-		return;
 	ks = ksize(mem);
-	memzero_explicit(mem, ks);
+	if (ks)
+		memzero_explicit(mem, ks);
 	kfree(mem);
 }
 EXPORT_SYMBOL(kfree_sensitive);
@@ -1749,8 +1747,6 @@ size_t ksize(const void *objp)
 {
 	size_t size;
 
-	if (WARN_ON_ONCE(!objp))
-		return 0;
 	/*
 	 * We need to check that the pointed to object is valid, and only then
 	 * unpoison the shadow memory below. We use __kasan_check_read(), to
@@ -1764,7 +1760,7 @@ size_t ksize(const void *objp)
 	 * We want to perform the check before __ksize(), to avoid potentially
 	 * crashing in __ksize() due to accessing invalid metadata.
 	 */
-	if (unlikely(objp == ZERO_SIZE_PTR) || !__kasan_check_read(objp, 1))
+	if (unlikely(ZERO_OR_NULL_PTR(objp)) || !__kasan_check_read(objp, 1))
 		return 0;
 
 	size = __ksize(objp);
_

Patches currently in -mm which might be from william.kucharski@oracle.com are

mm-ksize-should-silently-accept-a-null-pointer.patch
