From: akpm@linux-foundation.org
Subject: + init-mainc-code-clean-up.patch added to -mm tree
Date: Fri, 02 May 2014 14:34:33 -0700
Message-ID: <53640f69.kqn1clt7Qv7kclJA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48289 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbaEBVee (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2014 17:34:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: + init-mainc-code-clean-up.patch added to -mm tree
To: fabf@skynet.be
From: akpm@linux-foundation.org
Date: Fri, 02 May 2014 14:34:33 -0700


The patch titled
     Subject: init/main.c: code clean-up
has been added to the -mm tree.  Its filename is
     init-mainc-code-clean-up.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/init-mainc-code-clean-up.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/init-mainc-code-clean-up.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: init/main.c: code clean-up

Fixing some checkpatch warnings(remove global initialization, move
__initdata, coalesce formats ...)

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

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
@@ -355,8 +354,8 @@ static void __init setup_command_line(ch
 	initcall_command_line =
 		memblock_virt_alloc(strlen(boot_command_line) + 1, 0);
 	static_command_line = memblock_virt_alloc(strlen(command_line) + 1, 0);
-	strcpy (saved_command_line, boot_command_line);
-	strcpy (static_command_line, command_line);
+	strcpy(saved_command_line, boot_command_line);
+	strcpy(static_command_line, command_line);
 }
 
 /*
@@ -424,8 +423,8 @@ void __init parse_early_options(char *cm
 /* Arch code calls this early on, or if not, just before other parsing. */
 void __init parse_early_param(void)
 {
-	static __initdata int done = 0;
-	static __initdata char tmp_cmdline[COMMAND_LINE_SIZE];
+	static int done __initdata;
+	static char tmp_cmdline[COMMAND_LINE_SIZE] __initdata;
 
 	if (done)
 		return;
@@ -479,7 +478,7 @@ static void __init mm_init(void)
 
 asmlinkage void __init start_kernel(void)
 {
-	char * command_line;
+	char *command_line;
 	extern const struct kernel_param __start___param[], __stop___param[];
 
 	/*
@@ -547,7 +546,8 @@ asmlinkage void __init start_kernel(void
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

fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-jfs-jfs_logmgrc-remove-null-assignment-on-static.patch
fs-jfs-superc-remove-0-assignement-to-static-code-clean-up.patch
ntfs-remove-null-value-assignments.patch
fs-squashfs-squashfsh-replace-pr_warning-by-pr_warn.patch
fs-configs-itemc-kernel-doc-fixes-clean-up.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch
fs-9p-kerneldoc-fixes.patch
mm-slubc-convert-printk-to-pr_foo.patch
mm-slubc-convert-vnsprintf-static-to-va_format.patch
mm-memory_hotplugc-use-pfn_down.patch
mm-memblockc-use-pfn_down.patch
mm-memcontrolc-remove-null-assignment-on-static.patch
mm-vmallocc-replace-seq_printf-by-seq_puts.patch
mm-zbudc-make-size-unsigned-like-unique-callsite.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
lib-libcrc32cc-use-ptr_err_or_zero.patch
lib-vsprintfc-fix-comparison-to-bool.patch
fs-binfmt_elfc-fix-bool-assignements.patch
init-mainc-code-clean-up.patch
fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
linux-next.patch
ufs-sb-mutex-merge-mutex_destroy.patch

