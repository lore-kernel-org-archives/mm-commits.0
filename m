From: akpm@linux-foundation.org
Subject: [merged] ipc-msgc-use-list_for_each_entry_-for-list-traversing.patch removed from -mm tree
Date: Tue, 07 May 2013 10:52:30 -0700
Message-ID: <20130507175230.7B27E5A4111@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:58500 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759620Ab3EGRwb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:52:31 -0400
Received: by mail-yh0-f74.google.com with SMTP id t59so86621yho.1
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:52:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npajkovs@redhat.com, ebiederm@xmission.com, peter@hurleysoftware.com, skinsbursky@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/msg.c: use list_for_each_entry_[safe] for list traversing
has been removed from the -mm tree.  Its filename was
     ipc-msgc-use-list_for_each_entry_-for-list-traversing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nikola Pajkovsky <npajkovs@redhat.com>
Subject: ipc/msg.c: use list_for_each_entry_[safe] for list traversing

The ipc/msg.c code does its list operations by hand and it open-codes the
accesses, instead of using for_each_entry_[safe].

Signed-off-by: Nikola Pajkovsky <npajkovs@redhat.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |   35 ++++++++---------------------------
 1 file changed, 8 insertions(+), 27 deletions(-)

diff -puN ipc/msg.c~ipc-msgc-use-list_for_each_entry_-for-list-traversing ipc/msg.c
--- a/ipc/msg.c~ipc-msgc-use-list_for_each_entry_-for-list-traversing
+++ a/ipc/msg.c
@@ -238,14 +238,9 @@ static inline void ss_del(struct msg_sen
 
 static void ss_wakeup(struct list_head *h, int kill)
 {
-	struct list_head *tmp;
+	struct msg_sender *mss, *t;
 
-	tmp = h->next;
-	while (tmp != h) {
-		struct msg_sender *mss;
-
-		mss = list_entry(tmp, struct msg_sender, list);
-		tmp = tmp->next;
+	list_for_each_entry_safe(mss, t, h, list) {
 		if (kill)
 			mss->list.next = NULL;
 		wake_up_process(mss->tsk);
@@ -254,14 +249,9 @@ static void ss_wakeup(struct list_head *
 
 static void expunge_all(struct msg_queue *msq, int res)
 {
-	struct list_head *tmp;
-
-	tmp = msq->q_receivers.next;
-	while (tmp != &msq->q_receivers) {
-		struct msg_receiver *msr;
+	struct msg_receiver *msr, *t;
 
-		msr = list_entry(tmp, struct msg_receiver, r_list);
-		tmp = tmp->next;
+	list_for_each_entry_safe(msr, t, &msq->q_receivers, r_list) {
 		msr->r_msg = NULL;
 		wake_up_process(msr->r_tsk);
 		smp_mb();
@@ -279,7 +269,7 @@ static void expunge_all(struct msg_queue
  */
 static void freeque(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 {
-	struct list_head *tmp;
+	struct msg_msg *msg, *t;
 	struct msg_queue *msq = container_of(ipcp, struct msg_queue, q_perm);
 
 	expunge_all(msq, -EIDRM);
@@ -287,11 +277,7 @@ static void freeque(struct ipc_namespace
 	msg_rmid(ns, msq);
 	msg_unlock(msq);
 
-	tmp = msq->q_messages.next;
-	while (tmp != &msq->q_messages) {
-		struct msg_msg *msg = list_entry(tmp, struct msg_msg, m_list);
-
-		tmp = tmp->next;
+	list_for_each_entry_safe(msg, t, &msq->q_messages, m_list) {
 		atomic_dec(&ns->msg_hdrs);
 		free_msg(msg);
 	}
@@ -604,14 +590,9 @@ static int testmsg(struct msg_msg *msg, 
 
 static inline int pipelined_send(struct msg_queue *msq, struct msg_msg *msg)
 {
-	struct list_head *tmp;
