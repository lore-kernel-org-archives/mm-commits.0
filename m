Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9931EB37
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 15:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714663351; cv=none; b=aZZq0wIRdsJcK7Ha/UYKbo0zjUd0RB4F7MKd2zrZMIPP2fwGShi49HqM/ZuffJ8m+jI60JtCAyTuDtecRlCZhCqoB9LUy6lcAu6qKqwbbZpPf+IBOzQ0TCDKt/ukBS/nrO9W/nbpE0BFVjtmNC6CBtG6klqXPLQ8KeMsxT7jeDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714663351; c=relaxed/simple;
	bh=Zo55aRZ/6ukzGaliUY26cApD1NyjRSPzyBnMrufRqig=;
	h=Date:To:From:Subject:Message-Id; b=AmsvYdhTCUIToZuTCv6VmMXLYPhIHUd7/VwBDaQMStl1oTLrb4lVc/Z/TtXiHL/w630vHerpaCecXfns7aYrGyGzzzLQHCGGDPwDfQKZJVknV0WvZuRukho/ZyDNvrw1ExyFX9SkeBAzK0FohYwD2RVks4KStcOZ9PC1TJBnr5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a5Haotcx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a5Haotcx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497FFC113CC;
	Thu,  2 May 2024 15:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714663350;
	bh=Zo55aRZ/6ukzGaliUY26cApD1NyjRSPzyBnMrufRqig=;
	h=Date:To:From:Subject:From;
	b=a5HaotcxArkqhe/VTxS+qiNeZ08fhf6o9hS3NMhAuwpdXjR4LMkbZsZm5JsAQzQaB
	 QCiMU/btWcnSCMYz7eGcOzUcw8MBjAbx1k4jr66pn7K8DC59q0qsICXHggVBHXuaOn
	 K03/1Rhg8MtRNFtDh5AeUOLTWsQ3FWU2EwotqReM=
Date: Thu, 02 May 2024 08:22:29 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,izik.eidus@ravellosystems.com,david@redhat.com,alexs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-ksm-rename-mm_slot-for-get_next_rmap_item.patch removed from -mm tree
Message-Id: <20240502152230.497FFC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: rename mm_slot for get_next_rmap_item
has been removed from the -mm tree.  Its filename was
     mm-ksm-rename-mm_slot-for-get_next_rmap_item.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: "Alex Shi (tencent)" <alexs@kernel.org>
Subject: mm/ksm: rename mm_slot for get_next_rmap_item
Date: Sun, 28 Apr 2024 18:06:18 +0800

To distinguish ksm_mm_slot and mm_slot for better code readability, rename
parameter "struct ksm_mm_slot *mm_slot", as "struct ksm_mm_slot
*ksm_slot".  No function change.

Link: https://lkml.kernel.org/r/20240428100619.3332036-4-alexs@kernel.org
Signed-off-by: Alex Shi (tencent) <alexs@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/ksm.c~mm-ksm-rename-mm_slot-for-get_next_rmap_item
+++ a/mm/ksm.c
@@ -2468,7 +2468,7 @@ static void cmp_and_merge_page(struct pa
 	}
 }
 
-static struct ksm_rmap_item *get_next_rmap_item(struct ksm_mm_slot *mm_slot,
+static struct ksm_rmap_item *get_next_rmap_item(struct ksm_mm_slot *ksm_slot,
 					    struct ksm_rmap_item **rmap_list,
 					    unsigned long addr)
 {
@@ -2488,7 +2488,7 @@ static struct ksm_rmap_item *get_next_rm
 	rmap_item = alloc_rmap_item();
 	if (rmap_item) {
 		/* It has already been zeroed */
-		rmap_item->mm = mm_slot->slot.mm;
+		rmap_item->mm = ksm_slot->slot.mm;
 		rmap_item->mm->ksm_rmap_items++;
 		rmap_item->address = addr;
 		rmap_item->rmap_list = *rmap_list;
_

Patches currently in -mm which might be from alexs@kernel.org are

mm-ksm-add-ksm_get_folio.patch
mm-ksm-use-folio-in-remove_rmap_item_from_tree.patch
mm-ksm-add-folio_set_stable_node.patch
mm-ksm-use-folio-in-remove_stable_node.patch
mm-ksm-use-folio-in-stable_node_dup.patch
mm-ksm-use-ksm_get_folio-in-scan_get_next_rmap_item.patch
mm-ksm-use-folio-in-write_protect_page.patch
mm-ksm-convert-chain-series-funcs-and-replace-get_ksm_page.patch
mm-ksm-replace-set_page_stable_node-by-folio_set_stable_node.patch

