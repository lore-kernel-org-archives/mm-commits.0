From: akpm@linux-foundation.org
Subject: + spi_s3c24xx-signedness-fix.patch added to -mm tree
Date: Thu, 01 May 2008 01:24:01 -0700
Message-ID: <200805010824.m418O1hV028118@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753633AbYEAIYR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 04:24:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthew@wil.cx, dbrownell@users.sourceforge.net, julia@diku.dk, willy@linux.intel.com


The patch titled
     spi_s3c24xx signedness fix
has been added to the -mm tree.  Its filename is
     spi_s3c24xx-signedness-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi_s3c24xx signedness fix
From: Matthew Wilcox <matthew@wil.cx>

On Fri, Apr 18, 2008 at 09:08:55PM +0200, Julia Lawall wrote:
> I found 63 occurrences of this problem with the following semantic match
> (http://www.emn.fr/x-info/coccinelle/):
>
> @@ unsigned int i; @@
>
> * i < 0
>

Since this one's always in the range 0-255, it could probably be made
signed, but it's just as easy to make it work unsigned.

Reported-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_s3c24xx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/spi/spi_s3c24xx.c~spi_s3c24xx-signedness-fix drivers/spi/spi_s3c24xx.c
--- a/drivers/spi/spi_s3c24xx.c~spi_s3c24xx-signedness-fix
+++ a/drivers/spi/spi_s3c24xx.c
@@ -125,10 +125,10 @@ static int s3c24xx_spi_setupxfer(struct 
 	/* is clk = pclk / (2 * (pre+1)), or is it
 	 *    clk = (pclk * 2) / ( pre + 1) */
 
-	div = (div / 2) - 1;
+	div /= 2;
 
-	if (div < 0)
-		div = 1;
+	if (div > 0)
+		div -= 1;
 
 	if (div > 255)
 		div = 255;
_

Patches currently in -mm which might be from matthew@wil.cx are

origin.patch
parisc-remove-redundant-display-of-free-swap-space-in-show_mem.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
pci-hotplug-construct-one-fakephp-slot-per-pci-slot.patch
pci-hotplug-introduce-pci_slot.patch
git-semaphore.patch
spi_s3c24xx-signedness-fix.patch
make-sure-nobodys-leaking-resources.patch

