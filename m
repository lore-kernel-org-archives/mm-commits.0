From: akpm@linux-foundation.org
Subject: [merged] thermal-spear13xx-checking-for-null-instead-of-is_err.patch removed from -mm tree
Date: Fri, 23 Mar 2012 11:22:51 -0700
Message-ID: <20120323182251.68607A02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:60973 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759202Ab2CWSWx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 14:22:53 -0400
Received: by eekc41 with SMTP id c41so186983eek.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 11:22:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, lenb@kernel.org, vincenzo.frascino@st.com, viresh.kumar@st.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thermal: spear13xx: checking for NULL instead of IS_ERR()
has been removed from the -mm tree.  Its filename was
     thermal-spear13xx-checking-for-null-instead-of-is_err.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: thermal: spear13xx: checking for NULL instead of IS_ERR()

thermal_zone_device_register() never returns NULL, on error it returns and
ERR_PTR().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Viresh Kumar <viresh.kumar@st.com>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@st.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/spear_thermal.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/thermal/spear_thermal.c~thermal-spear13xx-checking-for-null-instead-of-is_err drivers/thermal/spear_thermal.c
--- a/drivers/thermal/spear_thermal.c~thermal-spear13xx-checking-for-null-instead-of-is_err
+++ a/drivers/thermal/spear_thermal.c
@@ -149,9 +149,9 @@ static int spear_thermal_probe(struct pl
 
 	spear_thermal = thermal_zone_device_register("spear_thermal", 0,
 				stdev, &ops, 0, 0, 0, 0);
-	if (!spear_thermal) {
+	if (IS_ERR(spear_thermal)) {
 		dev_err(&pdev->dev, "thermal zone device is NULL\n");
-		ret = -EINVAL;
+		ret = PTR_ERR(spear_thermal);
 		goto disable_clk;
 	}
 
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
backlight-lp855x_bl-silence-a-compiler-warning.patch
drivers-leds-leds-tca6507c-cleanup-error-handling-in-tca6507_probe.patch
epoll-remove-unneeded-variable-in-reverse_path_check.patch

