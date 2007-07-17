From: akpm@linux-foundation.org
Subject: - remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch removed from -mm tree
Date: Tue, 17 Jul 2007 02:41:58 -0700
Message-ID: <200707170946.l6H9kNsH010486@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55491 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752660AbXGQJqf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 05:46:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulmck@linux.vnet.ibm.com, ak@suse.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Remove workaround for unimmunized rcu_dereference from mce_log()
has been removed from the -mm tree.  Its filename was
     remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: Remove workaround for unimmunized rcu_dereference from mce_log()
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Remove the rmb() from mce_log(), since the immunized version of
rcu_dereference() makes it unnecessary.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/mce.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN arch/x86_64/kernel/mce.c~remove-workaround-for-unimmunized-rcu_dereference-from-mce_log arch/x86_64/kernel/mce.c
--- a/arch/x86_64/kernel/mce.c~remove-workaround-for-unimmunized-rcu_dereference-from-mce_log
+++ a/arch/x86_64/kernel/mce.c
@@ -67,9 +67,6 @@ void mce_log(struct mce *mce)
 	wmb();
 	for (;;) {
 		entry = rcu_dereference(mcelog.next);
-		/* The rmb forces the compiler to reload next in each
-		    iteration */
-		rmb();
 		for (;;) {
 			/* When the buffer fills up discard new entries. Assume
 			   that the earlier errors are the more interesting. */
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

origin.patch
remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch
