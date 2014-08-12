From: akpm@linux-foundation.org
Subject: [merged] init-mainc-code-clean-up.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:41:54 -0700
Message-ID: <53ea6e02.Bx5RwqOh5qyeiF0u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f73.google.com ([209.85.218.73]:52122 "EHLO
	mail-oi0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094AbaHLTlz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:41:55 -0400
Received: by mail-oi0-f73.google.com with SMTP id u20so1912284oif.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:41:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: init/main.c: code clean-up
has been removed from the -mm tree.  Its filename was
     init-mainc-code-clean-up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: init/main.c: code clean-up

Fixing some checkpatch warnings(remove global initialization, move
__initdata, coalesce formats ...)

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff -puN init/main.c~init-mainc-code-clean-up init/main.c
--- a/init/main.c~init-mainc-code-clean-up
+++ a/init/main.c
@@ -6,7 +6,7 @@
  *  GK 2/5/95  -  Changed to support mounting root fs via NFS
  *  Added initrd & change_root: Werner Almesberger & Hans Lermen, Feb '96
  *  Moan early if gcc is old, avoiding bogus kernels - Paul Gortmaker, May '96
- *  Simplified starting of init:  Michael A. Griffith <grif@acm.org> 
+ *  Simplified starting of init:  Michael A. Griffith <grif@acm.org>
  */
 
 #define DEBUG		/* Enable initcall_debug */
@@ -136,7 +136,7 @@ static char *ramdisk_execute_command;
  * Used to generate warnings if static_key manipulation functions are used
  * before jump_label_init is called.
  */
-bool static_key_initialized __read_mostly = false;
+bool static_key_initialized __read_mostly;
 EXPORT_SYMBOL_GPL(static_key_initialized);
 
 /*
@@ -159,8 +159,8 @@ static int __init set_reset_devices(char
 
 __setup("reset_devices", set_reset_devices);
 
-static const char * argv_init[MAX_INIT_ARGS+2] = { "init", NULL, };
-const char * envp_init[MAX_INIT_ENVS+2] = { "HOME=/", "TERM=linux", NULL, };
+static const char *argv_init[MAX_INIT_ARGS+2] = { "init", NULL, };
+const char *envp_init[MAX_INIT_ENVS+2] = { "HOME=/", "TERM=linux", NULL, };
 static const char *panic_later, *panic_param;
 
 extern const struct obs_kernel_param __setup_start[], __setup_end[];
@@ -199,7 +199,6 @@ static int __init obsolete_checksetup(ch
  * still work even if initially too large, it will just take slightly longer
  */
 unsigned long loops_per_jiffy = (1<<12);
-
 EXPORT_SYMBOL(loops_per_jiffy);
 
 static int __init debug_kernel(char *str)
@@ -376,8 +375,8 @@ static void __init setup_command_line(ch
 	initcall_command_line =
 		memblock_virt_alloc(strlen(boot_command_line) + 1, 0);
 	static_command_line = memblock_virt_alloc(strlen(command_line) + 1, 0);
-	strcpy (saved_command_line, boot_command_line);
-	strcpy (static_command_line, command_line);
+	strcpy(saved_command_line, boot_command_line);
+	strcpy(static_command_line, command_line);
 }
 
 /*
@@ -445,8 +444,8 @@ void __init parse_early_options(char *cm
 /* Arch code calls this early on, or if not, just before other parsing. */
 void __init parse_early_param(void)
 {
-	static __initdata int done = 0;
-	static __initdata char tmp_cmdline[COMMAND_LINE_SIZE];
+	static int done __initdata;
+	static char tmp_cmdline[COMMAND_LINE_SIZE] __initdata;
 
 	if (done)
 		return;
@@ -500,7 +499,8 @@ static void __init mm_init(void)
 
 asmlinkage __visible void __init start_kernel(void)
 {
-	char * command_line, *after_dashes;
+	char *command_line;
+	char *after_dashes;
 	extern const struct kernel_param __start___param[], __stop___param[];
 
 	/*
@@ -572,7 +572,8 @@ asmlinkage __visible void __init start_k
 	 * fragile until we cpu_idle() for the first time.
 	 */
 	preempt_disable();
-	if (WARN(!irqs_disabled(), "Interrupts were enabled *very* early, fixing it\n"))
+	if (WARN(!irqs_disabled(),
+		 "Interrupts were enabled *very* early, fixing it\n"))
 		local_irq_disable();
 	idr_init_cache();
 	rcu_init();
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
linux-next.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

