From: akpm@linux-foundation.org
Subject: + ata-hpt366-convert-to-use-match_string-helper.patch added to
 -mm tree
Date: Mon, 01 Feb 2016 22:10:35 -0800
Message-ID: <56b0485b.EWSMpjmxqxzGLtD5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56746 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbcBBGKg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 01:10:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, b.zolnierkie@samsung.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ata: hpt366: convert to use match_string() helper
has been added to the -mm tree.  Its filename is
     ata-hpt366-convert-to-use-match_string-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ata-hpt366-convert-to-use-match_string-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ata-hpt366-convert-to-use-match_string-helper.patch

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
Subject: ata: hpt366: convert to use match_string() helper

The new helper returns index of the mathing string in an array.  We would
use it here.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_hpt366.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN drivers/ata/pata_hpt366.c~ata-hpt366-convert-to-use-match_string-helper drivers/ata/pata_hpt366.c
--- a/drivers/ata/pata_hpt366.c~ata-hpt366-convert-to-use-match_string-helper
+++ a/drivers/ata/pata_hpt366.c
@@ -176,17 +176,14 @@ static int hpt_dma_blacklisted(const str
 			       const char * const list[])
 {
 	unsigned char model_num[ATA_ID_PROD_LEN + 1];
-	int i = 0;
+	int i;
 
 	ata_id_c_string(dev->id, model_num, ATA_ID_PROD, sizeof(model_num));
 
-	while (list[i] != NULL) {
-		if (!strcmp(list[i], model_num)) {
-			pr_warn("%s is not supported for %s\n",
-				modestr, list[i]);
-			return 1;
-		}
-		i++;
+	i = match_string(list, -1, model_num);
+	if (i >= 0) {
+		pr_warn("%s is not supported for %s\n", modestr, list[i]);
+		return 1;
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-string-introduce-match_string-helper.patch
device-property-convert-to-use-match_string-helper.patch
pinctrl-convert-to-use-match_string-helper.patch
drm-edid-convert-to-use-match_string-helper.patch
power-charger_manager-convert-to-use-match_string-helper.patch
power-ab8500-convert-to-use-match_string-helper.patch
ata-hpt366-convert-to-use-match_string-helper.patch
ide-hpt366-convert-to-use-match_string-helper.patch
lib-string_helpers-export-string_units_210-for-others.patch
lib-string_helpers-fix-indentation-in-few-places.patch
x86-efi-use-proper-units-in-efi_find_mirror.patch

