From: akpm@linux-foundation.org
Subject: [obsolete] cgroups-new-resource-counter-inheritance-api.patch removed from -mm tree
Date: Wed, 14 Dec 2011 12:06:19 -0800
Message-ID: <20111214200620.18B9E10004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:54510 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab1LNUGV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2011 15:06:21 -0500
Received: by yenm5 with SMTP id m5so135066yen.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Dec 2011 12:06:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fweisbec@gmail.com, adityakali@google.com, hannes@cmpxchg.org, htejun@gmail.com, kay.sievers@vrfy.org, kirill@shutemov.name, lizf@cn.fujitsu.com, oleg@redhat.com, paul@paulmenage.org, thockin@hockin.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroups: new resource counter inheritance API
has been removed from the -mm tree.  Its filename was
     cgroups-new-resource-counter-inheritance-api.patch

This patch was dropped because it is obsolete

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

Patches currently in -mm which might be from fweisbec@gmail.com are

linux-next.patch
reiserfs-delay-reiserfs-lock-until-journal-initialization.patch
reiserfs-dont-lock-journal_init.patch
reiserfs-dont-lock-root-inode-searching.patch
cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks.patch
cgroups-new-cancel_attach_task-subsystem-callback.patch
cgroups-ability-to-stop-res-charge-propagation-on-bounded-ancestor.patch
cgroups-add-res-counter-common-ancestor-searching.patch
res_counter-allow-charge-failure-pointer-to-be-null.patch
cgroups-pull-up-res-counter-charge-failure-interpretation-to-caller.patch
cgroups-allow-subsystems-to-cancel-a-fork.patch
cgroups-add-a-task-counter-subsystem.patch
cgroups-add-a-task-counter-subsystem-fix.patch
cgroup-fix-task-counter-common-ancestor-logic.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch
selftests-new-very-basic-kernel-selftests-directory.patch
selftests-new-x86-breakpoints-selftest.patch

