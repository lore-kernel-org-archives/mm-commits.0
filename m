From: akpm@linux-foundation.org
Subject: - rtc-make-example-code-jump-to-done-instead-of-return-when-ioctl-not-supported.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:05:32 -0700
Message-ID: <200707172305.l6HN5WIQ011929@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38280 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936432AbXGQXRr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:17:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hcegtvedt@atmel.com, a.zummo@towertech.it, david-b@pacbell.net, hskinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     rtc: make example code jump to done instead of return when ioctl not supported
has been removed from the -mm tree.  Its filename was
     rtc-make-example-code-jump-to-done-instead-of-return-when-ioctl-not-supported.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc: make example code jump to done instead of return when ioctl not supported
From: Hans-Christian Egtvedt <hcegtvedt@atmel.com>

Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/rtc.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/rtc.txt~rtc-make-example-code-jump-to-done-instead-of-return-when-ioctl-not-supported Documentation/rtc.txt
--- a/Documentation/rtc.txt~rtc-make-example-code-jump-to-done-instead-of-return-when-ioctl-not-supported
+++ a/Documentation/rtc.txt
@@ -385,7 +385,7 @@ test_PIE:
 		/* not all RTCs support periodic IRQs */
 		if (errno == ENOTTY) {
 			fprintf(stderr, "\nNo periodic IRQ support\n");
-			return 0;
+			goto done;
 		}
 		perror("RTC_IRQP_READ ioctl");
 		exit(errno);
_

Patches currently in -mm which might be from hcegtvedt@atmel.com are

origin.patch
git-watchdog.patch
