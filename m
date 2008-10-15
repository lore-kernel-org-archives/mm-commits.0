From: akpm@linux-foundation.org
Subject: - proc-remove-unused-get_dma_list.patch removed from -mm tree
Date: Wed, 15 Oct 2008 14:14:16 -0700
Message-ID: <200810152114.m9FLEGkv005732@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55817 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753440AbYJOVOq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 17:14:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     proc: remove unused get_dma_list()
has been removed from the -mm tree.  Its filename was
     proc-remove-unused-get_dma_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: remove unused get_dma_list()
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/dma.c |   17 -----------------
 fs/proc/proc_misc.c   |    1 -
 2 files changed, 18 deletions(-)

diff -puN arch/arm/kernel/dma.c~proc-remove-unused-get_dma_list arch/arm/kernel/dma.c
--- a/arch/arm/kernel/dma.c~proc-remove-unused-get_dma_list
+++ a/arch/arm/kernel/dma.c
@@ -26,23 +26,6 @@ EXPORT_SYMBOL(dma_spin_lock);
 static dma_t dma_chan[MAX_DMA_CHANNELS];
 
 /*
- * Get dma list for /proc/dma
- */
-int get_dma_list(char *buf)
-{
-	dma_t *dma;
-	char *p = buf;
-	int i;
-
-	for (i = 0, dma = dma_chan; i < MAX_DMA_CHANNELS; i++, dma++)
-		if (dma->lock)
-			p += sprintf(p, "%2d: %14s %s\n", i,
-				     dma->d_ops->type, dma->device_id);
-
-	return p - buf;
-}
-
-/*
  * Request DMA channel
  *
  * On certain platforms, we have to allocate an interrupt as well...
diff -puN fs/proc/proc_misc.c~proc-remove-unused-get_dma_list fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~proc-remove-unused-get_dma_list
+++ a/fs/proc/proc_misc.c
@@ -68,7 +68,6 @@
 extern int get_hardware_list(char *);
 extern int get_stram_list(char *);
 extern int get_exec_domain_list(char *);
-extern int get_dma_list(char *);
 
 static int proc_calc_metrics(char *page, char **start, off_t off,
 				 int count, int *eof, int len)
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
tags-skip-in-filenames.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
cpuset-use-seq_cpumask-seq_nodemask.patch
compat_binfmt_elf-definition-tweak.patch
proc-move-sysrq-trigger-out-of-fs-proc.patch
sysctl-simplify-strategy.patch
fs-kconfig-move-ext2-ext3-ext4-jbd-jbd2-out.patch
fs-kconfig-move-cifs-out.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

