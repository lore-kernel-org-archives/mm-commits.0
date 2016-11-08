From: akpm@linux-foundation.org
Subject: +
 kexec-change-to-export-the-value-of-phys_base-instead-of-symbol-address.patch added to -mm tree
Date: Tue, 08 Nov 2016 14:07:37 -0800
Message-ID: <58224ca9.Z1eVmCSqZPNdHE33%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46354 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750724AbcKHWHj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2016 17:07:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, anderson@redhat.com, ats-kumagai@wm.jp.nec.com, d.hatayama@jp.fujitsu.com, dyoung@redhat.com, ebiederm@xmission.com, hpa@zytor.com, keescook@chromium.org, mingo@redhat.com, panand@redhat.com, surovegin@google.com, takahiro.akashi@linaro.org, tglx@linutronix.de, thgarnie@google.com, vgoyal@redhat.com, xlpang@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: export the value of phys_base instead of symbol address
has been added to the -mm tree.  Its filename is
     kexec-change-to-export-the-value-of-phys_base-instead-of-symbol-address.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-change-to-export-the-value-of-phys_base-instead-of-symbol-address.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-change-to-export-the-value-of-phys_base-instead-of-symbol-address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: kexec: export the value of phys_base instead of symbol address

Currently in x86_64, the symbol address of phys_base is exported to
vmcoreinfo.  Dave Anderson complained this is really useless for his Crash
implementation.  Because in user-space utility Crash and Makedumpfile
which exported vmcore information is mainly used for, value of phys_base
is needed to covert virtual address of exported kernel symbol to physical
address.  Especially init_level4_pgt, if we want to access and go over the
page table to look up a PA corresponding to VA, firstly we need calculate

  page_dir = SYMBOL(init_level4_pgt) - __START_KERNEL_map + phys_base;

Now in Crash and Makedumpfile, we have to analyze the vmcore elf program
header to get value of phys_base.  As Dave said, it would be preferable if
it were readily availabl in vmcoreinfo rather than depending upon the
PT_LOAD semantics.

Hence in this patch change to export the value of phys_base instead of its
virtual address.

And people also complained that KERNEL_IMAGE_SIZE exporting is x86_64
only, should be moved into arch dependent function
arch_crash_save_vmcoreinfo.  Do the moving in this patch.

Link: http://lkml.kernel.org/r/1478568596-30060-2-git-send-email-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Thomas Garnier <thgarnie@google.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Xunlei Pang <xlpang@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Eugene Surovegin <surovegin@google.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Atsushi Kumagai <ats-kumagai@wm.jp.nec.com>
Cc: Dave Anderson <anderson@redhat.com>
Cc: Pratyush Anand <panand@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/machine_kexec_64.c |    3 ++-
 kernel/kexec_core.c                |    3 ---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN arch/x86/kernel/machine_kexec_64.c~kexec-change-to-export-the-value-of-phys_base-instead-of-symbol-address arch/x86/kernel/machine_kexec_64.c
--- a/arch/x86/kernel/machine_kexec_64.c~kexec-change-to-export-the-value-of-phys_base-instead-of-symbol-address
+++ a/arch/x86/kernel/machine_kexec_64.c
@@ -328,7 +328,7 @@ void machine_kexec(struct kimage *image)
 
 void arch_crash_save_vmcoreinfo(void)
 {
-	VMCOREINFO_SYMBOL(phys_base);
+	VMCOREINFO_NUMBER(phys_base);
 	VMCOREINFO_SYMBOL(init_level4_pgt);
 
 #ifdef CONFIG_NUMA
@@ -337,6 +337,7 @@ void arch_crash_save_vmcoreinfo(void)
 #endif
 	vmcoreinfo_append_str("KERNELOFFSET=%lx\n",
 			      kaslr_offset());
+	VMCOREINFO_NUMBER(KERNEL_IMAGE_SIZE);
 }
 
 /* arch-dependent functionality related to kexec file-based syscall */
diff -puN kernel/kexec_core.c~kexec-change-to-export-the-value-of-phys_base-instead-of-symbol-address kernel/kexec_core.c
--- a/kernel/kexec_core.c~kexec-change-to-export-the-value-of-phys_base-instead-of-symbol-address
+++ a/kernel/kexec_core.c
@@ -1467,9 +1467,6 @@ static int __init crash_save_vmcoreinfo_
 #endif
 	VMCOREINFO_NUMBER(PG_head_mask);
 	VMCOREINFO_NUMBER(PAGE_BUDDY_MAPCOUNT_VALUE);
-#ifdef CONFIG_X86
-	VMCOREINFO_NUMBER(KERNEL_IMAGE_SIZE);
-#endif
 #ifdef CONFIG_HUGETLB_PAGE
 	VMCOREINFO_NUMBER(HUGETLB_PAGE_DTOR);
 #endif
_

Patches currently in -mm which might be from bhe@redhat.com are

revert-kdump-vmcoreinfo-report-memory-sections-virtual-addresses.patch
kexec-change-to-export-the-value-of-phys_base-instead-of-symbol-address.patch

