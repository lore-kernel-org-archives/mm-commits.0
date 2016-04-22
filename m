From: akpm@linux-foundation.org
Subject: + mm-kasan-dont-call-kasan_krealloc-from-ksize.patch added to -mm tree
Date: Fri, 22 Apr 2016 14:34:19 -0700
Message-ID: <571a98db.KCXFJT2leGZ/X32J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35869 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbcDVVeU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2016 17:34:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glider@google.com, adech.fo@gmail.com, cl@linux.com, dvyukov@google.com, kcc@google.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, kasan: don't call kasan_krealloc() from ksize().
has been added to the -mm tree.  Its filename is
     mm-kasan-dont-call-kasan_krealloc-from-ksize.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kasan-dont-call-kasan_krealloc-from-ksize.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kasan-dont-call-kasan_krealloc-from-ksize.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: mm, kasan: don't call kasan_krealloc() from ksize().

Instead of calling kasan_krealloc(), which replaces the memory allocation
stack ID (if stack depot is used), just unpoison the whole memory chunk.

Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <adech.fo@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Konstantin Serebryany <kcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 mm/slub.c |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/slab.c~mm-kasan-dont-call-kasan_krealloc-from-ksize mm/slab.c
--- a/mm/slab.c~mm-kasan-dont-call-kasan_krealloc-from-ksize
+++ a/mm/slab.c
@@ -4336,7 +4336,7 @@ size_t ksize(const void *objp)
 	/* We assume that ksize callers could use the whole allocated area,
 	 * so we need to unpoison this area.
 	 */
-	kasan_krealloc(objp, size, GFP_NOWAIT);
+	kasan_unpoison_shadow(objp, size);
 
 	return size;
 }
diff -puN mm/slub.c~mm-kasan-dont-call-kasan_krealloc-from-ksize mm/slub.c
--- a/mm/slub.c~mm-kasan-dont-call-kasan_krealloc-from-ksize
+++ a/mm/slub.c
@@ -3635,8 +3635,9 @@ size_t ksize(const void *object)
 {
 	size_t size = __ksize(object);
 	/* We assume that ksize callers could use whole allocated area,
-	   so we need unpoison this area. */
-	kasan_krealloc(object, size, GFP_NOWAIT);
+	 * so we need to unpoison this area.
+	 */
+	kasan_unpoison_shadow(object, size);
 	return size;
 }
 EXPORT_SYMBOL(ksize);
_

Patches currently in -mm which might be from glider@google.com are

lib-stackdepotc-allow-the-stack-trace-hash-to-be-zero.patch
mm-kasan-initial-memory-quarantine-implementation.patch
mm-kasan-initial-memory-quarantine-implementation-v8.patch
mm-kasan-dont-call-kasan_krealloc-from-ksize.patch
mm-kasan-add-a-ksize-test.patch

