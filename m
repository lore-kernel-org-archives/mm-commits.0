From: akpm@linux-foundation.org
Subject: [merged] rtc-da9052-add-constraints-to-set-valid-year.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:17:52 -0700
Message-ID: <553550e0.11gxn3Uxdi/QbcJR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40189 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbbDTTLb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:11:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adam.ward.opensource@diasemi.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-da9052.c: add constraints to set valid year
has been removed from the -mm tree.  Its filename was
     rtc-da9052-add-constraints-to-set-valid-year.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Adam Ward <adam.ward.opensource@diasemi.com>
Subject: drivers/rtc/rtc-da9052.c: add constraints to set valid year

Signed-off-by: Adam Ward <adam.ward.opensource@diasemi.com>
Tested-by: Adam Ward <adam.ward.opensource@diasemi.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-da9052.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/rtc/rtc-da9052.c~rtc-da9052-add-constraints-to-set-valid-year drivers/rtc/rtc-da9052.c
--- a/drivers/rtc/rtc-da9052.c~rtc-da9052-add-constraints-to-set-valid-year
+++ a/drivers/rtc/rtc-da9052.c
@@ -206,6 +206,10 @@ static int da9052_rtc_set_time(struct de
 	uint8_t v[6];
 	int ret;
 
+	/* DA9052 only has 6 bits for year - to represent 2000-2063 */
+	if ((tm->tm_year < 100) || (tm->tm_year > 163))
+		return -EINVAL;
+
 	rtc = dev_get_drvdata(dev);
 
 	v[0] = tm->tm_sec;
@@ -243,6 +247,10 @@ static int da9052_rtc_set_alarm(struct d
 	struct rtc_time *tm = &alrm->time;
 	struct da9052_rtc *rtc = dev_get_drvdata(dev);
 
+	/* DA9052 only has 6 bits for year - to represent 2000-2063 */
+	if ((tm->tm_year < 100) || (tm->tm_year > 163))
+		return -EINVAL;
+
 	ret = da9052_rtc_enable_alarm(rtc, 0);
 	if (ret < 0)
 		return ret;
_

Patches currently in -mm which might be from adam.ward.opensource@diasemi.com are

origin.patch

