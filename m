From: akpm@linux-foundation.org
Subject: [merged]
 console-dont-prefer-first-registered-if-dt-specifies-stdout-path.patch
 removed from -mm tree
Date: Mon, 10 Oct 2016 15:58:14 -0700
Message-ID: <57fc1d06.preFLk00froaMoe4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38126 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752257AbcJJW6U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:58:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paul.burton@imgtec.com, bp@suse.de, colona@arista.com, daniel.vetter@ffwll.ch, frowand.list@gmail.com, gregkh@linuxfoundation.org, jack@suse.com, joe@perches.com, jslaby@suse.cz, pmladek@suse.com, ralf@linux-mips.org, robh+dt@kernel.org, sergey.senozhatsky@gmail.com, tj@kernel.org, treding@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: console: don't prefer first registered if DT specifies stdout-path
has been removed from the -mm tree.  Its filename was
     console-dont-prefer-first-registered-if-dt-specifies-stdout-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Paul Burton <paul.burton@imgtec.com>
Subject: console: don't prefer first registered if DT specifies stdout-path

If a device tree specifies a preferred device for kernel console output
via the stdout-path or linux,stdout-path chosen node properties or the
stdout alias then the kernel ought to honor it & output the kernel console
to that device.  As it stands, this isn't the case.  Whilst we parse the
stdout-path properties & set an of_stdout variable from of_alias_scan(),
and use that from of_console_check() to determine whether to add a console
device as a preferred console whilst registering it, we also prefer the
first registered console if no other has been selected at the time of its
registration.

This means that if a console other than the one the device tree selects
via stdout-path is registered first, we will switch to using it & when the
stdout-path console is later registered the call to
add_preferred_console() via of_console_check() is too late to do anything
useful.  In practice this seems to mean that we switch to the dummy
console device fairly early & see no further console output:

    Console: colour dummy device 80x25
    console [tty0] enabled
    bootconsole [ns16550a0] disabled

Fix this by not automatically preferring the first registered console if
one is specified by the device tree.  This allows consoles to be
registered but not enabled, and once the driver for the console selected
by stdout-path calls of_console_check() the driver will be added to the
list of preferred consoles before any other console has been enabled. 
When that console is then registered via register_console() it will be
enabled as expected.

Link: http://lkml.kernel.org/r/20160809151937.26118-1-paul.burton@imgtec.com
Signed-off-by: Paul Burton <paul.burton@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Burton <paul.burton@imgtec.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Ivan Delalande <colona@arista.com>
Cc: Thierry Reding <treding@nvidia.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Jan Kara <jack@suse.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Frank Rowand <frowand.list@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/of/base.c       |    2 ++
 include/linux/console.h |    6 ++++++
 kernel/printk/printk.c  |   13 ++++++++++++-
 3 files changed, 20 insertions(+), 1 deletion(-)

diff -puN drivers/of/base.c~console-dont-prefer-first-registered-if-dt-specifies-stdout-path drivers/of/base.c
--- a/drivers/of/base.c~console-dont-prefer-first-registered-if-dt-specifies-stdout-path
+++ a/drivers/of/base.c
@@ -2077,6 +2077,8 @@ void of_alias_scan(void * (*dt_alloc)(u6
 			name = of_get_property(of_aliases, "stdout", NULL);
 		if (name)
 			of_stdout = of_find_node_opts_by_path(name, &of_stdout_options);
+		if (of_stdout)
+			console_set_by_of();
 	}
 
 	if (!of_aliases)
diff -puN include/linux/console.h~console-dont-prefer-first-registered-if-dt-specifies-stdout-path include/linux/console.h
--- a/include/linux/console.h~console-dont-prefer-first-registered-if-dt-specifies-stdout-path
+++ a/include/linux/console.h
@@ -173,6 +173,12 @@ static inline void console_sysfs_notify(
 #endif
 extern bool console_suspend_enabled;
 
+#ifdef CONFIG_OF
+extern void console_set_by_of(void);
+#else
+static inline void console_set_by_of(void) {}
+#endif
+
 /* Suspend and resume console messages over PM events */
 extern void suspend_console(void);
 extern void resume_console(void);
diff -puN kernel/printk/printk.c~console-dont-prefer-first-registered-if-dt-specifies-stdout-path kernel/printk/printk.c
--- a/kernel/printk/printk.c~console-dont-prefer-first-registered-if-dt-specifies-stdout-path
+++ a/kernel/printk/printk.c
@@ -253,6 +253,17 @@ static int preferred_console = -1;
 int console_set_on_cmdline;
 EXPORT_SYMBOL(console_set_on_cmdline);
 
+#ifdef CONFIG_OF
+static bool of_specified_console;
+
+void console_set_by_of(void)
+{
+	of_specified_console = true;
+}
+#else
+# define of_specified_console false
+#endif
+
 /* Flag: console code may call schedule() */
 static int console_may_schedule;
 
@@ -2647,7 +2658,7 @@ void register_console(struct console *ne
 	 *	didn't select a console we take the first one
 	 *	that registers here.
 	 */
-	if (preferred_console < 0) {
+	if (preferred_console < 0 && !of_specified_console) {
 		if (newcon->index < 0)
 			newcon->index = 0;
 		if (newcon->setup == NULL ||
_

Patches currently in -mm which might be from paul.burton@imgtec.com are


