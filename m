From: akpm@linux-foundation.org
Subject: - remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:52:36 -0700
Message-ID: <200710180652.l9I6qaNI030302@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35676 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932345AbXJRHnF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:43:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulmck@linux.vnet.ibm.com, ak@suse.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Remove workaround for unimmunized rcu_dereference from mce_log()
has been removed from the -mm tree.  Its filename was
     remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 arch/x86/kernel/mce_64.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN arch/x86/kernel/mce_64.c~remove-workaround-for-unimmunized-rcu_dereference-from-mce_log arch/x86/kernel/mce_64.c
--- a/arch/x86/kernel/mce_64.c~remove-workaround-for-unimmunized-rcu_dereference-from-mce_log
+++ a/arch/x86/kernel/mce_64.c
@@ -76,9 +76,6 @@ void mce_log(struct mce *mce)
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
make-access-to-tasks-nsproxy-lighter.patch
make-access-to-tasks-nsproxy-lighterpatch-breaks-unshare.patch
make-access-to-tasks-nsproxy-lighter-update-get_net_ns_by_pid.patch
