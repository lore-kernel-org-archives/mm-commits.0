From: akpm@linux-foundation.org
Subject: - initialise-pi_lock-if-config_rt_mutexes=n.patch removed from -mm tree
Date: Sun, 18 Mar 2007 01:10:13 -0800
Message-ID: <200703180910.l2I9ADx4020075@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60546 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195AbXCRJL1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 05:11:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zilvinas@wilibox.com, mingo@elte.hu, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     initialise pi_lock if CONFIG_RT_MUTEXES=N
has been removed from the -mm tree.  Its filename was
     initialise-pi_lock-if-config_rt_mutexes=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: initialise pi_lock if CONFIG_RT_MUTEXES=N
From: Zilvinas Valinskas <zilvinas@wilibox.com>

Fixes a bogus lockdep warning which causes lockdep to disable itself.

Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/fork.c~initialise-pi_lock-if-config_rt_mutexes=n kernel/fork.c
--- a/kernel/fork.c~initialise-pi_lock-if-config_rt_mutexes=n
+++ a/kernel/fork.c
@@ -933,8 +933,8 @@ asmlinkage long sys_set_tid_address(int 
 
 static inline void rt_mutex_init_task(struct task_struct *p)
 {
-#ifdef CONFIG_RT_MUTEXES
 	spin_lock_init(&p->pi_lock);
+#ifdef CONFIG_RT_MUTEXES
 	plist_head_init(&p->pi_waiters, &p->pi_lock);
 	p->pi_blocked_on = NULL;
 #endif
_

Patches currently in -mm which might be from zilvinas@wilibox.com are

origin.patch
