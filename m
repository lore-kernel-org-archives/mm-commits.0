From: akpm@linux-foundation.org
Subject: + mm-remove-initialization-of-static-per-cpu-variables.patch added to -mm tree
Date: Mon, 30 Jun 2008 15:37:48 -0700
Message-ID: <200806302237.m5UMbme8029220@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49143 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932890AbYF3Whu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 18:37:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vegard.nossum@gmail.com


The patch titled
     mm: remove initialization of static per-cpu variables
has been added to the -mm tree.  Its filename is
     mm-remove-initialization-of-static-per-cpu-variables.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove initialization of static per-cpu variables
From: Vegard Nossum <vegard.nossum@gmail.com>

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/swap.c~mm-remove-initialization-of-static-per-cpu-variables mm/swap.c
--- a/mm/swap.c~mm-remove-initialization-of-static-per-cpu-variables
+++ a/mm/swap.c
@@ -34,9 +34,9 @@
 /* How many pages do we try to swap or page in/out together? */
 int page_cluster;
 
-static DEFINE_PER_CPU(struct pagevec, lru_add_pvecs) = { 0, };
-static DEFINE_PER_CPU(struct pagevec, lru_add_active_pvecs) = { 0, };
-static DEFINE_PER_CPU(struct pagevec, lru_rotate_pvecs) = { 0, };
+static DEFINE_PER_CPU(struct pagevec, lru_add_pvecs);
+static DEFINE_PER_CPU(struct pagevec, lru_add_active_pvecs);
+static DEFINE_PER_CPU(struct pagevec, lru_rotate_pvecs);
 
 /*
  * This path almost never happens for VM activity - pages are normally
@@ -493,7 +493,7 @@ EXPORT_SYMBOL(pagevec_lookup_tag);
  */
 #define ACCT_THRESHOLD	max(16, NR_CPUS * 2)
 
-static DEFINE_PER_CPU(long, committed_space) = 0;
+static DEFINE_PER_CPU(long, committed_space);
 
 void vm_acct_memory(long pages)
 {
_

Patches currently in -mm which might be from vegard.nossum@gmail.com are

arm-fix-header-guards.patch
parisc-fix-incomplete-header-guard.patch
mm-remove-initialization-of-static-per-cpu-variables.patch
kallsyms-fix-potential-overflow-in-binary-search.patch
quota-cleanup-loop-in-sync_dquots.patch
quota-move-function-macros-from-quotah-to-quotaopsh-fix.patch
taskstats-remove-initialization-of-static-per-cpu-variable.patch

