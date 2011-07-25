From: akpm@linux-foundation.org
Subject: + drivers-base-power-oppc-fix-dev_opp-initial-value.patch added to -mm tree
Date: Mon, 25 Jul 2011 12:34:36 -0700
Message-ID: <201107251934.p6PJYbKZ024218@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55879 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751855Ab1GYTfD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jul 2011 15:35:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jhbird.choi@samsung.com, greg@kroah.com, rjw@sisk.pl


The patch titled
     drivers/base/power/opp.c: fix dev_opp initial value
has been added to the -mm tree.  Its filename is
     drivers-base-power-oppc-fix-dev_opp-initial-value.patch

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
Subject: drivers/base/power/opp.c: fix dev_opp initial value
From: Jonghwan Choi <jhbird.choi@samsung.com>

Dev_opp initial value shoule be ERR_PTR(), IS_ERR() is used to check
error.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/power/opp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/power/opp.c~drivers-base-power-oppc-fix-dev_opp-initial-value drivers/base/power/opp.c
--- a/drivers/base/power/opp.c~drivers-base-power-oppc-fix-dev_opp-initial-value
+++ a/drivers/base/power/opp.c
@@ -453,7 +453,7 @@ int opp_add(struct device *dev, unsigned
 static int opp_set_availability(struct device *dev, unsigned long freq,
 		bool availability_req)
 {
-	struct device_opp *tmp_dev_opp, *dev_opp = NULL;
+	struct device_opp *tmp_dev_opp, *dev_opp = ERR_PTR(-ENODEV);
 	struct opp *new_opp, *tmp_opp, *opp = ERR_PTR(-ENODEV);
 	int r = 0;
 
_

Patches currently in -mm which might be from jhbird.choi@samsung.com are

origin.patch
linux-next.patch
drivers-base-power-oppc-fix-dev_opp-initial-value.patch

