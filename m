From: akpm@linux-foundation.org
Subject: + unify-queue_delayed_work-and-queue_delayed_work_on-fix.patch added to -mm tree
Date: Thu, 15 Feb 2007 16:28:03 -0800
Message-ID: <200702160028.l1G0S39m013677@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39988 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422858AbXBPA2P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 19:28:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, oleg@tv-sign.ru


The patch titled
     unify queue_delayed_work and queue_delayed_work_on fix
has been added to the -mm tree.  Its filename is
     unify-queue_delayed_work-and-queue_delayed_work_on-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: unify queue_delayed_work and queue_delayed_work_on fix
From: Jiri Slaby <jirislaby@gmail.com>

Since cwq->wq is unset for other than singlethread_cpu when singlethread
workqueue was created, an oops occurs during bootup. Fix it by setting
correct private value for workqueue.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/workqueue.c~unify-queue_delayed_work-and-queue_delayed_work_on-fix kernel/workqueue.c
--- a/kernel/workqueue.c~unify-queue_delayed_work-and-queue_delayed_work_on-fix
+++ a/kernel/workqueue.c
@@ -210,7 +210,8 @@ int queue_delayed_work_on(int cpu, struc
 
 		/* This stores cwq for the moment, for the timer_fn */
 		set_wq_data(work,
-			per_cpu_ptr(wq->cpu_wq, raw_smp_processor_id()));
+			per_cpu_ptr(wq->cpu_wq, wq->singlethread ?
+				singlethread_cpu : raw_smp_processor_id()));
 		timer->expires = jiffies + delay;
 		timer->data = (unsigned long)dwork;
 		timer->function = delayed_work_timer_fn;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
unify-queue_delayed_work-and-queue_delayed_work_on-fix.patch
shrink_slab-handle-bad-shrinkers.patch
