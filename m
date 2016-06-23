From: akpm@linux-foundation.org
Subject: +
 mm-compaction-split-freepages-without-holding-the-zone-lock-fix-2.patch
 added to -mm tree
Date: Wed, 22 Jun 2016 17:37:16 -0700
Message-ID: <576b2f3c.yzPEAxxlqgudw2i1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48304 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbcFWAhR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jun 2016 20:37:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-split-freepages-without-holding-the-zone-lock-fix-2
has been added to the -mm tree.  Its filename is
     mm-compaction-split-freepages-without-holding-the-zone-lock-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-split-freepages-without-holding-the-zone-lock-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-split-freepages-without-holding-the-zone-lock-fix-2.patch

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
Subject: mm-compaction-split-freepages-without-holding-the-zone-lock-fix-2

Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compaction-split-freepages-without-holding-the-zone-lock-fix-2 mm/compaction.c
--- a/mm/compaction.c~mm-compaction-split-freepages-without-holding-the-zone-lock-fix-2
+++ a/mm/compaction.c
@@ -498,10 +498,14 @@ static unsigned long isolate_freepages_b
 		/* Found a free page, will break it into order-0 pages */
 		order = page_order(page);
 		isolated = __isolate_free_page(page, order);
+		if (!isolated)
+			break;
 		set_page_private(page, order);
+
 		total_isolated += isolated;
-		list_add_tail(&page->lru, freelist);
 		cc->nr_freepages += isolated;
+		list_add_tail(&page->lru, freelist);
+
 		if (!strict && cc->nr_migratepages <= cc->nr_freepages) {
 			blockpfn += isolated;
 			break;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-reorganize-slab-freelist-randomization-fix.patch
mm-balloon-use-general-non-lru-movable-page-feature-fix.patch
mm-compaction-split-freepages-without-holding-the-zone-lock-fix-2.patch
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

