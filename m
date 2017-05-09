From: akpm@linux-foundation.org
Subject: [merged]
 time-delete-current_time_sec-and-current_time.patch removed from -mm tree
Date: Tue, 09 May 2017 11:04:16 -0700
Message-ID: <20170509180416.dga6zz5s4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35536 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751838AbdEISER (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:04:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, deepa.kernel@gmail.com, john.stultz@linaro.org, mm-commits@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: time: delete CURRENT_TIME_SEC and CURRENT_TIME
has been removed from the -mm tree.  Its filename was
     time-delete-current_time_sec-and-current_time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
