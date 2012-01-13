From: akpm@linux-foundation.org
Subject: + s390-char-use-for_each_clear_bit.patch added to -mm tree
Date: Fri, 13 Jan 2012 14:56:18 -0800
Message-ID: <20120113225619.2B34E1E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:33463 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932966Ab2AMW4U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 17:56:20 -0500
Received: by ggnk3 with SMTP id k3so368945ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 14:56:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com


The patch titled
     Subject: s390/char: use for_each_clear_bit()
has been added to the -mm tree.  Its filename is
     s390-char-use-for_each_clear_bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: s390/char: use for_each_clear_bit()

Use for_each_clear_bit() to iterate over all the cleared bit in a
memory region.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/char/sclp_cmd.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/s390/char/sclp_cmd.c~s390-char-use-for_each_clear_bit drivers/s390/char/sclp_cmd.c
--- a/drivers/s390/char/sclp_cmd.c~s390-char-use-for_each_clear_bit
+++ a/drivers/s390/char/sclp_cmd.c
@@ -441,9 +441,8 @@ static int sclp_mem_notifier(struct noti
 	start = arg->start_pfn << PAGE_SHIFT;
 	size = arg->nr_pages << PAGE_SHIFT;
 	mutex_lock(&sclp_mem_mutex);
-	for (id = 0; id <= sclp_max_storage_id; id++)
-		if (!test_bit(id, sclp_storage_ids))
-			sclp_attach_storage(id);
+	for_each_clear_bit(id, sclp_storage_ids, sclp_max_storage_id + 1)
+		sclp_attach_storage(id);
 	switch (action) {
 	case MEM_ONLINE:
 	case MEM_GOING_OFFLINE:
_
Subject: Subject: s390/char: use for_each_clear_bit()

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
bitops-rename-for_each_set_bit_cont-in-favor-of-analogous-listh-function.patch
bitops-remove-for_each_set_bit_cont.patch
bitops-introduce-for_each_clear_bit.patch
mtd-use-for_each_clear_bit.patch
s390-char-use-for_each_clear_bit.patch
uwb-use-for_each_clear_bit.patch
x86-use-for_each_clear_bit_from.patch

