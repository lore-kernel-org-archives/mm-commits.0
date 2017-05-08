From: akpm@linux-foundation.org
Subject: [patch 074/114] drm: use set_memory.h header
Date: Mon, 08 May 2017 15:58:17 -0700
Message-ID: <20170508225817.xqPWkb1za%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47240 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751528AbdEHW6S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:58:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, labbott@redhat.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Laura Abbott <labbott@redhat.com>
Subject: drm: use set_memory.h header

set_memory_* functions have moved to set_memory.h. Switch to this
explicitly.

[akpm@linux-foundation.org: track drivers/gpu/drm/i915/i915_gem_gtt.c linux-next changes]
Link: http://lkml.kernel.org/r/1488920133-27229-8-git-send-email-labbott@redhat.com
Signed-off-by: Laura Abbott <labbott@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c |    3 +++
 drivers/gpu/drm/gma500/gtt.c             |    1 +
 drivers/gpu/drm/gma500/psb_drv.c         |    1 +
 drivers/gpu/drm/i915/i915_gem_gtt.c      |    2 ++
 drivers/gpu/drm/radeon/radeon_gart.c     |    3 +++
 drivers/gpu/drm/ttm/ttm_page_alloc.c     |    3 +++
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c |    3 +++
 drivers/gpu/drm/ttm/ttm_tt.c             |    3 +++
 8 files changed, 19 insertions(+)

diff -puN drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c~drm-use-set_memoryh-header drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c~drm-use-set_memoryh-header
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c
@@ -27,6 +27,9 @@
  */
 #include <drm/drmP.h>
 #include <drm/amdgpu_drm.h>
+#ifdef CONFIG_X86
+#include <asm/set_memory.h>
+#endif
 #include "amdgpu.h"
 
 /*
diff -puN drivers/gpu/drm/gma500/gtt.c~drm-use-set_memoryh-header drivers/gpu/drm/gma500/gtt.c
--- a/drivers/gpu/drm/gma500/gtt.c~drm-use-set_memoryh-header
+++ a/drivers/gpu/drm/gma500/gtt.c
@@ -21,6 +21,7 @@
 
 #include <drm/drmP.h>
 #include <linux/shmem_fs.h>
+#include <asm/set_memory.h>
 #include "psb_drv.h"
 #include "blitter.h"
 
diff -puN drivers/gpu/drm/gma500/psb_drv.c~drm-use-set_memoryh-header drivers/gpu/drm/gma500/psb_drv.c
--- a/drivers/gpu/drm/gma500/psb_drv.c~drm-use-set_memoryh-header
+++ a/drivers/gpu/drm/gma500/psb_drv.c
@@ -35,6 +35,7 @@
 #include <linux/pm_runtime.h>
 #include <acpi/video.h>
 #include <linux/module.h>
+#include <asm/set_memory.h>
 
 static struct drm_driver driver;
 static int psb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent);
diff -puN drivers/gpu/drm/i915/i915_gem_gtt.c~drm-use-set_memoryh-header drivers/gpu/drm/i915/i915_gem_gtt.c
--- a/drivers/gpu/drm/i915/i915_gem_gtt.c~drm-use-set_memoryh-header
+++ a/drivers/gpu/drm/i915/i915_gem_gtt.c
@@ -31,6 +31,8 @@
 #include <linux/seq_file.h>
 #include <linux/stop_machine.h>
 
+#include <asm/set_memory.h>
+
 #include <drm/drmP.h>
 #include <drm/i915_drm.h>
 
diff -puN drivers/gpu/drm/radeon/radeon_gart.c~drm-use-set_memoryh-header drivers/gpu/drm/radeon/radeon_gart.c
--- a/drivers/gpu/drm/radeon/radeon_gart.c~drm-use-set_memoryh-header
+++ a/drivers/gpu/drm/radeon/radeon_gart.c
@@ -27,6 +27,9 @@
  */
 #include <drm/drmP.h>
 #include <drm/radeon_drm.h>
+#ifdef CONFIG_X86
+#include <asm/set_memory.h>
+#endif
 #include "radeon.h"
 
 /*
diff -puN drivers/gpu/drm/ttm/ttm_page_alloc.c~drm-use-set_memoryh-header drivers/gpu/drm/ttm/ttm_page_alloc.c
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c~drm-use-set_memoryh-header
+++ a/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -51,6 +51,9 @@
 #if IS_ENABLED(CONFIG_AGP)
 #include <asm/agp.h>
 #endif
+#ifdef CONFIG_X86
+#include <asm/set_memory.h>
+#endif
 
 #define NUM_PAGES_TO_ALLOC		(PAGE_SIZE/sizeof(struct page *))
 #define SMALL_ALLOCATION		16
diff -puN drivers/gpu/drm/ttm/ttm_page_alloc_dma.c~drm-use-set_memoryh-header drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
--- a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c~drm-use-set_memoryh-header
+++ a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
@@ -53,6 +53,9 @@
 #if IS_ENABLED(CONFIG_AGP)
 #include <asm/agp.h>
 #endif
+#ifdef CONFIG_X86
+#include <asm/set_memory.h>
+#endif
 
 #define NUM_PAGES_TO_ALLOC		(PAGE_SIZE/sizeof(struct page *))
 #define SMALL_ALLOCATION		4
diff -puN drivers/gpu/drm/ttm/ttm_tt.c~drm-use-set_memoryh-header drivers/gpu/drm/ttm/ttm_tt.c
--- a/drivers/gpu/drm/ttm/ttm_tt.c~drm-use-set_memoryh-header
+++ a/drivers/gpu/drm/ttm/ttm_tt.c
@@ -44,6 +44,9 @@
 #include <drm/ttm/ttm_bo_driver.h>
 #include <drm/ttm/ttm_placement.h>
 #include <drm/ttm/ttm_page_alloc.h>
+#ifdef CONFIG_X86
+#include <asm/set_memory.h>
+#endif
 
 /**
  * Allocates storage for pointers to the pages that back the ttm.
_
