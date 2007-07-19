From: akpm@linux-foundation.org
Subject: - pm-integrate-beeping-flag-with-existing-acpi_sleep-flags.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:00:34 -0700
Message-ID: <200707192000.l6JK0Ybw019462@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47268 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751447AbXGSUYn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:24:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@suse.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     PM: Integrate beeping flag with existing acpi_sleep flags
has been removed from the -mm tree.  Its filename was
     pm-integrate-beeping-flag-with-existing-acpi_sleep-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PM: Integrate beeping flag with existing acpi_sleep flags
From: Pavel Machek <pavel@suse.cz>

Move "debug during resume from s2ram" into the variable we already use
for real-mode flags to simplify code. It also closes nasty trap for
the user in acpi_sleep_setup; order of parameters actually mattered there,
acpi_sleep=s3_bios,s3_mode doing something different from
acpi_sleep=s3_mode,s3_bios.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/acpi/sleep.c    |   12 ++++++++----
 arch/i386/kernel/acpi/wakeup.S   |   18 ++++++++----------
 arch/x86_64/kernel/acpi/sleep.c  |    8 +++++---
 arch/x86_64/kernel/acpi/wakeup.S |   15 ++++++---------
 include/linux/acpi.h             |    3 +--
 kernel/power/main.c              |   23 -----------------------
 kernel/sysctl.c                  |    2 +-
 7 files changed, 29 insertions(+), 52 deletions(-)

diff -puN arch/i386/kernel/acpi/sleep.c~pm-integrate-beeping-flag-with-existing-acpi_sleep-flags arch/i386/kernel/acpi/sleep.c
--- a/arch/i386/kernel/acpi/sleep.c~pm-integrate-beeping-flag-with-existing-acpi_sleep-flags
+++ a/arch/i386/kernel/acpi/sleep.c
@@ -14,7 +14,7 @@
 
 /* address in low memory of the wakeup routine. */
 unsigned long acpi_wakeup_address = 0;
-unsigned long acpi_video_flags;
+unsigned long acpi_realmode_flags;
 extern char wakeup_start, wakeup_end;
 
 extern unsigned long FASTCALL(acpi_copy_wakeup_routine(unsigned long));
