From: akpm@linux-foundation.org
Subject: + zsmalloc-page-migration-support-fix.patch added to -mm tree
Date: Fri, 03 Jun 2016 14:24:18 -0700
Message-ID: <5751f582.SCA1Q/ZQwklAD82J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52099 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbcFCVYT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2016 17:24:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, sergey.senozhatsky@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: zspage sanity check
has been added to the -mm tree.  Its filename is
     zsmalloc-page-migration-support-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-page-migration-support-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-page-migration-support-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
zsmalloc-page-migration-support-fix.patch
zram-use-__gfp_movable-for-memory-allocation.patch
mm-add-nr_zsmalloc-to-vmstat.patch

