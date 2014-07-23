From: akpm@linux-foundation.org
Subject: + kernel-printk-fix-bool-assignements.patch added to -mm tree
Date: Wed, 23 Jul 2014 13:23:15 -0700
Message-ID: <53d019b3.IetiytKzg99OWQay%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:48547 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933091AbaGWUXQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Jul 2014 16:23:16 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so498046oac.5
        for <mm-commits@vger.kernel.org>; Wed, 23 Jul 2014 13:23:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhangwm@marvell.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/printk/printk.c: fix bool assignements
has been added to the -mm tree.  Its filename is
     kernel-printk-fix-bool-assignements.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-printk-fix-bool-assignements.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-printk-fix-bool-assignements.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kernel-printk-fix-bool-assignements.patch
linux-next.patch

