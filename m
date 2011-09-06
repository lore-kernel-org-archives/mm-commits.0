From: akpm@linux-foundation.org
Subject: + cgroups-add-res-counter-common-ancestor-searching.patch added to -mm tree
Date: Tue, 06 Sep 2011 15:42:18 -0700
Message-ID: <201109062242.p86MgIpI008296@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56366 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755200Ab1IFWml (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2011 18:42:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fweisbec@gmail.com, adityakali@google.com, hannes@cmpxchg.org, kay.sievers@vrfy.org, lizf@cn.fujitsu.com, oleg@redhat.com, paul@paulmenage.org, thockin@hockin.org, tj@kernel.org


The patch titled
     cgroups: add res counter common ancestor searching
has been added to the -mm tree.  Its filename is
     cgroups-add-res-counter-common-ancestor-searching.patch

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
Subject: cgroups: add res counter common ancestor searching
From: Frederic Weisbecker <fweisbec@gmail.com>

Add a new API to find the common ancestor between two resource counters. 
This includes the passed resource counter themselves.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Aditya Kali <adityakali@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tim Hockin <thockin@hockin.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/res_counter.h |    2 ++
 kernel/res_counter.c        |   19 +++++++++++++++++++
 2 files changed, 21 insertions(+)

diff -puN include/linux/res_counter.h~cgroups-add-res-counter-common-ancestor-searching include/linux/res_counter.h
--- a/include/linux/res_counter.h~cgroups-add-res-counter-common-ancestor-searching
+++ a/include/linux/res_counter.h
@@ -146,6 +146,8 @@ static inline void res_counter_uncharge(
 	res_counter_uncharge_until(counter, NULL, val);
 }
 
+struct res_counter *res_counter_common_ancestor(struct res_counter *l, struct res_counter *r);
+
 /**
  * res_counter_margin - calculate chargeable space of a counter
  * @cnt: the counter
diff -puN kernel/res_counter.c~cgroups-add-res-counter-common-ancestor-searching kernel/res_counter.c
--- a/kernel/res_counter.c~cgroups-add-res-counter-common-ancestor-searching
+++ a/kernel/res_counter.c
@@ -92,6 +92,25 @@ void res_counter_uncharge_until(struct r
 }
 
 
+struct res_counter *
+res_counter_common_ancestor(struct res_counter *r1, struct res_counter *r2)
+{
+	struct res_counter *iter;
+
+	while (r1) {
+		iter = r2;
+		while (iter) {
+			if (iter == r1)
+				return iter;
+			iter = iter->parent;
+		}
+
+		r1 = r1->parent;
+	}
+
+	return NULL;
+}
+
 static inline unsigned long long *
 res_counter_member(struct res_counter *counter, int member)
 {
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

