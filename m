From: akpm@linux-foundation.org
Subject: - use-warn-in-arch-x86-mm-pageattrc.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:40:35 -0700
Message-ID: <200808181940.m7IJeZCs008470@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758399AbYHRTlf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:41:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     use WARN() in arch/x86/mm/pageattr.c
has been removed from the -mm tree.  Its filename was
     use-warn-in-arch-x86-mm-pageattrc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: use WARN() in arch/x86/mm/pageattr.c
From: Arjan van de Ven <arjan@linux.intel.com>

Use WARN() instead of a printk+WARN_ON() pair; this way the message becomes
part of the warning section for better reporting/collection.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pageattr-test.c |    3 +--
 arch/x86/mm/pageattr.c      |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN arch/x86/mm/pageattr-test.c~use-warn-in-arch-x86-mm-pageattrc arch/x86/mm/pageattr-test.c
--- a/arch/x86/mm/pageattr-test.c~use-warn-in-arch-x86-mm-pageattrc
+++ a/arch/x86/mm/pageattr-test.c
@@ -221,8 +221,7 @@ static int pageattr_test(void)
 	failed += print_split(&sc);
 
 	if (failed) {
-		printk(KERN_ERR "NOT PASSED. Please report.\n");
-		WARN_ON(1);
+		WARN(1, KERN_ERR "NOT PASSED. Please report.\n");
 		return -EINVAL;
 	} else {
 		if (print)
diff -puN arch/x86/mm/pageattr.c~use-warn-in-arch-x86-mm-pageattrc arch/x86/mm/pageattr.c
--- a/arch/x86/mm/pageattr.c~use-warn-in-arch-x86-mm-pageattrc
+++ a/arch/x86/mm/pageattr.c
@@ -592,10 +592,9 @@ repeat:
 	if (!pte_val(old_pte)) {
 		if (!primary)
 			return 0;
-		printk(KERN_WARNING "CPA: called for zero pte. "
+		WARN(1, KERN_WARNING "CPA: called for zero pte. "
 		       "vaddr = %lx cpa->vaddr = %lx\n", address,
 		       cpa->vaddr);
-		WARN_ON(1);
 		return -EINVAL;
 	}
 
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch
linux-next.patch
use-warn-in-arch-x86-mm-ioremapc.patch
use-warn-in-arch-x86-kernel.patch

