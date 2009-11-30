From: akpm@linux-foundation.org
Subject: [merged] mm-includecheck-fix-slqb.patch removed from -mm tree
Date: Mon, 30 Nov 2009 12:34:33 -0800
Message-ID: <200911302034.nAUKYXWL023876@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752201AbZK3Uff (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Nov 2009 15:35:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaswinder@kernel.org, jaswinderrajput@gmail.com, npiggin@suse.de, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     mm: includecheck fix slqb
has been removed from the -mm tree.  Its filename was
     mm-includecheck-fix-slqb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: includecheck fix slqb
From: Jaswinder Singh Rajput <jaswinder@kernel.org>

fix the following 'make includecheck' warnings:

  include/linux/slqb_def.h: linux/kobject.h is included more than once.
  mm/slqb.c: linux/seq_file.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slqb_def.h |    1 -
 mm/slqb.c                |    1 -
 2 files changed, 2 deletions(-)

diff -puN include/linux/slqb_def.h~mm-includecheck-fix-slqb include/linux/slqb_def.h
--- a/include/linux/slqb_def.h~mm-includecheck-fix-slqb
+++ a/include/linux/slqb_def.h
@@ -13,7 +13,6 @@
 #include <linux/rcu_types.h>
 #include <linux/mm_types.h>
 #include <linux/kernel.h>
-#include <linux/kobject.h>
 
 #define SLAB_NUMA		0x00000001UL    /* shortcut */
 
diff -puN mm/slqb.c~mm-includecheck-fix-slqb mm/slqb.c
--- a/mm/slqb.c~mm-includecheck-fix-slqb
+++ a/mm/slqb.c
@@ -3302,7 +3302,6 @@ static void gather_stats(struct kmem_cac
  */
 #ifdef CONFIG_SLABINFO
 #include <linux/proc_fs.h>
-#include <linux/seq_file.h>
 ssize_t slabinfo_write(struct file *file, const char __user * buffer,
 		       size_t count, loff_t *ppos)
 {
_

Patches currently in -mm which might be from jaswinder@kernel.org are

linux-next.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
xtensa-includecheck-fix-vectorss.patch
writeback-fix-missing-kernel-doc-notation.patch

