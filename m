From: akpm@linux-foundation.org
Subject: + kexec-jump-check-code-size-in-control-page.patch added to -mm tree
Date: Tue, 12 Aug 2008 16:15:45 -0700
Message-ID: <200808122315.m7CNFjAK018739@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751517AbYHLXQ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 19:16:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ying.huang@intel.com, ebiederm@xmission.com, mingo@elte.hu, pavel@ucw.cz, rjw@sisk.pl, vgoyal@redhat.com


The patch titled
     kexec jump: check code size in control page
has been added to the -mm tree.  Its filename is
     kexec-jump-check-code-size-in-control-page.patch

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
Subject: kexec jump: check code size in control page
From: Huang Ying <ying.huang@intel.com>

Kexec/Kexec-jump require code size in control page is less than
PAGE_SIZE/2.  This patch add link-time checking for this.

ASSERT() of ld link script is used as the link-time checking mechanism.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/machine_kexec_32.c   |    2 +-
 arch/x86/kernel/relocate_kernel_32.S |   10 +++++++---
 arch/x86/kernel/vmlinux_32.lds.S     |    6 ++++++
 include/asm-x86/kexec.h              |    4 ++++
 4 files changed, 18 insertions(+), 4 deletions(-)

diff -puN arch/x86/kernel/machine_kexec_32.c~kexec-jump-check-code-size-in-control-page arch/x86/kernel/machine_kexec_32.c
--- a/arch/x86/kernel/machine_kexec_32.c~kexec-jump-check-code-size-in-control-page
+++ a/arch/x86/kernel/machine_kexec_32.c
@@ -138,7 +138,7 @@ void machine_kexec(struct kimage *image)
 	}
 
 	control_page = page_address(image->control_code_page);
-	memcpy(control_page, relocate_kernel, PAGE_SIZE/2);
+	memcpy(control_page, relocate_kernel, KEXEC_CONTROL_CODE_MAX_SIZE);
 
 	relocate_kernel_ptr = control_page;
 	page_list[PA_CONTROL_PAGE] = __pa(control_page);
diff -puN arch/x86/kernel/relocate_kernel_32.S~kexec-jump-check-code-size-in-control-page arch/x86/kernel/relocate_kernel_32.S
--- a/arch/x86/kernel/relocate_kernel_32.S~kexec-jump-check-code-size-in-control-page
+++ a/arch/x86/kernel/relocate_kernel_32.S
@@ -20,10 +20,11 @@
 #define PAGE_ATTR (_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED | _PAGE_DIRTY)
 #define PAE_PGD_ATTR (_PAGE_PRESENT)
 
-/* control_page + PAGE_SIZE/2 ~ control_page + PAGE_SIZE * 3/4 are
- * used to save some data for jumping back
+/* control_page + KEXEC_CONTROL_CODE_MAX_SIZE
+ * ~ control_page + PAGE_SIZE are used as data storage and stack for
+ * jumping back
  */
-#define DATA(offset)		(PAGE_SIZE/2+(offset))
+#define DATA(offset)		(KEXEC_CONTROL_CODE_MAX_SIZE+(offset))
 
 /* Minimal CPU state */
 #define ESP			DATA(0x0)
@@ -376,3 +377,6 @@ swap_pages:
 	popl	%ebx
 	popl	%ebp
 	ret
+
+	.globl kexec_control_code_size
+.set kexec_control_code_size, . - relocate_kernel
diff -puN arch/x86/kernel/vmlinux_32.lds.S~kexec-jump-check-code-size-in-control-page arch/x86/kernel/vmlinux_32.lds.S
--- a/arch/x86/kernel/vmlinux_32.lds.S~kexec-jump-check-code-size-in-control-page
+++ a/arch/x86/kernel/vmlinux_32.lds.S
@@ -210,3 +210,9 @@ SECTIONS
 
   DWARF_DEBUG
 }
+
+/* Link time checks */
+#include <asm/kexec.h>
+
+ASSERT(kexec_control_code_size <= KEXEC_CONTROL_CODE_MAX_SIZE,
+       "kexec control code size is too big")
diff -puN include/asm-x86/kexec.h~kexec-jump-check-code-size-in-control-page include/asm-x86/kexec.h
--- a/include/asm-x86/kexec.h~kexec-jump-check-code-size-in-control-page
+++ a/include/asm-x86/kexec.h
@@ -41,6 +41,10 @@
 # define PAGES_NR		17
 #endif
 
+#ifdef CONFIG_X86_32
+# define KEXEC_CONTROL_CODE_MAX_SIZE	2048
+#endif
+
 #ifndef __ASSEMBLY__
 
 #include <linux/string.h>
_

Patches currently in -mm which might be from ying.huang@intel.com are

origin.patch
kexec-jump-clean-up-ifdef-and-comments.patch
kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size.patch
kexec-jump-check-code-size-in-control-page.patch
kexec-jump-remove-duplication-of-kexec_restart_prepare.patch
kexec-jump-in-sync-with-hibernation-implementation.patch
kexec-jump-__ftrace_enabled_save-restore.patch
kexec-jump-fix-for-ftrace.patch

