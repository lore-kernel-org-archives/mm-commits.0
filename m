From: akpm@linux-foundation.org
Subject: + remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch added to -mm tree
Date: Wed, 11 Jul 2007 18:26:47 -0700
Message-ID: <200707120126.l6C1Ql2C000886@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41507 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761526AbXGLB13 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jul 2007 21:27:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com, ak@suse.de, mingo@elte.hu


The patch titled
     Remove workaround for unimmunized rcu_dereference from mce_log()
has been added to the -mm tree.  Its filename is
     remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 3 deletions(-)

diff -puN arch/x86_64/kernel/mce.c~remove-workaround-for-unimmunized-rcu_dereference-from-mce_log arch/x86_64/kernel/mce.c
--- a/arch/x86_64/kernel/mce.c~remove-workaround-for-unimmunized-rcu_dereference-from-mce_log
+++ a/arch/x86_64/kernel/mce.c
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

document-the-fact-that-rcu-callbacks-can-run-in-parallel.patch
immunize-rcu_dereference-against-crazy-compiler-writers.patch
remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch
