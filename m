From: akpm@linux-foundation.org
Subject: [patch 34/78] ipc/mqueue: add missing sparse annotation
Date: Mon, 27 Feb 2017 14:28:21 -0800
Message-ID: <58b4a805.bhPnPPsrYtjEy2KR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45908 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751834AbdB0Wzy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:55:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, luc.vanoostenryck@gmail.com

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
