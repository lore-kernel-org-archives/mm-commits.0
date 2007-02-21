From: akpm@linux-foundation.org
Subject: - lockdep-debug_locks-check-after-check_chain_key.patch removed from -mm tree
Date: Wed, 21 Feb 2007 02:45:43 -0800
Message-ID: <200702211045.l1LAjhHt006397@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46887 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932510AbXBUKp5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 05:45:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jarkao2@o2.pl, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     lockdep: debug_locks check after check_chain_key
has been removed from the -mm tree.  Its filename was
     lockdep-debug_locks-check-after-check_chain_key.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockdep: debug_locks check after check_chain_key
From: Jarek Poplawski <jarkao2@o2.pl>

In __lock_acquire check_chain_key can turn off debug_locks, so check is
needed to assure proper return code.

Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/lockdep.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/lockdep.c~lockdep-debug_locks-check-after-check_chain_key kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-debug_locks-check-after-check_chain_key
+++ a/kernel/lockdep.c
@@ -2228,6 +2228,10 @@ out_calc_hash:
 
 	curr->lockdep_depth++;
 	check_chain_key(curr);
+#ifdef CONFIG_DEBUG_LOCKDEP
+	if (unlikely(!debug_locks))
+		return 0;
+#endif
 	if (unlikely(curr->lockdep_depth >= MAX_LOCK_DEPTH)) {
 		debug_locks_off();
 		printk("BUG: MAX_LOCK_DEPTH too low!\n");
_

Patches currently in -mm which might be from jarkao2@o2.pl are
