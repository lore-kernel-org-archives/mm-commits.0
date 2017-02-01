From: akpm@linux-foundation.org
Subject: + ipc-mqueue-add-missing-sparse-annotation.patch added to -mm
 tree
Date: Wed, 01 Feb 2017 14:23:57 -0800
Message-ID: <58925ffd.HWDbJJGxRL95ENSg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42236 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752974AbdBAWX6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Feb 2017 17:23:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luc.vanoostenryck@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/mqueue: add missing sparse annotation
has been added to the -mm tree.  Its filename is
     ipc-mqueue-add-missing-sparse-annotation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-mqueue-add-missing-sparse-annotation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-mqueue-add-missing-sparse-annotation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ipc-mqueue-add-missing-sparse-annotation.patch

