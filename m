From: akpm@linux-foundation.org
Subject: [merged]
 rtc-rtc-ds1742-revert-drivers-rtc-rtc-ds1742c-remove-redundant-of_match_ptr-helper.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:38:38 -0700
Message-ID: <53ea6d3e.JNjyDDx3mJTU1X80%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f201.google.com ([209.85.213.201]:46658 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902AbaHLTij (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:38:39 -0400
Received: by mail-ig0-f201.google.com with SMTP id h3so1068952igd.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:38:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shc_work@mail.ru, a.zummo@towertech.it, sachin.kamat@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-ds1742.c: revert "drivers/rtc/rtc-ds1742.c: remove redundant of_match_ptr() helper"
has been removed from the -mm tree.  Its filename was
     rtc-rtc-ds1742-revert-drivers-rtc-rtc-ds1742c-remove-redundant-of_match_ptr-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Shiyan <shc_work@mail.ru>
Subject: drivers/rtc/rtc-ds1742.c: revert "drivers/rtc/rtc-ds1742.c: remove redundant of_match_ptr() helper"

Commit 5516f0971793a0f7d ("drivers/rtc/rtc-ds1742.c: remove redundant
of_match_ptr() helper") has description as: "'ds1742_rtc_of_match' is
always compiled in.  Hence the helper macro is not needed".

It is not true, of_match_ptr() macro makes of_device_id parameter unused
and this constant is declared with __maybe_unused attribute, so normally
this variable should be discarded by linker.  This patch revers this
commit, since there are no reason to compile of_device_id constant for
non-DT systems.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1742.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-ds1742.c~rtc-rtc-ds1742-revert-drivers-rtc-rtc-ds1742c-remove-redundant-of_match_ptr-helper drivers/rtc/rtc-ds1742.c
--- a/drivers/rtc/rtc-ds1742.c~rtc-rtc-ds1742-revert-drivers-rtc-rtc-ds1742c-remove-redundant-of_match_ptr-helper
+++ a/drivers/rtc/rtc-ds1742.c
@@ -231,7 +231,7 @@ static struct platform_driver ds1742_rtc
 	.driver		= {
 		.name	= "rtc-ds1742",
 		.owner	= THIS_MODULE,
-		.of_match_table = ds1742_rtc_of_match,
+		.of_match_table = of_match_ptr(ds1742_rtc_of_match),
 	},
 };
 
_

Patches currently in -mm which might be from shc_work@mail.ru are

origin.patch
linux-next.patch

