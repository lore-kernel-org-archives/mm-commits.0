From: akpm@linux-foundation.org
Subject: + arch-arm26-kernel-entrys-remove-dead-code.patch added to -mm tree
Date: Wed, 21 Feb 2007 14:04:08 -0800
Message-ID: <200702212204.l1LM4830027801@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51214 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932632AbXBUWHZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 17:07:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, spyro@f2s.com


The patch titled
     arch/arm26/kernel/entry.S: remove dead code
has been added to the -mm tree.  Its filename is
     arch-arm26-kernel-entrys-remove-dead-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: arch/arm26/kernel/entry.S: remove dead code
From: Adrian Bunk <bunk@stusta.de>

CONFIG_ALIGNMENT_TRAP is never set on arm26.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Ian Molton <spyro@f2s.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm26/kernel/entry.S |   10 ----------
 1 files changed, 10 deletions(-)

diff -puN arch/arm26/kernel/entry.S~arch-arm26-kernel-entrys-remove-dead-code arch/arm26/kernel/entry.S
--- a/arch/arm26/kernel/entry.S~arch-arm26-kernel-entrys-remove-dead-code
+++ a/arch/arm26/kernel/entry.S
@@ -245,11 +245,6 @@ ENTRY(vector_swi)
 	zero_fp
 	get_scno
 
-#ifdef CONFIG_ALIGNMENT_TRAP
-	ldr	ip, __cr_alignment
-	ldr	ip, [ip]
-	mcr	p15, 0, ip, c1, c0		@ update control register
-#endif
 	enable_irqs ip
 
 	str	r4, [sp, #-S_OFF]!		@ push fifth arg
@@ -299,11 +294,6 @@ __sys_trace_return:
 	b	ret_slow_syscall
 
 	.align	5
-#ifdef CONFIG_ALIGNMENT_TRAP
-	.type	__cr_alignment, #object
-__cr_alignment:
-	.word	cr_alignment
-#endif
 
 	.type	sys_call_table, #object
 ENTRY(sys_call_table)
_

Patches currently in -mm which might be from bunk@stusta.de are

arch-arm26-kernel-entrys-remove-dead-code.patch
git-cpufreq.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
mips-remove-smp_tune_scheduling.patch
remove-fs-jffs2-ioctlc.patch
git-ubi.patch
git-net.patch
net-uninline-skb_put-fix.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
git-unionfs.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
lumpy-reclaim-cleanup.patch
kill-net-rxrpc-rxrpc_symsc.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
linux-kernel-markers-kconfig-menus-fix.patch
linux-kernel-markers-architecture-independant-code-license-fix.patch
linux-kernel-markers-i386-optimization-export-fix.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
