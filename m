From: akpm@linux-foundation.org
Subject: + lockdep-debug_locks-check-after-check_chain_key.patch added to -mm tree
Date: Mon, 12 Feb 2007 23:23:53 -0800
Message-ID: <200702130723.l1D7NrYb024900@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57541 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbXBMHYO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 02:24:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jarkao2@o2.pl, mingo@elte.hu


The patch titled
     lockdep: debug_locks check after check_chain_key
has been added to the -mm tree.  Its filename is
     lockdep-debug_locks-check-after-check_chain_key.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -2227,6 +2227,10 @@ out_calc_hash:
 
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

origin.patch
br_if-oops-in-port_carrier_check.patch
lockdep-debug_locks-check-after-check_chain_key.patch
