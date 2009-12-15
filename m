From: akpm@linux-foundation.org
Subject: [folded] drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch removed from -mm tree
Date: Mon, 14 Dec 2009 17:07:31 -0800
Message-ID: <200912150107.nBF17VYR012555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37319 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756625AbZLOBH6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 20:07:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel@caiaq.de, akpm@linux-foundation.org, dbrownell@users.sourceforge.net, hartleys@visionengravers.com, mm-commits@vger.kernel.org


The patch titled
     drivers-misc-add-driver-for-texas-instruments-dac7512-update
has been removed from the -mm tree.  Its filename was
     drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch

This patch was dropped because it was folded into drivers-misc-add-driver-for-texas-instruments-dac7512.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers-misc-add-driver-for-texas-instruments-dac7512-update
From: Daniel Mack <daniel@caiaq.de>

On Mon, Oct 12, 2009 at 12:31:46PM -0400, H Hartley Sweeten wrote:
> On Wednesday, October 07, 2009 1:01 PM, Daniel Mack wrote:
> > This is actually too trivial to publish, but to export the function of
> > that chip to the userspace, a module like this is needed.
> >
> > Signed-off-by: Daniel Mack <daniel@caiaq.de>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: David Brownell <dbrownell@users.sourceforge.net>
> > Cc: spi-devel-general@lists.sourceforge.net
> > ---
>
> [snip]
>
> > +static ssize_t dac7512_store_val(struct device *dev,
> > +				 struct device_attribute *attr,
> > +				 const char *buf, size_t count)
> > +{
> > +	struct spi_device *spi = to_spi_device(dev);
> > +	unsigned char tmp[2];
> > +	unsigned long val;
> > +
> > +	if (strict_strtoul(buf, 10, &val) < 0)
> > +		return -EINVAL;
> > +
> > +	tmp[0] = val >> 8;
> > +	tmp[1] = val & 0xff;
> > +	spi_write(spi, tmp, sizeof(tmp));
> > +	return count;
> > +}
> > +
> > +static DEVICE_ATTR(value, S_IWUSR | S_IRUGO,
> > +		   NULL, dac7512_store_val);
>
> You have declared the "value" device attribute with mode S_IWUSR | S_IRUGO
> but have not provided a show callback.

Sorry, forget my last mail, I got you wrong. You're of course right,
S_IRUGO shouldn't be set for write-only attributes. Updates patch below.

Thanks,
Daniel

From ab18a967e55d2bb1d39559333bca81a01c2838f0 Mon Sep 17 00:00:00 2001
Date: Thu, 8 Oct 2009 03:55:46 +0800
Subject: [PATCH] drivers/misc: add driver for Texas Instruments DAC7512

This is actually too trivial to publish, but to export the function of
that chip to the userspace, a module like this is needed.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: "H Hartley Sweeten" <hartleys@visionengravers.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/misc/Makefile~drivers-misc-add-driver-for-texas-instruments-dac7512-update drivers/misc/Makefile
diff -puN drivers/misc/ti_dac7512.c~drivers-misc-add-driver-for-texas-instruments-dac7512-update drivers/misc/ti_dac7512.c
--- a/drivers/misc/ti_dac7512.c~drivers-misc-add-driver-for-texas-instruments-dac7512-update
+++ a/drivers/misc/ti_dac7512.c
@@ -43,8 +43,7 @@ static ssize_t dac7512_store_val(struct 
 	return count;
 }
 
-static DEVICE_ATTR(value, S_IWUSR | S_IRUGO,
-		   NULL, dac7512_store_val);
+static DEVICE_ATTR(value, S_IWUSR, NULL, dac7512_store_val);
 
 static struct attribute *dac7512_attributes[] = {
 	&dev_attr_value.attr,
_

Patches currently in -mm which might be from daniel@caiaq.de are

origin.patch
drivers-misc-add-driver-for-texas-instruments-dac7512.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch

