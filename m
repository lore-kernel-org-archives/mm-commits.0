From: akpm@linux-foundation.org
Subject: + zsmalloc-micro-optimize-zs_object_copy.patch added to -mm tree
Date: Tue, 24 Mar 2015 14:03:49 -0700
Message-ID: <5511d135.LvYZHBBG2huWFQF6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36886 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbbCXVDu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Mar 2015 17:03:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: micro-optimize zs_object_copy()
has been added to the -mm tree.  Its filename is
     zsmalloc-micro-optimize-zs_object_copy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-micro-optimize-zs_object_copy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-micro-optimize-zs_object_copy.patch

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
Subject: zsmalloc: micro-optimize zs_object_copy()

A micro-optimization.  Avoid additional branching and reduce (a bit)
registry pressure (f.e.  s_off += size; d_off += size; may be calculated
twise: first for >= PAGE_SIZE check and later for offset update in "else"
clause).

/scripts/bloat-o-meter shows some improvement

add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-10 (-10)
function                          old     new   delta
zs_object_copy                    550     540     -10

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-micro-optimize-zs_object_copy mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-micro-optimize-zs_object_copy
+++ a/mm/zsmalloc.c
@@ -1537,28 +1537,27 @@ static void zs_object_copy(unsigned long
 		if (written == class->size)
 			break;
 
-		if (s_off + size >= PAGE_SIZE) {
+		s_off += size;
+		s_size -= size;
+		d_off += size;
+		d_size -= size;
+
+		if (s_off >= PAGE_SIZE) {
 			kunmap_atomic(s_addr);
 			s_page = get_next_page(s_page);
 			BUG_ON(!s_page);
 			s_addr = kmap_atomic(s_page);
 			s_size = class->size - written;
 			s_off = 0;
-		} else {
-			s_off += size;
-			s_size -= size;
 		}
 
-		if (d_off + size >= PAGE_SIZE) {
+		if (d_off >= PAGE_SIZE) {
 			kunmap_atomic(d_addr);
 			d_page = get_next_page(d_page);
 			BUG_ON(!d_page);
 			d_addr = kmap_atomic(d_page);
 			d_size = class->size - written;
 			d_off = 0;
-		} else {
-			d_off += size;
-			d_size -= size;
 		}
 	}
 
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
zsmalloc-remove-extra-cond_resched-in-__zs_compact.patch
zsmalloc-do-not-remap-dst-page-while-prepare-next-src-page.patch
zsmalloc-micro-optimize-zs_object_copy.patch
cpumask-dont-perform-while-loop-in-cpumask_next_and.patch
lib-lz4-pull-out-constant-tables.patch

