From: akpm@linux-foundation.org
Subject: + mm-vmscan-move-lru-lists-to-node-fix.patch added to -mm tree
Date: Wed, 22 Jun 2016 15:39:03 -0700
Message-ID: <576b1387.vkcwtMYUcaA6OA0v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46139 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbcFVWjE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jun 2016 18:39:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgorman@techsingularity.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmscan-move-lru-lists-to-node-fix
has been added to the -mm tree.  Its filename is
     mm-vmscan-move-lru-lists-to-node-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-move-lru-lists-to-node-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-move-lru-lists-to-node-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmscan-move-lru-lists-to-node-fix

probably a merge snafu

Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/swap.c~mm-vmscan-move-lru-lists-to-node-fix mm/swap.c
--- a/mm/swap.c~mm-vmscan-move-lru-lists-to-node-fix
+++ a/mm/swap.c
@@ -319,7 +319,8 @@ void activate_page(struct page *page)
 
 	page = compound_head(page);
 	spin_lock_irq(zone_lru_lock(zone));
-	__activate_page(page, mem_cgroup_page_lruvec(page, zone), NULL);
+	__activate_page(page, mem_cgroup_page_lruvec(page, zone->zone_pgdat),
+			NULL);
 	spin_unlock_irq(zone_lru_lock(zone));
 }
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-reorganize-slab-freelist-randomization-fix.patch
mm-balloon-use-general-non-lru-movable-page-feature-fix.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
mm-fix-build-warnings-in-linux-compactionh-fix.patch
mm-vmscan-move-lru-lists-to-node-fix.patch
mm-update-the-comment-in-__isolate_free_page-checkpatch-fixes.patch
nvme-dont-allocate-unused-nvme_major-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

