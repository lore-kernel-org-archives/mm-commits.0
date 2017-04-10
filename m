From: akpm@linux-foundation.org
Subject: + time-delete-current_time_sec-and-current_time.patch added to
 -mm tree
Date: Mon, 10 Apr 2017 15:34:37 -0700
Message-ID: <58ec087d.U5GdBoM8CAWbeHNM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60554 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752369AbdDJWei (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Apr 2017 18:34:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deepa.kernel@gmail.com, arnd@arndb.de, john.stultz@linaro.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: time: delete CURRENT_TIME_SEC and CURRENT_TIME
has been added to the -mm tree.  Its filename is
     time-delete-current_time_sec-and-current_time.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/time-delete-current_time_sec-and-current_time.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/time-delete-current_time_sec-and-current_time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: time: delete CURRENT_TIME_SEC and CURRENT_TIME

All uses of CURRENT_TIME_SEC and CURRENT_TIME macros have been replaced by
other time functions.  These macros are also not y2038 safe.  And, all
their use cases can be fulfilled by y2038 safe ktime_get_* variants.

Link: http://lkml.kernel.org/r/1491613030-11599-12-git-send-email-deepa.kernel@gmail.com
Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/time.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN include/linux/time.h~time-delete-current_time_sec-and-current_time include/linux/time.h
--- a/include/linux/time.h~time-delete-current_time_sec-and-current_time
+++ a/include/linux/time.h
@@ -151,9 +151,6 @@ static inline bool timespec_inject_offse
 	return true;
 }
 
-#define CURRENT_TIME		(current_kernel_time())
-#define CURRENT_TIME_SEC	((struct timespec) { get_seconds(), 0 })
