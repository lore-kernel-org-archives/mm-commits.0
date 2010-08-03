From: akpm@linux-foundation.org
Subject: + edac-mpc85xx-add-support-for-new-mpcxxx-pxxxx-edac-controllers-fix.patch added to -mm tree
Date: Tue, 03 Aug 2010 13:04:04 -0700
Message-ID: <201008032004.o73K444f008366@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757648Ab0HCURx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Aug 2010 16:17:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cbouatmailru@gmail.com, avorontsov@mvista.com, djiang@mvista.com, dougthompson@xmission.com, ptyser@xes-inc.com, scottwood@freescale.com


The patch titled
     edac-mpc85xx-add-support-for-new-mpcxxx-pxxxx-edac-controllers-fix
has been added to the -mm tree.  Its filename is
     edac-mpc85xx-add-support-for-new-mpcxxx-pxxxx-edac-controllers-fix.patch

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
Subject: edac-mpc85xx-add-support-for-new-mpcxxx-pxxxx-edac-controllers-fix
From: Anton Vorontsov <cbouatmailru@gmail.com>

On Wed, Jul 21, 2010 at 06:21:08PM -0500, Scott Wood wrote:
[...]
> > > > +	{ .compatible = "fsl,p4080-l2-cache-controller", },
> > >
> > > L2 on the p4080 is quite different from those other chips.  It's part
> > > of the core, controlled by SPRs.
> >
> > erm, was that an ack or a nack?
>
> NACK, p4080 doesn't belong in this table, at least not its L2.
>
> L3 on p4080 is similar to L2 on these other chips, though, and it
> wouldn't take much to get this driver working on it -- but the match
> table entry should wait until the differences are accommodated.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
Cc: Scott Wood <scottwood@freescale.com>
Cc: Peter Tyser <ptyser@xes-inc.com>
Cc: Dave Jiang <djiang@mvista.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/mpc85xx_edac.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/edac/mpc85xx_edac.c~edac-mpc85xx-add-support-for-new-mpcxxx-pxxxx-edac-controllers-fix drivers/edac/mpc85xx_edac.c
--- a/drivers/edac/mpc85xx_edac.c~edac-mpc85xx-add-support-for-new-mpcxxx-pxxxx-edac-controllers-fix
+++ a/drivers/edac/mpc85xx_edac.c
@@ -652,7 +652,6 @@ static struct of_device_id mpc85xx_l2_er
 	{ .compatible = "fsl,p1020-l2-cache-controller", },
 	{ .compatible = "fsl,p1021-l2-cache-controller", },
 	{ .compatible = "fsl,p2020-l2-cache-controller", },
-	{ .compatible = "fsl,p4080-l2-cache-controller", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, mpc85xx_l2_err_of_match);
_

Patches currently in -mm which might be from cbouatmailru@gmail.com are

linux-next.patch
drivers-power-ds2782_batteryc-fix-ds2782-battery-driver-units.patch
mtdpart-memory-accessor-interface-for-mtd-layer.patch
edac-mpc85xx-add-support-for-new-mpcxxx-pxxxx-edac-controllers-fix.patch

