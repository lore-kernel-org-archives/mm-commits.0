From: akpm@linux-foundation.org
Subject: [merged]
 mm-x86-revisit-tlb_flushall_shift-tuning-for-page-flushes-except-on-ivybridge.patch removed from -mm tree
Date: Tue, 28 Jan 2014 11:10:13 -0800
Message-ID: <52e80095.i2l/DY/elLh1TMxb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45616 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068AbaA1TKO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 14:10:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, riel@redhat.com, mingo@kernel.org, hpa@zytor.com, davidlohr@hp.com, alex.shi@linaro.org, mgorman@suse.de

Subject: [merged] mm-x86-revisit-tlb_flushall_shift-tuning-for-page-flushes-except-on-ivybridge.patch removed from -mm tree
To: mgorman@suse.de,alex.shi@linaro.org,davidlohr@hp.com,hpa@zytor.com,mingo@kernel.org,riel@redhat.com,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 11:10:13 -0800


The patch titled
     Subject: mm: x86: revisit tlb_flushall_shift tuning for page flushes except on IvyBridge
has been removed from the -mm tree.  Its filename was
     mm-x86-revisit-tlb_flushall_shift-tuning-for-page-flushes-except-on-ivybridge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: x86: revisit tlb_flushall_shift tuning for page flushes except on IvyBridge

There was a large ebizzy performance regression that was bisected to
commit 611ae8e3 (x86/tlb: enable tlb flush range support for x86).  The
problem was related to the tlb_flushall_shift tuning for IvyBridge which
was altered.  The problem is that it is not clear if the tuning values for
each CPU family is correct as the methodology used to tune the values is
unclear.

This patch uses a conservative tlb_flushall_shift value for all CPU
families except IvyBridge so the decision can be revisited if any
regression is found as a result of this change.  IvyBridge is an exception
as testing with one methodology determined that the value of 2 is
acceptable.  Details are in the changelog for the patch "x86: mm: Change
tlb_flushall_shift for IvyBridge".

One important aspect of this to watch out for is Xen.  The original commit
log mentioned large performance gains on Xen.  It's possible Xen is more
sensitive to this value if it flushes small ranges of pages more
frequently than workloads on bare metal typically do.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Alex Shi <alex.shi@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H Peter Anvin <hpa@zytor.com>
Tested-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/amd.c   |    5 +----
 arch/x86/kernel/cpu/intel.c |   10 +++-------
 2 files changed, 4 insertions(+), 11 deletions(-)

diff -puN arch/x86/kernel/cpu/amd.c~mm-x86-revisit-tlb_flushall_shift-tuning-for-page-flushes-except-on-ivybridge arch/x86/kernel/cpu/amd.c
--- a/arch/x86/kernel/cpu/amd.c~mm-x86-revisit-tlb_flushall_shift-tuning-for-page-flushes-except-on-ivybridge
+++ a/arch/x86/kernel/cpu/amd.c
@@ -767,10 +767,7 @@ static unsigned int amd_size_cache(struc
 
 static void cpu_set_tlb_flushall_shift(struct cpuinfo_x86 *c)
 {
-	tlb_flushall_shift = 5;
-
-	if (c->x86 <= 0x11)
-		tlb_flushall_shift = 4;
+	tlb_flushall_shift = 6;
 }
 
 static void cpu_detect_tlb_amd(struct cpuinfo_x86 *c)
diff -puN arch/x86/kernel/cpu/intel.c~mm-x86-revisit-tlb_flushall_shift-tuning-for-page-flushes-except-on-ivybridge arch/x86/kernel/cpu/intel.c
--- a/arch/x86/kernel/cpu/intel.c~mm-x86-revisit-tlb_flushall_shift-tuning-for-page-flushes-except-on-ivybridge
+++ a/arch/x86/kernel/cpu/intel.c
@@ -640,21 +640,17 @@ static void intel_tlb_flushall_shift_set
 	case 0x61d: /* six-core 45 nm xeon "Dunnington" */
 		tlb_flushall_shift = -1;
 		break;
+	case 0x63a: /* Ivybridge */
+		tlb_flushall_shift = 2;
+		break;
 	case 0x61a: /* 45 nm nehalem, "Bloomfield" */
 	case 0x61e: /* 45 nm nehalem, "Lynnfield" */
 	case 0x625: /* 32 nm nehalem, "Clarkdale" */
 	case 0x62c: /* 32 nm nehalem, "Gulftown" */
 	case 0x62e: /* 45 nm nehalem-ex, "Beckton" */
 	case 0x62f: /* 32 nm Xeon E7 */
-		tlb_flushall_shift = 6;
-		break;
 	case 0x62a: /* SandyBridge */
 	case 0x62d: /* SandyBridge, "Romely-EP" */
-		tlb_flushall_shift = 5;
-		break;
-	case 0x63a: /* Ivybridge */
-		tlb_flushall_shift = 2;
-		break;
 	default:
 		tlb_flushall_shift = 6;
 	}
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-remove-bug_on-from-mlock_vma_page.patch
mm-page-writebackc-fix-dirty_balance_reserve-subtraction-from-dirtyable-memory.patch
mm-page-writebackc-do-not-count-anon-pages-as-dirtyable-memory.patch
mm-numa-initialse-numa-balancing-after-jump-label-initialisation.patch
mm-mempolicyc-convert-to-pr_foo.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch
linux-next.patch
zsmalloc-move-it-under-mm.patch
zram-promote-zram-from-staging.patch

