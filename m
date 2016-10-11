From: akpm@linux-foundation.org
Subject: [patch 084/102] kdump, vmcoreinfo: report memory sections virtual addresses
Date: Tue, 11 Oct 2016 13:55:08 -0700
Message-ID: <57fd51ac.D8abWi9Pph0Trd1M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38428 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751554AbcJKU5W (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:57:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, thgarnie@google.com, bhe@redhat.com, d.hatayama@jp.fujitsu.com, ebiederm@xmission.com, hpa@zytor.com, keescook@chromium.org, mingo@redhat.com, surovegin@google.com, tglx@linutronix.de, xlpang@redhat.com

From: Thomas Garnier <thgarnie@google.com>
Subject: kdump, vmcoreinfo: report memory sections virtual addresses

KASLR memory randomization can randomize the base of the physical memory
mapping (PAGE_OFFSET), vmalloc (VMALLOC_START) and vmemmap
(VMEMMAP_START).  Adding these variables on VMCOREINFO so tools can easily
identify the base of each memory section.

Link: http://lkml.kernel.org/r/1471531632-23003-1-git-send-email-thgarnie@google.com
Signed-off-by: Thomas Garnier <thgarnie@google.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Xunlei Pang <xlpang@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Eugene Surovegin <surovegin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/machine_kexec_64.c |    3 +++
 include/linux/kexec.h              |    6 ++++++
 2 files changed, 9 insertions(+)

diff -puN arch/x86/kernel/machine_kexec_64.c~kdump-vmcoreinfo-report-memory-sections-virtual-addresses arch/x86/kernel/machine_kexec_64.c
--- a/arch/x86/kernel/machine_kexec_64.c~kdump-vmcoreinfo-report-memory-sections-virtual-addresses
+++ a/arch/x86/kernel/machine_kexec_64.c
@@ -337,6 +337,9 @@ void arch_crash_save_vmcoreinfo(void)
 #endif
 	vmcoreinfo_append_str("KERNELOFFSET=%lx\n",
 			      kaslr_offset());
+	VMCOREINFO_PAGE_OFFSET(PAGE_OFFSET);
+	VMCOREINFO_VMALLOC_START(VMALLOC_START);
+	VMCOREINFO_VMEMMAP_START(VMEMMAP_START);
 }
 
 /* arch-dependent functionality related to kexec file-based syscall */
diff -puN include/linux/kexec.h~kdump-vmcoreinfo-report-memory-sections-virtual-addresses include/linux/kexec.h
--- a/include/linux/kexec.h~kdump-vmcoreinfo-report-memory-sections-virtual-addresses
+++ a/include/linux/kexec.h
@@ -259,6 +259,12 @@ phys_addr_t paddr_vmcoreinfo_note(void);
 	vmcoreinfo_append_str("NUMBER(%s)=%ld\n", #name, (long)name)
 #define VMCOREINFO_CONFIG(name) \
 	vmcoreinfo_append_str("CONFIG_%s=y\n", #name)
+#define VMCOREINFO_PAGE_OFFSET(value) \
+	vmcoreinfo_append_str("PAGE_OFFSET=%lx\n", (unsigned long)value)
+#define VMCOREINFO_VMALLOC_START(value) \
+	vmcoreinfo_append_str("VMALLOC_START=%lx\n", (unsigned long)value)
+#define VMCOREINFO_VMEMMAP_START(value) \
+	vmcoreinfo_append_str("VMEMMAP_START=%lx\n", (unsigned long)value)
 
 extern struct kimage *kexec_image;
 extern struct kimage *kexec_crash_image;
_
