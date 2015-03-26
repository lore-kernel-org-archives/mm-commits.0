From: akpm@linux-foundation.org
Subject: + zsmalloc-remove-extra-cond_resched-in-__zs_compact.patch added
 to -mm tree
Date: Thu, 26 Mar 2015 12:45:59 -0700
Message-ID: <551461f7.OeCK3gn4nc5n55s0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57051 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbbCZTqA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Mar 2015 15:46:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: remove extra cond_resched() in __zs_compact
has been added to the -mm tree.  Its filename is
     zsmalloc-remove-extra-cond_resched-in-__zs_compact.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-remove-extra-cond_resched-in-__zs_compact.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-remove-extra-cond_resched-in-__zs_compact.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zsmalloc: remove extra cond_resched() in __zs_compact

Do not perform cond_resched() before the busy compaction loop in
__zs_compact(), because this loop does it when needed.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-remove-extra-cond_resched-in-__zs_compact mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-remove-extra-cond_resched-in-__zs_compact
+++ a/mm/zsmalloc.c
@@ -1711,8 +1711,6 @@ static unsigned long __zs_compact(struct
 	struct page *dst_page = NULL;
 	unsigned long nr_total_migrated = 0;
 
-	cond_resched();
-
 	spin_lock(&class->lock);
 	while ((src_page = isolate_source_page(class))) {
 
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-cosmetic-zram_attr_ro-code-formatting-tweak.patch
zram-use-idr-instead-of-zram_devices-array.patch
zram-factor-out-device-reset-from-reset_store.patch
zram-reorganize-code-layout.patch
zram-add-dynamic-device-add-remove-functionality.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-remove-max_num_devices-limitation.patch
zram-report-every-added-and-removed-device.patch
zram-trivial-correct-flag-operations-comment.patch
zram-return-zram-device_id-value-from-zram_add.patch
zram-introduce-automatic-device_id-generation.patch
zram-introduce-automatic-device_id-generation-fix.patch
zram-do-not-let-user-enforce-new-device-dev_id.patch
zsmalloc-decouple-handle-and-object.patch
zsmalloc-factor-out-obj_.patch
zsmalloc-support-compaction.patch
zsmalloc-adjust-zs_almost_full.patch
zram-support-compaction.patch
zsmalloc-record-handle-in-page-private-for-huge-object.patch
zsmalloc-add-fullness-into-stat.patch
zsmalloc-zsmalloc-documentation.patch
zram-remove-num_migrated-device-attr.patch
zram-move-compact_store-to-sysfs-functions-area.patch
zram-use-generic-start-end-io-accounting.patch
zram-describe-device-attrs-in-documentation.patch
zram-export-new-io_stat-sysfs-attrs.patch
zram-export-new-mm_stat-sysfs-attrs.patch
zram-deprecate-zram-attrs-sysfs-nodes.patch
zsmalloc-remove-synchronize_rcu-from-zs_compact.patch
zsmalloc-micro-optimize-zs_object_copy.patch
zsmalloc-remove-unnecessary-insertion-removal-of-zspage-in-compaction.patch
zsmalloc-remove-extra-cond_resched-in-__zs_compact.patch
cpumask-dont-perform-while-loop-in-cpumask_next_and.patch
lib-lz4-pull-out-constant-tables.patch

