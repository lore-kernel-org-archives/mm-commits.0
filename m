From: akpm@linux-foundation.org
Subject: + aoe-dont-use-flush_scheduled_work.patch added to -mm tree
Date: Fri, 22 Oct 2010 13:06:41 -0700
Message-ID: <201010222006.o9MK6fbE004961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56997 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755842Ab0JVUHR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Oct 2010 16:07:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, axboe@kernel.dk, ecashin@coraid.com


The patch titled
     aoe: don't use flush_scheduled_work()
has been added to the -mm tree.  Its filename is
     aoe-dont-use-flush_scheduled_work.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aoe: don't use flush_scheduled_work()
From: Tejun Heo <tj@kernel.org>

flush_scheduled_work() is deprecated and scheduled to be removed. 
Directly cancel aoedev->work on free instead of depending on
flush_scheduled_works().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: "Ed L. Cashin" <ecashin@coraid.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoedev.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/block/aoe/aoedev.c~aoe-dont-use-flush_scheduled_work drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-dont-use-flush_scheduled_work
+++ a/drivers/block/aoe/aoedev.c
@@ -102,6 +102,7 @@ aoedev_freedev(struct aoedev *d)
 {
 	struct aoetgt **t, **e;
 
+	cancel_work_sync(&d->work);
 	if (d->gd) {
 		aoedisk_rm_sysfs(d);
 		del_gendisk(d->gd);
@@ -135,7 +136,6 @@ aoedev_flush(const char __user *str, siz
 		all = !strncmp(buf, "all", 3);
 	}
 
-	flush_scheduled_work();
 	spin_lock_irqsave(&devlist_lock, flags);
 	dd = &devlist;
 	while ((d = *dd)) {
@@ -257,8 +257,6 @@ aoedev_exit(void)
 	struct aoedev *d;
 	ulong flags;
 
-	flush_scheduled_work();
-
 	while ((d = devlist)) {
 		devlist = d->next;
 
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
percpu-fix-list_head-init-bug-in-__percpu_counter_init.patch
linux-next.patch
isdn-capi-unregister-capictr-notifier-after-init-failure.patch
isdn-capi-make-kcapi-use-a-separate-workqueue.patch
aoe-dont-use-flush_scheduled_work.patch
stop_machine-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
percpu_counter-add-debugobj-support.patch
percpu_counter-use-this_cpu_ptr-instead-of-per_cpu_ptr.patch
pps-trivial-fixes.patch
pps-declare-variables-where-they-are-used-in-switch.patch
pps-fix-race-in-pps_fetch-handler.patch
pps-unify-timestamp-gathering.patch
pps-access-pps-device-by-direct-pointer.patch
pps-convert-printk-pr_-to-dev_.patch
pps-move-idr-stuff-to-ppsc.patch
pps-add-async-pps-event-handler.patch
pps-add-async-pps-event-handler-fix.patch
pps-dont-disable-interrupts-when-using-spin-locks.patch
pps-use-bug_on-for-kernel-api-safety-checks.patch
pps-simplify-conditions-a-bit.patch
ntp-add-hardpps-implementation.patch
pps-capture-monotonic_raw-timestamps-as-well.patch
pps-add-kernel-consumer-support.patch
pps-add-parallel-port-pps-client.patch
pps-add-parallel-port-pps-signal-generator.patch

