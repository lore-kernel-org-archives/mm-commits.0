From: akpm@linux-foundation.org
Subject: - asic3-driver-update-2.patch removed from -mm tree
Date: Wed, 06 Feb 2008 19:30:11 -0800
Message-ID: <200802070329.m173TqSF013900@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39527 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759265AbYBGD37 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 22:29:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sameo@openedhand.com, mm-commits@vger.kernel.org


The patch titled
     ASIC3 driver update 2
has been removed from the -mm tree.  Its filename was
     asic3-driver-update-2.patch

This patch was dropped because it was folded into asic3-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ASIC3 driver update 2
From: Samuel Ortiz <sameo@openedhand.com>

On Fri, Oct 19, 2007 at 11:00:34AM -0700, Andrew Morton wrote:
> On Fri, 19 Oct 2007 12:53:00 +0200 Samuel Ortiz <sameo@openedhand.com> wrote:
>
> > On Thu, Oct 18, 2007 at 03:05:44PM -0700, Andrew Morton wrote:
> > > On Thu, 18 Oct 2007 11:12:41 +0200
> > > Samuel Ortiz <sameo@openedhand.com> wrote:
> >
> > > > +#include <linux/module.h>
> > > > +#include <linux/version.h>
> > > > +#include <linux/irq.h>
> > >
> > > Please see the large comment at the top of linux/irq.h.  I believe this
> > > driver will fial to compile on at least arm.
> > It doesn't build as a module, since we need the irq.h symbols.
> > I changed MFD_ASIC3 to bool. I somehow feel that this is not the cleanest
> > solution, but OTOH I think that dynamically adding IRQs and GPIOs to an
> > embedded board doesn't make much sense.
>
> We seem to have miscommunicated here.  <linux/irq.h> contains references to
> things which only some architectures actually implement.  I don't know
> which architectures those are, but it includes common ones like x86, so
> it's a real trap.  I recall it does not include arm, so your code might
> break on arm.
>
> At least, that's what's _supposed_ to happen: I just compiled and linked
> this driver into an ARM kernel with no problems so now I'm all confused as
> to what the problem was.
Yes, ARM implements the irq.h API. So, it will definitely builds on an ARM
kernel.
However, since there is no requirement for other architectures to implement
this API and since the asic3 is currently only found and tested on ARM
machines, I think it would be safer to make it depends on ARM.
Would that make sense to you ? Here goes a new revision of the patch in case
it does. That would be version 3.

--
ASIC3 driver - v3.

This is a patch for the ASIC3 silicon originally designed by Compaq.
This is a multifunction device, found in many PDAs (iPAQs, HTCs...).

Changes from v3 to v2:
---------------------
- Depends on ARM

Changes from v2 to v1:
---------------------
- Fixes checkpatch errors and warnings.
- Depends on GENERIC_HARDIRQS.
- MFD_ASIC3 is bool, as it needs non-exported irq.h symbols.
- Disable local interrupts when taking the lock from the irq_chip ops.
- Optimize bus shift handling.
- Coding style fixes.

Signed-off-by: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/mfd/Kconfig~asic3-driver-update-2 drivers/mfd/Kconfig
--- a/drivers/mfd/Kconfig~asic3-driver-update-2
+++ a/drivers/mfd/Kconfig
@@ -17,10 +17,10 @@ config MFD_SM501
 
 config MFD_ASIC3
 	bool "Support for Compaq ASIC3"
-	depends on GENERIC_HARDIRQS
+	depends on GENERIC_HARDIRQS && ARM
 	 ---help---
 	  This driver supports the ASIC3 multifunction chip found on many
-	  PDAs (mainly iPAQ and HTC based ones).
+	  PDAs (mainly iPAQ and HTC based ones)
 
 endmenu
 
_

Patches currently in -mm which might be from sameo@openedhand.com are

asic3-driver.patch
asic3-driver-update-2.patch
