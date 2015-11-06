From: akpm@linux-foundation.org
Subject: [folded-merged]
 uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch removed from -mm tree
Date: Thu, 05 Nov 2015 18:22:29 -0800
Message-ID: <563c0ee5.8qjscu5IKqXJSB3J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52368 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031154AbbKFCWa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 21:22:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix
has been removed from the -mm tree.  Its filename was
     uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch

This patch was dropped because it was folded into uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix

fix ppc warning

Reported-by: Fengguang Wu <fengguang.wu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/sysdev/fsl_pci.c~uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix arch/powerpc/sysdev/fsl_pci.c
--- a/arch/powerpc/sysdev/fsl_pci.c~uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix
+++ a/arch/powerpc/sysdev/fsl_pci.c
@@ -999,7 +999,7 @@ int fsl_pci_mcheck_exception(struct pt_r
 			ret = get_user(regs->nip, &inst);
 			pagefault_enable();
 		} else {
-			ret = probe_kernel_address(regs->nip, inst);
+			ret = probe_kernel_address((void *)regs->nip, inst);
 		}
 
 		if (mcheck_handle_load(regs, inst)) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable-fix.patch
mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process-fix.patch
mm-vmstatc-uninline-node_page_state.patch
mm-vmstatc-uninline-node_page_state-fix.patch
mm-cmac-suppress-warning.patch
memcg-fix-thresholds-for-32b-architectures-fix-fix.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
mm-slub-kasan-enable-user-tracking-by-default-with-kasan=y-fix.patch

