From: akpm@linux-foundation.org
Subject: + drm-use-set_memoryh-header.patch added to -mm tree
Date: Fri, 03 Mar 2017 15:50:17 -0800
Message-ID: <58ba0139.tKgTyAWuRIvqwohz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35038 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752425AbdCDAA7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2017 19:00:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: labbott@redhat.com, airlied@linux.ie, alexander.shishkin@linux.intel.com, arnd@arndb.de, catalin.marinas@arm.com, daniel@iogearbox.net, davem@davemloft.net, heiko.carstens@de.ibm.com, hpa@zytor.com, jeyu@redhat.com, keescook@chromium.org, linux@armlinux.org.uk, linux@roeck-us.net, mark.rutland@arm.com, mingo@redhat.com, schwidefsky@de.ibm.com, tglx@linutronix.de, tiwai@suse.com, will.deacon@arm.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     Subject: drm: use set_memory.h header
has been added to the -mm tree.  Its filename is
     drm-use-set_memoryh-header.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drm-use-set_memoryh-header.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drm-use-set_memoryh-header.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laura Abbott <labbott@redhat.com>
Subject: drm: use set_memory.h header

set_memory_* functions have moved to set_memory.h. Switch to this
explicitly.

Link: http://lkml.kernel.org/r/1488413706-9739-8-git-send-email-labbott@redhat.com
Signed-off-by: Laura Abbott <labbott@redhat.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jessica Yu <jeyu@redhat.com>
Cc: Takashi Iwai <tiwai@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c |    1 +
 drivers/gpu/drm/gma500/gtt.c             |    1 +
 drivers/gpu/drm/gma500/psb_drv.c         |    1 +
 drivers/gpu/drm/radeon/radeon_gart.c     |    1 +
 drivers/gpu/drm/ttm/ttm_page_alloc.c     |    1 +
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c |    1 +
 drivers/gpu/drm/ttm/ttm_tt.c             |    1 +
 7 files changed, 7 insertions(+)

diff -puN drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c~drm-use-set_memoryh-header drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c~drm-use-set_memoryh-header
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c
@@ -27,6 +27,7 @@
  */
 #include <drm/drmP.h>
 #include <drm/amdgpu_drm.h>
+#include <asm/set_memory.h>
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
diff -puN drivers/gpu/drm/radeon/radeon_gart.c~drm-use-set_memoryh-header drivers/gpu/drm/radeon/radeon_gart.c
--- a/drivers/gpu/drm/radeon/radeon_gart.c~drm-use-set_memoryh-header
+++ a/drivers/gpu/drm/radeon/radeon_gart.c
@@ -27,6 +27,7 @@
  */
 #include <drm/drmP.h>
 #include <drm/radeon_drm.h>
+#include <asm/set_memory.h>
 #include "radeon.h"
 
 /*
diff -puN drivers/gpu/drm/ttm/ttm_page_alloc.c~drm-use-set_memoryh-header drivers/gpu/drm/ttm/ttm_page_alloc.c
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c~drm-use-set_memoryh-header
+++ a/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -51,6 +51,7 @@
 #if IS_ENABLED(CONFIG_AGP)
 #include <asm/agp.h>
 #endif
+#include <asm/set_memory.h>
 
 #define NUM_PAGES_TO_ALLOC		(PAGE_SIZE/sizeof(struct page *))
 #define SMALL_ALLOCATION		16
diff -puN drivers/gpu/drm/ttm/ttm_page_alloc_dma.c~drm-use-set_memoryh-header drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
--- a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c~drm-use-set_memoryh-header
+++ a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
@@ -53,6 +53,7 @@
 #if IS_ENABLED(CONFIG_AGP)
 #include <asm/agp.h>
 #endif
+#include <asm/set_memory.h>
 
 #define NUM_PAGES_TO_ALLOC		(PAGE_SIZE/sizeof(struct page *))
 #define SMALL_ALLOCATION		4
diff -puN drivers/gpu/drm/ttm/ttm_tt.c~drm-use-set_memoryh-header drivers/gpu/drm/ttm/ttm_tt.c
--- a/drivers/gpu/drm/ttm/ttm_tt.c~drm-use-set_memoryh-header
+++ a/drivers/gpu/drm/ttm/ttm_tt.c
@@ -44,6 +44,7 @@
 #include <drm/ttm/ttm_bo_driver.h>
 #include <drm/ttm/ttm_placement.h>
 #include <drm/ttm/ttm_page_alloc.h>
+#include <asm/set_memory.h>
 
 /**
  * Allocates storage for pointers to the pages that back the ttm.
_

Patches currently in -mm which might be from labbott@redhat.com are

treewide-move-set_memory_-functions-away-from-cacheflushh.patch
arm-use-set_memoryh-header.patch
arm64-use-set_memoryh-header.patch
s390-use-set_memoryh-header.patch
x86-use-set_memoryh-header.patch
agp-use-set_memoryh-header.patch
drm-use-set_memoryh-header.patch
intel_th-use-set_memoryh-header.patch
watchdog-hpwdt-use-set_memoryh-header.patch
bpf-use-set_memoryh-header.patch
module-use-set_memoryh-header.patch
pm-hibernate-use-set_memoryh-header.patch
alsa-hda-use-set_memoryh-header.patch
treewide-decouple-cacheflushh-and-set_memoryh.patch

