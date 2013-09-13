From: akpm@linux-foundation.org
Subject: [-] cyber2000fb-avoid-palette-corruption-at-higher-clocks.patch
 removed from -mm tree
Date: Fri, 13 Sep 2013 13:30:19 -0700
Message-ID: <523375db.mDKko45gJePuK1B2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38226 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab3IMUaU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 16:30:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rmk@arm.linux.org.uk, linux@rainbow-software.org

Subject: [-] cyber2000fb-avoid-palette-corruption-at-higher-clocks.patch removed from -mm tree
To: linux@rainbow-software.org,rmk@arm.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 13:30:19 -0700


The patch titled
     Subject: cyber2000fb: avoid palette corruption at higher clocks
has been removed from the -mm tree.  Its filename was
     cyber2000fb-avoid-palette-corruption-at-higher-clocks.patch

This patch was dropped because rmk timeout!

------------------------------------------------------
From: Ondrej Zary <linux@rainbow-software.org>
Subject: cyber2000fb: avoid palette corruption at higher clocks

When 1280x1024@75Hz mode is set, console palette is not set properly -
sometimes the background is white, sometimes yellow and text colors are
also messed up.  This does not happen at 1280x1024@60Hz and below.

It seems that the HW needs some time before setting the palette - maybe
the PLL needs more time to lock at higher speeds.  This patch fixes the
problem but without knowing what register to check for PLL lock(?), the
delay might be excessive.

On Fri, 28 Jan 2011 18:15:37 +0000
Russell King <rmk@arm.linux.org.uk> wrote:

> On Tue, Jan 18, 2011 at 01:14:24PM -0800, Andrew Morton wrote:
> > Russell, I have an (old) note here that this is awaiting an ack from
> > yourself?
> 
> Well, I can reproduce this problem on the Netwinders here.  I'm not sure
> that we should delay all mode switches by one second - and any attempt
> to reduce this value does result in the palette not being set correctly.
> 
> For 1280x1024-75, the dotclock is 135MHz, which gives a PLL values of
> 0x41 and 0x06.  That's: M=0x41+1, N=0x06+1, P=0x00 (top 2 bits of 0x06)
> -> Q=1
> 
> 	Fpll = 14.31818MHz * M / N
> 	Fout = Fpll / Q
> 
> The PLL itself is formed by dividing the 14-ish MHz frequency by N and
> phase comparing the output of the VCO, divided by M, and adjusting the
> VCO until the two correlate.  As VCOs typically tend to have a limited
> range, it's normal to divide the output frequency to produce a greater
> range - and in this case that's done by Q.
> 
> For the 800x600-100 copied from /etc/fb.modes, this has a dotclock of
> 67.5MHz, which is exactly half this rate.  The PLL values for this are:
> M=0x41+1, N=0x06+1, P=0x01, giving PLL values of 0x41 and 0x46.
> 
> Booting with 800x600-100 does not suffer the problem.  So it's not
> related to PLL lock time.  There's something else going on.
> 
> Another experiment I tried was forcing the PLL values to produce 108MHz
> instead of 135MHz.  108MHz is the dotclock for 1280x1024-60.  This too
> doesn't suffer the problem.
> 
> I've also tried chosing other delay values.  100ms is too short and
> produces the problem, but 1s works.  1s for a PLL to lock is a hell of
> a time, especially for a PLL operating in the MHz range.
> 
> I've tried setting the PLL to a known good freqency, and then switching
> to 135MHz - the problem persists.  It's not like 135MHz is reaching the
> limits - it'll go up to 206MHz.
> 
> So, I don't think this has anything to do with PLL locking.  I think
> there's something else going on which isn't immediately obvious - maybe
> bandwidth starvation preventing us from writing properly to the palette?
> As it's a horrible VGA, where you write the same register multiple times
> I wouldn't be surprised if some writes were going missing.
> 
> I'll see if I can play around with it some more this evening, but I've
> spent an awful long time on just this issue already this afternoon...
> 
> I think further investigation needs to happen on this patch before it's
> acceptable.  Or maybe we should prevent the cyberpro coming up in

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cyber2000fb.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/video/cyber2000fb.c~cyber2000fb-avoid-palette-corruption-at-higher-clocks drivers/video/cyber2000fb.c
--- a/drivers/video/cyber2000fb.c~cyber2000fb-avoid-palette-corruption-at-higher-clocks
+++ a/drivers/video/cyber2000fb.c
@@ -518,6 +518,9 @@ static void cyber2000fb_set_timing(struc
 	cyber2000_grphw(0xb9, 0x00, cfb);
 	spin_unlock(&cfb->reg_b0_lock);
 
+	/* wait (for the PLL?) to avoid palette corruption at higher clocks */
+	msleep(1000);
+
 	cfb->ramdac_ctrl = hw->ramdac;
 	cyber2000fb_write_ramdac_ctrl(cfb);
 
_

Patches currently in -mm which might be from linux@rainbow-software.org are

origin.patch

