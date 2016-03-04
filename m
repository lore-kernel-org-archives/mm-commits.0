From: akpm@linux-foundation.org
Subject: +
 ipmi-watchdog-use-nmi_panic-when-kernel-panics-in-nmi-handler.patch added
 to -mm tree
Date: Fri, 04 Mar 2016 13:52:34 -0800
Message-ID: <56da03a2.wVbcc9HrZMQRi7Dn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42376 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759071AbcCDVwg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2016 16:52:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidehiro.kawai.ez@hitachi.com, cminyard@mvista.com, linux@roeck-us.net, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipmi/watchdog: use nmi_panic() when kernel panics in NMI handler
has been added to the -mm tree.  Its filename is
     ipmi-watchdog-use-nmi_panic-when-kernel-panics-in-nmi-handler.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipmi-watchdog-use-nmi_panic-when-kernel-panics-in-nmi-handler.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipmi-watchdog-use-nmi_panic-when-kernel-panics-in-nmi-handler.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

panic-change-nmi_panic-from-macro-to-function.patch
ipmi-watchdog-use-nmi_panic-when-kernel-panics-in-nmi-handler.patch
hpwdt-use-nmi_panic-when-kernel-panics-in-nmi-handler.patch

