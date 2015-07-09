From: akpm@linux-foundation.org
Subject: +
 ipc-modify-message-queue-accounting-to-not-take-kernel-data-structures-into-account.patch added to -mm tree
Date: Thu, 09 Jul 2015 14:48:10 -0700
Message-ID: <559eec1a.AadPiK9O8S4WdiWz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52879 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbbGIVsL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 17:48:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: redmnic@gmail.com, arto@bendiken.net, dbueso@suse.de, dhowells@redhat.com, dledford@redhat.com, jb_duffy@btinternet.com, mtk.manpages@gmail.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: modify message queue accounting to not take kernel data structures into account
has been added to the -mm tree.  Its filename is
     ipc-modify-message-queue-accounting-to-not-take-kernel-data-structures-into-account.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-modify-message-queue-accounting-to-not-take-kernel-data-structures-into-account.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-modify-message-queue-accounting-to-not-take-kernel-data-structures-into-account.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marcus Gelderie <redmnic@gmail.com>
Subject: ipc: modify message queue accounting to not take kernel data structures into account

A while back, the message queue implementation in the kernel was improved
to use btrees to speed up retrieval of messages, in
d6629859b36("ipc/mqueue: improve performance of send/recv").  The patch
introducing the improved kernel handling of message queues (using btrees)
has, as a by-product, changed the meaning of the QSIZE field in the
pseudo-file created for the queue.  Before, this field reflected the size
of the user-data in the queue.  Since, it also takes kernel data
structures into account.  For example, if 13 bytes of user data are in the
queue, on my machine the file reports a size of 61 bytes.

There was some discussion on this topic before (for example
https://lkml.org/lkml/2014/10/1/115).  Commenting on a th lkml, Michael
Kerrisk gave the following background
(https://lkml.org/lkml/2015/6/16/74):

    The pseudofiles in the mqueue filesystem (usually mounted at
    /dev/mqueue) expose fields with metadata describing a message
    queue. One of these fields, QSIZE, as originally implemented,
    showed the total number of bytes of user data in all messages in
    the message queue, and this feature was documented from the
    beginning in the mq_overview(7) page. In 3.5, some other (useful)
    work happened to break the user-space API in a couple of places,
    including the value exposed via QSIZE, which now includes a measure
    of kernel overhead bytes for the queue, a figure that renders QSIZE
    useless for its original purpose, since there's no way to deduce
    the number of overhead bytes consumed by the implementation.
    (The other user-space breakage was subsequently fixed.)

This patch removes the accounting of kernel data structures in the queue. 
Reporting the size of these data-structures in the QSIZE field was a
breaking change (see Michael's comment above).  Without the QSIZE field
reporting the total size of user-data in the queue, there is no way to
deduce this number.

It should be noted that the resource limit RLIMIT_MSGQUEUE is counted
against the worst-case size of the queue (in both the old and the new
implementation).  Therefore, the kernel overhead accounting in QSIZE is
not necessary to help the user understand the limitations RLIMIT imposes
on the processes.

Signed-off-by: Marcus Gelderie <redmnic@gmail.com>
Acked-by: Doug Ledford <dledford@redhat.com>
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: David Howells <dhowells@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: John Duffy <jb_duffy@btinternet.com>
Cc: Arto Bendiken <arto@bendiken.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN ipc/mqueue.c~ipc-modify-message-queue-accounting-to-not-take-kernel-data-structures-into-account ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-modify-message-queue-accounting-to-not-take-kernel-data-structures-into-account
+++ a/ipc/mqueue.c
@@ -142,7 +142,6 @@ static int msg_insert(struct msg_msg *ms
 		if (!leaf)
 			return -ENOMEM;
 		INIT_LIST_HEAD(&leaf->msg_list);
-		info->qsize += sizeof(*leaf);
 	}
 	leaf->priority = msg->m_type;
 	rb_link_node(&leaf->rb_node, parent, p);
@@ -187,7 +186,6 @@ try_again:
 			     "lazy leaf delete!\n");
 		rb_erase(&leaf->rb_node, &info->msg_tree);
 		if (info->node_cache) {
-			info->qsize -= sizeof(*leaf);
 			kfree(leaf);
 		} else {
 			info->node_cache = leaf;
@@ -200,7 +198,6 @@ try_again:
 		if (list_empty(&leaf->msg_list)) {
 			rb_erase(&leaf->rb_node, &info->msg_tree);
 			if (info->node_cache) {
-				info->qsize -= sizeof(*leaf);
 				kfree(leaf);
 			} else {
 				info->node_cache = leaf;
@@ -1034,7 +1031,6 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqd
 		/* Save our speculative allocation into the cache */
 		INIT_LIST_HEAD(&new_leaf->msg_list);
 		info->node_cache = new_leaf;
-		info->qsize += sizeof(*new_leaf);
 		new_leaf = NULL;
 	} else {
 		kfree(new_leaf);
@@ -1142,7 +1138,6 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t,
 		/* Save our speculative allocation into the cache */
 		INIT_LIST_HEAD(&new_leaf->msg_list);
 		info->node_cache = new_leaf;
-		info->qsize += sizeof(*new_leaf);
 	} else {
 		kfree(new_leaf);
 	}
_

Patches currently in -mm which might be from redmnic@gmail.com are

ipc-modify-message-queue-accounting-to-not-take-kernel-data-structures-into-account.patch

