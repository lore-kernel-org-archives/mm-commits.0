From: akpm@linux-foundation.org
Subject: [merged] s390-char-use-for_each_clear_bit.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:29:18 -0700
Message-ID: <20120326192918.5CF0DA0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:63654 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab2CZT3T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:29:19 -0400
Received: by mail-ee0-f74.google.com with SMTP id c41so293886eek.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:29:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: s390/char: use for_each_clear_bit()
has been removed from the -mm tree.  Its filename was
     s390-char-use-for_each_clear_bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
ocfs2-use-find_last_bit.patch
ocfs2-use-bitmap_weight.patch
sysctl-use-bitmap-library-functions.patch

