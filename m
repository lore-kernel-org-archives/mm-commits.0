From: akpm@linux-foundation.org
Subject: + cfq-iosched-do-not-leak-ioc_data-across-iosched-switches.patch added to -mm tree
Date: Mon, 07 Apr 2008 16:31:21 -0700
Message-ID: <200804072331.m37NVLEM030548@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753010AbYDGXcK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2008 19:32:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fchecconi@gmail.com, fabio@gandalf.sssup.it, jens.axboe@oracle.com


The patch titled
     cfq-iosched: do not leak ioc_data across iosched switches
has been added to the -mm tree.  Its filename is
     cfq-iosched-do-not-leak-ioc_data-across-iosched-switches.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cfq-iosched: do not leak ioc_data across iosched switches
From: Fabio Checconi <fchecconi@gmail.com>

When switching scheduler from cfq, cfq_exit_queue() does not clear
ioc->ioc_data, leaving a dangling pointer that can deceive the following
lookups when the iosched is switched back to cfq.  The pattern that can
trigger that is the following:

    - elevator switch from cfq to something else;
    - module unloading, with elv_unregister() that calls cfq_free_io_context()
      on ioc freeing the cic (via the .trim op);
    - module gets reloaded and the elevator switches back to cfq;
    - reallocation of a cic at the same address as before (with a valid key).

To fix it just assign NULL to ioc_data in __cfq_exit_single_io_context(), that
is called from the regular exit path and from the elevator switching code. 
The only path that frees a cic and is not covered is the error handling one,
but cic's freed in this way are never cached in ioc_data.

Signed-off-by: Fabio Checconi <fabio@gandalf.sssup.it>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/cfq-iosched.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN block/cfq-iosched.c~cfq-iosched-do-not-leak-ioc_data-across-iosched-switches block/cfq-iosched.c
--- a/block/cfq-iosched.c~cfq-iosched-do-not-leak-ioc_data-across-iosched-switches
+++ a/block/cfq-iosched.c
@@ -1214,6 +1214,8 @@ static void cfq_exit_cfqq(struct cfq_dat
 static void __cfq_exit_single_io_context(struct cfq_data *cfqd,
 					 struct cfq_io_context *cic)
 {
+	struct io_context *ioc = cic->ioc;
+
 	list_del_init(&cic->queue_list);
 
 	/*
@@ -1223,6 +1225,9 @@ static void __cfq_exit_single_io_context
 	cic->dead_key = (unsigned long) cic->key;
 	cic->key = NULL;
 
+	if (ioc->ioc_data == cic)
+		rcu_assign_pointer(ioc->ioc_data, NULL);
+
 	if (cic->cfqq[ASYNC]) {
 		cfq_exit_cfqq(cfqd, cic->cfqq[ASYNC]);
 		cic->cfqq[ASYNC] = NULL;
@@ -1255,7 +1260,6 @@ static void cfq_exit_single_io_context(s
  */
 static void cfq_exit_io_context(struct io_context *ioc)
 {
-	rcu_assign_pointer(ioc->ioc_data, NULL);
 	call_for_each_cic(ioc, cfq_exit_single_io_context);
 }
 
@@ -1478,8 +1482,7 @@ cfq_drop_dead_cic(struct cfq_data *cfqd,
 
 	spin_lock_irqsave(&ioc->lock, flags);
 
-	if (ioc->ioc_data == cic)
-		rcu_assign_pointer(ioc->ioc_data, NULL);
+	BUG_ON(ioc->ioc_data == cic);
 
 	radix_tree_delete(&ioc->radix_root, (unsigned long) cfqd);
 	hlist_del_rcu(&cic->cic_list);
_

Patches currently in -mm which might be from fchecconi@gmail.com are

cfq-iosched-do-not-leak-ioc_data-across-iosched-switches.patch

