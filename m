From: akpm@google.com
Subject: + cgroups-new-resource-counter-inheritance-api.patch added to -mm tree
Date: Tue, 04 Oct 2011 15:01:27 -0700
Message-ID: <201110042201.p94M1SoF026613@wpaz33.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:52691 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933049Ab1JDWBp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Oct 2011 18:01:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fweisbec@gmail.com, adityakali@google.com, hannes@cmpxchg.org, htejun@gmail.com, kay.sievers@vrfy.org, kirill@shutemov.name, lizf@cn.fujitsu.com, oleg@redhat.com, paul@paulmenage.org, thockin@hockin.org


The patch titled
     Subject: cgroups: new resource counter inheritance API
has been added to the -mm tree.  Its filename is
     cgroups-new-resource-counter-inheritance-api.patch

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
Subject: cgroups: new resource counter inheritance API

Provide an API to inherit a counter value from a parent.  This can be
useful to implement cgroup.clone_children on a resource counter.

Still the resources of the children are limited by those of the parent, so
this is only to provide a default setting behaviour when clone_children is
set.

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

 include/linux/res_counter.h |    2 ++
 kernel/res_counter.c        |   18 ++++++++++++++++++
 2 files changed, 20 insertions(+)

diff -puN include/linux/res_counter.h~cgroups-new-resource-counter-inheritance-api include/linux/res_counter.h
--- a/include/linux/res_counter.h~cgroups-new-resource-counter-inheritance-api
+++ a/include/linux/res_counter.h
@@ -84,6 +84,8 @@ int res_counter_write(struct res_counter
 
 void res_counter_write_u64(struct res_counter *counter, int member, u64 val);
 
+void res_counter_inherit(struct res_counter *counter, int member);
+
 /*
  * the field descriptors. one for each member of res_counter
  */
diff -puN kernel/res_counter.c~cgroups-new-resource-counter-inheritance-api kernel/res_counter.c
--- a/kernel/res_counter.c~cgroups-new-resource-counter-inheritance-api
+++ a/kernel/res_counter.c
@@ -202,3 +202,21 @@ int res_counter_write(struct res_counter
 
 	return 0;
 }
+
+/*
+ * Simple inheritance implementation to get the same value
+ * than a parent. However this doesn't enforce the child value
+ * to be always below the one of the parent. But the child is
+ * subject to its parent limitation anyway.
+ */
+void res_counter_inherit(struct res_counter *counter, int member)
+{
+	struct res_counter *parent;
+	unsigned long long val;
+
+	parent = counter->parent;
+	if (parent) {
+		val = res_counter_read_u64(parent, member);
+		res_counter_write_u64(counter, member, val);
+	}
+}
_
Subject: Subject: cgroups: new resource counter inheritance API

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

