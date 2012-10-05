From: akpm@linux-foundation.org
Subject: [merged] frv-kill-used-but-uninitialized-variable.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:13:45 -0700
Message-ID: <20121005201345.A5CA6100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:33212 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932793Ab2JEUNr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:13:47 -0400
Received: by mail-vb0-f74.google.com with SMTP id s24so236339vbi.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:13:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: frv: kill used but uninitialized variable
has been removed from the -mm tree.  Its filename was
     frv-kill-used-but-uninitialized-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch
cris-fix-i-o-macros.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix-fix.patch

