From: akpm@linux-foundation.org
Subject: - possible-bugfix-make-dmi_mark_tsc_unstable-call-mark_tsc_unstable.patch removed from -mm tree
Date: Mon, 05 Mar 2007 21:11:04 -0800
Message-ID: <200703060511.l265B4P5012642@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51237 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbXCFFLg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 00:11:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guichaz@gmail.com, guichaz@yahoo.fr, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Possible bugfix: make dmi_mark_tsc_unstable() call mark_tsc_unstable()
has been removed from the -mm tree.  Its filename was
     possible-bugfix-make-dmi_mark_tsc_unstable-call-mark_tsc_unstable.patch

This patch was dropped because dropping the pther patch broke it

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

possible-bugfix-make-dmi_mark_tsc_unstable-call-mark_tsc_unstable.patch
