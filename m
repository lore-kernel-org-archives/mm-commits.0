Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE27143759
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291610; cv=none; b=OEqw138HOpZoi0F/a6sdiJfyIIPfv0bO8Qsii52zGymFLUtyX3KTe4Ay1yetCybHCuQOIY3NR96AJsoycE2RJR260M3cWve+DkGM6aFiFOw4tqqtgws5ON060VV4EMeMci7vCJz4yR/kSpO5By1327+GLRQbgWon6yCNUrXfPGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291610; c=relaxed/simple;
	bh=fGjhoOmtfWYswduPaNH0QXKVXXBe4uGH3eecWigMqUY=;
	h=Date:To:From:Subject:Message-Id; b=Yb4fPO50E8bqnQcwVRosT3TsUqkWJVKZ62n2MnyrKpPwp0tI0q2FeX25UjrkFwGyLybbamgRH5v/qEEuHEAjaNeBBAY1TwzKJ5DvQKzcv21DjAsxRjG3KdRHmYoU+FhONO+CpKyewx/I9n5HsTxkWF+miLdvWDC8rs/AoRnu+Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yZDHtCRb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yZDHtCRb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E39C32782;
	Tue, 25 Jun 2024 05:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291610;
	bh=fGjhoOmtfWYswduPaNH0QXKVXXBe4uGH3eecWigMqUY=;
	h=Date:To:From:Subject:From;
	b=yZDHtCRbCUBTTWDoytoozktvjrBamNV0+C/24Ffz0elseLwu8nEaA5G53sJuBr6BE
	 pTgcKFLnqH1S6DiA4l/KWnolTLy5yNikSgDxRxvfHkI2XtoGTY8uOs1470gEoO3lry
	 UqTejnXaXaaImhPT9NJvdEjc5gpXcsgHM7XSpGC8=
Date: Mon, 24 Jun 2024 22:00:09 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,yosryahmed@google.com,ying.huang@intel.com,xiang@kernel.org,willy@infradead.org,surenb@google.com,ryan.roberts@arm.com,rafael@kernel.org,pavel@ucw.cz,len.brown@intel.com,khalid.aziz@oracle.com,kasong@tencent.com,hughd@google.com,hch@infradead.org,hannes@cmpxchg.org,hanchuanhua@oppo.com,david@redhat.com,davem@davemloft.net,chrisl@kernel.org,baolin.wang@linux.alibaba.com,andreas@gaisler.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-pte_move_swp_offset-helper-which-can-move-offset-bidirectionally.patch removed from -mm tree
Message-Id: <20240625050010.74E39C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce pte_move_swp_offset() helper which can move offset bidirectionally
has been removed from the -mm tree.  Its filename was
     mm-introduce-pte_move_swp_offset-helper-which-can-move-offset-bidirectionally.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: introduce pte_move_swp_offset() helper which can move offset bidirectionally
Date: Wed, 29 May 2024 20:28:21 +1200

There could arise a necessity to obtain the first pte_t from a swap pte_t
located in the middle.  For instance, this may occur within the context of
do_swap_page(), where a page fault can potentially occur in any PTE of a
large folio.  To address this, the following patch introduces
pte_move_swp_offset(), a function capable of bidirectional movement by a
specified delta argument.  Consequently, pte_next_swp_offset() will
directly invoke it with delta = 1.

Link: https://lkml.kernel.org/r/20240529082824.150954-4-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Suggested-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Chuanhua Han <hanchuanhua@oppo.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

--- a/mm/internal.h~mm-introduce-pte_move_swp_offset-helper-which-can-move-offset-bidirectionally
+++ a/mm/internal.h
@@ -211,18 +211,21 @@ static inline int folio_pte_batch(struct
 }
 
 /**
- * pte_next_swp_offset - Increment the swap entry offset field of a swap pte.
+ * pte_move_swp_offset - Move the swap entry offset field of a swap pte
+ *	 forward or backward by delta
  * @pte: The initial pte state; is_swap_pte(pte) must be true and
  *	 non_swap_entry() must be false.
+ * @delta: The direction and the offset we are moving; forward if delta
+ *	 is positive; backward if delta is negative
  *
- * Increments the swap offset, while maintaining all other fields, including
+ * Moves the swap offset, while maintaining all other fields, including
  * swap type, and any swp pte bits. The resulting pte is returned.
  */
-static inline pte_t pte_next_swp_offset(pte_t pte)
+static inline pte_t pte_move_swp_offset(pte_t pte, long delta)
 {
 	swp_entry_t entry = pte_to_swp_entry(pte);
 	pte_t new = __swp_entry_to_pte(__swp_entry(swp_type(entry),
-						   (swp_offset(entry) + 1)));
+						   (swp_offset(entry) + delta)));
 
 	if (pte_swp_soft_dirty(pte))
 		new = pte_swp_mksoft_dirty(new);
@@ -234,6 +237,20 @@ static inline pte_t pte_next_swp_offset(
 	return new;
 }
 
+
+/**
+ * pte_next_swp_offset - Increment the swap entry offset field of a swap pte.
+ * @pte: The initial pte state; is_swap_pte(pte) must be true and
+ *	 non_swap_entry() must be false.
+ *
+ * Increments the swap offset, while maintaining all other fields, including
+ * swap type, and any swp pte bits. The resulting pte is returned.
+ */
+static inline pte_t pte_next_swp_offset(pte_t pte)
+{
+	return pte_move_swp_offset(pte, 1);
+}
+
 /**
  * swap_pte_batch - detect a PTE batch for a set of contiguous swap entries
  * @start_ptep: Page table pointer for the first entry.
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix-2.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix-3.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix-2.patch
mm-remove-folio_test_anonfolio==false-path-in-__folio_add_anon_rmap.patch
tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout.patch

