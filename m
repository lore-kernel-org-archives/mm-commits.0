From: akpm@linux-foundation.org
Subject: [merged] printk-use-symbolic-defines-for-console-loglevels.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 13:05:03 -0700
Message-ID: <5390cd6f.XgUnZ8rCsWHgvVhD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56790 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbaFEUFE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 16:05:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org, keescook@chromium.org, joe@perches.com, Valdis.Kletnieks@vt.edu, bp@suse.de

Subject: [merged] printk-use-symbolic-defines-for-console-loglevels.patch removed from -mm tree
To: bp@suse.de,Valdis.Kletnieks@vt.edu,joe@perches.com,keescook@chromium.org,rdunlap@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 13:05:03 -0700


The patch titled
     Subject: kernel/printk: use symbolic defines for console loglevels
has been removed from the -mm tree.  Its filename was
     printk-use-symbolic-defines-for-console-loglevels.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Borislav Petkov <bp@suse.de>
Subject: kernel/printk: use symbolic defines for console loglevels

... instead of naked numbers.

Stuff in sysrq.c used to set it to 8 which is supposed to mean above
default level so set it to DEBUG instead as we're terminating/killing all
tasks and we want to be verbose there.

Also, correct the check in x86_64_start_kernel which should be >= as
we're clearly issuing the string there for all debug levels, not only
the magical 10.

Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Joe Perches <joe@perches.com>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/head64.c      |    2 +-
 arch/x86/platform/uv/uv_nmi.c |    2 +-
 drivers/nubus/nubus.c         |   18 +++++++++---------
 drivers/tty/sysrq.c           |    8 ++++----
 include/linux/printk.h        |   15 +++++++++++++--
 init/main.c                   |    4 ++--
 kernel/debug/kdb/kdb_bt.c     |    2 +-
 kernel/debug/kdb/kdb_io.c     |    2 +-
 kernel/debug/kdb/kdb_main.c   |    2 +-
 kernel/printk/printk.c        |   13 +++----------
 10 files changed, 36 insertions(+), 32 deletions(-)

diff -puN arch/x86/kernel/head64.c~printk-use-symbolic-defines-for-console-loglevels arch/x86/kernel/head64.c
--- a/arch/x86/kernel/head64.c~printk-use-symbolic-defines-for-console-loglevels
+++ a/arch/x86/kernel/head64.c
@@ -172,7 +172,7 @@ asmlinkage __visible void __init x86_64_
 	 */
 	load_ucode_bsp();
 
-	if (console_loglevel == 10)
+	if (console_loglevel >= CONSOLE_LOGLEVEL_DEBUG)
 		early_printk("Kernel alive\n");
 
 	clear_page(init_level4_pgt);
diff -puN arch/x86/platform/uv/uv_nmi.c~printk-use-symbolic-defines-for-console-loglevels arch/x86/platform/uv/uv_nmi.c
--- a/arch/x86/platform/uv/uv_nmi.c~printk-use-symbolic-defines-for-console-loglevels
+++ a/arch/x86/platform/uv/uv_nmi.c
@@ -85,7 +85,7 @@ static cpumask_var_t uv_nmi_cpu_mask;
  * Default is all stack dumps go to the console and buffer.
  * Lower level to send to log buffer only.
  */
-static int uv_nmi_loglevel = 7;
+static int uv_nmi_loglevel = CONSOLE_LOGLEVEL_DEFAULT;
 module_param_named(dump_loglevel, uv_nmi_loglevel, int, 0644);
 
 /*
diff -puN drivers/nubus/nubus.c~printk-use-symbolic-defines-for-console-loglevels drivers/nubus/nubus.c
--- a/drivers/nubus/nubus.c~printk-use-symbolic-defines-for-console-loglevels
+++ a/drivers/nubus/nubus.c
@@ -473,7 +473,7 @@ static struct nubus_dev* __init
 	if (slot == 0 && (unsigned long)dir.base % 2)
 		dir.base += 1;
 	
-	if (console_loglevel >= 10)
+	if (console_loglevel >= CONSOLE_LOGLEVEL_DEBUG)
 		printk(KERN_DEBUG "nubus_get_functional_resource: parent is 0x%p, dir is 0x%p\n",
 		       parent->base, dir.base);
 
@@ -568,7 +568,7 @@ static int __init nubus_get_vidnames(str
 
 	printk(KERN_INFO "    video modes supported:\n");
 	nubus_get_subdir(parent, &dir);
-	if (console_loglevel >= 10)
+	if (console_loglevel >= CONSOLE_LOGLEVEL_DEBUG)
 		printk(KERN_DEBUG "nubus_get_vidnames: parent is 0x%p, dir is 0x%p\n",
 		       parent->base, dir.base);
 
@@ -629,7 +629,7 @@ static int __init nubus_get_vendorinfo(s
 
 	printk(KERN_INFO "    vendor info:\n");
 	nubus_get_subdir(parent, &dir);
-	if (console_loglevel >= 10)
+	if (console_loglevel >= CONSOLE_LOGLEVEL_DEBUG)
 		printk(KERN_DEBUG "nubus_get_vendorinfo: parent is 0x%p, dir is 0x%p\n",
 		       parent->base, dir.base);
 
@@ -654,7 +654,7 @@ static int __init nubus_get_board_resour
 	struct nubus_dirent ent;
 	
 	nubus_get_subdir(parent, &dir);
-	if (console_loglevel >= 10)
+	if (console_loglevel >= CONSOLE_LOGLEVEL_DEBUG)
 		printk(KERN_DEBUG "nubus_get_board_resource: parent is 0x%p, dir is 0x%p\n",
 		       parent->base, dir.base);
 
@@ -753,19 +753,19 @@ static void __init nubus_find_rom_dir(st
 	if (nubus_readdir(&dir, &ent) == -1)
 		goto badrom;
 
-	if (console_loglevel >= 10)
+	if (console_loglevel >= CONSOLE_LOGLEVEL_DEBUG)
 		printk(KERN_INFO "nubus_get_rom_dir: entry %02x %06x\n", ent.type, ent.data);
 	/* This one takes us to where we want to go. */
 	if (nubus_readdir(&dir, &ent) == -1) 
 		goto badrom;
