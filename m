From: akpm@linux-foundation.org
Subject: + mm-print-the-correct-method-to-disable-automatic-numa-migration.patch added to -mm tree
Date: Wed, 10 Apr 2013 14:13:58 -0700
Message-ID: <20130410211358.847575A425C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:37668 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531Ab3DJVOA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Apr 2013 17:14:00 -0400
Received: by mail-ob0-f201.google.com with SMTP id uz6so221480obc.0
        for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2013 14:13:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, mel@csn.ul.ie


The patch titled
     Subject: mm: print the correct method to disable automatic numa migration
has been added to the -mm tree.  Its filename is
     mm-print-the-correct-method-to-disable-automatic-numa-migration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: mm: print the correct method to disable automatic numa migration

When the "default y" CONFIG_NUMA_BALANCING_DEFAULT_ENABLED is enabled, the
message it prints refers to a sysctl to disable it again.  But that sysctl
doesn't exist.

Document the correct (highly obscure method) through debugfs.

This should be also in Documentation/* but isn't.

Also fix the checkpatch problems.

BTW I think the "default y" is highly dubious for such a
experimential feature.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/mempolicy.c~mm-print-the-correct-method-to-disable-automatic-numa-migration mm/mempolicy.c
--- a/mm/mempolicy.c~mm-print-the-correct-method-to-disable-automatic-numa-migration
+++ a/mm/mempolicy.c
@@ -2530,8 +2530,8 @@ static void __init check_numabalancing_e
 		numabalancing_default = true;
 
 	if (nr_node_ids > 1 && !numabalancing_override) {
-		printk(KERN_INFO "Enabling automatic NUMA balancing. "
-			"Configure with numa_balancing= or sysctl");
+		pr_info("Enabling automatic NUMA balancing.\n");
+		pr_info("Change with numa_balancing= or echo -NUMA >/sys/kernel/debug/sched_features\n");
 		set_numabalancing_state(numabalancing_default);
 	}
 }
_

Patches currently in -mm which might be from ak@linux.intel.com are

linux-next.patch
mm-print-the-correct-method-to-disable-automatic-numa-migration.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch

