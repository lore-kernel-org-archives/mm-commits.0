From: akpm@linux-foundation.org
Subject: [merged] ipc-sem-explicitly-inline-check_restart.patch removed
 from -mm tree
Date: Thu, 15 Dec 2016 10:47:01 -0800
Message-ID: <5852e525.achq2grBDdnjIBlD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48822 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756255AbcLOSrC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:47:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem: explicitly inline check_restart
has been removed from the -mm tree.  Its filename was
     ipc-sem-explicitly-inline-check_restart.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: ipc/sem: explicitly inline check_restart

The compiler already does this, but make it explicit.  This helper is
really small and also used in update_queue's main loop, which is O(N^2)
scanning.  Inline and avoid the function overhead.

Link: http://lkml.kernel.org/r/1474225896-10066-5-git-send-email-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/sem.c~ipc-sem-explicitly-inline-check_restart ipc/sem.c
--- a/ipc/sem.c~ipc-sem-explicitly-inline-check_restart
+++ a/ipc/sem.c
@@ -772,7 +772,7 @@ static void unlink_queue(struct sem_arra
  * modified the array.
  * Note that wait-for-zero operations are handled without restart.
  */
-static int check_restart(struct sem_array *sma, struct sem_queue *q)
+static inline int check_restart(struct sem_array *sma, struct sem_queue *q)
 {
 	/* pending complex alter operations are too difficult to analyse */
 	if (!list_empty(&sma->pending_alter))
_

Patches currently in -mm which might be from dave@stgolabs.net are


