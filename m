From: akpm@linux-foundation.org
Subject: +
 revert-console-dont-prefer-first-registered-if-dt-specifies-stdout-path.patch added to -mm tree
Date: Fri, 04 Nov 2016 12:39:06 -0700
Message-ID: <581ce3da.jYJUk+mdArYXBT88%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52838 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750903AbcKDTjH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Nov 2016 15:39:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hdegoede@redhat.com, frowand.list@gmail.com, gregkh@linuxfoundation.org, paul.burton@imgtec.com, regressions@leemhuis.info, robh+dt@kernel.org, stable@vger.kernel.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "console: don't prefer first registered if DT specifies stdout-path"
has been added to the -mm tree.  Its filename is
     revert-console-dont-prefer-first-registered-if-dt-specifies-stdout-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-console-dont-prefer-first-registered-if-dt-specifies-stdout-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-console-dont-prefer-first-registered-if-dt-specifies-stdout-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hans de Goede <hdegoede@redhat.com>
Subject: Revert "console: don't prefer first registered if DT specifies stdout-path"

This reverts commit 05fd007e4629 ("console: don't prefer first registered
if DT specifies stdout-path").

The reverted commit changes existing behavior on which many ARM boards
rely.  Many ARM small-board-computers, like e.g.  the Raspberry Pi have
both a video output and a serial console.  Depending on whether the user
is using the device as a more regular computer; or as a headless device we
need to have the console on either one or the other.

Many users rely on the kernel behavior of the console being present on
both outputs, before the reverted commit the console setup with no
console= kernel arguments on an ARM board which sets stdout-path in dt
would look like this:

[root@localhost ~]# cat /proc/consoles
ttyS0                -W- (EC p a)    4:64
tty0                 -WU (E  p  )    4:1

Where as after the reverted commit, it looks like this:

[root@localhost ~]# cat /proc/consoles
ttyS0                -W- (EC p a)    4:64

This commit reverts commit 05fd007e4629 ("console: don't prefer first
registered if DT specifies stdout-path") restoring the original behavior.

Fixes: 05fd007e4629 ("console: don't prefer first registered if DT specifies stdout-path")
Link: http://lkml.kernel.org/r/20161104121135.4780-2-hdegoede@redhat.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Cc: Paul Burton <paul.burton@imgtec.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Frank Rowand <frowand.list@gmail.com>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/of/base.c       |    2 --
 include/linux/console.h |    6 ------
 kernel/printk/printk.c  |   13 +------------
 3 files changed, 1 insertion(+), 20 deletions(-)

diff -puN drivers/of/base.c~revert-console-dont-prefer-first-registered-if-dt-specifies-stdout-path drivers/of/base.c
--- a/drivers/of/base.c~revert-console-dont-prefer-first-registered-if-dt-specifies-stdout-path
+++ a/drivers/of/base.c
@@ -2077,8 +2077,6 @@ void of_alias_scan(void * (*dt_alloc)(u6
 			name = of_get_property(of_aliases, "stdout", NULL);
 		if (name)
 			of_stdout = of_find_node_opts_by_path(name, &of_stdout_options);
-		if (of_stdout)
-			console_set_by_of();
 	}
 
 	if (!of_aliases)
diff -puN include/linux/console.h~revert-console-dont-prefer-first-registered-if-dt-specifies-stdout-path include/linux/console.h
--- a/include/linux/console.h~revert-console-dont-prefer-first-registered-if-dt-specifies-stdout-path
+++ a/include/linux/console.h
@@ -173,12 +173,6 @@ static inline void console_sysfs_notify(
 #endif
 extern bool console_suspend_enabled;
 
-#ifdef CONFIG_OF
-extern void console_set_by_of(void);
-#else
-static inline void console_set_by_of(void) {}
-#endif
-
 /* Suspend and resume console messages over PM events */
 extern void suspend_console(void);
 extern void resume_console(void);
diff -puN kernel/printk/printk.c~revert-console-dont-prefer-first-registered-if-dt-specifies-stdout-path kernel/printk/printk.c
--- a/kernel/printk/printk.c~revert-console-dont-prefer-first-registered-if-dt-specifies-stdout-path
+++ a/kernel/printk/printk.c
@@ -253,17 +253,6 @@ static int preferred_console = -1;
 int console_set_on_cmdline;
 EXPORT_SYMBOL(console_set_on_cmdline);
 
-#ifdef CONFIG_OF
-static bool of_specified_console;
-
-void console_set_by_of(void)
-{
-	of_specified_console = true;
-}
-#else
-# define of_specified_console false
-#endif
