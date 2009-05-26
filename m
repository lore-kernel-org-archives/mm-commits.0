From: akpm@linux-foundation.org
Subject: [merged] cls_cgroup-remove-unneeded-cgroup_lock.patch removed from -mm tree
Date: Tue, 26 May 2009 12:35:25 -0700
Message-ID: <200905261935.n4QJZP8s006245@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756708AbZEZTpB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 15:45:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, lizf@cn.fujitsuc.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cls_cgroup: remove unneeded cgroup_lock
has been removed from the -mm tree.  Its filename was
     cls_cgroup-remove-unneeded-cgroup_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cls_cgroup: remove unneeded cgroup_lock
From: Li Zefan <lizf@cn.fujitsu.com>

We can remove this lock here, since we are in cgroup write handler and
thus the cgrp is guaranteed to be valid, and no lock is needed when
writing a u32 variable.

Signed-off-by: Li Zefan <lizf@cn.fujitsuc.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sched/cls_cgroup.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN net/sched/cls_cgroup.c~cls_cgroup-remove-unneeded-cgroup_lock net/sched/cls_cgroup.c
--- a/net/sched/cls_cgroup.c~cls_cgroup-remove-unneeded-cgroup_lock
+++ a/net/sched/cls_cgroup.c
@@ -62,13 +62,7 @@ static u64 read_classid(struct cgroup *c
 
 static int write_classid(struct cgroup *cgrp, struct cftype *cft, u64 value)
 {
-	if (!cgroup_lock_live_group(cgrp))
-		return -ENODEV;
-
 	cgrp_cls_state(cgrp)->classid = (u32) value;
-
-	cgroup_unlock();
