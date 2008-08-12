From: akpm@linux-foundation.org
Subject: - lockdep-handle-chains-involving-classes-defined-in-modules.patch removed from -mm tree
Date: Tue, 12 Aug 2008 13:33:47 -0700
Message-ID: <200808122033.m7CKXloN011828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44537 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751306AbYHLUei (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 16:34:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rabin@rab.in, a.p.zijlstra@chello.nl, mingo@elte.hu, snakebyte@gmx.de, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     lockdep: handle chains involving classes defined in modules
has been removed from the -mm tree.  Its filename was
     lockdep-handle-chains-involving-classes-defined-in-modules.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lockdep: handle chains involving classes defined in modules
From: Rabin Vincent <rabin@rab.in>

/proc/lockdep_chains currently oopses after any module which creates and
uses a lock is unloaded.  This is because one of the chains involves a
class which was defined in the module just unloaded.

Solve this by marking the classes as unused and not printing information
about the unused classes.

Reported-by: Eric Sesterhenn <snakebyte@gmx.de>
Signed-off-by: Rabin Vincent <rabin@rab.in>
Acked-by: Huang Ying <ying.huang@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/lockdep.c      |    1 +
 kernel/lockdep_proc.c |    3 +++
 2 files changed, 4 insertions(+)

diff -puN kernel/lockdep.c~lockdep-handle-chains-involving-classes-defined-in-modules kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-handle-chains-involving-classes-defined-in-modules
+++ a/kernel/lockdep.c
@@ -3174,6 +3174,7 @@ static void zap_class(struct lock_class 
 	list_del_rcu(&class->hash_entry);
 	list_del_rcu(&class->lock_entry);
 
+	class->key = NULL;
 }
 
 static inline int within(const void *addr, void *start, unsigned long size)
diff -puN kernel/lockdep_proc.c~lockdep-handle-chains-involving-classes-defined-in-modules kernel/lockdep_proc.c
--- a/kernel/lockdep_proc.c~lockdep-handle-chains-involving-classes-defined-in-modules
+++ a/kernel/lockdep_proc.c
@@ -201,6 +201,9 @@ static int lc_show(struct seq_file *m, v
 
 	for (i = 0; i < chain->depth; i++) {
 		class = lock_chain_get_class(chain, i);
+		if (!class->key)
+			continue;
+
 		seq_printf(m, "[%p] ", class->key);
 		print_name(m, class);
 		seq_puts(m, "\n");
_

Patches currently in -mm which might be from rabin@rab.in are

origin.patch
cpuidle-make-sysfs-attributes-sysdev-class-attributes.patch
linux-next.patch

