From: akpm@linux-foundation.org
Subject: [patch 054/114] ipc/sem: explicitly inline check_restart
Date: Wed, 14 Dec 2016 15:06:40 -0800
Message-ID: <5851d080.LWEs7Xl2IsD3sML+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34926 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753350AbcLNXH0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:07:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com

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
