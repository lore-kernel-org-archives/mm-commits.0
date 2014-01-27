From: akpm@linux-foundation.org
Subject: +
 mm-numa-initialse-numa-balancing-after-jump-label-initialisation.patch
 added to -mm tree
Date: Mon, 27 Jan 2014 14:43:48 -0800
Message-ID: <52e6e124.JaVXelreffNw9ezC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36895 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328AbaA0Wnt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jan 2014 17:43:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, riel@redhat.com, mgorman@suse.de

Subject: + mm-numa-initialse-numa-balancing-after-jump-label-initialisation.patch added to -mm tree
To: mgorman@suse.de,riel@redhat.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 27 Jan 2014 14:43:48 -0800


The patch titled
     Subject: mm: numa: Initialse numa balancing after jump label initialisation
has been added to the -mm tree.  Its filename is
     mm-numa-initialse-numa-balancing-after-jump-label-initialisation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-numa-initialse-numa-balancing-after-jump-label-initialisation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-numa-initialse-numa-balancing-after-jump-label-initialisation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: numa: Initialse numa balancing after jump label initialisation

The command line parsing takes place before jump labels are initialised which
generates a warning if numa_balancing= is specified and CONFIG_JUMP_LABEL
is set. On older kernls before commit c4b2c0c5 (static_key: WARN on
usage before jump_label_init was called) the kernel would have crashed.
This patch enables automatic numa balancing later in the initialisation
process if numa_balancing= is specified.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff -puN mm/mempolicy.c~mm-numa-initialse-numa-balancing-after-jump-label-initialisation mm/mempolicy.c
--- a/mm/mempolicy.c~mm-numa-initialse-numa-balancing-after-jump-label-initialisation
+++ a/mm/mempolicy.c
@@ -2655,7 +2655,7 @@ void mpol_free_shared_policy(struct shar
 }
 
 #ifdef CONFIG_NUMA_BALANCING
-static bool __initdata numabalancing_override;
+static int __initdata numabalancing_override;
 
 static void __init check_numabalancing_enable(void)
 {
@@ -2664,9 +2664,15 @@ static void __init check_numabalancing_e
 	if (IS_ENABLED(CONFIG_NUMA_BALANCING_DEFAULT_ENABLED))
 		numabalancing_default = true;
 
+	/* Parsed by setup_numabalancing. override == 1 enables, -1 disables */
+	if (numabalancing_override)
+		set_numabalancing_state(numabalancing_override == 1);
+
 	if (nr_node_ids > 1 && !numabalancing_override) {
-		printk(KERN_INFO "Enabling automatic NUMA balancing. "
-			"Configure with numa_balancing= or the kernel.numa_balancing sysctl");
+		printk(KERN_INFO "%s automatic NUMA balancing. "
+			"Configure with numa_balancing= or the "
+			"kernel.numa_balancing sysctl",
+			numabalancing_default ? "Enabling" : "Disabling");
 		set_numabalancing_state(numabalancing_default);
 	}
 }
@@ -2676,13 +2682,12 @@ static int __init setup_numabalancing(ch
 	int ret = 0;
 	if (!str)
 		goto out;
-	numabalancing_override = true;
 
 	if (!strcmp(str, "enable")) {
-		set_numabalancing_state(true);
+		numabalancing_override = 1;
 		ret = 1;
 	} else if (!strcmp(str, "disable")) {
-		set_numabalancing_state(false);
+		numabalancing_override = -1;
 		ret = 1;
 	}
 out:
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-remove-bug_on-from-mlock_vma_page.patch
mm-page-writebackc-fix-dirty_balance_reserve-subtraction-from-dirtyable-memory.patch
mm-page-writebackc-do-not-count-anon-pages-as-dirtyable-memory.patch
mm-numa-initialse-numa-balancing-after-jump-label-initialisation.patch
x86-mm-account-for-tlb-flushes-only-when-debugging.patch
x86-mm-clean-up-inconsistencies-when-flushing-tlb-ranges.patch
x86-mm-eliminate-redundant-page-table-walk-during-tlb-range-flushing.patch
x86-mm-change-tlb_flushall_shift-for-ivybridge.patch
mm-x86-revisit-tlb_flushall_shift-tuning-for-page-flushes-except-on-ivybridge.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch
linux-next.patch
mm-migratec-fix-setting-of-cpupid-on-page-migration-twice-against-normal-page.patch
zsmalloc-move-it-under-mm.patch
zram-promote-zram-from-staging.patch

