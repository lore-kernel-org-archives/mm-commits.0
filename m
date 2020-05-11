From: akpm@linux-foundation.org
Subject: [merged]
 parisc-add-sysctl-file-interface-panic_on_stackoverflow.patch removed from
 -mm tree
Date: Mon, 11 May 2020 11:45:40 -0700
Message-ID: <20200511184540.yaCpSJaWb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727051AbgEKSpm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 11 May 2020 14:45:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, deller@gmx.de, James.Bottomley@HansenPartnership.com, keescook@chromium.org, mcgrof@kernel.org, mm-commits@vger.kernel.org, nixiaoming@huawei.com, yzaikin@google.com


The patch titled
     Subject: parisc: add sysctl file interface panic_on_stackoverflow
has been removed from the -mm tree.  Its filename was
     parisc-add-sysctl-file-interface-panic_on_stackoverflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xiaoming Ni <nixiaoming@huawei.com>
Subject: parisc: add sysctl file interface panic_on_stackoverflow

The variable sysctl_panic_on_stackoverflow is used in
arch/parisc/kernel/irq.c and arch/x86/kernel/irq_32.c, but the sysctl file
interface panic_on_stackoverflow only exists on x86.

Add sysctl file interface panic_on_stackoverflow for parisc

Link: http://lkml.kernel.org/r/1586610379-51745-1-git-send-email-nixiaoming@huawei.com
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de> p
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/kernel/sysctl.c~parisc-add-sysctl-file-interface-panic_on_stackoverflow
+++ a/kernel/sysctl.c
@@ -2333,30 +2333,32 @@ static struct ctl_table kern_table[] = {
 		.proc_handler   = proc_dointvec,
 	},
 #endif
-#if defined(CONFIG_X86)
+
+#if (defined(CONFIG_X86_32) || defined(CONFIG_PARISC)) && \
+	defined(CONFIG_DEBUG_STACKOVERFLOW)
 	{
-		.procname	= "panic_on_unrecovered_nmi",
-		.data		= &panic_on_unrecovered_nmi,
+		.procname	= "panic_on_stackoverflow",
+		.data		= &sysctl_panic_on_stackoverflow,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+#endif
+#if defined(CONFIG_X86)
 	{
-		.procname	= "panic_on_io_nmi",
-		.data		= &panic_on_io_nmi,
+		.procname	= "panic_on_unrecovered_nmi",
+		.data		= &panic_on_unrecovered_nmi,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
-#ifdef CONFIG_DEBUG_STACKOVERFLOW
 	{
-		.procname	= "panic_on_stackoverflow",
-		.data		= &sysctl_panic_on_stackoverflow,
+		.procname	= "panic_on_io_nmi",
+		.data		= &panic_on_io_nmi,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
-#endif
 	{
 		.procname	= "bootloader_type",
 		.data		= &bootloader_type,
_

Patches currently in -mm which might be from nixiaoming@huawei.com are
