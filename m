From: akpm@google.com
Subject: + cgroups-add-res-counter-common-ancestor-searching.patch added to -mm tree
Date: Tue, 04 Oct 2011 15:01:46 -0700
Message-ID: <201110042201.p94M1lZ2030133@wpaz17.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:3439 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933049Ab1JDWCA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Oct 2011 18:02:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill@shutemov.name, adityakali@google.com, fweisbec@gmail.com, hannes@cmpxchg.org, htejun@gmail.com, kay.sievers@vrfy.org, lizf@cn.fujitsu.com, oleg@redhat.com, paul@paulmenage.org, thockin@hockin.org


The patch titled
     Subject: cgroups: add res counter common ancestor searching
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
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: cgroups: add res counter common ancestor searching

Add a new API to find the common ancestor between two resource counters. 
This includes the passed resource counter themselves.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Aditya Kali <adityakali@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tim Hockin <thockin@hockin.org>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 include/linux/res_counter.h |    3 +++
 kernel/res_counter.c        |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff -puN include/linux/res_counter.h~cgroups-add-res-counter-common-ancestor-searching include/linux/res_counter.h
--- a/include/linux/res_counter.h~cgroups-add-res-counter-common-ancestor-searching
+++ a/include/linux/res_counter.h
@@ -147,6 +147,9 @@ static inline void res_counter_uncharge(
 	res_counter_uncharge_until(counter, NULL, val);
 }
 
+struct res_counter *res_counter_common_ancestor(struct res_counter *l,
+						struct res_counter *r);
+
 /**
  * res_counter_margin - calculate chargeable space of a counter
  * @cnt: the counter
diff -puN kernel/res_counter.c~cgroups-add-res-counter-common-ancestor-searching kernel/res_counter.c
--- a/kernel/res_counter.c~cgroups-add-res-counter-common-ancestor-searching
+++ a/kernel/res_counter.c
@@ -91,6 +91,39 @@ void res_counter_uncharge_until(struct r
 	local_irq_restore(flags);
 }
 
+/*
+ * Walk through r1 and r2 parents and try to find the closest common one
+ * between both. If none is found, it returns NULL.
+ */
+struct res_counter *
+res_counter_common_ancestor(struct res_counter *r1, struct res_counter *r2)
+{
+	struct res_counter *iter;
+	int r1_depth = 0, r2_depth = 0;
+
+	for (iter = r1; iter; iter = iter->parent)
+		r1_depth++;
+
+	for (iter = r2; iter; iter = iter->parent)
+		r2_depth++;
+
+	while (r1_depth > r2_depth) {
+		r1 = r1->parent;
+		r1_depth--;
+	}
+
+	while (r2_depth > r1_depth) {
+		r2 = r2->parent;
+		r2_depth--;
+	}
+
+	while (r1 != r2) {
+		r1 = r1->parent;
+		r2 = r2->parent;
+	}
+
+	return r1;
+}
 
 static inline unsigned long long *
 res_counter_member(struct res_counter *counter, int member)
_
Subject: Subject: cgroups: add res counter common ancestor searching

Patches currently in -mm which might be from kirill@shutemov.name are

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

