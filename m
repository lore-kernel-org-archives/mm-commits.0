From: akpm@linux-foundation.org
Subject: + powerpc-powernv-reboot-when-requested-by-firmware.patch added
 to -mm tree
Date: Wed, 01 Apr 2015 13:06:17 -0700
Message-ID: <551c4fb9.N9VmTehkE5XuJKs2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34136 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbbDAUGS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2015 16:06:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joel@jms.id.au, benh@kernel.crashing.org, davem@davemloft.net, fabf@skynet.be, jk@ozlabs.org, mpe@ellerman.id.au, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/powernv: reboot when requested by firmware
has been added to the -mm tree.  Its filename is
     powerpc-powernv-reboot-when-requested-by-firmware.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-powernv-reboot-when-requested-by-firmware.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-powernv-reboot-when-requested-by-firmware.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joel Stanley <joel@jms.id.au>
Subject: powerpc/powernv: reboot when requested by firmware

Use orderly_reboot so userspace will to shut itself down via the reboot
path.  This is required for graceful reboot initiated by the BMC, such as
when a user uses ipmitool to issue a 'chassis power cycle' command.

Signed-off-by: Joel Stanley <joel@jms.id.au>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeremy Kerr <jk@ozlabs.org>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/powernv/opal-power.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/platforms/powernv/opal-power.c~powerpc-powernv-reboot-when-requested-by-firmware arch/powerpc/platforms/powernv/opal-power.c
--- a/arch/powerpc/platforms/powernv/opal-power.c~powerpc-powernv-reboot-when-requested-by-firmware
+++ a/arch/powerpc/platforms/powernv/opal-power.c
@@ -29,8 +29,9 @@ static int opal_power_control_event(stru
 
 	switch (type) {
 	case SOFT_REBOOT:
-		/* Fall through. The service processor is responsible for
-		 * bringing the machine back up */
+		pr_info("OPAL: reboot requested\n");
+		orderly_reboot();
+		break;
 	case SOFT_OFF:
 		pr_info("OPAL: poweroff requested\n");
 		orderly_poweroff(true);
_

Patches currently in -mm which might be from joel@jms.id.au are

envctrl-ignore-orderly_poweroff-return-value.patch
kernel-rebootc-add-orderly_reboot-for-graceful-reboot.patch
powerpc-powernv-reboot-when-requested-by-firmware.patch
linux-next.patch

