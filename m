From: akpm@linux-foundation.org
Subject: - fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix-sparse-fix.patch removed from -mm tree
Date: Wed, 09 May 2007 03:04:44 -0700
Message-ID: <200705091004.l49A4iav020777@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755090AbXEIKFZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 06:05:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tilman@imap.cc, suparna@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix sparse fix
has been removed from the -mm tree.  Its filename was
     fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix-sparse-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix sparse fix
From: Tilman Schmidt <tilman@imap.cc>

Cc: Suparna Bhattacharya <suparna@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/aio.h |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff -puN include/linux/aio.h~fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix-sparse-fix include/linux/aio.h
--- a/include/linux/aio.h~fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix-sparse-fix
+++ a/include/linux/aio.h
@@ -237,9 +237,14 @@ do {									\
 	}								\
 } while (0)
 
-#define io_wait_to_kiocb(io_wait) container_of(container_of(io_wait,	\
-	struct wait_bit_queue, wait), struct kiocb, ki_wait)
+static inline struct kiocb *io_wait_to_kiocb(wait_queue_t *io_wait)
+{
+	struct wait_bit_queue *wbqptr;
 
+	wbqptr = container_of(io_wait, struct wait_bit_queue, wait);
+	return container_of(wbqptr, struct kiocb, ki_wait);
+}
+
 #include <linux/aio_abi.h>
 
 static inline struct kiocb *list_kiocb(struct list_head *h)
_

Patches currently in -mm which might be from tilman@imap.cc are

origin.patch
remove-obsolete-label-from-isdn4linux-v3.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix-sparse-fix.patch
