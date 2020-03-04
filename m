From: akpm@linux-foundation.org
Subject: [folded-merged]
 loop-use-worker-per-cgroup-instead-of-kworker-fix-2.patch removed from -mm
 tree
Date: Tue, 03 Mar 2020 16:25:24 -0800
Message-ID: <20200304002524.656DImyv1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727865AbgCDAZ2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Mar 2020 19:25:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axboe@kernel.dk, chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org, hughd@google.com, lizefan@huawei.com, mhocko@kernel.org, mm-commits@vger.kernel.org, schatzberg.dan@gmail.com, shakeelb@google.com, tglx@linutronix.de, tj@kernel.org, vdavydov.dev@gmail.com, yang.shi@linux.alibaba.com


The patch titled
     Subject: loop: fix irq lock ordering bug
has been removed from the -mm tree.  Its filename was
     loop-use-worker-per-cgroup-instead-of-kworker-fix-2.patch

This patch was dropped because it was folded into loop-use-worker-per-cgroup-instead-of-kworker.patch

------------------------------------------------------
From: Dan Schatzberg <schatzberg.dan@gmail.com>
Subject: loop: fix irq lock ordering bug

"loop: Use worker per cgroup instead of kworker" in patch series "Charge
loop device i/o to issuing cgroup", v3.  introduced a lock ordering bug. 
The previously existing lo->lo_lock was always acquired as spin_lock_irq
but never actually used in irq context.  The above patch started to use
this lock in irq context which triggered a lockdep warning on sysfs
reading.

Fix this by executing file_path outside of the lock.

Link: http://lkml.kernel.org/r/20200228161847.28107-1-schatzberg.dan@gmail.com
Signed-off-by: Dan Schatzberg <schatzberg.dan@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/block/loop.c~loop-use-worker-per-cgroup-instead-of-kworker-fix-2
+++ a/drivers/block/loop.c
@@ -776,12 +776,18 @@ static ssize_t loop_attr_backing_file_sh
 {
 	ssize_t ret;
 	char *p = NULL;
+	struct file *filp = NULL;
 
 	spin_lock_irq(&lo->lo_lock);
 	if (lo->lo_backing_file)
-		p = file_path(lo->lo_backing_file, buf, PAGE_SIZE - 1);
+		filp = get_file(lo->lo_backing_file);
 	spin_unlock_irq(&lo->lo_lock);
 
+	if (filp) {
+		p = file_path(filp, buf, PAGE_SIZE - 1);
+		fput(filp);
+	}
+
 	if (IS_ERR_OR_NULL(p))
 		ret = PTR_ERR(p);
 	else {
_

Patches currently in -mm which might be from schatzberg.dan@gmail.com are

loop-use-worker-per-cgroup-instead-of-kworker.patch
mm-charge-active-memcg-when-no-mm-is-set.patch
loop-charge-i-o-to-mem-and-blk-cg.patch
