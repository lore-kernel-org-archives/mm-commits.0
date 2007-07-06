From: akpm@linux-foundation.org
Subject: + pm-optional-beeping-during-resume-from-suspend-to-ram.patch added to -mm tree
Date: Fri, 06 Jul 2007 15:40:13 -0700
Message-ID: <200707062240.l66MeD4A024634@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51629 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750953AbXGFWlP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 18:41:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nigel@nigel.suspend2.net, rjw@sisk.pl


The patch titled
     PM: Optional beeping during resume from suspend to RAM
has been added to the -mm tree.  Its filename is
     pm-optional-beeping-during-resume-from-suspend-to-ram.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PM: Optional beeping during resume from suspend to RAM
From: Nigel Cunningham <nigel@nigel.suspend2.net>

Add a feature allowing the user to make the system beep during a resume from
suspend to RAM, on x86_64 and i386.

This is useful for the users with broken resume from RAM, so that they can
verify if the control reaches the kernel after a wake-up event.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/acpi/wakeup.S   |   27 +++++++++++++++++++++++++++
 arch/x86_64/kernel/acpi/wakeup.S |   25 +++++++++++++++++++++++++
 include/linux/acpi.h             |    1 +
 kernel/power/main.c              |   23 +++++++++++++++++++++++
 4 files changed, 76 insertions(+)

diff -puN arch/i386/kernel/acpi/wakeup.S~pm-optional-beeping-during-resume-from-suspend-to-ram arch/i386/kernel/acpi/wakeup.S
--- a/arch/i386/kernel/acpi/wakeup.S~pm-optional-beeping-during-resume-from-suspend-to-ram
+++ a/arch/i386/kernel/acpi/wakeup.S
@@ -13,6 +13,21 @@
 # cs = 0x1234, eip = 0x05
 # 
 
+#define BEEP \
+	inb	$97, %al; 	\
+	outb	%al, $0x80; 	\
+	movb	$3, %al; 	\
+	outb	%al, $97; 	\
+	outb	%al, $0x80; 	\
+	movb	$-74, %al; 	\
+	outb	%al, $67; 	\
+	outb	%al, $0x80; 	\
+	movb	$-119, %al; 	\
+	outb	%al, $66; 	\
+	outb	%al, $0x80; 	\
+	movb	$15, %al; 	\
+	outb	%al, $66;
+
 ALIGN
 	.align	4096
 ENTRY(wakeup_start)
@@ -31,6 +46,11 @@ wakeup_code:
 	movw	%cs, %ax
 	movw	%ax, %ds					# Make ds:0 point to wakeup_start
 	movw	%ax, %ss
+
+	testl   $1, beep_flags - wakeup_code
+	jz      1f
+	BEEP
+1:
 	mov	$(wakeup_stack - wakeup_code), %sp		# Private stack is needed for ASUS board
 	movw	$0x0e00 + 'S', %fs:(0x12)
 
@@ -88,6 +108,10 @@ wakeup_code:
 	cmpl	$0x12345678, %eax
 	jne	bogus_real_magic
 
+	testl   $2, beep_flags - wakeup_code
+	jz      1f
+	BEEP
+1:
 	ljmpl	$__KERNEL_CS,$wakeup_pmode_return
 
 real_save_gdt:	.word 0
@@ -98,6 +122,7 @@ real_save_cr4:	.long 0
 real_magic:	.long 0
 video_mode:	.long 0
 video_flags:	.long 0
+beep_flags:	.long 0
 real_efer_save_restore:	.long 0
 real_save_efer_edx: 	.long 0
 real_save_efer_eax: 	.long 0
@@ -262,6 +287,8 @@ ENTRY(acpi_copy_wakeup_routine)
 	movl	%edx, video_mode - wakeup_start (%eax)
 	movl	acpi_video_flags, %edx
 	movl	%edx, video_flags - wakeup_start (%eax)
+	movl	s2ram_beep, %edx
+	movl	%edx, beep_flags - wakeup_start (%eax)
 	movl	$0x12345678, real_magic - wakeup_start (%eax)
 	movl	$0x12345678, saved_magic
 	popl	%ebx
diff -puN arch/x86_64/kernel/acpi/wakeup.S~pm-optional-beeping-during-resume-from-suspend-to-ram arch/x86_64/kernel/acpi/wakeup.S
--- a/arch/x86_64/kernel/acpi/wakeup.S~pm-optional-beeping-during-resume-from-suspend-to-ram
+++ a/arch/x86_64/kernel/acpi/wakeup.S
@@ -16,6 +16,21 @@
 # cs = 0x1234, eip = 0x05
 #
 
