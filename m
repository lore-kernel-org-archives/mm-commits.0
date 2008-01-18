From: akpm@linux-foundation.org
Subject: + i915-fix-invalid-opcode-exception-on-cpus-without-clflush.patch added to -mm tree
Date: Thu, 17 Jan 2008 16:18:38 -0800
Message-ID: <200801180018.m0I0IcZv021583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41711 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755946AbYARATZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jan 2008 19:19:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyle@mcmartin.ca, airlied@linux.ie, kmcmartin@redhat.com


The patch titled
     i915: fix invalid opcode exception on cpus without clflush
has been added to the -mm tree.  Its filename is
     i915-fix-invalid-opcode-exception-on-cpus-without-clflush.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i915: fix invalid opcode exception on cpus without clflush
From: Kyle McMartin <kyle@mcmartin.ca>

i915_flush_ttm was unconditionally executing a clflush instruction to
(obviously) flush the cache.  Instead, check if the cpu supports clflush,
and if not, fall back to calling wbinvd to flush the entire cache.

Signed-off-by: Kyle McMartin <kmcmartin@redhat.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/drm/i915_buffer.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN drivers/char/drm/i915_buffer.c~i915-fix-invalid-opcode-exception-on-cpus-without-clflush drivers/char/drm/i915_buffer.c
--- a/drivers/char/drm/i915_buffer.c~i915-fix-invalid-opcode-exception-on-cpus-without-clflush
+++ a/drivers/char/drm/i915_buffer.c
@@ -169,7 +169,18 @@ void i915_flush_ttm(struct drm_ttm *ttm)
 		return;
 
 	DRM_MEMORYBARRIER();
+
+#ifdef CONFIG_X86_32
+	/* Hopefully nobody has built an x86-64 processor without clflush */
+	if (!cpu_has_clflush) {
+		wbinvd();
+		DRM_MEMORYBARRIER();
+		return;
+	}
+#endif
+
 	for (i = ttm->num_pages - 1; i >= 0; i--)
 		drm_cache_flush_page(drm_ttm_get_page(ttm, i));
+
 	DRM_MEMORYBARRIER();
 }
_

Patches currently in -mm which might be from kyle@mcmartin.ca are

i915-fix-invalid-opcode-exception-on-cpus-without-clflush.patch
kill-warnings-in-mptbaseh-on-parisc64.patch
iommu-sg-merging-parisc-make-iommu-respect-the-segment-size-limits.patch
alpha-parisc-removing-config-variable-debug_rwlock.patch
documentation-about-unaligned-memory-access.patch
add-cmpxchg_local-to-parisc.patch
modules-make-module_address_lookup-safe.patch
modules-make-module_address_lookup-safe-fix.patch
