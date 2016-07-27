From: akpm@linux-foundation.org
Subject: [merged] cgroup-remove-unnecessary-0-check-from-css_from_id.patch removed from -mm tree
Date: Wed, 27 Jul 2016 12:03:31 -0700
Message-ID: <57990583.OHVmB4sAU4Lw5OC1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40800 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190AbcG0TDc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 15:03:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kernel@kyup.com, tj@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroup: remove unnecessary 0 check from css_from_id()
has been removed from the -mm tree.  Its filename was
     cgroup-remove-unnecessary-0-check-from-css_from_id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: cgroup: remove unnecessary 0 check from css_from_id()

css_idr allocation starts at 1, so index 0 will never point to an item. 
css_from_id() currently filters that before asking idr_find(), but
idr_find() would also just return NULL, so this is not needed.

Link: http://lkml.kernel.org/r/20160617162427.GC19084@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Nikolay Borisov <kernel@kyup.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cgroup.c~cgroup-remove-unnecessary-0-check-from-css_from_id kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-remove-unnecessary-0-check-from-css_from_id
+++ a/kernel/cgroup.c
@@ -6166,7 +6166,7 @@ struct cgroup_subsys_state *css_tryget_o
 struct cgroup_subsys_state *css_from_id(int id, struct cgroup_subsys *ss)
 {
 	WARN_ON_ONCE(!rcu_read_lock_held());
-	return id > 0 ? idr_find(&ss->css_idr, id) : NULL;
+	return idr_find(&ss->css_idr, id);
 }
 
 /**
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code.patch
mm-fix-vm-scalability-regression-in-cgroup-aware-workingset-code-fix.patch

