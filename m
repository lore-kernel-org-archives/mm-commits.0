From: akpm@linux-foundation.org
Subject: [merged] drivers-mtd-mtdcorec-make-symbols-static.patch removed from -mm tree
Date: Tue, 08 Sep 2009 14:26:22 -0700
Message-ID: <200909082126.n88LQMGP006920@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39606 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751864AbZIHV0a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2009 17:26:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hartleys@visionengravers.com, dwmw2@infradead.org, hsweeten@visionengravers.com, mm-commits@vger.kernel.org


The patch titled
     drivers/mtd/mtdcore.c: make symbols static
has been removed from the -mm tree.  Its filename was
     drivers-mtd-mtdcorec-make-symbols-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/mtd/mtdcore.c: make symbols static
From: H Hartley Sweeten <hartleys@visionengravers.com>

Make mtd_group and mtd_groups static since they are only used in this
file.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdcore.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/mtd/mtdcore.c~drivers-mtd-mtdcorec-make-symbols-static drivers/mtd/mtdcore.c
--- a/drivers/mtd/mtdcore.c~drivers-mtd-mtdcorec-make-symbols-static
+++ a/drivers/mtd/mtdcore.c
@@ -213,11 +213,11 @@ static struct attribute *mtd_attrs[] = {
 	NULL,
 };
 
-struct attribute_group mtd_group = {
+static struct attribute_group mtd_group = {
 	.attrs		= mtd_attrs,
 };
 
-const struct attribute_group *mtd_groups[] = {
+static const struct attribute_group *mtd_groups[] = {
 	&mtd_group,
 	NULL,
 };
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

linux-next.patch
mtd-sst25l-non-jedec-spi-flash-driver.patch
fs-bufferc-clean-up-export-macros.patch
aioc-move-export-macros-to-line-after-function.patch
gpio-include-linux-gpioh-not-asm-gpioh.patch
atyfb-coding-style-cleanup.patch
jbdh-bitfields-should-be-unsigned.patch

