From: akpm@linux-foundation.org
Subject: + cgroups-pull-up-res-counter-charge-failure-interpretation-to-caller.patch added to -mm tree
Date: Tue, 06 Sep 2011 15:42:25 -0700
Message-ID: <201109062242.p86MgQgD008316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44097 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754983Ab1IFWmn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2011 18:42:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fweisbec@gmail.com, adityakali@google.com, hannes@cmpxchg.org, kay.sievers@vrfy.org, lizf@cn.fujitsu.com, oleg@redhat.com, paul@paulmenage.org, thockin@hockin.org, tj@kernel.org


The patch titled
     cgroups: pull up res counter charge failure interpretation to caller
has been added to the -mm tree.  Its filename is
     cgroups-pull-up-res-counter-charge-failure-interpretation-to-caller.patch

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
Subject: cgroups: pull up res counter charge failure interpretation to caller
From: Frederic Weisbecker <fweisbec@gmail.com>

res_counter_charge() always returns -ENOMEM when the limit is reached and
the charge thus can't happen.

However it's up to the caller to interpret this failure and return the
appropriate error value.  The task counter subsystem will need to report
the user that a fork() has been cancelled because of some limit reached,
not because we are too short on memory.

Fix this by returning -1 when res_counter_charge() fails.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Aditya Kali <adityakali@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tim Hockin <thockin@hockin.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/res_counter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/res_counter.c~cgroups-pull-up-res-counter-charge-failure-interpretation-to-caller kernel/res_counter.c
--- a/kernel/res_counter.c~cgroups-pull-up-res-counter-charge-failure-interpretation-to-caller
+++ a/kernel/res_counter.c
@@ -26,7 +26,7 @@ int res_counter_charge_locked(struct res
 {
 	if (counter->usage + val > counter->limit) {
 		counter->failcnt++;
-		return -ENOMEM;
+		return -1;
 	}
 
 	counter->usage += val;
_

Patches currently in -mm which might be from fweisbec@gmail.com are

linux-next.patch
tracex86-add-tracepoint-to-x86-timer-interrupt-handler.patch
tracex86-add-x86-irq-vector-entry-exit-tracepoints.patch
cgroups-more-safe-tasklist-locking-in-cgroup_attach_proc.patch
cgroups-fix-ordering-of-calls-in-cgroup_attach_proc.patch
cgroups-add-res_counter_write_u64-api.patch
cgroups-new-resource-counter-inheritance-api.patch
cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks.patch
cgroups-new-cancel_attach_task-subsystem-callback.patch
cgroups-new-cancel_attach_task-subsystem-callback-fix.patch
cgroups-ability-to-stop-res-charge-propagation-on-bounded-ancestor.patch
cgroups-add-res-counter-common-ancestor-searching.patch
cgroups-add-res-counter-common-ancestor-searching-fix.patch
res_counter-allow-charge-failure-pointer-to-be-null.patch
cgroups-pull-up-res-counter-charge-failure-interpretation-to-caller.patch
cgroups-add-a-task-counter-subsystem.patch
cgroups-add-documentation-for-task-counter-subsystem.patch
cgroups-allow-subsystems-to-cancel-a-fork.patch
cgroups-convert-task-counter-to-use-the-subsys-fork-callback.patch

