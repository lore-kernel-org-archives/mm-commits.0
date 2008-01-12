From: akpm@linux-foundation.org
Subject: - arm-pxa-gpiolib-support-make-pxa_gpio_chip-static.patch removed from -mm tree
Date: Fri, 11 Jan 2008 18:13:06 -0800
Message-ID: <200801120213.m0C2D6rW009326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40149 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758501AbYALCOB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 21:14:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: philipp.zabel@gmail.com, david-b@pacbell.net, dbrownell@users.sourceforge.net, nico@cam.org, rmk+kernel@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Make pxa_gpio_chip static
has been removed from the -mm tree.  Its filename was
     arm-pxa-gpiolib-support-make-pxa_gpio_chip-static.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Make pxa_gpio_chip static
From: Philipp Zabel <philipp.zabel@gmail.com>

Am Dienstag, den 27.11.2007, 01:22 -0800 schrieb David Brownell:
> On Tuesday 27 November 2007, Andrew Morton wrote:
> > On Tue, 27 Nov 2007 00:49:27 -0800 David Brownell <david-b@pacbell.net> wrote:
> >
> > > On Tuesday 27 November 2007, Andrew Morton wrote:
> > > >
> > > > (How come people are sending around patche sand not cc'ing mailing lists).
> > >
> > > This was already discussed on the ARM mailing list.
> >
> > Not by me ;)
>
> Then the only just outcome is to have Philipp send you a followup
> patch addressing at least that "static" issue, cc'ing L-A-K.  ;)

So be it:

From f7f3426eb92734b41bae22c3f1fc7e60bc8b9256 Mon Sep 17 00:00:00 2001
Date: Tue, 27 Nov 2007 14:01:45 +0100
Subject: [PATCH] Make pxa_gpio_chip static

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Nicolas Pitre <nico@cam.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-pxa/gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/mach-pxa/gpio.c~arm-pxa-gpiolib-support-make-pxa_gpio_chip-static arch/arm/mach-pxa/gpio.c
--- a/arch/arm/mach-pxa/gpio.c~arm-pxa-gpiolib-support-make-pxa_gpio_chip-static
+++ a/arch/arm/mach-pxa/gpio.c
@@ -129,7 +129,7 @@ static void pxa_gpio_set(struct gpio_chi
 		__raw_writel(mask, pxa->regbase + GPCR_OFFSET);
 }
 
-struct pxa_gpio_chip pxa_gpio_chip[] = {
+static struct pxa_gpio_chip pxa_gpio_chip[] = {
 	[0] = {
 		.regbase = GPIO0_BASE,
 		.chip = {
_

Patches currently in -mm which might be from philipp.zabel@gmail.com are

git-arm.patch
ds1wm-decouple-host-irq-and-intr-active-state-settings.patch
arm-pxa-gpiolib-support-make-pxa_gpio_chip-static.patch