@@ -68,9 +68,11 @@ static int __init acpi_sleep_setup(char 
 {
 	while ((str != NULL) && (*str != '\0')) {
 		if (strncmp(str, "s3_bios", 7) == 0)
-			acpi_video_flags = 1;
+			acpi_realmode_flags |= 1;
 		if (strncmp(str, "s3_mode", 7) == 0)
-			acpi_video_flags |= 2;
+			acpi_realmode_flags |= 2;
+		if (strncmp(str, "s3_beep", 7) == 0)
+			acpi_realmode_flags |= 4;
 		str = strchr(str, ',');
 		if (str != NULL)
 			str += strspn(str, ", \t");
@@ -80,9 +82,11 @@ static int __init acpi_sleep_setup(char 
 
 __setup("acpi_sleep=", acpi_sleep_setup);
 
+/* Ouch, we want to delete this. We already have better version in userspace, in
+   s2ram from suspend.sf.net project */
 static __init int reset_videomode_after_s3(struct dmi_system_id *d)
 {
-	acpi_video_flags |= 2;
+	acpi_realmode_flags |= 2;
 	return 0;
 }
 
diff -puN arch/i386/kernel/acpi/wakeup.S~pm-integrate-beeping-flag-with-existing-acpi_sleep-flags arch/i386/kernel/acpi/wakeup.S
--- a/arch/i386/kernel/acpi/wakeup.S~pm-integrate-beeping-flag-with-existing-acpi_sleep-flags
+++ a/arch/i386/kernel/acpi/wakeup.S
@@ -47,7 +47,7 @@ wakeup_code:
 	movw	%ax, %ds					# Make ds:0 point to wakeup_start
 	movw	%ax, %ss
 
-	testl   $1, beep_flags - wakeup_code
+	testl   $4, realmode_flags - wakeup_code
 	jz      1f
 	BEEP
 1:
@@ -61,7 +61,7 @@ wakeup_code:
 	cmpl	$0x12345678, %eax
 	jne	bogus_real_magic
 
-	testl	$1, video_flags - wakeup_code
+	testl	$1, realmode_flags - wakeup_code
 	jz	1f
 	lcall   $0xc000,$3
 	movw	%cs, %ax
@@ -69,7 +69,7 @@ wakeup_code:
 	movw	%ax, %ss
 1:
 
-	testl	$2, video_flags - wakeup_code
+	testl	$2, realmode_flags - wakeup_code
 	jz	1f
 	mov	video_mode - wakeup_code, %ax
 	call	mode_set
@@ -108,11 +108,11 @@ wakeup_code:
 	cmpl	$0x12345678, %eax
 	jne	bogus_real_magic
 
-	testl   $2, beep_flags - wakeup_code
+	testl   $8, realmode_flags - wakeup_code
 	jz      1f
 	BEEP
 1:
-	ljmpl	$__KERNEL_CS,$wakeup_pmode_return
+	ljmpl	$__KERNEL_CS, $wakeup_pmode_return
 
 real_save_gdt:	.word 0
 		.long 0
@@ -121,7 +121,7 @@ real_save_cr3:	.long 0
 real_save_cr4:	.long 0
 real_magic:	.long 0
 video_mode:	.long 0
-video_flags:	.long 0
+realmode_flags:	.long 0
 beep_flags:	.long 0
 real_efer_save_restore:	.long 0
 real_save_efer_edx: 	.long 0
@@ -285,10 +285,8 @@ ENTRY(acpi_copy_wakeup_routine)
 
 	movl	saved_videomode, %edx
 	movl	%edx, video_mode - wakeup_start (%eax)
-	movl	acpi_video_flags, %edx
-	movl	%edx, video_flags - wakeup_start (%eax)
-	movl	s2ram_beep, %edx
-	movl	%edx, beep_flags - wakeup_start (%eax)
+	movl	acpi_realmode_flags, %edx
+	movl	%edx, realmode_flags - wakeup_start (%eax)
 	movl	$0x12345678, real_magic - wakeup_start (%eax)
 	movl	$0x12345678, saved_magic
 	popl	%ebx
diff -puN arch/x86_64/kernel/acpi/sleep.c~pm-integrate-beeping-flag-with-existing-acpi_sleep-flags arch/x86_64/kernel/acpi/sleep.c
--- a/arch/x86_64/kernel/acpi/sleep.c~pm-integrate-beeping-flag-with-existing-acpi_sleep-flags
+++ a/arch/x86_64/kernel/acpi/sleep.c
@@ -55,7 +55,7 @@
 
 /* address in low memory of the wakeup routine. */
 unsigned long acpi_wakeup_address = 0;
-unsigned long acpi_video_flags;
+unsigned long acpi_realmode_flags;
 extern char wakeup_start, wakeup_end;
 
 extern unsigned long acpi_copy_wakeup_routine(unsigned long);
@@ -103,9 +103,11 @@ static int __init acpi_sleep_setup(char 
 {
 	while ((str != NULL) && (*str != '\0')) {
 		if (strncmp(str, "s3_bios", 7) == 0)
-			acpi_video_flags = 1;
+			acpi_realmode_flags |= 1;
 		if (strncmp(str, "s3_mode", 7) == 0)
-			acpi_video_flags |= 2;
+			acpi_realmode_flags |= 2;
+		if (strncmp(str, "s3_beep", 7) == 0)
+			acpi_realmode_flags |= 4;
 		str = strchr(str, ',');
 		if (str != NULL)
 			str += strspn(str, ", \t");
diff -puN arch/x86_64/kernel/acpi/wakeup.S~pm-integrate-beeping-flag-with-existing-acpi_sleep-flags arch/x86_64/kernel/acpi/wakeup.S
--- a/arch/x86_64/kernel/acpi/wakeup.S~pm-integrate-beeping-flag-with-existing-acpi_sleep-flags
+++ a/arch/x86_64/kernel/acpi/wakeup.S
@@ -50,7 +50,7 @@ wakeup_code:
 	movw	%ax, %ss
 
 	# Data segment must be set up before we can see whether to beep.
-	testl   $1, beep_flags - wakeup_code
+	testl   $4, realmode_flags - wakeup_code
 	jz      1f
 	BEEP
 1:
@@ -70,7 +70,7 @@ wakeup_code:
 	testl	%eax, %eax
 	jnz	no_longmode
 
-	testl	$1, video_flags - wakeup_code
+	testl	$1, realmode_flags - wakeup_code
 	jz	1f
 	lcall   $0xc000,$3
 	movw	%cs, %ax
@@ -78,7 +78,7 @@ wakeup_code:
 	movw	%ax, %ss
 1:
 
-	testl	$2, video_flags - wakeup_code
+	testl	$2, realmode_flags - wakeup_code
 	jz	1f
 	mov	video_mode - wakeup_code, %ax
 	call	mode_seta
@@ -251,9 +251,8 @@ gdt_48a:
 	.long   gdta - wakeup_code              # gdt base (relocated in later)
 	
 real_magic:	.quad 0
-beep_flags:	.quad 0
 video_mode:	.quad 0
-video_flags:	.quad 0
+realmode_flags:	.quad 0
 
 .code16
 bogus_real_magic:
@@ -367,12 +366,10 @@ ENTRY(acpi_copy_wakeup_routine)
 	pushq	%rax
 	pushq	%rdx
 
-	movl	s2ram_beep, %edx
-	movl	%edx, beep_flags - wakeup_start (,%rdi)
 	movl	saved_video_mode, %edx
 	movl	%edx, video_mode - wakeup_start (,%rdi)
-	movl	acpi_video_flags, %edx
-	movl	%edx, video_flags - wakeup_start (,%rdi)
+	movl	acpi_realmode_flags, %edx
+	movl	%edx, realmode_flags - wakeup_start (,%rdi)
 	movq	$0x12345678, real_magic - wakeup_start (,%rdi)
 	movq	$0x123456789abcdef0, %rdx
 	movq	%rdx, saved_magic
diff -puN include/linux/acpi.h~pm-integrate-beeping-flag-with-existing-acpi_sleep-flags include/linux/acpi.h
--- a/include/linux/acpi.h~pm-integrate-beeping-flag-with-existing-acpi_sleep-flags
+++ a/include/linux/acpi.h
@@ -122,8 +122,7 @@ extern struct acpi_mcfg_allocation *pci_
 extern int pci_mmcfg_config_num;
 
 extern int sbf_port;
-extern unsigned long acpi_video_flags;
-extern unsigned long s2ram_beep;
+extern unsigned long acpi_realmode_flags;
 
 #else	/* !CONFIG_ACPI */
 
diff -puN kernel/power/main.c~pm-integrate-beeping-flag-with-existing-acpi_sleep-flags kernel/power/main.c
--- a/kernel/power/main.c~pm-integrate-beeping-flag-with-existing-acpi_sleep-flags
+++ a/kernel/power/main.c
@@ -332,27 +332,6 @@ static ssize_t state_store(struct kset *
 
 power_attr(state);
 
-unsigned long s2ram_beep = 0;
-
-static ssize_t s2ram_beep_show(struct kset *kset, char *buf)
-{
-	return sprintf(buf, "%d\n", s2ram_beep);
-}
-
-static ssize_t
-s2ram_beep_store(struct kset *kset, const char *buf, size_t n)
-{
-	int val;
-
-	if (sscanf(buf, "%d", &val) > 0) {
-		s2ram_beep = val;
-		return n;
-	}
-	return -EINVAL;
-}
-
-power_attr(s2ram_beep);
-
 #ifdef CONFIG_PM_TRACE
 int pm_trace_enabled;
 
@@ -378,13 +357,11 @@ power_attr(pm_trace);
 static struct attribute * g[] = {
 	&state_attr.attr,
 	&pm_trace_attr.attr,
-	&s2ram_beep_attr.attr,
 	NULL,
 };
 #else
 static struct attribute * g[] = {
 	&state_attr.attr,
-	&s2ram_beep_attr.attr,
 	NULL,
 };
 #endif /* CONFIG_PM_TRACE */
diff -puN kernel/sysctl.c~pm-integrate-beeping-flag-with-existing-acpi_sleep-flags kernel/sysctl.c
--- a/kernel/sysctl.c~pm-integrate-beeping-flag-with-existing-acpi_sleep-flags
+++ a/kernel/sysctl.c
@@ -660,7 +660,7 @@ static ctl_table kern_table[] = {
 	{
 		.ctl_name	= KERN_ACPI_VIDEO_FLAGS,
 		.procname	= "acpi_video_flags",
-		.data		= &acpi_video_flags,
+		.data		= &acpi_realmode_flags,
 		.maxlen		= sizeof (unsigned long),
 		.mode		= 0644,
 		.proc_handler	= &proc_doulongvec_minmax,
_

Patches currently in -mm which might be from pavel@suse.cz are

origin.patch
git-acpi.patch
