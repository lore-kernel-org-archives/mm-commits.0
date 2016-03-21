From: akpm@linux-foundation.org
Subject: [merged] ide-hpt366-convert-to-use-match_string-helper.patch
 removed from -mm tree
Date: Mon, 21 Mar 2016 11:42:18 -0700
Message-ID: <56f0408a.0xVllD5sSG6P07VR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52800 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757942AbcCUTVV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:21:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: ide: hpt366: convert to use match_string() helper
has been removed from the -mm tree.  Its filename was
     ide-hpt366-convert-to-use-match_string-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: ide: hpt366: convert to use match_string() helper

The new helper returns index of the mathing string in an array. We would use it
here.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/hpt366.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN drivers/ide/hpt366.c~ide-hpt366-convert-to-use-match_string-helper drivers/ide/hpt366.c
--- a/drivers/ide/hpt366.c~ide-hpt366-convert-to-use-match_string-helper
+++ a/drivers/ide/hpt366.c
@@ -531,14 +531,9 @@ static const struct hpt_info hpt371n = {
 	.timings	= &hpt37x_timings
 };
 
-static int check_in_drive_list(ide_drive_t *drive, const char **list)
+static bool check_in_drive_list(ide_drive_t *drive, const char **list)
 {
-	char *m = (char *)&drive->id[ATA_ID_PROD];
