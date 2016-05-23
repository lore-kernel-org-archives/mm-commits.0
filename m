From: akpm@linux-foundation.org
Subject: [folded-merged]
 allocate-idle-task-for-a-cpu-always-on-its-local-node-fix.patch removed
 from -mm tree
Date: Mon, 23 May 2016 16:15:24 -0700
Message-ID: <57438f0c.txxG7PmDJ5VfWFiG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42062 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbcEWXPZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:15:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@linux.intel.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: allocate-idle-task-for-a-cpu-always-on-its-local-node-fix
has been removed from the -mm tree.  Its filename was
     allocate-idle-task-for-a-cpu-always-on-its-local-node-fix.patch

This patch was dropped because it was folded into allocate-idle-task-for-a-cpu-always-on-its-local-node.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: allocate-idle-task-for-a-cpu-always-on-its-local-node-fix

use NUMA_NO_NODE, not a bare -1

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/fork.c~allocate-idle-task-for-a-cpu-always-on-its-local-node-fix kernel/fork.c
--- a/kernel/fork.c~allocate-idle-task-for-a-cpu-always-on-its-local-node-fix
+++ a/kernel/fork.c
@@ -346,7 +346,7 @@ static struct task_struct *dup_task_stru
 	struct thread_info *ti;
 	int err;
 
-	if (node < 0)
+	if (node == NUMA_NO_NODE)
 		node = tsk_fork_get_node(orig);
 	tsk = alloc_task_struct_node(node);
 	if (!tsk)
@@ -1754,7 +1754,7 @@ long _do_fork(unsigned long clone_flags,
 	}
 
 	p = copy_process(clone_flags, stack_start, stack_size,
-			 child_tidptr, NULL, trace, tls, -1);
+			 child_tidptr, NULL, trace, tls, NUMA_NO_NODE);
 	/*
 	 * Do this prior waking up the new thread - the thread pointer
 	 * might get invalid after that point, if the thread exits quickly.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

allocate-idle-task-for-a-cpu-always-on-its-local-node.patch
drivers-memstick-core-mspro_block-use-kmemdup-fix.patch

