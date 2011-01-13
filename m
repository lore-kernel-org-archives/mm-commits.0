From: akpm@linux-foundation.org
Subject: [merged] memstick-core-fix-device_register-error-handling.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:09:39 -0800
Message-ID: <201101132012.p0DKCKNP030284@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60412 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933763Ab1AMUUs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:20:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: segooon@gmail.com, maximlevitsky@gmail.com, oakad@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     memstick: core: fix device_register() error handling
has been removed from the -mm tree.  Its filename was
     memstick-core-fix-device_register-error-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -465,6 +465,7 @@ static void memstick_check(struct work_s
 		if (!host->card) {
 			host->card = card;
 			if (device_register(&card->dev)) {
+				put_device(&card->dev);
 				kfree(host->card);
 				host->card = NULL;
 			}
_

Patches currently in -mm which might be from segooon@gmail.com are

origin.patch
linux-next.patch

