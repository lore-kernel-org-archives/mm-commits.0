From: akpm@linux-foundation.org
Subject: - sis-drm-fix-the-memory-allocator-if-the-sis-fb-is-built-as-a-module.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:06:21 -0700
Message-ID: <200808042006.m74K6L0u027682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35630 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759147AbYHDUGy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:06:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     SiS DRM: fix the memory allocator if the SIS FB is built as a module
has been removed from the -mm tree.  Its filename was
     sis-drm-fix-the-memory-allocator-if-the-sis-fb-is-built-as-a-module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: SiS DRM: fix the memory allocator if the SIS FB is built as a module
From: David Howells <dhowells@redhat.com>

Fix the SIS DRM memory allocator if the SIS FB built as a module.  The SIS DRM
code initialises the mm allocation hooks, but _only_ if the SIS FB is not
built as a module because it depends on CONFIG_FB_SIS, and that's unset if the
SIS FB is not built in.  It must check CONFIG_FB_SIS_MODULE as well.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/sis/sis_mm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/gpu/drm/sis/sis_mm.c~sis-drm-fix-the-memory-allocator-if-the-sis-fb-is-built-as-a-module drivers/gpu/drm/sis/sis_mm.c
--- a/drivers/gpu/drm/sis/sis_mm.c~sis-drm-fix-the-memory-allocator-if-the-sis-fb-is-built-as-a-module
+++ a/drivers/gpu/drm/sis/sis_mm.c
@@ -41,7 +41,7 @@
 #define AGP_TYPE 1
 
 
-#if defined(CONFIG_FB_SIS)
+#if defined(CONFIG_FB_SIS) || defined(CONFIG_FB_SIS_MODULE)
 /* fb management via fb device */
 
 #define SIS_MM_ALIGN_SHIFT 0
@@ -75,12 +75,12 @@ static unsigned long sis_sman_mm_offset(
 	return ~((unsigned long)ref);
 }
 
-#else /* CONFIG_FB_SIS */
+#else /* CONFIG_FB_SIS[_MODULE] */
 
 #define SIS_MM_ALIGN_SHIFT 4
 #define SIS_MM_ALIGN_MASK ( (1 << SIS_MM_ALIGN_SHIFT) - 1)
 
-#endif /* CONFIG_FB_SIS */
+#endif /* CONFIG_FB_SIS[_MODULE] */
 
 static int sis_fb_init(struct drm_device *dev, void *data, struct drm_file *file_priv)
 {
@@ -89,7 +89,7 @@ static int sis_fb_init(struct drm_device
 	int ret;
 
 	mutex_lock(&dev->struct_mutex);
-#if defined(CONFIG_FB_SIS)
+#if defined(CONFIG_FB_SIS) || defined(CONFIG_FB_SIS_MODULE)
 	{
 		struct drm_sman_mm sman_mm;
 		sman_mm.private = (void *)0xFFFFFFFF;
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
cifs-fix-range-check.patch
git-unionfs.patch
clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range.patch
binfmt_elf_fdpic-support-auxvec-base-platform-string.patch
binfmt_elf_fdpic-convert-initial-stack-alignment-to-arch_align_stack.patch
binfmt_elf_fdpic-wire-up-at_execfd-at_execfn-at_secure.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
mutex-subsystem-synchro-test-module.patch

