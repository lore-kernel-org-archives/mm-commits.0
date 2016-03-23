From: akpm@linux-foundation.org
Subject: [merged]
 ipmi-watchdog-use-nmi_panic-when-kernel-panics-in-nmi-handler.patch removed from -mm tree
Date: Wed, 23 Mar 2016 10:42:21 -0700
Message-ID: <56f2d57d.TUOWTWA33fDYwOny%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59336 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559AbcCWRmW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:42:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidehiro.kawai.ez@hitachi.com, cminyard@mvista.com, linux@roeck-us.net, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipmi/watchdog: use nmi_panic() when kernel panics in NMI handler
has been removed from the -mm tree.  Its filename was
     ipmi-watchdog-use-nmi_panic-when-kernel-panics-in-nmi-handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: ipmi/watchdog: use nmi_panic() when kernel panics in NMI handler

commit 1717f2096b54 ("panic, x86: Fix re-entrance problem due to panic on
NMI") introduced nmi_panic() which prevents concurrent and recursive
execution of panic().  It also saves registers for the crash dump on x86
by later commit 58c5661f2144 ("panic, x86: Allow CPUs to save registers
even if looping in NMI context").

ipmi_watchdog driver can call panic() from NMI handler, so replace it with
nmi_panic().

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Acked-by: Corey Minyard <cminyard@mvista.com>
Acked-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_watchdog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/ipmi/ipmi_watchdog.c~ipmi-watchdog-use-nmi_panic-when-kernel-panics-in-nmi-handler drivers/char/ipmi/ipmi_watchdog.c
--- a/drivers/char/ipmi/ipmi_watchdog.c~ipmi-watchdog-use-nmi_panic-when-kernel-panics-in-nmi-handler
+++ a/drivers/char/ipmi/ipmi_watchdog.c
@@ -1140,7 +1140,7 @@ ipmi_nmi(unsigned int val, struct pt_reg
 		   the timer.   So do so. */
 		pretimeout_since_last_heartbeat = 1;
 		if (atomic_inc_and_test(&preop_panic_excl))
-			panic(PFX "pre-timeout");
+			nmi_panic(regs, PFX "pre-timeout");
 	}
 
 	return NMI_HANDLED;
_

Patches currently in -mm which might be from hidehiro.kawai.ez@hitachi.com are


