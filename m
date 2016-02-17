From: akpm@linux-foundation.org
Subject: + slub-relax-cmpxchg-consistency-restrictions.patch added to -mm
 tree
Date: Wed, 17 Feb 2016 12:05:06 -0800
Message-ID: <56c4d272.TKHEta6BlH3FV+Xz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48773 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965265AbcBQUFH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Feb 2016 15:05:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: labbott@fedoraproject.org, cl@linux.com, js1304@gmail.com, keescook@chromium.org, minipli@googlemail.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: relax CMPXCHG consistency restrictions
has been added to the -mm tree.  Its filename is
     slub-relax-cmpxchg-consistency-restrictions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-relax-cmpxchg-consistency-restrictions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-relax-cmpxchg-consistency-restrictions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laura Abbott <labbott@fedoraproject.org>
Subject: slub: relax CMPXCHG consistency restrictions

When debug options are enabled, cmpxchg on the page is disabled.  This is
because the page must be locked to ensure there are no false positives
when performing consistency checks.  Some debug options such as poisoning
and red zoning only act on the object itself.  There is no need to protect
other CPUs from modification on only the object.  Allow cmpxchg to happen
with poisoning and red zoning are set on a slab.

Credit to Mathias Krause for the original work which inspired this series

Signed-off-by: Laura Abbott <labbott@fedoraproject.org>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN mm/slub.c~slub-relax-cmpxchg-consistency-restrictions mm/slub.c
--- a/mm/slub.c~slub-relax-cmpxchg-consistency-restrictions
+++ a/mm/slub.c
@@ -164,6 +164,14 @@ static inline bool kmem_cache_has_cpu_pa
 				SLAB_POISON | SLAB_STORE_USER)
 
 /*
+ * These debug flags cannot use CMPXCHG because there might be consistency
+ * issues when checking or reading debug information
+ */
+#define SLAB_NO_CMPXCHG (SLAB_CONSISTENCY_CHECKS | SLAB_STORE_USER | \
+				SLAB_TRACE)
+
+
+/*
  * Debugging flags that require metadata to be stored in the slab.  These get
  * disabled when slub_debug=O is used and a cache's min order increases with
  * metadata.
@@ -3338,7 +3346,7 @@ static int kmem_cache_open(struct kmem_c
 
 #if defined(CONFIG_HAVE_CMPXCHG_DOUBLE) && \
     defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
-	if (system_has_cmpxchg_double() && (s->flags & SLAB_DEBUG_FLAGS) == 0)
+	if (system_has_cmpxchg_double() && (s->flags & SLAB_NO_CMPXCHG) == 0)
 		/* Enable fast mode */
 		s->flags |= __CMPXCHG_DOUBLE;
 #endif
@@ -4846,7 +4854,6 @@ static ssize_t red_zone_store(struct kme
 
 	s->flags &= ~SLAB_RED_ZONE;
 	if (buf[0] == '1') {
-		s->flags &= ~__CMPXCHG_DOUBLE;
 		s->flags |= SLAB_RED_ZONE;
 	}
 	calculate_sizes(s, -1);
@@ -4867,7 +4874,6 @@ static ssize_t poison_store(struct kmem_
 
 	s->flags &= ~SLAB_POISON;
 	if (buf[0] == '1') {
-		s->flags &= ~__CMPXCHG_DOUBLE;
 		s->flags |= SLAB_POISON;
 	}
 	calculate_sizes(s, -1);
_

Patches currently in -mm which might be from labbott@fedoraproject.org are

slub-drop-lock-at-the-end-of-free_debug_processing.patch
slub-fix-clean-free_debug_processing-return-paths.patch
slub-convert-slab_debug_free-to-slab_consistency_checks.patch
slub-relax-cmpxchg-consistency-restrictions.patch
mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc.patch
mm-page_poisonc-enable-page_poisoning-as-a-separate-option.patch
mm-page_poisoningc-allow-for-zero-poisoning.patch

