From: akpm@linux-foundation.org
Subject: + initialise-pi_lock-if-config_rt_mutexes=n.patch added to -mm tree
Date: Fri, 16 Mar 2007 10:13:03 -0800
Message-ID: <200703161813.l2GID3jA018466@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57874 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965817AbXCPSO0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Mar 2007 14:14:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zilvinas@wilibox.com, mingo@elte.hu, stable@kernel.org


The patch titled
     initialise pi_lock if CONFIG_RT_MUTEXES=N
has been added to the -mm tree.  Its filename is
     initialise-pi_lock-if-config_rt_mutexes=n.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -935,8 +935,8 @@ asmlinkage long sys_set_tid_address(int 
 
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

initialise-pi_lock-if-config_rt_mutexes=n.patch
