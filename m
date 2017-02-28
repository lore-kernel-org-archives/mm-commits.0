From: akpm@linux-foundation.org
Subject: [merged] ipc-mqueue-add-missing-sparse-annotation.patch removed
 from -mm tree
Date: Tue, 28 Feb 2017 12:50:48 -0800
Message-ID: <58b5e2a8.kjcou8vzSlGX/WpV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52712 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751829AbdB1Uve (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 15:51:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luc.vanoostenryck@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/mqueue: add missing sparse annotation
has been removed from the -mm tree.  Its filename was
     ipc-mqueue-add-missing-sparse-annotation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: ipc/mqueue: add missing sparse annotation

Link: http://lkml.kernel.org/r/20170128235704.45302-1-luc.vanoostenryck@gmail.com
Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN ipc/mqueue.c~ipc-mqueue-add-missing-sparse-annotation ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-mqueue-add-missing-sparse-annotation
+++ a/ipc/mqueue.c
@@ -558,6 +558,7 @@ static void wq_add(struct mqueue_inode_i
  */
 static int wq_sleep(struct mqueue_inode_info *info, int sr,
 		    ktime_t *timeout, struct ext_wait_queue *ewp)
+	__releases(&info->lock)
 {
 	int retval;
 	signed long time;
_

Patches currently in -mm which might be from luc.vanoostenryck@gmail.com are


