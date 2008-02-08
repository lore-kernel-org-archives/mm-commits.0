From: akpm@linux-foundation.org
Subject: + x86-fix-pgtable_t-build-breakage.patch added to -mm tree
Date: Fri, 08 Feb 2008 15:48:44 -0800
Message-ID: <200802082348.m18NmPqn020208@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60965 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754269AbYBHXtv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 18:49:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, schwidefsky@de.ibm.com


The patch titled
     x86: fix pgtable_t build breakage
has been added to the -mm tree.  Its filename is
     x86-fix-pgtable_t-build-breakage.patch

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
Subject: x86: fix pgtable_t build breakage
From: Ingo Molnar <mingo@elte.hu>

Fix build breakage caused by commit 2f569afd9ced9ebec9.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/page_32.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN include/asm-x86/page_32.h~x86-fix-pgtable_t-build-breakage include/asm-x86/page_32.h
--- a/include/asm-x86/page_32.h~x86-fix-pgtable_t-build-breakage
+++ a/include/asm-x86/page_32.h
@@ -50,11 +50,13 @@ typedef unsigned long	phys_addr_t;
 typedef union { pteval_t pte, pte_low; } pte_t;
 typedef pte_t boot_pte_t;
 
-typedef struct page *pgtable_t;
-
 #endif	/* __ASSEMBLY__ */
 #endif	/* CONFIG_X86_PAE */
 
+#ifndef __ASSEMBLY__
+typedef struct page *pgtable_t;
+#endif
+
 #ifdef CONFIG_HUGETLB_PAGE
 #define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
 #endif
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
x86-fix-pgtable_t-build-breakage.patch
smack-unlabeled-outgoing-ambient-packets.patch
git-hrt.patch
revert-git-hrt.patch
git-kvm.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
pci-disable-decoding-during-sizing-of-bars.patch
x86-validate-against-acpi-motherboard-resources.patch
git-sched.patch
git-sched-fix-git-conflicts.patch
git-x86.patch
git-x86-fix-git-conflicts.patch
deprecate-find_task_by_pid-kgdb.patch
x86-amd-thermal-interrupt-support.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected.patch
x86-mmconf-enable-mcfg-early.patch
x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron-v3.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used.patch
d_path-make-d_path-use-a-struct-path-fix.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
