From: akpm@linux-foundation.org
Subject: +
 kernel-param-consolidate-__startstop___param-in-linux-moduleparamh.patch
 added to -mm tree
Date: Fri, 19 Sep 2014 16:21:04 -0700
Message-ID: <541cba60.0Q2g/5ISnoWApDIV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57363 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141AbaISXVF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Sep 2014 19:21:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/param: consolidate __{start,stop}___param[] in <linux/moduleparam.h>
has been added to the -mm tree.  Its filename is
     kernel-param-consolidate-__startstop___param-in-linux-moduleparamh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-param-consolidate-__startstop___param-in-linux-moduleparamh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-param-consolidate-__startstop___param-in-linux-moduleparamh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: kernel/param: consolidate __{start,stop}___param[] in <linux/moduleparam.h>

Consolidate the various external const and non-const declarations of
__start___param[] and __stop___param in <linux/moduleparam.h>.  This
requires making a few struct kernel_param pointers in kernel/params.c
const.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/moduleparam.h |    2 ++
 init/main.c                 |    2 --
 kernel/params.c             |    7 +++----
 3 files changed, 5 insertions(+), 6 deletions(-)

diff -puN include/linux/moduleparam.h~kernel-param-consolidate-__startstop___param-in-linux-moduleparamh include/linux/moduleparam.h
--- a/include/linux/moduleparam.h~kernel-param-consolidate-__startstop___param-in-linux-moduleparamh
+++ a/include/linux/moduleparam.h
@@ -78,6 +78,8 @@ struct kernel_param {
 	};
 };
 
+extern const struct kernel_param __start___param[], __stop___param[];
+
 /* Special one for strings we want to copy into */
 struct kparam_string {
 	unsigned int maxlen;
diff -puN init/main.c~kernel-param-consolidate-__startstop___param-in-linux-moduleparamh init/main.c
--- a/init/main.c~kernel-param-consolidate-__startstop___param-in-linux-moduleparamh
+++ a/init/main.c
@@ -501,7 +501,6 @@ asmlinkage __visible void __init start_k
 {
 	char *command_line;
 	char *after_dashes;
-	extern const struct kernel_param __start___param[], __stop___param[];
 
 	/*
 	 * Need to run as early as possible, to initialize the
@@ -844,7 +843,6 @@ static char *initcall_level_names[] __in
 
 static void __init do_initcall_level(int level)
 {
-	extern const struct kernel_param __start___param[], __stop___param[];
 	initcall_t *fn;
 
 	strcpy(initcall_command_line, saved_command_line);
diff -puN kernel/params.c~kernel-param-consolidate-__startstop___param-in-linux-moduleparamh kernel/params.c
--- a/kernel/params.c~kernel-param-consolidate-__startstop___param-in-linux-moduleparamh
+++ a/kernel/params.c
@@ -19,6 +19,7 @@
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/slab.h>
@@ -513,8 +514,6 @@ EXPORT_SYMBOL(param_ops_string);
 #define to_module_attr(n) container_of(n, struct module_attribute, attr)
 #define to_module_kobject(n) container_of(n, struct module_kobject, kobj)
 
-extern struct kernel_param __start___param[], __stop___param[];
-
 struct param_attribute
 {
 	struct module_attribute mattr;
@@ -774,7 +773,7 @@ static struct module_kobject * __init lo
 }
 
 static void __init kernel_add_sysfs_param(const char *name,
-					  struct kernel_param *kparam,
+					  const struct kernel_param *kparam,
 					  unsigned int name_skip)
 {
 	struct module_kobject *mk;
@@ -809,7 +808,7 @@ static void __init kernel_add_sysfs_para
  */
 static void __init param_sysfs_builtin(void)
 {
-	struct kernel_param *kp;
+	const struct kernel_param *kp;
 	unsigned int name_len;
 	char modname[MODULE_NAME_LEN];
 
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
mn10300-use-kbuild-logic-to-include-asm-generic-sectionsh.patch
cris-use-kbuild-logic-to-include-asm-generic-sectionsh.patch
m32r-use-kbuild-logic-to-include-asm-generic-sectionsh.patch
score-use-kbuild-logic-to-include-asm-generic-sectionsh.patch
m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush.patch
m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush-v2.patch
alpha-use-kbuild-logic-to-include-asm-generic-sectionsh.patch
include-linux-screen_infoh-remove-unused-orig_-macros.patch
nosave-consolidate-__nosave_beginend-in-asm-sectionsh.patch
printk-dont-bother-using-log_cpu_max_buf_shift-on-smp.patch
linux-next.patch
frv-remove-unused-declarations-of-__start___ex_table-and-__stop___ex_table.patch
ia64-remove-duplicate-declarations-of-__per_cpu_start-and-__per_cpu_end.patch
kernel-param-consolidate-__startstop___param-in-linux-moduleparamh.patch

