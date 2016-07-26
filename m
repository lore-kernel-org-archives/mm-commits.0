From: akpm@linux-foundation.org
Subject: [folded-merged] zsmalloc-page-migration-support-fix.patch removed from -mm tree
Date: Tue, 26 Jul 2016 14:53:09 -0700
Message-ID: <5797dbc5.x/cOj8CXOEeyo+Ew%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55606 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbcGZVxK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 17:53:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, sergey.senozhatsky@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: zspage sanity check
has been removed from the -mm tree.  Its filename was
     zsmalloc-page-migration-support-fix.patch

This patch was dropped because it was folded into zsmalloc-page-migration-support.patch

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: zspage sanity check

The zsmalloc page migration is new feature so I want to catch any
corruption of zspage struct which is very critical to work regardless of
CONFIG_DEBUG_VM.

Link: http://lkml.kernel.org/r/20160603010129.GC3304@bbox
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-page-migration-support-fix mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-page-migration-support-fix
+++ a/mm/zsmalloc.c
@@ -523,7 +523,7 @@ static void get_zspage_mapping(struct zs
 				unsigned int *class_idx,
 				enum fullness_group *fullness)
 {
-	VM_BUG_ON(zspage->magic != ZSPAGE_MAGIC);
+	BUG_ON(zspage->magic != ZSPAGE_MAGIC);
 
 	*fullness = zspage->fullness;
 	*class_idx = zspage->class;
@@ -857,7 +857,7 @@ static struct zspage *get_zspage(struct
 {
 	struct zspage *zspage = (struct zspage *)page->private;
 
-	VM_BUG_ON(zspage->magic != ZSPAGE_MAGIC);
+	BUG_ON(zspage->magic != ZSPAGE_MAGIC);
 	return zspage;
 }
 
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-use-put_page-to-free-page-instead-of-putback_lru_page.patch
mm-migrate-support-non-lru-movable-page-migration.patch
mm-balloon-use-general-non-lru-movable-page-feature.patch
zsmalloc-keep-max_object-in-size_class.patch
zsmalloc-use-bit_spin_lock.patch
zsmalloc-use-accessor.patch
zsmalloc-factor-page-chain-functionality-out.patch
zsmalloc-introduce-zspage-structure.patch
zsmalloc-separate-free_zspage-from-putback_zspage.patch
zsmalloc-use-freeobj-for-index.patch
zsmalloc-page-migration-support.patch
zsmalloc-page-migration-support-fix-2.patch
zram-use-__gfp_movable-for-memory-allocation.patch
zsmalloc-use-obj_tag_bit-for-bit-shifter.patch
mm-add-nr_zsmalloc-to-vmstat.patch
mm-add-nr_zsmalloc-to-vmstat-fix-2.patch
mm-fix-build-warnings-in-linux-compactionh.patch

