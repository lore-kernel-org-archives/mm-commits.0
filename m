Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793739854;
	b=nmXpnW+nJhg0/HRLcfJaIn/gJyCXdgR60EzhtVxTfhXA6T1xcrxAC8r2fWc7oafk9fY5
	 Mu5PnPXy4ZvEytYyqLA50VDiaqwLvSnscq2eG8a6NGAnpXEXbfd8+DXxlAv878b+dPQ/9
	 kRDt7lrs10V8WBheO8m0jmyFrJ5fJ0VhrWGTNIWLRsOHclxK6MhASQHS5wMkKbCbGTLjT
	 p7R+e0OHlaX1nWl/csfQCJQCMbROSJStwpNcB+J4gZfhqkLvbIfwKUtQSFLesTmKPG0a5
	 xhR1IJUMyTFtwulDj3Q/i8/yzl+859ffnTXygARLcZxhyiONR9DFH+qNZT2TAOkkxXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793739854;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=/uaqUW62RzKg4WOQ+BBl99ebPj0uKO/LO38X1nkcnXM=;
	b=4uYijx/6yyaAaKex0b3PM+OcWijNaAxrGly4fIyfXF8h/MrCVjLmxVjSp9zJ7O/WEYyA
	 TNe4qLqwYRQ7PRo/bvZJbRXpNC7IIJjkUAoVgWkCcVka0Am+jIwMmngO3jJKRo84dWtS9
	 UkxAA3zLvjsdMXIGrniyI+JnlpFe8z7CyB6fDlEH8B1EJKxAxQHQ/jzePrv0xIrjuARzL
	 qVWZPm0JAfPcKqPrbdJ1j3RcSFv0Ods4LMqWLmBLU+w14CA9XcAFWDHmRQtP2zog9Q56m
	 /tHRV0eNqBjFsFVtmDnKb+vYcjQmEEDFFR4B2txzaH1P4TbO20oln9c4opMYOFK2srw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=aLZNF39v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D958E606A32C
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 21:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=aLZNF39v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8671F000C1;
	Tue,  3 Nov 2026 21:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793739853;
	bh=/uaqUW62RzKg4WOQ+BBl99ebPj0uKO/LO38X1nkcnXM=;
	h=Date:To:From:Subject;
	b=aLZNF39vEaPbklUC5C17nyEWWgpgiMTFEyXNl7H86AqaGEPVkIv3k8nvcnkvpUTWM
	 WewoWLinhKim1F1LQ5l6nz8VMKYYkPpDN2J9DGJ3OHKiMtDcquxDuw9zCh3wRbiQki
	 B284wwdIXTCeJr81Q2Sr/SPOYlqTKzTnZtVoLRCU=
Date: Tue, 03 Nov 2026 13:04:12 -0800
To: mm-commits@vger.kernel.org,wujianyue000@gmail.com,
	shikemeng@huaweicloud.com,ryncsn@gmail.com,nphamcs@gmail.com,
	kasong@tencent.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,
	baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-give-hibernation-swap-slots-their-own-swap-table-entry-type.patch added to mm-new branch
Message-Id: <20261103210413.4A8671F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm, swap: give hibernation swap slots their own swap table entry type
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-give-hibernation-swap-slots-their-own-swap-table-entry-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-give-hibernation-swap-slots-their-own-swap-table-entry-type.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Youngjun Park <youngjun.park@lge.com>
Subject: mm, swap: give hibernation swap slots their own swap table entry type
Date: Wed, 04 Nov 2026 00:25:46 +0800

swap_alloc_hibernation_slot() stores a fake shadow in the slot it hands
out.  An anon slot swapped out with no workingset shadow looks exactly the
same, so nothing in mm can tell the two apart.

Give hibernation slots their own type.  Bit 4 and every bit above it are
set, except the count field, which stays 0.  Bits 0 to 3 are taken by the
shadow, PFN, pointer and bad marks, so bit 4 is the first free one.  The
type holds no data, so the value alone says what it is.

The entry has no swap count.  Hibernation only allocates and frees a slot,
so a count would never change.  swap_free_hibernation_slot() frees the slot
directly, there is no count to put first.

The slot is no longer a shadow, so the previous patch keeps it out of the
swap cache.  The count field stays 0 as well, so code that reads the count
without checking the type sees an unused slot instead of one at
SWP_TB_COUNT_MAX, and a wrong put is caught by the existing underflow
check.

[kasong@tencent.com: renamed the layout entry to HIB and reworded its doc]
Link: https://lore.kernel.org/20261104-swap-hibernation-slots-v4-2-0ba9393609e1@tencent.com
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Kairui Song <kasong@tencent.com>
Link: https://lore.kernel.org/linux-mm/abp7aDgYLrxF3Me8@KASONG-MC4/
Acked-by: Kairui Song <kasong@tencent.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Jianyue Wu <wujianyue000@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>

---

 mm/swap_table.h |   14 ++++++++++++++
 mm/swapfile.c   |   13 +++++++------
 2 files changed, 21 insertions(+), 6 deletions(-)

