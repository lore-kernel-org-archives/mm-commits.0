Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1019DEE49A6
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbjHUUkK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbjHUUkA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C881B1;
        Mon, 21 Aug 2023 13:39:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7463564AF5;
        Mon, 21 Aug 2023 20:39:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA90C433C7;
        Mon, 21 Aug 2023 20:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650372;
        bh=gdeTd2Fq8N6hGs3pm1LoGgcAK9FXyF3raWVMYgUvC/8=;
        h=Date:To:From:Subject:From;
        b=RF/2n2umfN7Oc+iiX9YpDqqnWqlcr2lawBlu64hH3l6s/b2lYvFilfoVmUQaWyT8a
         dGlNg56lKHyOXCzWesFVPmaqwdyXZZyJoW1FRwR0MaPOginAoeUvtggyRtlMeL4uOm
         nyJJfUgDRLhoZSdX9HhPTAHecf7qqxQj+NUUwRoQ=
Date:   Mon, 21 Aug 2023 13:39:32 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        yuzhao@google.com, surenb@google.com, suleiman@google.com,
        steven@liquorix.net, stable@vger.kernel.org,
        quic_charante@quicinc.com, oleksandr@natalenko.name,
        matthias.bgg@gmail.com, lecopzer.chen@mediatek.com,
        heftig@archlinux.org, bgeffon@google.com, baohua@kernel.org,
        angelogioacchino.delregno@collabora.com,
        aneesh.kumar@linux.ibm.com, kaleshsingh@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-unstable-multi-gen-lru-fix-per-zone-reclaim.patch removed from -mm tree
Message-Id: <20230821203932.CCA90C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Multi-gen LRU: fix per-zone reclaim
has been removed from the -mm tree.  Its filename was
     mm-unstable-multi-gen-lru-fix-per-zone-reclaim.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kalesh Singh <kaleshsingh@google.com>
Subject: Multi-gen LRU: fix per-zone reclaim
Date: Tue, 1 Aug 2023 19:56:02 -0700

MGLRU has a LRU list for each zone for each type (anon/file) in each
generation:

	long nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];

The min_seq (oldest generation) can progress independently for each
type but the max_seq (youngest generation) is shared for both anon and
file. This is to maintain a common frame of reference.

In order for eviction to advance the min_seq of a type, all the per-zone
lists in the oldest generation of that type must be empty.

The eviction logic only considers pages from eligible zones for
eviction or promotion.

    scan_folios() {
	...
	for (zone = sc->reclaim_idx; zone >= 0; zone--)  {
	    ...
	    sort_folio(); 	// Promote
	    ...
	    isolate_folio(); 	// Evict
	}
	...
    }

Consider the system has the movable zone configured and default 4
generations. The current state of the system is as shown below
(only illustrating one type for simplicity):

Type: ANON

	Zone    DMA32     Normal    Movable    Device

	Gen 0       0          0        4GB         0

	Gen 1       0        1GB        1MB         0

	Gen 2     1MB        4GB        1MB         0

	Gen 3     1MB        1MB        1MB         0

Now consider there is a GFP_KERNEL allocation request (eligible zone
index <= Normal), evict_folios() will return without doing any work
since there are no pages to scan in the eligible zones of the oldest
generation. Reclaim won't make progress until triggered from a ZONE_MOVABLE
allocation request; which may not happen soon if there is a lot of free
memory in the movable zone. This can lead to OOM kills, although there
is 1GB pages in the Normal zone of Gen 1 that we have not yet tried to
reclaim.

This issue is not seen in the conventional active/inactive LRU since
there are no per-zone lists.

If there are no (not enough) folios to scan in the eligible zones, move
folios from ineligible zone (zone_index > reclaim_index) to the next
generation. This allows for the progression of min_seq and reclaiming
from the next generation (Gen 1).

Qualcomm, Mediatek and raspberrypi [1] discovered this issue independently.

[1] https://github.com/raspberrypi/linux/issues/5395

Link: https://lkml.kernel.org/r/20230802025606.346758-1-kaleshsingh@google.com
Fixes: ac35a4902374 ("mm: multi-gen LRU: minimal implementation")
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Reported-by: Charan Teja Kalla <quic_charante@quicinc.com>
Reported-by: Lecopzer Chen <lecopzer.chen@mediatek.com>
Tested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com> [mediatek]
Tested-by: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Jan Alexander Steffens (heftig) <heftig@archlinux.org>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Steven Barrett <steven@liquorix.net>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Aneesh Kumar K V <aneesh.kumar@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/mm/vmscan.c~mm-unstable-multi-gen-lru-fix-per-zone-reclaim
+++ a/mm/vmscan.c
@@ -4889,7 +4889,8 @@ static int lru_gen_memcg_seg(struct lruv
  *                          the eviction
  ******************************************************************************/
 
-static bool sort_folio(struct lruvec *lruvec, struct folio *folio, int tier_idx)
+static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_control *sc,
+		       int tier_idx)
 {
 	bool success;
 	int gen = folio_lru_gen(folio);
@@ -4939,6 +4940,13 @@ static bool sort_folio(struct lruvec *lr
 		return true;
 	}
 
+	/* ineligible */
+	if (zone > sc->reclaim_idx) {
+		gen = folio_inc_gen(lruvec, folio, false);
+		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
+		return true;
+	}
+
 	/* waiting for writeback */
 	if (folio_test_locked(folio) || folio_test_writeback(folio) ||
 	    (type == LRU_GEN_FILE && folio_test_dirty(folio))) {
@@ -4987,7 +4995,8 @@ static bool isolate_folio(struct lruvec
 static int scan_folios(struct lruvec *lruvec, struct scan_control *sc,
 		       int type, int tier, struct list_head *list)
 {
-	int gen, zone;
+	int i;
+	int gen;
 	enum vm_event_item item;
 	int sorted = 0;
 	int scanned = 0;
@@ -5003,9 +5012,10 @@ static int scan_folios(struct lruvec *lr
 
 	gen = lru_gen_from_seq(lrugen->min_seq[type]);
 
-	for (zone = sc->reclaim_idx; zone >= 0; zone--) {
+	for (i = MAX_NR_ZONES; i > 0; i--) {
 		LIST_HEAD(moved);
 		int skipped = 0;
+		int zone = (sc->reclaim_idx + i) % MAX_NR_ZONES;
 		struct list_head *head = &lrugen->folios[gen][type][zone];
 
 		while (!list_empty(head)) {
@@ -5019,7 +5029,7 @@ static int scan_folios(struct lruvec *lr
 
 			scanned += delta;
 
-			if (sort_folio(lruvec, folio, tier))
+			if (sort_folio(lruvec, folio, sc, tier))
 				sorted += delta;
 			else if (isolate_folio(lruvec, folio, sc)) {
 				list_add(&folio->lru, list);
_

Patches currently in -mm which might be from kaleshsingh@google.com are


