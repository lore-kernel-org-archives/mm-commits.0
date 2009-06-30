From: akpm@linux-foundation.org
Subject: + drivers-mtd-mtdcorec-make-symbols-static.patch added to -mm tree
Date: Tue, 30 Jun 2009 12:17:14 -0700
Message-ID: <200906301917.n5UJHECM008232@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41760 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756021AbZF3TR3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jun 2009 15:17:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, dwmw2@infradead.org, hsweeten@visionengravers.com


The patch titled
     drivers/mtd/mtdcore.c: make symbols static
has been added to the -mm tree.  Its filename is
     drivers-mtd-mtdcorec-make-symbols-static.patch

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
 
-struct attribute_group *mtd_groups[] = {
+static struct attribute_group *mtd_groups[] = {
 	&mtd_group,
 	NULL,
 };
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

linux-next.patch
mtd-sst25l-non-jedec-spi-flash-driver.patch
mtd-sst25l-non-jedec-spi-flash-driver-update.patch
mtd-sst25l-non-jedec-spi-flash-driver-fix.patch
drivers-mtd-mtdcorec-make-symbols-static.patch
atyfb-coding-style-cleanup.patch

