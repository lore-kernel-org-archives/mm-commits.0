From: akpm@linux-foundation.org
Subject: - git-arm-fix.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:40:17 -0700
Message-ID: <200804261640.m3QGeHrs031018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757689AbYDZQt3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:49:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: philipp.zabel@gmail.com, akpm@linux-foundation.org, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     From: "pHilipp Zabel" <philipp.zabel@gmail.com>
has been removed from the -mm tree.  Its filename was
     git-arm-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: From: "pHilipp Zabel" <philipp.zabel@gmail.com>


On Thu, Apr 17, 2008 at 9:41 AM, Russell King <rmk@arm.linux.org.uk> wrote:
> On Wed, Apr 16, 2008 at 05:15:38PM -0700, akpm@linux-foundation.org wrote:
>  > Subject: git-arm: drivers/mfd/htc-pasic3.c is arm-specific
>  > From: Andrew Morton <akpm@linux-foundation.org>
>  >
>  > drivers/mfd/htc-pasic3.c:22:31: error: asm/arch/pxa-regs.h: No such file or directory
>  >
>  > Cc: Russell King <rmk@arm.linux.org.uk>
>  > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>  > ---
>  >
>  >  drivers/mfd/Kconfig |    1 +
>  >  1 file changed, 1 insertion(+)
>  >
>  > diff -puN drivers/mfd/Kconfig~git-arm-drivers-mfd-htc-pasic3c-is-arm-specific drivers/mfd/Kconfig
>  > --- a/drivers/mfd/Kconfig~git-arm-drivers-mfd-htc-pasic3c-is-arm-specific
>  > +++ a/drivers/mfd/Kconfig
>  > @@ -32,6 +32,7 @@ config HTC_EGPIO
>  >
>  >  config HTC_PASIC3
>  >       tristate "HTC PASIC3 LED/DS1WM chip support"
>  > +     depends on ARM
>
>  depends on ARCH_PXA would be much better.

I'm sorry, that #include <asm/arch/pxa-regs.h> is a left-over that
slipped through the net. The four or five devices using this chip that
I know of are all PXA263/PXA272, but this would be better instead:

index 94e359b..4edc120 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/htc-pasic3.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/mfd/htc-pasic3.c~git-arm-fix drivers/mfd/htc-pasic3.c
--- a/drivers/mfd/htc-pasic3.c~git-arm-fix
+++ a/drivers/mfd/htc-pasic3.c
@@ -19,8 +19,6 @@
 #include <linux/interrupt.h>
 #include <linux/mfd/htc-pasic3.h>
 
-#include <asm/arch/pxa-regs.h>
