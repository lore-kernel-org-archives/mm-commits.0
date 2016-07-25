From: akpm@linux-foundation.org
Subject: [merged] pps-do-not-crash-when-failed-to-register.patch removed
 from -mm tree
Date: Mon, 25 Jul 2016 12:05:17 -0700
Message-ID: <579662ed.ZlObwA1HdsEnM7Ry%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44073 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbcGYTFS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2016 15:05:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, giometti@enneenne.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: pps: do not crash when failed to register
has been removed from the -mm tree.  Its filename was
     pps-do-not-crash-when-failed-to-register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiri Slaby <jslaby@suse.cz>
Subject: pps: do not crash when failed to register

With this command sequence:
 modprobe plip
 modprobe pps_parport
 rmmod pps_parport
the partport_pps modules causes this crash:

===

BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffffa110301d>] parport_detach+0x1d/0x60 [pps_parport]
Oops: 0000 [#1] SMP
...
Call Trace:
 [<ffffffffa036a185>] parport_unregister_driver+0x65/0xc0 [parport]
 [<ffffffff810ff667>] SyS_delete_module+0x187/0x210

===

1) plip is loaded and takes the parport device for exclusive use:
  plip0: Parallel port at 0x378, using IRQ 7.

2) pps_parport then fails to grab the device:
  pps_parport: parallel port PPS client
  parport0: cannot grant exclusive access for device pps_parport
  pps_parport: couldn't register with parport0

3) rmmod of pps_parport is then killed because it tries to access
   pardev->name, but pardev (taken from port->cad) is NULL.

So add a check for NULL in the test there too.

Link: http://lkml.kernel.org/r/20160714115245.12651-1-jslaby@suse.cz
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/clients/pps_parport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pps/clients/pps_parport.c~pps-do-not-crash-when-failed-to-register drivers/pps/clients/pps_parport.c
--- a/drivers/pps/clients/pps_parport.c~pps-do-not-crash-when-failed-to-register
+++ a/drivers/pps/clients/pps_parport.c
@@ -195,7 +195,7 @@ static void parport_detach(struct parpor
 	struct pps_client_pp *device;
 
 	/* FIXME: oooh, this is ugly! */
-	if (strcmp(pardev->name, KBUILD_MODNAME))
+	if (!pardev || strcmp(pardev->name, KBUILD_MODNAME))
 		/* not our port */
 		return;
 
_

Patches currently in -mm which might be from jslaby@suse.cz are


