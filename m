From: akpm@linux-foundation.org
Subject: - cgroups-fix-compile-warning.patch removed from -mm tree
Date: Fri, 16 May 2008 15:53:07 -0700
Message-ID: <200805162253.m4GMr758003111@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759520AbYEPWxZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 May 2008 18:53:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mt-ml@gmx.de, menage@google.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     cgroups: fix compile warning
has been removed from the -mm tree.  Its filename was
     cgroups-fix-compile-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: fix compile warning
From: Mirco Tischler <mt-ml@gmx.de>

Return type of cpu_rt_runtime_write() should be int instead of ssize_t.

Signed-off-by: Mirco Tischler <mt-ml@gmx.de>
Acked-by: Paul Menage <menage@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched.c~cgroups-fix-compile-warning kernel/sched.c
--- a/kernel/sched.c~cgroups-fix-compile-warning
+++ a/kernel/sched.c
@@ -8986,7 +8986,7 @@ static u64 cpu_shares_read_u64(struct cg
 #endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
-static ssize_t cpu_rt_runtime_write(struct cgroup *cgrp, struct cftype *cft,
+static int cpu_rt_runtime_write(struct cgroup *cgrp, struct cftype *cft,
 				s64 val)
 {
 	return sched_group_set_rt_runtime(cgroup_tg(cgrp), val);
_

Patches currently in -mm which might be from mt-ml@gmx.de are

origin.patch

