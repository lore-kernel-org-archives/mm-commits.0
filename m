From: akpm@linux-foundation.org
Subject: [merged] kernel-printk-fix-bool-assignements.patch removed from
 -mm tree
Date: Thu, 07 Aug 2014 13:07:29 -0700
Message-ID: <53e3dc81.Ugdm8OqwgD72yH/l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yk0-f201.google.com ([209.85.160.201]:38756 "EHLO
	mail-yk0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbaHGUHa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:07:30 -0400
Received: by mail-yk0-f201.google.com with SMTP id 142so611356ykq.0
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:07:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhangwm@marvell.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/printk/printk.c: fix bool assignements
has been removed from the -mm tree.  Its filename was
     kernel-printk-fix-bool-assignements.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Neil Zhang <zhangwm@marvell.com>
Subject: kernel/printk/printk.c: fix bool assignements

Fix coccinelle warnings.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/printk/printk.c~kernel-printk-fix-bool-assignements kernel/printk/printk.c
--- a/kernel/printk/printk.c~kernel-printk-fix-bool-assignements
+++ a/kernel/printk/printk.c
@@ -919,7 +919,7 @@ static bool __read_mostly ignore_logleve
 
 static int __init ignore_loglevel_setup(char *str)
 {
-	ignore_loglevel = 1;
+	ignore_loglevel = true;
 	pr_info("debug: ignoring loglevel setting.\n");
 
 	return 0;
@@ -2005,12 +2005,12 @@ int update_console_cmdline(char *name, i
 	return -1;
 }
 
-bool console_suspend_enabled = 1;
+bool console_suspend_enabled = true;
 EXPORT_SYMBOL(console_suspend_enabled);
 
 static int __init console_suspend_disable(char *str)
 {
-	console_suspend_enabled = 0;
+	console_suspend_enabled = false;
 	return 1;
 }
 __setup("no_console_suspend", console_suspend_disable);
_

Patches currently in -mm which might be from zhangwm@marvell.com are

origin.patch
linux-next.patch