-	if (console_loglevel >= 10)
+	if (console_loglevel >= CONSOLE_LOGLEVEL_DEBUG)
 		printk(KERN_DEBUG "nubus_get_rom_dir: entry %02x %06x\n", ent.type, ent.data);
 	nubus_get_subdir(&ent, &dir);
 
 	/* Resource ID 01, also an "Unknown Macintosh" */
 	if (nubus_readdir(&dir, &ent) == -1) 
 		goto badrom;
-	if (console_loglevel >= 10)
+	if (console_loglevel >= CONSOLE_LOGLEVEL_DEBUG)
 		printk(KERN_DEBUG "nubus_get_rom_dir: entry %02x %06x\n", ent.type, ent.data);
 
 	/* FIXME: the first one is *not* always the right one.  We
@@ -780,7 +780,7 @@ static void __init nubus_find_rom_dir(st
 	   path to that address... */
 	if (nubus_readdir(&dir, &ent) == -1)
 		goto badrom;
-	if (console_loglevel >= 10)
+	if (console_loglevel >= CONSOLE_LOGLEVEL_DEBUG)
 		printk(KERN_DEBUG "nubus_get_rom_dir: entry %02x %06x\n", ent.type, ent.data);
 	
 	/* Bwahahahaha... */
@@ -816,7 +816,7 @@ static struct nubus_board* __init nubus_
 	board->fblock = rp;
 
 	/* Dump the format block for debugging purposes */
