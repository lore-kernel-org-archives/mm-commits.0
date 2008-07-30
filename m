From: akpm@linux-foundation.org
Subject: - update-smc91x-driver-with-arm-versatile-board-info.patch removed from -mm tree
Date: Wed, 30 Jul 2008 16:09:08 -0700
Message-ID: <200807302309.m6UN98js022524@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752080AbYG3XKj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 19:10:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dsaxena@plexity.net, jeff@garzik.org, nico@cam.org, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Update smc91x driver with ARM Versatile board info
has been removed from the -mm tree.  Its filename was
     update-smc91x-driver-with-arm-versatile-board-info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Update smc91x driver with ARM Versatile board info
From: Deepak Saxena <dsaxena@plexity.net>

We need to specify a Versatile-specific SMC_IRQ_FLAGS value or the new
generic IRQ layer will complain thusly:

No IRQF_TRIGGER set_type function for IRQ 25 (<NULL>)

Signed-off-by: Deepak Saxena <dsaxena@plexity.net>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Nicolas Pitre <nico@cam.org>

On Fri, 20 Oct 2006 22:50:40 +0100
Russell King <rmk@arm.linux.org.uk> wrote:

> On Fri, Oct 20, 2006 at 02:42:04PM -0700, akpm@linux-foundation.org wrote:
> > We need to specify a Versatile-specific SMC_IRQ_FLAGS value or the new
> > generic IRQ layer will complain thusly:
> 
> I don't think I heard anything back from my previous suggestion that
> the IRQ flags are passed through the platform device IRQ resource.
> 
> Doing so would avoid adding yet another platform specific block into
> the file.
> 
> BTW, Integrator platforms will also suffer from this, which will add
> another ifdef to this header.
> 
> Let's do it right and arrange to pass these flags from the platform
> code.  It's not like they're in a critical path.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/smc91x.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN drivers/net/smc91x.h~update-smc91x-driver-with-arm-versatile-board-info drivers/net/smc91x.h
--- a/drivers/net/smc91x.h~update-smc91x-driver-with-arm-versatile-board-info
+++ a/drivers/net/smc91x.h
@@ -435,6 +435,24 @@ static inline void LPD7_SMC_outsw (unsig
 
 #include <asm/unit/smc91111.h>
 
+#elif	defined(CONFIG_ARCH_VERSATILE)
+
+#define SMC_CAN_USE_8BIT	1
+#define SMC_CAN_USE_16BIT	1
+#define SMC_CAN_USE_32BIT	1
+#define SMC_NOWAIT		1
+
+#define SMC_inb(a, r)		readb((a) + (r))
+#define SMC_inw(a, r)		readw((a) + (r))
+#define SMC_inl(a, r)		readl((a) + (r))
+#define SMC_outb(v, a, r)	writeb(v, (a) + (r))
+#define SMC_outw(v, a, r)	writew(v, (a) + (r))
+#define SMC_outl(v, a, r)	writel(v, (a) + (r))
+#define SMC_insl(a, r, p, l)	readsl((a) + (r), p, l)
+#define SMC_outsl(a, r, p, l)	writesl((a) + (r), p, l)
+
+#define SMC_IRQ_FLAGS		(0)
+
 #else
 
 /*
_

Patches currently in -mm which might be from dsaxena@plexity.net are

update-smc91x-driver-with-arm-versatile-board-info.patch

