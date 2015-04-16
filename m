From: akpm@linux-foundation.org
Subject: [merged] powerpc-powernv-reboot-when-requested-by-firmware.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 09:54:34 -0700
Message-ID: <552fe94a.OMNn7nJcWqsqK8Ot%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43089 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbbDPQtF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:49:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joel@jms.id.au, benh@kernel.crashing.org, davem@davemloft.net, fabf@skynet.be, jk@ozlabs.org, mpe@ellerman.id.au, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/powernv: reboot when requested by firmware
has been removed from the -mm tree.  Its filename was
     powerpc-powernv-reboot-when-requested-by-firmware.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

