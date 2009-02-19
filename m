From: akpm@linux-foundation.org
Subject: + serial-update-pnp-ids.patch added to -mm tree
Date: Thu, 19 Feb 2009 12:17:24 -0800
Message-ID: <200902192017.n1JKHOmO020115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752830AbZBSUS0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 15:18:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg59@srcf.ucam.org, alan@lxorguk.ukuu.org.uk, mjg@redhat.com


The patch titled
     serial: update PNP IDs
has been added to the -mm tree.  Its filename is
     serial-update-pnp-ids.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: update PNP IDs
From: Matthew Garrett <mjg59@srcf.ucam.org>

Add new Wacom device IDs to the 8250_pnp serial driver, to support
autoconfig on some newer tablet PCs.  Also add a comment to clarify that
the FUJ02E6 device is a custom protocol, not a Wacom tablet.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pnp.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/serial/8250_pnp.c~serial-update-pnp-ids drivers/serial/8250_pnp.c
--- a/drivers/serial/8250_pnp.c~serial-update-pnp-ids
+++ a/drivers/serial/8250_pnp.c
@@ -333,6 +333,10 @@ static const struct pnp_device_id pnp_de
 	{       "WACF006",              0       },
 	{       "WACF007",              0       },
 	{       "WACF008",              0       },
+	{       "WACF009",              0       },
+	{       "WACF00A",              0       },
+	{       "WACF00B",              0       },
+	{       "WACF00C",              0       },
 	/* Compaq touchscreen */
 	{       "FPI2002",              0 },
 	/* Fujitsu Stylistic touchscreens */
@@ -346,8 +350,9 @@ static const struct pnp_device_id pnp_de
 	{       "FUJ02B8",              0 },
 	{       "FUJ02B9",              0 },
 	{       "FUJ02BC",              0 },
-	/* Fujitsu Wacom Tablet PC devices */
+	/* Fujitsu Wacom Tablet PC device */
 	{	"FUJ02E5",		0	},
+	/* Fujitsu P-series tablet PC device */
 	{	"FUJ02E6",		0	},
 	/*
 	 * LG C1 EXPRESS DUAL (C1-PB11A3) touch screen (actually a FUJ02E6 in
_

Patches currently in -mm which might be from mjg59@srcf.ucam.org are

origin.patch
linux-next.patch
x86-oqo-depends-on-input_polldev.patch
serial-update-pnp-ids.patch

