From: akpm@linux-foundation.org
Subject: + possible-bugfix-make-dmi_mark_tsc_unstable-call-mark_tsc_unstable.patch added to -mm tree
Date: Sun, 04 Mar 2007 22:56:23 -0800
Message-ID: <200703050656.l256uNDb012075@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33842 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbXCEHDE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 02:03:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: guichaz@gmail.com, guichaz@yahoo.fr, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     Possible bugfix: make dmi_mark_tsc_unstable() call mark_tsc_unstable()
has been added to the -mm tree.  Its filename is
     possible-bugfix-make-dmi_mark_tsc_unstable-call-mark_tsc_unstable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Possible bugfix: make dmi_mark_tsc_unstable() call mark_tsc_unstable()
From: "Guillaume Chazarain" <guichaz@gmail.com>

Let the clocksource know the TSC is disabled.

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/tsc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/tsc.c~possible-bugfix-make-dmi_mark_tsc_unstable-call-mark_tsc_unstable arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c~possible-bugfix-make-dmi_mark_tsc_unstable-call-mark_tsc_unstable
+++ a/arch/i386/kernel/tsc.c
@@ -287,7 +287,7 @@ static int __init dmi_mark_tsc_unstable(
 {
 	printk(KERN_NOTICE "%s detected: marking TSC unstable.\n",
 		       d->ident);
-	tsc_disable = 1;
+	mark_tsc_unstable();
 	return 0;
 }
 
_

Patches currently in -mm which might be from guichaz@gmail.com are

bugfix-dont-use-the-tsc-in-sched_clock-if-unstable.patch
cleanup-unify-tsc_unstable-and-tsc_disable.patch
possible-bugfix-make-dmi_mark_tsc_unstable-call-mark_tsc_unstable.patch