--- a/mm/swapfile.c~mm-swap-give-hibernation-swap-slots-their-own-swap-table-entry-type
+++ a/mm/swapfile.c
@@ -941,7 +941,7 @@ static bool __swap_cluster_alloc_entries
 	 * upon folio unmap.
 	 *
 	 * Else, it's a exclusive order 0 allocation for hibernation.
-	 * The slot starts with count == 1 and never increases.
+	 * The slot carries no swap count and is freed by offset.
 	 */
 	if (likely(folio)) {
 		order = folio_order(folio);
@@ -953,8 +953,8 @@ static bool __swap_cluster_alloc_entries
 		order = 0;
 		nr_pages = 1;
 		swap_cluster_assert_empty(ci, ci_off, 1, false);
-		/* Fake shadow placeholder with no flag, hibernation does not use the zeromap */
-		__swap_table_set(ci, ci_off, __swp_tb_mk_count(shadow_to_swp_tb(NULL, 0), 1));
+		/* Exclusively owned by hibernation, must never enter the swap cache */
+		__swap_table_set(ci, ci_off, SWP_TB_HIB);
 	} else {
 		/* Allocation without folio is only possible with hibernation */
 		WARN_ON_ONCE(1);
@@ -1953,9 +1953,11 @@ void __swap_cluster_free_entries(struct
 		old_tb = __swap_table_get(ci, ci_off);
 		/*
 		 * Freeing is done after release of the last swap count
-		 * ref, or after swap cache is dropped
+		 * ref, or after swap cache is dropped. A hibernation slot
+		 * has no count and is freed directly by its owner.
 		 */
-		VM_WARN_ON(!swp_tb_is_shadow(old_tb) || __swp_tb_get_count(old_tb) > 1);
+		VM_WARN_ON(!swp_tb_is_hibernation(old_tb) &&
+			   (!swp_tb_is_shadow(old_tb) || __swp_tb_get_count(old_tb) > 1));
 
 		/* Resetting the slot to NULL also clears the inline flags. */
 		__swap_table_set(ci, ci_off, null_to_swp_tb());
@@ -2225,7 +2227,6 @@ void swap_free_hibernation_slot(swp_entr
 	pgoff_t offset = swp_offset(entry);
 
 	ci = swap_cluster_lock(si, offset);
-	__swap_cluster_put_entry(ci, offset % SWAPFILE_CLUSTER);
 	/*
 	 * A slot with a folio in the swap cache is freed when the folio
 	 * leaves the cache, the same rule swap_put_entries_cluster() follows.
--- a/mm/swap_table.h~mm-swap-give-hibernation-swap-slots-their-own-swap-table-entry-type
+++ a/mm/swap_table.h
@@ -30,6 +30,7 @@ struct swap_memcg_table {
  * PFN:      |SWAP_COUNT|Z|------ PFN -------|10| - Cached slot
  * Pointer:  |----------- Pointer ----------|100| - (Unused)
  * Bad:      |------------- 1 -------------|1000| - Bad slot
+ * HIB:      |    0     |------- 1 -------|10000| - Hibernation slot
  *
  * COUNT is `SWP_TB_COUNT_BITS` long, Z is the `SWP_TB_ZERO_FLAG` bit,
  * and together they form the `SWP_TB_FLAGS_BITS` wide flags field.
@@ -54,6 +55,11 @@ struct swap_memcg_table {
  *   aligned pointers.
  *
  * - Bad: Swap slot is reserved, protects swap header or holes on swap devices.
+ *
+ * - HIB: Swap slot is reserved by hibernation for the suspend image. It is a
+ *   special pin, like the swap cache pin: the allocator treats the non-NULL
+ *   entry as in use, but the slot is never duplicated and never enters the
+ *   swap cache. The count stays 0, so a stray put trips the underflow check.
  */
 
 /* NULL Entry, all 0 */
@@ -81,6 +87,9 @@ struct swap_memcg_table {
 /* Bad slot: ends with 0b1000 and rests of bits are all 1 */
 #define SWP_TB_BAD		((~0UL) << 3)
 
+/* Hibernation slot: ends with 0b10000, no count, rests of bits are all 1 */
+#define SWP_TB_HIB		(((~0UL) << 4) & ~SWP_TB_COUNT_MASK)
+
 /* Macro for shadow offset calculation */
 #define SWAP_COUNT_SHIFT	SWP_TB_FLAGS_BITS
 
@@ -166,6 +175,11 @@ static inline bool swp_tb_is_bad(unsigne
 	return swp_tb == SWP_TB_BAD;
 }
 
+static inline bool swp_tb_is_hibernation(unsigned long swp_tb)
+{
+	return swp_tb == SWP_TB_HIB;
+}
+
 static inline bool swp_tb_is_countable(unsigned long swp_tb)
 {
 	return (swp_tb_is_shadow(swp_tb) || swp_tb_is_folio(swp_tb) ||
_

Patches currently in -mm which might be from youngjun.park@lge.com are

mm-swap-only-allow-swapped-out-slots-into-the-swap-cache.patch
mm-swap-give-hibernation-swap-slots-their-own-swap-table-entry-type.patch
mm-swap-drop-the-swap-cache-guard-and-reclaim-in-swap_free_hibernation_slot.patch