-	if (console_loglevel >= 10) {
+	if (console_loglevel >= CONSOLE_LOGLEVEL_DEBUG) {
 		int i;
 		printk(KERN_DEBUG "Slot %X, format block at 0x%p\n",
 		       slot, rp);
diff -puN drivers/tty/sysrq.c~printk-use-symbolic-defines-for-console-loglevels drivers/tty/sysrq.c
--- a/drivers/tty/sysrq.c~printk-use-symbolic-defines-for-console-loglevels
+++ a/drivers/tty/sysrq.c
@@ -88,7 +88,7 @@ static void sysrq_handle_loglevel(int ke
 	int i;
 
 	i = key - '0';
-	console_loglevel = 7;
+	console_loglevel = CONSOLE_LOGLEVEL_DEFAULT;
 	printk("Loglevel set to %d\n", i);
 	console_loglevel = i;
 }
@@ -343,7 +343,7 @@ static void send_sig_all(int sig)
 static void sysrq_handle_term(int key)
 {
 	send_sig_all(SIGTERM);
-	console_loglevel = 8;
+	console_loglevel = CONSOLE_LOGLEVEL_DEBUG;
 }
 static struct sysrq_key_op sysrq_term_op = {
 	.handler	= sysrq_handle_term,
@@ -387,7 +387,7 @@ static struct sysrq_key_op sysrq_thaw_op
 static void sysrq_handle_kill(int key)
 {
 	send_sig_all(SIGKILL);
-	console_loglevel = 8;
+	console_loglevel = CONSOLE_LOGLEVEL_DEBUG;
 }
 static struct sysrq_key_op sysrq_kill_op = {
 	.handler	= sysrq_handle_kill,
@@ -520,7 +520,7 @@ void __handle_sysrq(int key, bool check_
 	 * routing in the consumers of /proc/kmsg.
 	 */
 	orig_log_level = console_loglevel;
-	console_loglevel = 7;
+	console_loglevel = CONSOLE_LOGLEVEL_DEFAULT;
 	printk(KERN_INFO "SysRq : ");
 
         op_p = __sysrq_get_key_op(key);
diff -puN include/linux/printk.h~printk-use-symbolic-defines-for-console-loglevels include/linux/printk.h
--- a/include/linux/printk.h~printk-use-symbolic-defines-for-console-loglevels
+++ a/include/linux/printk.h
@@ -30,6 +30,17 @@ static inline const char *printk_skip_le
 	return buffer;
 }
 
+/* printk's without a loglevel use this.. */
+#define DEFAULT_MESSAGE_LOGLEVEL CONFIG_DEFAULT_MESSAGE_LOGLEVEL
+
+/* We show everything that is MORE important than this.. */
+#define CONSOLE_LOGLEVEL_SILENT  0 /* Mum's the word */
+#define CONSOLE_LOGLEVEL_MIN	 1 /* Minimum loglevel we let people use */
+#define CONSOLE_LOGLEVEL_QUIET	 4 /* Shhh ..., when booted with "quiet" */
+#define CONSOLE_LOGLEVEL_DEFAULT 7 /* anything MORE serious than KERN_DEBUG */
+#define CONSOLE_LOGLEVEL_DEBUG	10 /* issue debug messages */
+#define CONSOLE_LOGLEVEL_MOTORMOUTH 15	/* You can't shut this one up */
+
 extern int console_printk[];
 
 #define console_loglevel (console_printk[0])
@@ -39,13 +50,13 @@ extern int console_printk[];
 
 static inline void console_silent(void)
 {
-	console_loglevel = 0;
+	console_loglevel = CONSOLE_LOGLEVEL_SILENT;
 }
 
 static inline void console_verbose(void)
 {
 	if (console_loglevel)
-		console_loglevel = 15;
+		console_loglevel = CONSOLE_LOGLEVEL_MOTORMOUTH;
 }
 
 struct va_format {
diff -puN init/main.c~printk-use-symbolic-defines-for-console-loglevels init/main.c
--- a/init/main.c~printk-use-symbolic-defines-for-console-loglevels
+++ a/init/main.c
@@ -203,13 +203,13 @@ EXPORT_SYMBOL(loops_per_jiffy);
 
 static int __init debug_kernel(char *str)
 {
-	console_loglevel = 10;
+	console_loglevel = CONSOLE_LOGLEVEL_DEBUG;
 	return 0;
 }
 
 static int __init quiet_kernel(char *str)
 {
-	console_loglevel = 4;
+	console_loglevel = CONSOLE_LOGLEVEL_QUIET;
 	return 0;
 }
 
diff -puN kernel/debug/kdb/kdb_bt.c~printk-use-symbolic-defines-for-console-loglevels kernel/debug/kdb/kdb_bt.c
--- a/kernel/debug/kdb/kdb_bt.c~printk-use-symbolic-defines-for-console-loglevels
+++ a/kernel/debug/kdb/kdb_bt.c
@@ -21,7 +21,7 @@
 static void kdb_show_stack(struct task_struct *p, void *addr)
 {
 	int old_lvl = console_loglevel;
-	console_loglevel = 15;
+	console_loglevel = CONSOLE_LOGLEVEL_MOTORMOUTH;
 	kdb_trap_printk++;
 	kdb_set_current_task(p);
 	if (addr) {
diff -puN kernel/debug/kdb/kdb_io.c~printk-use-symbolic-defines-for-console-loglevels kernel/debug/kdb/kdb_io.c
--- a/kernel/debug/kdb/kdb_io.c~printk-use-symbolic-defines-for-console-loglevels
+++ a/kernel/debug/kdb/kdb_io.c
@@ -710,7 +710,7 @@ kdb_printit:
 	}
 	if (logging) {
 		saved_loglevel = console_loglevel;
-		console_loglevel = 0;
+		console_loglevel = CONSOLE_LOGLEVEL_SILENT;
 		printk(KERN_INFO "%s", kdb_buffer);
 	}
 
diff -puN kernel/debug/kdb/kdb_main.c~printk-use-symbolic-defines-for-console-loglevels kernel/debug/kdb/kdb_main.c
--- a/kernel/debug/kdb/kdb_main.c~printk-use-symbolic-defines-for-console-loglevels
+++ a/kernel/debug/kdb/kdb_main.c
@@ -1091,7 +1091,7 @@ static int kdb_reboot(int argc, const ch
 static void kdb_dumpregs(struct pt_regs *regs)
 {
 	int old_lvl = console_loglevel;
-	console_loglevel = 15;
+	console_loglevel = CONSOLE_LOGLEVEL_MOTORMOUTH;
 	kdb_trap_printk++;
 	show_regs(regs);
 	kdb_trap_printk--;
diff -puN kernel/printk/printk.c~printk-use-symbolic-defines-for-console-loglevels kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-use-symbolic-defines-for-console-loglevels
+++ a/kernel/printk/printk.c
@@ -54,18 +54,11 @@
 #include "console_cmdline.h"
 #include "braille.h"
 
-/* printk's without a loglevel use this.. */
-#define DEFAULT_MESSAGE_LOGLEVEL CONFIG_DEFAULT_MESSAGE_LOGLEVEL
-
-/* We show everything that is MORE important than this.. */
-#define MINIMUM_CONSOLE_LOGLEVEL 1 /* Minimum loglevel we let people use */
-#define DEFAULT_CONSOLE_LOGLEVEL 7 /* anything MORE serious than KERN_DEBUG */
