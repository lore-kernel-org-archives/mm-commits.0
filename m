From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 30/54] asm-generic: don't include <linux/mm.h> in
 cacheflush.h
Date: Sun, 07 Jun 2020 21:41:42 -0700
Message-ID: <20200608044142.aNNA3qCXI%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgFHElo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:41:44 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anton.ivanov@cambridgegreys.com, arnd@arndb.de, bp@alien8.de, dan.j.williams@intel.com, dave.jiang@intel.com, hch@lst.de, hpa@zytor.com, ira.weiny@intel.com, jdike@addtoit.com, keith.busch@intel.com, linux-mm@kvack.org, mingo@redhat.com, mm-commits@vger.kernel.org, npiggin@gmail.com, peterz@infradead.org, richard@nod.at, tglx@linutronix.de, torvalds@linux-foundation.org, vishal.l.verma@intel.com, will@kernel.org

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
