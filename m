From: akpm@google.com
Subject: + cgroups-pull-up-res-counter-charge-failure-interpretation-to-caller.patch added to -mm tree
Date: Tue, 04 Oct 2011 15:01:54 -0700
Message-ID: <201110042201.p94M1tOo007973@wpaz24.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:53070 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933049Ab1JDWCL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Oct 2011 18:02:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fweisbec@gmail.com, adityakali@google.com, hannes@cmpxchg.org, htejun@gmail.com, kay.sievers@vrfy.org, kirill@shutemov.name, lizf@cn.fujitsu.com, oleg@redhat.com, paul@paulmenage.org, thockin@hockin.org


The patch titled
     Subject: cgroups: pull up res counter charge failure interpretation to caller
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
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: cgroups: pull up res counter charge failure interpretation to caller

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
Cc: Tejun Heo <htejun@gmail.com>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 Documentation/cgroups/resource_counter.txt |    2 ++
 kernel/res_counter.c                       |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN Documentation/cgroups/resource_counter.txt~cgroups-pull-up-res-counter-charge-failure-interpretation-to-caller Documentation/cgroups/resource_counter.txt
--- a/Documentation/cgroups/resource_counter.txt~cgroups-pull-up-res-counter-charge-failure-interpretation-to-caller
+++ a/Documentation/cgroups/resource_counter.txt
@@ -76,6 +76,8 @@ to work with it.
 	limit_fail_at parameter is set to the particular res_counter element
 	where the charging failed.
 
+	It returns 0 on success and -1 on failure.
+
  d. int res_counter_charge_locked
 			(struct res_counter *rc, unsigned long val)
 
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
Subject: Subject: cgroups: pull up res counter charge failure interpretation to caller

Patches currently in -mm which might be from fweisbec@gmail.com are

origin.patch
linux-next.patch
cgroups-more-safe-tasklist-locking-in-cgroup_attach_proc.patch
cgroups-fix-ordering-of-calls-in-cgroup_attach_proc.patch
cgroups-add-res_counter_write_u64-api.patch
cgroups-new-resource-counter-inheritance-api.patch
cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks.patch
cgroups-new-cancel_attach_task-subsystem-callback.patch
cgroups-ability-to-stop-res-charge-propagation-on-bounded-ancestor.patch
cgroups-add-res-counter-common-ancestor-searching.patch
res_counter-allow-charge-failure-pointer-to-be-null.patch
cgroups-pull-up-res-counter-charge-failure-interpretation-to-caller.patch
cgroups-allow-subsystems-to-cancel-a-fork.patch
cgroups-add-a-task-counter-subsystem.patch

