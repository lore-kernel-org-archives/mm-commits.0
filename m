From: akpm@linux-foundation.org
Subject: [merged] serial-8250_pnp-use-wildcard-for-serial-wacom-tablets.patch removed from -mm tree
Date: Tue, 29 Dec 2009 13:32:48 -0800
Message-ID: <200912292132.nBTLWmJs008658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33090 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752809AbZL2VdN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Dec 2009 16:33:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mjg@redhat.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, pingc@wacom.com, mm-commits@vger.kernel.org


The patch titled
     serial/8250_pnp: use wildcard for serial Wacom tablets
has been removed from the -mm tree.  Its filename was
     serial-8250_pnp-use-wildcard-for-serial-wacom-tablets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial/8250_pnp: use wildcard for serial Wacom tablets
From: Matthew Garrett <mjg@redhat.com>

Wacom claims that the WACF namespace will always be devoted to serial
Wacom tablets.  Remove the existing entries and add a wildcard to avoid
having to update the kernel every time they add a new device.

Signed-off-by: Ping Cheng <pingc@wacom.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Tested-by: Ping Cheng <pingc@wacom.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pnp.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff -puN drivers/serial/8250_pnp.c~serial-8250_pnp-use-wildcard-for-serial-wacom-tablets drivers/serial/8250_pnp.c
--- a/drivers/serial/8250_pnp.c~serial-8250_pnp-use-wildcard-for-serial-wacom-tablets
+++ a/drivers/serial/8250_pnp.c
@@ -328,15 +328,7 @@ static const struct pnp_device_id pnp_de
 	/* U.S. Robotics 56K Voice INT PnP*/
 	{	"USR9190",		0	},
 	/* Wacom tablets */
-	{	"WACF004",		0	},
-	{	"WACF005",		0	},
-	{       "WACF006",              0       },
-	{       "WACF007",              0       },
-	{       "WACF008",              0       },
-	{       "WACF009",              0       },
-	{       "WACF00A",              0       },
-	{       "WACF00B",              0       },
-	{       "WACF00C",              0       },
+	{	"WACFXXX",		0	},
 	/* Compaq touchscreen */
 	{       "FPI2002",              0 },
 	/* Fujitsu Stylistic touchscreens */
_

Patches currently in -mm which might be from mjg@redhat.com are

linux-next.patch
dell_laptop-when-the-hardware-switch-is-disabled-dont-actually-allow-changing-the-softblock-status.patch

