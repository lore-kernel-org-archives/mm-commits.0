From: akpm@linux-foundation.org
Subject: +
 revert-kdump-vmcoreinfo-report-memory-sections-virtual-addresses.patch
 added to -mm tree
Date: Tue, 08 Nov 2016 14:07:34 -0800
Message-ID: <58224ca6.VOFJLbmF0PTCUg+m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46332 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750724AbcKHWHg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2016 17:07:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, anderson@redhat.com, ats-kumagai@wm.jp.nec.com, d.hatayama@jp.fujitsu.com, dyoung@redhat.com, ebiederm@xmission.com, hpa@zytor.com, keescook@chromium.org, mingo@redhat.com, panand@redhat.com, surovegin@google.com, takahiro.akashi@linaro.org, tglx@linutronix.de, thgarnie@google.com, vgoyal@redhat.com, xlpang@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "kdump, vmcoreinfo: report memory sections virtual addresses"
has been added to the -mm tree.  Its filename is
     revert-kdump-vmcoreinfo-report-memory-sections-virtual-addresses.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-kdump-vmcoreinfo-report-memory-sections-virtual-addresses.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-kdump-vmcoreinfo-report-memory-sections-virtual-addresses.patch

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
Subject: Revert "kdump, vmcoreinfo: report memory sections virtual addresses"

This reverts 0549a3c02efb3507 ("kdump, vmcoreinfo: report memory sections
virtual addresses").

Commit 0549a3c tells the userspace utility makedumpfile the randomized
base address of these memmory sections when mm kaslr is enabled.  However
the following patch "kexec: export the value of phys_base instead of
symbol address" makes makedumpfile not need these addresses any more.

Besides we should use VMCOREINFO_NUMBER to export the value of the
variable so that we can use the existing number_table mechanism of
Makedumpfile to fetch it.  So revert it now.  If needed we can add it later.

http://lists.infradead.org/pipermail/kexec/2016-October/017540.html
Link: http://lkml.kernel.org/r/1478568596-30060-1-git-send-email-bhe@redhat.com
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

 arch/x86/kernel/machine_kexec_64.c |    3 ---
 include/linux/kexec.h              |    6 ------
 2 files changed, 9 deletions(-)

diff -puN arch/x86/kernel/machine_kexec_64.c~revert-kdump-vmcoreinfo-report-memory-sections-virtual-addresses arch/x86/kernel/machine_kexec_64.c
--- a/arch/x86/kernel/machine_kexec_64.c~revert-kdump-vmcoreinfo-report-memory-sections-virtual-addresses
+++ a/arch/x86/kernel/machine_kexec_64.c
@@ -337,9 +337,6 @@ void arch_crash_save_vmcoreinfo(void)
 #endif
 	vmcoreinfo_append_str("KERNELOFFSET=%lx\n",
 			      kaslr_offset());
-	VMCOREINFO_PAGE_OFFSET(PAGE_OFFSET);
-	VMCOREINFO_VMALLOC_START(VMALLOC_START);
-	VMCOREINFO_VMEMMAP_START(VMEMMAP_START);
 }
 
 /* arch-dependent functionality related to kexec file-based syscall */
diff -puN include/linux/kexec.h~revert-kdump-vmcoreinfo-report-memory-sections-virtual-addresses include/linux/kexec.h
--- a/include/linux/kexec.h~revert-kdump-vmcoreinfo-report-memory-sections-virtual-addresses
+++ a/include/linux/kexec.h
@@ -259,12 +259,6 @@ phys_addr_t paddr_vmcoreinfo_note(void);
 	vmcoreinfo_append_str("NUMBER(%s)=%ld\n", #name, (long)name)
 #define VMCOREINFO_CONFIG(name) \
 	vmcoreinfo_append_str("CONFIG_%s=y\n", #name)
-#define VMCOREINFO_PAGE_OFFSET(value) \
-	vmcoreinfo_append_str("PAGE_OFFSET=%lx\n", (unsigned long)value)
-#define VMCOREINFO_VMALLOC_START(value) \
-	vmcoreinfo_append_str("VMALLOC_START=%lx\n", (unsigned long)value)
-#define VMCOREINFO_VMEMMAP_START(value) \
-	vmcoreinfo_append_str("VMEMMAP_START=%lx\n", (unsigned long)value)
 
 extern struct kimage *kexec_image;
 extern struct kimage *kexec_crash_image;
_

Patches currently in -mm which might be from bhe@redhat.com are

revert-kdump-vmcoreinfo-report-memory-sections-virtual-addresses.patch
kexec-change-to-export-the-value-of-phys_base-instead-of-symbol-address.patch

