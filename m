From: akpm@linux-foundation.org
Subject: [merged] init-mainc-add-initcall_blacklist-kernel-parameter.patch removed from -mm tree
Date: Thu, 05 Jun 2014 13:07:37 -0700
Message-ID: <5390ce09.MfeNX5kJlv48fwVO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaFEUHi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 16:07:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rostedt@goodmis.org, rob@landley.net, richard.weinberger@gmail.com, peterz@infradead.org, mingo@kernel.org, jwboyer@fedoraproject.org, fweisbec@gmail.com, andi@firstfloor.org, prarit@redhat.com

Subject: [merged] init-mainc-add-initcall_blacklist-kernel-parameter.patch removed from -mm tree
To: prarit@redhat.com,andi@firstfloor.org,fweisbec@gmail.com,jwboyer@fedoraproject.org,mingo@kernel.org,peterz@infradead.org,richard.weinberger@gmail.com,rob@landley.net,rostedt@goodmis.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 13:07:37 -0700


The patch titled
     Subject: init/main.c: add initcall_blacklist kernel parameter
has been removed from the -mm tree.  Its filename was
     init-mainc-add-initcall_blacklist-kernel-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Prarit Bhargava <prarit@redhat.com>
Subject: init/main.c: add initcall_blacklist kernel parameter

When a module is built into the kernel the module_init() function becomes
an initcall.  Sometimes debugging through dynamic debug can help, however,
debugging built in kernel modules is typically done by changing the
.config, recompiling, and booting the new kernel in an effort to determine
exactly which module caused a problem.

This patchset can be useful stand-alone or combined with initcall_debug. 
There are cases where some initcalls can hang the machine before the
console can be flushed, which can make initcall_debug output inaccurate. 
Having the ability to skip initcalls can help further debugging of these
scenarios.

Usage: initcall_blacklist=<list of comma separated initcalls>

ex) added "initcall_blacklist=sgi_uv_sysfs_init" as a kernel parameter and
the log contains:

	blacklisting initcall sgi_uv_sysfs_init
	...
	...
	initcall sgi_uv_sysfs_init blacklisted

ex) added "initcall_blacklist=foo_bar,sgi_uv_sysfs_init" as a kernel parameter
and the log contains:

	blacklisting initcall foo_bar
	blacklisting initcall sgi_uv_sysfs_init
	...
	...
	initcall sgi_uv_sysfs_init blacklisted

[akpm@linux-foundation.org: tweak printk text]
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Rob Landley <rob@landley.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    4 +
 init/main.c                         |   68 ++++++++++++++++++++++++++
 2 files changed, 72 insertions(+)

diff -puN Documentation/kernel-parameters.txt~init-mainc-add-initcall_blacklist-kernel-parameter Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~init-mainc-add-initcall_blacklist-kernel-parameter
+++ a/Documentation/kernel-parameters.txt
@@ -1312,6 +1312,10 @@ bytes respectively. Such letter suffixes
 			for working out where the kernel is dying during
 			startup.
 
+	initcall_blacklist=  [KNL] Do not execute a comma-separated list of
+			initcall functions.  Useful for debugging built-in
+			modules and initcalls.
+
 	initrd=		[BOOT] Specify the location of the initial ramdisk
 
 	inport.irq=	[HW] Inport (ATI XL and Microsoft) busmouse driver
diff -puN init/main.c~init-mainc-add-initcall_blacklist-kernel-parameter init/main.c
--- a/init/main.c~init-mainc-add-initcall_blacklist-kernel-parameter
+++ a/init/main.c
@@ -77,6 +77,7 @@
 #include <linux/sched_clock.h>
 #include <linux/context_tracking.h>
 #include <linux/random.h>
+#include <linux/list.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -665,6 +666,70 @@ static void __init do_ctors(void)
 bool initcall_debug;
 core_param(initcall_debug, initcall_debug, bool, 0644);
 
+#ifdef CONFIG_KALLSYMS
+struct blacklist_entry {
+	struct list_head next;
+	char *buf;
+};
+
+static __initdata_or_module LIST_HEAD(blacklisted_initcalls);
+
+static int __init initcall_blacklist(char *str)
+{
+	char *str_entry;
+	struct blacklist_entry *entry;
+
+	/* str argument is a comma-separated list of functions */
+	do {
+		str_entry = strsep(&str, ",");
+		if (str_entry) {
+			pr_debug("blacklisting initcall %s\n", str_entry);
+			entry = alloc_bootmem(sizeof(*entry));
+			entry->buf = alloc_bootmem(strlen(str_entry) + 1);
+			strcpy(entry->buf, str_entry);
+			list_add(&entry->next, &blacklisted_initcalls);
+		}
+	} while (str_entry);
+
+	return 0;
+}
+
+static bool __init_or_module initcall_blacklisted(initcall_t fn)
+{
+	struct list_head *tmp;
+	struct blacklist_entry *entry;
+	char *fn_name;
+
+	fn_name = kasprintf(GFP_KERNEL, "%pf", fn);
+	if (!fn_name)
+		return false;
+
+	list_for_each(tmp, &blacklisted_initcalls) {
+		entry = list_entry(tmp, struct blacklist_entry, next);
+		if (!strcmp(fn_name, entry->buf)) {
+			pr_debug("initcall %s blacklisted\n", fn_name);
+			kfree(fn_name);
+			return true;
+		}
+	}
+
+	kfree(fn_name);
+	return false;
+}
+#else
+static int __init initcall_blacklist(char *str)
+{
+	pr_warn("initcall_blacklist requires CONFIG_KALLSYMS\n");
+	return 0;
+}
+
+static bool __init_or_module initcall_blacklisted(initcall_t fn)
+{
+	return false;
+}
+#endif
+__setup("initcall_blacklist=", initcall_blacklist);
+
 static int __init_or_module do_one_initcall_debug(initcall_t fn)
 {
 	ktime_t calltime, delta, rettime;
@@ -689,6 +754,9 @@ int __init_or_module do_one_initcall(ini
 	int ret;
 	char msgbuf[64];
 
+	if (initcall_blacklisted(fn))
+		return -EPERM;
+
 	if (initcall_debug)
 		ret = do_one_initcall_debug(fn);
 	else
_

Patches currently in -mm which might be from prarit@redhat.com are

origin.patch
linux-next.patch

