From: akpm@linux-foundation.org
Subject: [patch 05/26] drivers/memstick/core/memstick.c: avoid -Wnonnull
 warning
Date: Tue, 24 Jan 2017 15:17:56 -0800
Message-ID: <5887e0a4.ic0zNxjmkeUo9F01%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41354 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750995AbdAXXR5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2017 18:17:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, arnd@arndb.de, oakad@yahoo.com

From: Arnd Bergmann <arnd@arndb.de>
Subject: drivers/memstick/core/memstick.c: avoid -Wnonnull warning

gcc-7 produces a harmless false-postive warning about a possible
NULL pointer access:

drivers/memstick/core/memstick.c: In function 'h_memstick_read_dev_id':
drivers/memstick/core/memstick.c:309:3: error: argument 2 null where non-null expected [-Werror=nonnull]
   memcpy(mrq->data, buf, mrq->data_len);

This can't happen because the caller sets the command to 'MS_TPC_READ_REG',
which causes the data direction to be 'READ' and the NULL pointer not
accessed.

As a simple workaround for the warning, we can pass a pointer to the
data that we actually want to read into. This is not needed here, but
also harmless, and lets the compiler know that the access is ok.

Link: http://lkml.kernel.org/r/20170111144143.548867-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/memstick.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/memstick/core/memstick.c~memstick-core-avoid-wnonnull-warning drivers/memstick/core/memstick.c
--- a/drivers/memstick/core/memstick.c~memstick-core-avoid-wnonnull-warning
+++ a/drivers/memstick/core/memstick.c
@@ -330,7 +330,7 @@ static int h_memstick_read_dev_id(struct
 	struct ms_id_register id_reg;
 
 	if (!(*mrq)) {
-		memstick_init_req(&card->current_mrq, MS_TPC_READ_REG, NULL,
+		memstick_init_req(&card->current_mrq, MS_TPC_READ_REG, &id_reg,
 				  sizeof(struct ms_id_register));
 		*mrq = &card->current_mrq;
 		return 0;
_
