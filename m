From: akpm@linux-foundation.org
Subject: + ide-hpt366-convert-to-use-match_string-helper.patch added to
 -mm tree
Date: Mon, 01 Feb 2016 22:10:36 -0800
Message-ID: <56b0485c.HWffPt673aT7PI0E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56750 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbcBBGKh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 01:10:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: ide: hpt366: convert to use match_string() helper
has been added to the -mm tree.  Its filename is
     ide-hpt366-convert-to-use-match_string-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ide-hpt366-convert-to-use-match_string-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ide-hpt366-convert-to-use-match_string-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
