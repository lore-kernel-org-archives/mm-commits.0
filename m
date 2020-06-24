From: akpm@linux-foundation.org
Subject: +
 mm-kcsan-instrument-slab-slub-free-with-assert_exclusive_access.patch added
 to -mm tree
Date: Wed, 24 Jun 2020 15:00:01 -0700
Message-ID: <20200624220001.-Dv0x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388452AbgFXWAC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 18:00:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, iamjoonsoo.kim@lge.com, glider@google.com, cl@linux.com, andreyknvl@google.com, elver@google.com


The patch titled
     Subject: mm, kcsan: instrument SLAB/SLUB free with "ASSERT_EXCLUSIVE_ACCESS"
has been added to the -mm tree.  Its filename is
     mm-kcsan-instrument-slab-slub-free-with-assert_exclusive_access.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kcsan-instrument-slab-slub-free-with-assert_exclusive_access.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kcsan-instrument-slab-slub-free-with-assert_exclusive_access.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: mm, kcsan: instrument SLAB/SLUB free with "ASSERT_EXCLUSIVE_ACCESS"

Provide the necessary KCSAN checks to assist with debugging racy
use-after-frees.  While KASAN is more reliable at generally catching such
use-after-frees (due to its use of a quarantine), it can be difficult to
debug racy use-after-frees.  If a reliable reproducer exists, KCSAN can
assist in debugging such issues.

Note: ASSERT_EXCLUSIVE_ACCESS is a convenience wrapper if the size is
simply sizeof(var).  Instead, here we just use __kcsan_check_access()
explicitly to pass the correct size.

Link: http://lkml.kernel.org/r/20200623072653.114563-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    5 +++++
 mm/slub.c |    5 +++++
 2 files changed, 10 insertions(+)

--- a/mm/slab.c~mm-kcsan-instrument-slab-slub-free-with-assert_exclusive_access
+++ a/mm/slab.c
@@ -3426,6 +3426,11 @@ static __always_inline void __cache_free
 	if (kasan_slab_free(cachep, objp, _RET_IP_))
 		return;
 
+	/* Use KCSAN to help debug racy use-after-free. */
+	if (!(cachep->flags & SLAB_TYPESAFE_BY_RCU))
+		__kcsan_check_access(objp, cachep->object_size,
+				     KCSAN_ACCESS_WRITE | KCSAN_ACCESS_ASSERT);
+
 	___cache_free(cachep, objp, caller);
 }
 
--- a/mm/slub.c~mm-kcsan-instrument-slab-slub-free-with-assert_exclusive_access
+++ a/mm/slub.c
@@ -1549,6 +1549,11 @@ static __always_inline bool slab_free_ho
 	if (!(s->flags & SLAB_DEBUG_OBJECTS))
 		debug_check_no_obj_freed(x, s->object_size);
 
+	/* Use KCSAN to help debug racy use-after-free. */
+	if (!(s->flags & SLAB_TYPESAFE_BY_RCU))
+		__kcsan_check_access(x, s->object_size,
+				     KCSAN_ACCESS_WRITE | KCSAN_ACCESS_ASSERT);
+
 	/* KASAN might put x into memory quarantine, delaying its reuse */
 	return kasan_slab_free(s, x, _RET_IP_);
 }
_

Patches currently in -mm which might be from elver@google.com are

mm-kcsan-instrument-slab-slub-free-with-assert_exclusive_access.patch
kcov-unconditionally-add-fno-stack-protector-to-compiler-options.patch
