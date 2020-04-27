From: akpm@linux-foundation.org
Subject: +
 kernel-hung_task-convert-hung_task_panic-boot-parameter-to-sysctl.patch
 added to -mm tree
Date: Mon, 27 Apr 2020 11:33:56 -0700
Message-ID: <20200427183356.i_yj2Ffjr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbgD0Sd6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Apr 2020 14:33:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, christian.brauner@ubuntu.com, ebiederm@xmission.com, gpiccoli@canonical.com, gregkh@linuxfoundation.org, ivan.teterevkov@nutanix.com, keescook@chromium.org, mcgrof@kernel.org, mhiramat@kernel.org, mhocko@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org, rientjes@google.com, tglx@linutronix.de, vbabka@suse.cz, willy@infradead.org, yzaikin@google.com


The patch titled
     Subject: kernel/hung_task convert hung_task_panic boot parameter to sysctl
has been added to the -mm tree.  Its filename is
     kernel-hung_task-convert-hung_task_panic-boot-parameter-to-sysctl.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-hung_task-convert-hung_task_panic-boot-parameter-to-sysctl.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-hung_task-convert-hung_task_panic-boot-parameter-to-sysctl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: kernel/hung_task convert hung_task_panic boot parameter to sysctl

We can now handle sysctl parameters on kernel command line and have
infrastructure to convert legacy command line options that duplicate
sysctl to become a sysctl alias.

This patch converts the hung_task_panic parameter.  Note that the sysctl
handler is more strict and allows only 0 and 1, while the legacy parameter
allowed any non-zero value.  But there is little reason anyone would not
be using 1.

Link: http://lkml.kernel.org/r/20200427180433.7029-4-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Guilherme G . Piccoli" <gpiccoli@canonical.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Ivan Teterevkov <ivan.teterevkov@nutanix.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    2 +-
 fs/proc/proc_sysctl.c                           |    1 +
 kernel/hung_task.c                              |   10 ----------
 3 files changed, 2 insertions(+), 11 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~kernel-hung_task-convert-hung_task_panic-boot-parameter-to-sysctl
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -1505,7 +1505,7 @@
 			[KNL] Should the hung task detector generate panics.
 			Format: <integer>
 
-			A nonzero value instructs the kernel to panic when a
+			A value of 1 instructs the kernel to panic when a
 			hung task is detected. The default value is controlled
 			by the CONFIG_BOOTPARAM_HUNG_TASK_PANIC build-time
 			option. The value selected by this boot parameter can
--- a/fs/proc/proc_sysctl.c~kernel-hung_task-convert-hung_task_panic-boot-parameter-to-sysctl
+++ a/fs/proc/proc_sysctl.c
@@ -1710,6 +1710,7 @@ struct sysctl_alias {
  */
 static const struct sysctl_alias sysctl_aliases[] = {
 	{"numa_zonelist_order",		"vm.numa_zonelist_order" },
+	{"hung_task_panic",		"kernel.hung_task_panic" },
 	{ }
 };
 
--- a/kernel/hung_task.c~kernel-hung_task-convert-hung_task_panic-boot-parameter-to-sysctl
+++ a/kernel/hung_task.c
@@ -63,16 +63,6 @@ static struct task_struct *watchdog_task
 unsigned int __read_mostly sysctl_hung_task_panic =
 				CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE;
 
-static int __init hung_task_panic_setup(char *str)
-{
-	int rc = kstrtouint(str, 0, &sysctl_hung_task_panic);
-
-	if (rc)
-		return rc;
-	return 1;
-}
-__setup("hung_task_panic=", hung_task_panic_setup);
