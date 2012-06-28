From: akpm@linux-foundation.org
Subject: + frv-kill-used-but-uninitialized-variable.patch added to -mm tree
Date: Thu, 28 Jun 2012 15:49:33 -0700
Message-ID: <20120628224933.4CB87A01CE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:52290 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245Ab2F1Wtf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jun 2012 18:49:35 -0400
Received: by fat25 with SMTP id 25so149602fat.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Jun 2012 15:49:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, dhowells@redhat.com


The patch titled
     Subject: frv: kill used but uninitialized variable
has been added to the -mm tree.  Its filename is
     frv-kill-used-but-uninitialized-variable.patch

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
Subject: frv: kill used but uninitialized variable

Commit 6afe1a1fe8ff83f6a ("PM: Remove legacy PM") removed the
initialization of retval, causing:

arch/frv/kernel/pm.c: In function 'sysctl_pm_do_suspend':
arch/frv/kernel/pm.c:165:5: warning: 'retval' may be used uninitialized in this function [-Wuninitialized]

Remove the variable completely to fix this, and convert to a proper
switch (...) { ... } construct to improve readability.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/pm.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff -puN arch/frv/kernel/pm.c~frv-kill-used-but-uninitialized-variable arch/frv/kernel/pm.c
--- a/arch/frv/kernel/pm.c~frv-kill-used-but-uninitialized-variable
+++ a/arch/frv/kernel/pm.c
@@ -153,23 +153,22 @@ static int user_atoi(char __user *ubuf, 
 static int sysctl_pm_do_suspend(ctl_table *ctl, int write,
 				void __user *buffer, size_t *lenp, loff_t *fpos)
 {
-	int retval, mode;
+	int mode;
 
 	if (*lenp <= 0)
 		return -EIO;
 
 	mode = user_atoi(buffer, *lenp);
-	if ((mode != 1) && (mode != 5))
-		return -EINVAL;
+	switch (mode) {
+	case 1:
+	    return pm_do_suspend();
 
-	if (retval == 0) {
-		if (mode == 5)
-		    retval = pm_do_bus_sleep();
-		else
-		    retval = pm_do_suspend();
-	}
+	case 5:
+	    return pm_do_bus_sleep();
 
-	return retval;
+	default:
+	    return -EINVAL;
+	}
 }
 
 static int try_set_cmode(int new_cmode)
_
Subject: Subject: frv: kill used but uninitialized variable

Patches currently in -mm which might be from geert@linux-m68k.org are

linux-next.patch
mn10300-move-setup_jiffies_interrupt-to-cevt-mn10300c.patch
mn10300-remove-duplicate-definition-of-ptrace_o_tracesysgood.patch
mn10300-kernel-internalh-needs-linux-irqreturnh.patch
mn10300-kernel-trapsc-needs-linux-exporth.patch
mn10300-mm-dma-allocc-needs-linux-exporth.patch
mn10300-use-elif-definedconfig_-instead-of-elif-config_.patch
h8300-pgtable-add-missing-include-asm-generic-pgtableh.patch
h8300-signal-fix-typo-statis.patch
h8300-time-add-missing-include-asm-irq_regsh.patch
h8300-uaccess-remove-assignment-to-__gu_val-in-unhandled-case-of-get_user.patch
h8300-uaccess-add-mising-__clear_user.patch
fs-ramfs-file-nommu-add-setpageuptodate.patch
frv-kill-used-but-uninitialized-variable.patch

