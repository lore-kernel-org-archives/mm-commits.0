From: akpm@linux-foundation.org
Subject: [merged]
 hpwdt-use-nmi_panic-when-kernel-panics-in-nmi-handler.patch removed from
 -mm tree
Date: Wed, 23 Mar 2016 10:42:23 -0700
Message-ID: <56f2d57f.CwKnOC0JTOhkrRdX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59341 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559AbcCWRmY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:42:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidehiro.kawai.ez@hitachi.com, linux@roeck-us.net, thomas.mingarelli@hpe.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     Subject: hpwdt: use nmi_panic() when kernel panics in NMI handler
has been removed from the -mm tree.  Its filename was
     hpwdt-use-nmi_panic-when-kernel-panics-in-nmi-handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: hpwdt: use nmi_panic() when kernel panics in NMI handler

commit 1717f2096b54 ("panic, x86: Fix re-entrance problem due to panic on
NMI") introduced nmi_panic() which prevents concurrent and recursive
execution of panic().  It also saves registers for the crash dump on x86
by later commit 58c5661f2144 ("panic, x86: Allow CPUs to save registers
even if looping in NMI context").

hpwdt driver can call panic() from NMI handler, so replace it with
nmi_panic().  Also, do some cleanups.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Acked-by: Guenter Roeck <linux@roeck-us.net>
Cc: Thomas Mingarelli <thomas.mingarelli@hpe.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/hpwdt.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/watchdog/hpwdt.c~hpwdt-use-nmi_panic-when-kernel-panics-in-nmi-handler drivers/watchdog/hpwdt.c
--- a/drivers/watchdog/hpwdt.c~hpwdt-use-nmi_panic-when-kernel-panics-in-nmi-handler
+++ a/drivers/watchdog/hpwdt.c
@@ -484,7 +484,7 @@ static int hpwdt_pretimeout(unsigned int
 	static int die_nmi_called;
 
 	if (!hpwdt_nmi_decoding)
-		goto out;
+		return NMI_DONE;
 
 	spin_lock_irqsave(&rom_lock, rom_pl);
 	if (!die_nmi_called && !is_icru && !is_uefi)
@@ -497,11 +497,11 @@ static int hpwdt_pretimeout(unsigned int
 
 	if (!is_icru && !is_uefi) {
 		if (cmn_regs.u1.ral == 0) {
-			panic("An NMI occurred, "
-				"but unable to determine source.\n");
+			nmi_panic(regs, "An NMI occurred, but unable to determine source.\n");
+			return NMI_HANDLED;
 		}
 	}
-	panic("An NMI occurred. Depending on your system the reason "
+	nmi_panic(regs, "An NMI occurred. Depending on your system the reason "
 		"for the NMI is logged in any one of the following "
 		"resources:\n"
 		"1. Integrated Management Log (IML)\n"
@@ -509,8 +509,7 @@ static int hpwdt_pretimeout(unsigned int
 		"3. OA Forward Progress Log\n"
 		"4. iLO Event Log");
 
-out:
-	return NMI_DONE;
+	return NMI_HANDLED;
 }
 #endif /* CONFIG_HPWDT_NMI_DECODING */
 
_

Patches currently in -mm which might be from hidehiro.kawai.ez@hitachi.com are


