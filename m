From: akpm@osdl.org
Subject: + i386-add-option-to-show-more-code-in-oops-reports.patch added to -mm tree
Date: Mon, 29 Jan 2007 17:04:18 -0800
Message-ID: <200701300104.l0U14IwO004935@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36031 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932854AbXA3BE2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 20:04:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cebbert@redhat.com, ak@suse.de


The patch titled
     i386: add option to show more code in oops reports
has been added to the -mm tree.  Its filename is
     i386-add-option-to-show-more-code-in-oops-reports.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: add option to show more code in oops reports
From: Chuck Ebbert <cebbert@redhat.com>

Sometimes developers need to see more object code in an oops report,
e.g. when kernel may be corrupted at runtime.

Add the "code_bytes" option for this.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/kernel-parameters.txt |    5 +++++
 arch/i386/kernel/traps.c            |   20 ++++++++++++++++----
 2 files changed, 21 insertions(+), 4 deletions(-)

diff -puN Documentation/kernel-parameters.txt~i386-add-option-to-show-more-code-in-oops-reports Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~i386-add-option-to-show-more-code-in-oops-reports
+++ a/Documentation/kernel-parameters.txt
@@ -365,6 +365,11 @@ and is between 256 and 4096 characters. 
 			clocksource is not available, it defaults to PIT.
 			Format: { pit | tsc | cyclone | pmtmr }
 
+	code_bytes	[IA32] How many bytes of object code to print in an
+			oops report.
+			Range: 0 - 8192
+			Default: 64
+
 	disable_8254_timer
 	enable_8254_timer
 			[IA32/X86_64] Disable/Enable interrupt 0 timer routing
diff -puN arch/i386/kernel/traps.c~i386-add-option-to-show-more-code-in-oops-reports arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c~i386-add-option-to-show-more-code-in-oops-reports
+++ a/arch/i386/kernel/traps.c
@@ -94,6 +94,7 @@ asmlinkage void spurious_interrupt_bug(v
 asmlinkage void machine_check(void);
 
 int kstack_depth_to_print = 24;
+static unsigned int code_bytes = 64;
 ATOMIC_NOTIFIER_HEAD(i386die_chain);
 
 int register_die_notifier(struct notifier_block *nb)
@@ -325,7 +326,8 @@ void show_registers(struct pt_regs *regs
 	 */
 	if (in_kernel) {
 		u8 *eip;
-		int code_bytes = 64;
+		unsigned int code_prologue = code_bytes * 43 / 64;
+		unsigned int code_len = code_bytes;
 		unsigned char c;
 
 		printk("\n" KERN_EMERG "Stack: ");
@@ -333,14 +335,14 @@ void show_registers(struct pt_regs *regs
 
 		printk(KERN_EMERG "Code: ");
 
-		eip = (u8 *)regs->eip - 43;
+		eip = (u8 *)regs->eip - code_prologue;
 		if (eip < (u8 *)PAGE_OFFSET ||
 			probe_kernel_address(eip, c)) {
 			/* try starting at EIP */
 			eip = (u8 *)regs->eip;
-			code_bytes = 32;
+			code_len = code_len - code_prologue + 1;
 		}
-		for (i = 0; i < code_bytes; i++, eip++) {
+		for (i = 0; i < code_len; i++, eip++) {
 			if (eip < (u8 *)PAGE_OFFSET ||
 				probe_kernel_address(eip, c)) {
 				printk(" Bad EIP value.");
@@ -1192,3 +1194,13 @@ static int __init kstack_setup(char *s)
 	return 1;
 }
 __setup("kstack=", kstack_setup);
+
+static int __init code_bytes_setup(char *s)
+{
+	code_bytes = simple_strtoul(s, NULL, 0);
+	if (code_bytes > 8192)
+		code_bytes = 8192;
+
+	return 1;
+}
+__setup("code_bytes=", code_bytes_setup);
_

Patches currently in -mm which might be from cebbert@redhat.com are

i386-add-option-to-show-more-code-in-oops-reports.patch
