From: akpm@osdl.org
Subject: + fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix-sparse-fix.patch added to -mm tree
Date: Fri, 12 Jan 2007 12:56:55 -0800
Message-ID: <200701122056.l0CKut8v028675@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:32883 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030474AbXALU6E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jan 2007 15:58:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tilman@imap.cc, suparna@in.ibm.com


The patch titled
     fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix sparse fix
has been added to the -mm tree.  Its filename is
     fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix-sparse-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

char-tty_wakeup-cleanup.patch
consolidate-line-discipline-number-definitions-v2.patch
consolidate-line-discipline-number-definitions-v2-sparc-fix.patch
consolidate-line-discipline-number-definitions-v2-fix-2.patch
fix-sparse-warnings-from-asmnet-checksumh.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix-sparse-fix.patch
