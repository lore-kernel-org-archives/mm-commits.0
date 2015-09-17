From: akpm@linux-foundation.org
Subject: +
 uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch added to -mm tree
Date: Thu, 17 Sep 2015 12:22:27 -0700
Message-ID: <55fb12f3.ODywJpkZ6UWLT546%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37093 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbbIQTW2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Sep 2015 15:22:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix
has been added to the -mm tree.  Its filename is
     uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
maintainers-update-ltp-mailing-list-fix.patch
mm-dax-vma-with-vm_ops-pfn_mkwrite-wants-to-be-write-notified-fix.patch
revert-mm-make-sure-all-file-vmas-have-vm_ops-set.patch
mm.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

