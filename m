From: akpm@linux-foundation.org
Subject: [merged]
 kernel-param-consolidate-__startstop___param-in-linux-moduleparamh.patch
 removed from -mm tree
Date: Tue, 14 Oct 2014 11:23:16 -0700
Message-ID: <543d6a14.n+R+m3nVNRRzfTTN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44634 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369AbaJNSXP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:23:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/param: consolidate __{start,stop}___param[] in <linux/moduleparam.h>
has been removed from the -mm tree.  Its filename was
     kernel-param-consolidate-__startstop___param-in-linux-moduleparamh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch

