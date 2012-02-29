From: akpm@linux-foundation.org
Subject: + thermal-spear13xx-checking-for-null-instead-of-is_err.patch added to -mm tree
Date: Wed, 29 Feb 2012 14:30:50 -0800
Message-ID: <20120229223051.53843A0476@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:62333 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964772Ab2B2Waw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Feb 2012 17:30:52 -0500
Received: by ghbz15 with SMTP id z15so364638ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 29 Feb 2012 14:30:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.carpenter@oracle.com, lenb@kernel.org, vincenzo.frascino@st.com, viresh.kumar@st.com


The patch titled
     Subject: thermal: spear13xx: checking for NULL instead of IS_ERR()
has been added to the -mm tree.  Its filename is
     thermal-spear13xx-checking-for-null-instead-of-is_err.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: thermal: spear13xx: checking for NULL instead of IS_ERR()

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
pps-class_create-returns-an-err_ptr-not-null.patch
c2port-class_create-returns-an-err_ptr.patch
thermal-spear13xx-checking-for-null-instead-of-is_err.patch
slab-introduce-kmalloc_array.patch
mm-compaction-make-compact_control-order-signed.patch
mm-compaction-make-compact_control-order-signed-fix.patch
drivers-leds-leds-tca6507c-cleanup-error-handling-in-tca6507_probe.patch
epoll-remove-unneeded-variable-in-reverse_path_check.patch

