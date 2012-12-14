From: akpm@linux-foundation.org
Subject: [merged] kthread-use-n_memory-instead-n_high_memory.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:28:38 -0800
Message-ID: <20121214232838.B943D100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:40499 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932629Ab2LNX2k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:28:40 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so410348vcd.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:28:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, cl@linux.com, dhillf@gmail.com, linfeng@cn.fujitsu.com, rientjes@google.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kthread: use N_MEMORY instead N_HIGH_MEMORY
has been removed from the -mm tree.  Its filename was
     kthread-use-n_memory-instead-n_high_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: kthread: use N_MEMORY instead N_HIGH_MEMORY

N_HIGH_MEMORY stands for the nodes that has normal or high memory.
N_MEMORY stands for the nodes that has any memory.

The code here need to handle with the nodes which have memory, we should
use N_MEMORY instead.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Lin Feng <linfeng@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kthread.c~kthread-use-n_memory-instead-n_high_memory kernel/kthread.c
--- a/kernel/kthread.c~kthread-use-n_memory-instead-n_high_memory
+++ a/kernel/kthread.c
@@ -428,7 +428,7 @@ int kthreadd(void *unused)
 	set_task_comm(tsk, "kthreadd");
 	ignore_signals(tsk);
 	set_cpus_allowed_ptr(tsk, cpu_all_mask);
-	set_mems_allowed(node_states[N_HIGH_MEMORY]);
+	set_mems_allowed(node_states[N_MEMORY]);
 
 	current->flags |= PF_NOFREEZE;
 
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch

