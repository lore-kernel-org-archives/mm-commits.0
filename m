From: akpm@linux-foundation.org
Subject: + sis-drm-fix-the-memory-allocator-if-the-sis-fb-is-built-as-a-module.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:37:24 -0700
Message-ID: <200807111843.m6BIh51H030775@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755999AbYGKSn6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:43:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, airlied@linux.ie


The patch titled
     SiS DRM: fix the memory allocator if the SIS FB is built as a module
has been added to the -mm tree.  Its filename is
     sis-drm-fix-the-memory-allocator-if-the-sis-fb-is-built-as-a-module.patch

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

 drivers/char/drm/sis_mm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/char/drm/sis_mm.c~sis-drm-fix-the-memory-allocator-if-the-sis-fb-is-built-as-a-module drivers/char/drm/sis_mm.c
--- a/drivers/char/drm/sis_mm.c~sis-drm-fix-the-memory-allocator-if-the-sis-fb-is-built-as-a-module
+++ a/drivers/char/drm/sis_mm.c
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

linux-next.patch
acpi-fix-a-cast-of-a-32-bit-int-to-a-pointer.patch
acpi-fix-build-with-config_pm_sleep=n.patch
calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
alsa-fix-a-const-pointer-usage-warning-in-the-digigram-pcxhr-soundcard-driver.patch
alsa-fix-a-const-pointer-usage-warning-in-the-digigram-mixart-soundcard-driver.patch
cifs-fix-range-check.patch
sis-drm-fix-the-memory-allocator-if-the-sis-fb-is-built-as-a-module.patch
sis-drm-fix-a-pointer-cast-warning.patch
ivtv-framebuffer-driver-fix-pointer-cast-warnings.patch
drx397xd-demodulator-driver-fix-a-const-pointer-assignment.patch
mtd-fix-const-assignment-in-the-command-line-partitioning-driver.patch
atm-fix-const-assignment-discard-warnings-in-the-atm-networking-driver.patch
atm-fix-direct-casts-of-pointers-to-u32-in-the-interphase-driver.patch
hysdn-remove-the-packed-attribute-from-poftimstamp_tag.patch
git-unionfs.patch
xfs-fix-disabled-xfs-posix-acl-handling.patch
mn10300-move-sg_dma_addresslen-to-asm-scatterlisth.patch
inflate-refactor-inflate-malloc-code.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
pnpacpi-fix-pnpacpi_parse_irq_options-test-against-pnp_irq_nr.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
sdio-fix-break-control-to-now-return-success-or-an-error.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
fix-a-const-assignment-in-moxa_load_fw.patch
frv-use-the-common-ascii-hex-helpers.patch
mn10300-use-the-common-ascii-hex-helpers.patch
mutex-subsystem-synchro-test-module.patch

