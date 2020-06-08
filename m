From: akpm@linux-foundation.org
Subject: [merged]
 asm-generic-dont-include-linux-mmh-in-cacheflushh.patch removed from -mm
 tree
Date: Mon, 08 Jun 2020 15:32:38 -0700
Message-ID: <20200608223238.kQVMfjz68%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726734AbgFHWck (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 18:32:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton.ivanov@cambridgegreys.com, arnd@arndb.de, bp@alien8.de, dan.j.williams@intel.com, dave.jiang@intel.com, hch@lst.de, hpa@zytor.com, ira.weiny@intel.com, jdike@addtoit.com, keith.busch@intel.com, mingo@redhat.com, mm-commits@vger.kernel.org, npiggin@gmail.com, peterz@infradead.org, richard@nod.at, tglx@linutronix.de, vishal.l.verma@intel.com, will@kernel.org


The patch titled
     Subject: asm-generic: don't include <linux/mm.h> in cacheflush.h
has been removed from the -mm tree.  Its filename was
     asm-generic-dont-include-linux-mmh-in-cacheflushh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: asm-generic: don't include <linux/mm.h> in cacheflush.h

This seems to lead to some crazy include loops when using
asm-generic/cacheflush.h on more architectures, so leave it to the arch
header for now.

[hch@lst.de: fix warning]
  Link: http://lkml.kernel.org/r/20200520173520.GA11199@lst.de
Link: http://lkml.kernel.org/r/20200515143646.3857579-7-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Will Deacon <will@kernel.org>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/asm/tlb.h                  |    2 ++
 arch/x86/include/asm/cacheflush.h          |    2 ++
 drivers/media/platform/omap3isp/ispvideo.c |    2 +-
 drivers/nvdimm/pmem.c                      |    3 ++-
 include/asm-generic/cacheflush.h           |    3 ---
 5 files changed, 7 insertions(+), 5 deletions(-)

--- a/arch/um/include/asm/tlb.h~asm-generic-dont-include-linux-mmh-in-cacheflushh
+++ a/arch/um/include/asm/tlb.h
@@ -2,6 +2,8 @@
 #ifndef __UM_TLB_H
 #define __UM_TLB_H
 
+#include <linux/mm.h>
+
 #include <asm/tlbflush.h>
 #include <asm-generic/cacheflush.h>
 #include <asm-generic/tlb.h>
--- a/arch/x86/include/asm/cacheflush.h~asm-generic-dont-include-linux-mmh-in-cacheflushh
+++ a/arch/x86/include/asm/cacheflush.h
@@ -2,6 +2,8 @@
 #ifndef _ASM_X86_CACHEFLUSH_H
 #define _ASM_X86_CACHEFLUSH_H
 
+#include <linux/mm.h>
+
 /* Caches aren't brain-dead on the intel. */
 #include <asm-generic/cacheflush.h>
 #include <asm/special_insns.h>
--- a/drivers/media/platform/omap3isp/ispvideo.c~asm-generic-dont-include-linux-mmh-in-cacheflushh
+++ a/drivers/media/platform/omap3isp/ispvideo.c
@@ -10,7 +10,6 @@
  *	     Sakari Ailus <sakari.ailus@iki.fi>
  */
 
-#include <asm/cacheflush.h>
 #include <linux/clk.h>
 #include <linux/mm.h>
 #include <linux/module.h>
@@ -19,6 +18,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <asm/cacheflush.h>
 
 #include <media/v4l2-dev.h>
 #include <media/v4l2-ioctl.h>
--- a/drivers/nvdimm/pmem.c~asm-generic-dont-include-linux-mmh-in-cacheflushh
+++ a/drivers/nvdimm/pmem.c
@@ -7,7 +7,6 @@
  * Copyright (c) 2015, Boaz Harrosh <boaz@plexistor.com>.
  */
 
-#include <asm/cacheflush.h>
 #include <linux/blkdev.h>
 #include <linux/hdreg.h>
 #include <linux/init.h>
@@ -25,6 +24,8 @@
 #include <linux/dax.h>
 #include <linux/nd.h>
 #include <linux/backing-dev.h>
+#include <linux/mm.h>
+#include <asm/cacheflush.h>
 #include "pmem.h"
 #include "pfn.h"
 #include "nd.h"
--- a/include/asm-generic/cacheflush.h~asm-generic-dont-include-linux-mmh-in-cacheflushh
+++ a/include/asm-generic/cacheflush.h
@@ -2,9 +2,6 @@
 #ifndef _ASM_GENERIC_CACHEFLUSH_H
 #define _ASM_GENERIC_CACHEFLUSH_H
 
-/* Keep includes the same across arches.  */
-#include <linux/mm.h>
-
 #define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
 
 /*
_

Patches currently in -mm which might be from hch@lst.de are

amdgpu-a-null-mm-does-not-mean-a-thread-is-a-kthread.patch
kernel-move-use_mm-unuse_mm-to-kthreadc.patch
kernel-move-use_mm-unuse_mm-to-kthreadc-v2.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract-v2.patch
kernel-set-user_ds-in-kthread_use_mm.patch
maccess-unexport-probe_kernel_write-and-probe_user_write.patch
maccess-remove-various-unused-weak-aliases.patch
maccess-remove-duplicate-kerneldoc-comments.patch
maccess-clarify-kerneldoc-comments.patch
maccess-update-the-top-of-file-comment.patch
maccess-rename-strncpy_from_unsafe_user-to-strncpy_from_user_nofault.patch
maccess-rename-strncpy_from_unsafe_strict-to-strncpy_from_kernel_nofault.patch
maccess-rename-strnlen_unsafe_user-to-strnlen_user_nofault.patch
maccess-remove-probe_read_common-and-probe_write_common.patch
maccess-unify-the-probe-kernel-arch-hooks.patch
bpf-factor-out-a-bpf_trace_copy_string-helper.patch
bpf-handle-the-compat-string-in-bpf_trace_copy_string-better.patch
bpf-rework-the-compat-kernel-probe-handling.patch
tracing-kprobes-handle-mixed-kernel-userspace-probes-better.patch
maccess-remove-strncpy_from_unsafe.patch
maccess-always-use-strict-semantics-for-probe_kernel_read.patch
maccess-move-user-access-routines-together.patch
maccess-allow-architectures-to-provide-kernel-probing-directly.patch
x86-use-non-set_fs-based-maccess-routines.patch
maccess-return-erange-when-copy_from_kernel_nofault_allowed-fails.patch
