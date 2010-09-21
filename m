From: akpm@linux-foundation.org
Subject: + memstick-core-fix-device_register-error-handling.patch added to -mm tree
Date: Tue, 21 Sep 2010 15:20:37 -0700
Message-ID: <201009212220.o8LMKbq3005888@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757712Ab0IUWUj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 18:20:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segooon@gmail.com, maximlevitsky@gmail.com, oakad@yahoo.com


The patch titled
     memstick: core: fix device_register() error handling
has been added to the -mm tree.  Its filename is
     memstick-core-fix-device_register-error-handling.patch

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
Subject: memstick: core: fix device_register() error handling
From: Vasiliy Kulikov <segooon@gmail.com>

If device_register() fails then call put_device().  See comment to
device_register.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/memstick.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/memstick/core/memstick.c~memstick-core-fix-device_register-error-handling drivers/memstick/core/memstick.c
--- a/drivers/memstick/core/memstick.c~memstick-core-fix-device_register-error-handling
+++ a/drivers/memstick/core/memstick.c
@@ -574,6 +574,7 @@ static void memstick_check(struct work_s
 		if (!host->card) {
 			host->card = card;
 			if (device_register(&card->dev)) {
+				put_device(&card->dev);
 				kfree(host->card);
 				host->card = NULL;
 			}
_

Patches currently in -mm which might be from segooon@gmail.com are

linux-next.patch
md-check-return-code-of-read_sb_page.patch
mm-mempolicy-check-return-code-of-check_range.patch
memstick-core-fix-device_register-error-handling.patch

