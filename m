From: akpm@linux-foundation.org
Subject: + i386-dont-check_pgt_cache-in-flush_tlb_mm.patch added to -mm tree
Date: Tue, 15 May 2007 12:04:51 -0700
Message-ID: <200705151904.l4FJ4pgr015273@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33890 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755634AbXEOTFJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 15:05:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, ak@suse.de, clameter@sgi.com, davem@davemloft.net, wli@holomorphy.com


The patch titled
     i386: don't check_pgt_cache in flush_tlb_mm
has been added to the -mm tree.  Its filename is
     i386-dont-check_pgt_cache-in-flush_tlb_mm.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: don't check_pgt_cache in flush_tlb_mm
From: Hugh Dickins <hugh@veritas.com>

No other architecture calls check_pgt_cache() from within flush_tlb_mm(),
and i386 is already calling check_pgt_cache() from the usual places,
tlb_finish_mmu() and cpu_idle() (the latter being odd, but not unusual). 
flush_tlb_mm() has no business to be freeing pages: remove that line, which
sneaked in with slub's i386 support.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/smp.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/smp.c~i386-dont-check_pgt_cache-in-flush_tlb_mm arch/i386/kernel/smp.c
--- a/arch/i386/kernel/smp.c~i386-dont-check_pgt_cache-in-flush_tlb_mm
+++ a/arch/i386/kernel/smp.c
@@ -421,7 +421,7 @@ void flush_tlb_mm (struct mm_struct * mm
 	}
 	if (!cpus_empty(cpu_mask))
 		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
-	check_pgt_cache();
+
 	preempt_enable();
 }
 
_

Patches currently in -mm which might be from hugh@veritas.com are

scsi-fix-config_scsi_wait_scan=m.patch
i386-dont-check_pgt_cache-in-flush_tlb_mm.patch
lazy-freeing-of-memory-through-madv_free.patch
restore-madv_dontneed-to-its-original-linux-behaviour.patch
mm-more-rmap-checking.patch
mm-more-rmap-checking-tidy.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
ext2-reservations.patch
ext2-balloc-use-io_error-label.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
prio-tree-debugging.patch
