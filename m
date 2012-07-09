From: akpm@linux-foundation.org
Subject: + fcoe-remove-redundant-less-than-zero-check.patch added to -mm tree
Date: Mon, 09 Jul 2012 16:30:11 -0700
Message-ID: <20120709233011.9A86B1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:39171 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab2GIXaM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2012 19:30:12 -0400
Received: by vbnl22 with SMTP id l22so1254092vbn.1
        for <mm-commits@vger.kernel.org>; Mon, 09 Jul 2012 16:30:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: robert.w.love@intel.com


The patch titled
     Subject: fcoe: Remove redundant 'less than zero' check
has been added to the -mm tree.  Its filename is
     fcoe-remove-redundant-less-than-zero-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: fcoe: Remove redundant 'less than zero' check

Patches currently in -mm which might be from robert.w.love@intel.com are

linux-next.patch
fcoe-remove-redundant-less-than-zero-check.patch

