From: akpm@osdl.org
Subject: + optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs-fix.patch added to -mm tree
Date: Mon, 29 Jan 2007 12:53:08 -0800
Message-ID: <200701292053.l0TKr8vE030702@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55964 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbXA2UxN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 15:53:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, clameter@engr.sgi.com


The patch titled
     slab.c ifdef reduction breaks build
has been added to the -mm tree.  Its filename is
     optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slab.c ifdef reduction breaks build
From: Jeff Dike <jdike@addtoit.com>

optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-
no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs converts some
ifdefs into ifs.

One of them causes cs_dmacachep to be referenced, when that field
doesn't exist, because it's ifdefed on CONFIG_ZONE_DMA.

I'd suggest reverting that chunk.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/slab.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/slab.c~optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs-fix mm/slab.c
--- a/mm/slab.c~optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs-fix
+++ a/mm/slab.c
@@ -1493,14 +1493,15 @@ void __init kmem_cache_init(void)
 					ARCH_KMALLOC_FLAGS|SLAB_PANIC,
 					NULL, NULL);
 		}
-		if (CONFIG_ZONE_DMA_FLAG)
-			sizes->cs_dmacachep = kmem_cache_create(
+#ifdef CONFIG_ZONE_DMA
+		sizes->cs_dmacachep = kmem_cache_create(
 					names->name_dma,
 					sizes->cs_size,
 					ARCH_KMALLOC_MINALIGN,
 					ARCH_KMALLOC_FLAGS|SLAB_CACHE_DMA|
 						SLAB_PANIC,
 					NULL, NULL);
+#endif
 		sizes++;
 		names++;
 	}
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-mknod.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs-fix.patch
uml-console-locking-fixes.patch
uml-return-hotplug-errors-to-host.patch
uml-console-whitespace-and-comment-tidying.patch
uml-lock-the-irqs_to_free-list.patch
uml-add-locking-to-network-transport-registration.patch
uml-network-driver-whitespace-and-style-fixes.patch
uml-watchdog-driver-locking.patch
uml-watchdog-driver-formatting.patch
uml-audio-driver-locking.patch
uml-audio-driver-formatting.patch
uml-mconsole-locking.patch
uml-make-two-variables-static.patch
uml-port-driver-formatting.patch
uml-kill-a-compilation-warning.patch
uml-network-driver-locking-and-code-cleanup.patch
uml-use-list_head-where-possible.patch
uml-locking-commentary-in-the-random-driver.patch
uml-mostly-const-a-structure.patch
uml-chan_userh-formatting-fices.patch
uml-console-locking-commentary-and-code-cleanup.patch
uml-fix-previous-console-locking.patch
uml-locking-comments-in-iomem-driver.patch
uml-memc-and-physmemc-formatting-fixes.patch
uml-initialize-a-list-head.patch
uml-make-time-data-per-cpu.patch
uml-delete-unused-file.patch
uml-remove-unused-variable-and-function.patch
uml-make-signal-handlers-static.patch
uml-const-a-variable.patch
uml-remove-code-controlled-by-non-existent-config-option.patch
uml-add-per-device-queues-and-locks-to-ubd-driver.patch
uml-locking-fixes-in-the-ubd-driver.patch
uml-locking-comments-in-memory-and-tempfile-code.patch
uml-locking-comments-in-startup-code.patch
uml-style-fixes-in-startup-code.patch
uml-libc-dependent-code-should-call-libc-directly.patch
uml-fix-style-violations.patch
uml-fix-apparent-config_64_bit-typo.patch
uml-fix-prototypes.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
proc-remove-useless-and-buggy-nlink-settings.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