+#define BEEP \
+	inb	$97, %al; 	\
+	outb	%al, $0x80; 	\
+	movb	$3, %al; 	\
+	outb	%al, $97; 	\
+	outb	%al, $0x80; 	\
+	movb	$-74, %al; 	\
+	outb	%al, $67; 	\
+	outb	%al, $0x80; 	\
+	movb	$-119, %al; 	\
+	outb	%al, $66; 	\
+	outb	%al, $0x80; 	\
+	movb	$15, %al; 	\
+	outb	%al, $66;
+
 
 ALIGN
 	.align	16
@@ -33,6 +48,13 @@ wakeup_code:
 	movw	%cs, %ax
 	movw	%ax, %ds		# Make ds:0 point to wakeup_start
 	movw	%ax, %ss
+
+	# Data segment must be set up before we can see whether to beep.
+	testl   $1, beep_flags - wakeup_code
+	jz      1f
+	BEEP
+1:
+
 					# Private stack is needed for ASUS board
 	mov	$(wakeup_stack - wakeup_code), %sp
 
@@ -229,6 +251,7 @@ gdt_48a:
 	.long   gdta - wakeup_code              # gdt base (relocated in later)
 	
 real_magic:	.quad 0
+beep_flags:	.quad 0
 video_mode:	.quad 0
 video_flags:	.quad 0
 
@@ -344,6 +367,8 @@ ENTRY(acpi_copy_wakeup_routine)
 	pushq	%rax
 	pushq	%rdx
 
+	movl	s2ram_beep, %edx
+	movl	%edx, beep_flags - wakeup_start (,%rdi)
 	movl	saved_video_mode, %edx
 	movl	%edx, video_mode - wakeup_start (,%rdi)
 	movl	acpi_video_flags, %edx
diff -puN include/linux/acpi.h~pm-optional-beeping-during-resume-from-suspend-to-ram include/linux/acpi.h
--- a/include/linux/acpi.h~pm-optional-beeping-during-resume-from-suspend-to-ram
+++ a/include/linux/acpi.h
@@ -121,6 +121,7 @@ extern int pci_mmcfg_config_num;
 
 extern int sbf_port;
 extern unsigned long acpi_video_flags;
+extern unsigned long s2ram_beep;
 
 #else	/* !CONFIG_ACPI */
 
diff -puN kernel/power/main.c~pm-optional-beeping-during-resume-from-suspend-to-ram kernel/power/main.c
--- a/kernel/power/main.c~pm-optional-beeping-during-resume-from-suspend-to-ram
+++ a/kernel/power/main.c
@@ -332,6 +332,27 @@ static ssize_t state_store(struct kset *
 
 power_attr(state);
 
+unsigned long s2ram_beep = 0;
+
+static ssize_t s2ram_beep_show(struct kset *kset, char *buf)
+{
+	return sprintf(buf, "%d\n", s2ram_beep);
+}
+
+static ssize_t
+s2ram_beep_store(struct kset *kset, const char *buf, size_t n)
+{
+	int val;
+
+	if (sscanf(buf, "%d", &val) > 0) {
+		s2ram_beep = val;
+		return n;
+	}
+	return -EINVAL;
+}
+
+power_attr(s2ram_beep);
+
 #ifdef CONFIG_PM_TRACE
 int pm_trace_enabled;
 
@@ -357,11 +378,13 @@ power_attr(pm_trace);
 static struct attribute * g[] = {
 	&state_attr.attr,
 	&pm_trace_attr.attr,
+	&s2ram_beep_attr.attr,
 	NULL,
 };
 #else
 static struct attribute * g[] = {
 	&state_attr.attr,
+	&s2ram_beep_attr.attr,
 	NULL,
 };
 #endif /* CONFIG_PM_TRACE */
_

Patches currently in -mm which might be from nigel@nigel.suspend2.net are

x86_64-pm_trace-support.patch
freezer-make-kernel-threads-nonfreezable-by-default.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-2.patch
swsusp-remove-incorrect-code-from-userc.patch
swsusp-remove-code-duplication-between-diskc-and-userc.patch
swsusp-introduce-restore-platform-operations.patch
swsusp-fix-hibernation-code-ordering.patch
hibernation-prepare-to-enter-the-low-power-state.patch
freezer-avoid-freezing-kernel-threads-prematurely.patch
pm-introduce-hibernation-and-suspend-notifiers.patch
pm-introduce-hibernation-and-suspend-notifiers-fix.patch
pm-introduce-hibernation-and-suspend-notifiers-tidy.patch
pm-introduce-hibernation-and-suspend-notifiers-fix-fix.patch
pm-disable-usermode-helper-before-hibernation-and-suspend.patch
pm-disable-usermode-helper-before-hibernation-and-suspend-fix.patch
pm-prevent-frozen-user-mode-helpers-from-failing-the-freezing-of-tasks-rev-2.patch
pm-reduce-code-duplication-between-mainc-and-userc-updated.patch
pm-optional-beeping-during-resume-from-suspend-to-ram.patch
