From: akpm@linux-foundation.org
Subject: - spi_s3c24xx-signedness-fix.patch removed from -mm tree
Date: Fri, 02 May 2008 12:43:03 -0700
Message-ID: <200805021943.m42Jh35r011256@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932280AbYEBTnq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:43:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew@wil.cx, dbrownell@users.sourceforge.net, julia@diku.dk, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     spi_s3c24xx signedness fix
has been removed from the -mm tree.  Its filename was
     spi_s3c24xx-signedness-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
make-sure-nobodys-leaking-resources.patch

