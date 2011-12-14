From: akpm@linux-foundation.org
Subject: [obsolete] cgroups-add-res-counter-common-ancestor-searching.patch removed from -mm tree
Date: Wed, 14 Dec 2011 12:06:31 -0800
Message-ID: <20111214200632.1B6EA10004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:55233 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab1LNUGd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2011 15:06:33 -0500
Received: by yhjj51 with SMTP id j51so241097yhj.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Dec 2011 12:06:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, adityakali@google.com, fweisbec@gmail.com, hannes@cmpxchg.org, htejun@gmail.com, kay.sievers@vrfy.org, lizf@cn.fujitsu.com, oleg@redhat.com, paul@paulmenage.org, thockin@hockin.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroups: add res counter common ancestor searching
has been removed from the -mm tree.  Its filename was
     cgroups-add-res-counter-common-ancestor-searching.patch

This patch was dropped because it is obsolete

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

Patches currently in -mm which might be from kirill@shutemov.name are

linux-next.patch
res_counter-allow-charge-failure-pointer-to-be-null.patch
cgroups-pull-up-res-counter-charge-failure-interpretation-to-caller.patch
cgroups-allow-subsystems-to-cancel-a-fork.patch
cgroups-add-a-task-counter-subsystem.patch
mm-memcg-consolidate-hierarchy-iteration-primitives.patch
mm-vmscan-distinguish-global-reclaim-from-global-lru-scanning.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
mm-memcg-per-priority-per-zone-hierarchy-scan-generations.patch
mm-move-memcg-hierarchy-reclaim-to-generic-reclaim-code.patch
mm-memcg-remove-optimization-of-keeping-the-root_mem_cgroup-lru-lists-empty.patch
mm-vmscan-convert-global-reclaim-to-per-memcg-lru-lists.patch
mm-collect-lru-list-heads-into-struct-lruvec.patch
mm-make-per-memcg-lru-lists-exclusive.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags-fix.patch
procfs-make-proc_get_link-to-use-dentry-instead-of-inode.patch
procfs-introduce-the-proc-pid-map_files-directory.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch

