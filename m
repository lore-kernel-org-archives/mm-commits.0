From: akpm@linux-foundation.org
Subject: + memstick-core-avoid-wnonnull-warning.patch added to -mm tree
Date: Wed, 11 Jan 2017 15:58:15 -0800
Message-ID: <5876c697.U/V+k0kSu120hMBy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39982 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932692AbdAKX6Q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2017 18:58:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, oakad@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/memstick/core/memstick.c: avoid -Wnonnull warning
has been added to the -mm tree.  Its filename is
     memstick-core-avoid-wnonnull-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memstick-core-avoid-wnonnull-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memstick-core-avoid-wnonnull-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from arnd@arndb.de are

memstick-core-avoid-wnonnull-warning.patch

