From: akpm@linux-foundation.org
Subject: +
 rtc-rtc-ds1742-revert-drivers-rtc-rtc-ds1742c-remove-redundant-of_match_ptr-helper.patch added to -mm tree
Date: Fri, 20 Jun 2014 15:50:14 -0700
Message-ID: <53a4baa6.FCQjl7wCvji7HKEO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33346 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757574AbaFTWuP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jun 2014 18:50:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sachin.kamat@linaro.org, a.zummo@towertech.it, shc_work@mail.ru


The patch titled
     Subject: drivers/rtc/rtc-ds1742.c: revert "drivers/rtc/rtc-ds1742.c: remove redundant of_match_ptr() helper"
has been added to the -mm tree.  Its filename is
     rtc-rtc-ds1742-revert-drivers-rtc-rtc-ds1742c-remove-redundant-of_match_ptr-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-rtc-ds1742-revert-drivers-rtc-rtc-ds1742c-remove-redundant-of_match_ptr-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-rtc-ds1742-revert-drivers-rtc-rtc-ds1742c-remove-redundant-of_match_ptr-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

rtc-rtc-ds1742-revert-drivers-rtc-rtc-ds1742c-remove-redundant-of_match_ptr-helper.patch
linux-next.patch

