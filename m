From: akpm@linux-foundation.org
Subject: [merged] fcoe-remove-redundant-less-than-zero-check.patch removed from -mm tree
Date: Thu, 12 Jul 2012 12:37:56 -0700
Message-ID: <20120712193757.0C7985C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:51266 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030747Ab2GLTh7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 15:37:59 -0400
Received: by weyr1 with SMTP id r1so145568wey.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 12:37:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: robert.w.love@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fcoe: Remove redundant 'less than zero' check
has been removed from the -mm tree.  Its filename was
     fcoe-remove-redundant-less-than-zero-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Robert Love <robert.w.love@intel.com>
Subject: fcoe: Remove redundant 'less than zero' check

strtoul returns an 'unsigned long' so there is no reason to check if the
value is less than zero.

strtoul already checks for the '-' character deep in its bowels.  It will
return an error if the user has provided a negative value and
fcoe_str_to_dev_loss will return that error to its caller.

This patch fixes the following Coverity reported warning:

CID 703581 -  NO_EFFECT Unsigned compared against 0 - This
less-than-zero comparison of an unsigned value is never true. "*val < 0UL".
drivers/scsi/fcoe/fcoe_sysfs.c:105

Signed-off-by: Robert Love <robert.w.love@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/fcoe/fcoe_sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/fcoe/fcoe_sysfs.c~fcoe-remove-redundant-less-than-zero-check drivers/scsi/fcoe/fcoe_sysfs.c
--- a/drivers/scsi/fcoe/fcoe_sysfs.c~fcoe-remove-redundant-less-than-zero-check
+++ a/drivers/scsi/fcoe/fcoe_sysfs.c
@@ -102,7 +102,7 @@ static int fcoe_str_to_dev_loss(const ch
 	int ret;
 
 	ret = kstrtoul(buf, 0, val);
-	if (ret || *val < 0)
+	if (ret)
 		return -EINVAL;
 	/*
 	 * Check for overflow; dev_loss_tmo is u32
_

Patches currently in -mm which might be from robert.w.love@intel.com are

linux-next.patch

