Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730611E511;
	Tue, 16 Apr 2024 22:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713307228; cv=none; b=ipAllN68yJuNV6N7wCdfDGYuxkpH2jmSlDvsLislxUDhhr4Qgzqld5Wb9Dp55q8myqL7yKeZeuQCGS9WKJfo33tvJQFNz3nAqEdQlP3WBIRCBP8HKqVwGK166QmAdx14vnD6hwILT9ij5blaPqiHHIqLxCTOqEudmlXZN+jIbK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713307228; c=relaxed/simple;
	bh=f+DBZ/WCs5frMGEdDpCafRYjmnCevsThD79heZG4s1E=;
	h=Date:To:From:Subject:Message-Id; b=RkAIXj3rwAxn8/5thvavekOt+OEH8icO5+WgQ4f6cbdssdjyLkbOdp72ClX88t0+/zYNYt4G3idC1P2HYuR0ZUl4WSW/DwVe3a537XPOwZ7JjxwQ5VVmM6QOwfjbmYby+rHyLxp/GL2Mf0Ik01tTvNplvCBbS/zJ/x49FNjwze4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x5GhLTLE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x5GhLTLE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46629C113CE;
	Tue, 16 Apr 2024 22:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713307228;
	bh=f+DBZ/WCs5frMGEdDpCafRYjmnCevsThD79heZG4s1E=;
	h=Date:To:From:Subject:From;
	b=x5GhLTLEH9QopDxNKSaGeTru6i9RbgWsqlbvT3smKaISJ5PO/GAcHRPEUdn3aYFLQ
	 eFFwrkDywEr78Z4WBH24Ef0xYMZONggc7EFtRzX2dYh9kAguxWdfVPG4cAFTK62qDg
	 XMDLyOJde0KY6jG03uGUH9MpYV4T9e40JY5/qUa8=
Date: Tue, 16 Apr 2024 15:40:27 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,stable@vger.kernel.org,peterx@redhat.com,linmiaohe@huawei.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mmswapops-update-check-in-is_pfn_swap_entry-for-hwpoison-entries.patch removed from -mm tree
Message-Id: <20240416224028.46629C113CE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm,swapops: update check in is_pfn_swap_entry for hwpoison entries
has been removed from the -mm tree.  Its filename was
     mmswapops-update-check-in-is_pfn_swap_entry-for-hwpoison-entries.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,swapops: update check in is_pfn_swap_entry for hwpoison entries
Date: Sun, 7 Apr 2024 15:05:37 +0200

Tony reported that the Machine check recovery was broken in v6.9-rc1, as
he was hitting a VM_BUG_ON when injecting uncorrectable memory errors to
DRAM.

After some more digging and debugging on his side, he realized that this
went back to v6.1, with the introduction of 'commit 0d206b5d2e0d
("mm/swap: add swp_offset_pfn() to fetch PFN from swap entry")'.  That
commit, among other things, introduced swp_offset_pfn(), replacing
hwpoison_entry_to_pfn() in its favour.

The patch also introduced a VM_BUG_ON() check for is_pfn_swap_entry(), but
is_pfn_swap_entry() never got updated to cover hwpoison entries, which
means that we would hit the VM_BUG_ON whenever we would call
swp_offset_pfn() for such entries on environments with CONFIG_DEBUG_VM
set.  Fix this by updating the check to cover hwpoison entries as well,
and update the comment while we are it.

Link: https://lkml.kernel.org/r/20240407130537.16977-1-osalvador@suse.de
Fixes: 0d206b5d2e0d ("mm/swap: add swp_offset_pfn() to fetch PFN from swap entry")
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reported-by: Tony Luck <tony.luck@intel.com>
Closes: https://lore.kernel.org/all/Zg8kLSl2yAlA3o5D@agluck-desk3/
Tested-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: <stable@vger.kernel.org>	[6.1.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |   65 +++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 32 deletions(-)

--- a/include/linux/swapops.h~mmswapops-update-check-in-is_pfn_swap_entry-for-hwpoison-entries
+++ a/include/linux/swapops.h
@@ -390,6 +390,35 @@ static inline bool is_migration_entry_di
 }
 #endif	/* CONFIG_MIGRATION */
 
+#ifdef CONFIG_MEMORY_FAILURE
+
+/*
+ * Support for hardware poisoned pages
+ */
+static inline swp_entry_t make_hwpoison_entry(struct page *page)
+{
+	BUG_ON(!PageLocked(page));
+	return swp_entry(SWP_HWPOISON, page_to_pfn(page));
+}
+
+static inline int is_hwpoison_entry(swp_entry_t entry)
+{
+	return swp_type(entry) == SWP_HWPOISON;
+}
+
+#else
+
+static inline swp_entry_t make_hwpoison_entry(struct page *page)
+{
+	return swp_entry(0, 0);
+}
+
+static inline int is_hwpoison_entry(swp_entry_t swp)
+{
+	return 0;
+}
+#endif
+
 typedef unsigned long pte_marker;
 
 #define  PTE_MARKER_UFFD_WP			BIT(0)
@@ -483,8 +512,9 @@ static inline struct folio *pfn_swap_ent
 
 /*
  * A pfn swap entry is a special type of swap entry that always has a pfn stored
- * in the swap offset. They are used to represent unaddressable device memory
- * and to restrict access to a page undergoing migration.
+ * in the swap offset. They can either be used to represent unaddressable device
+ * memory, to restrict access to a page undergoing migration or to represent a
+ * pfn which has been hwpoisoned and unmapped.
  */
 static inline bool is_pfn_swap_entry(swp_entry_t entry)
 {
@@ -492,7 +522,7 @@ static inline bool is_pfn_swap_entry(swp
 	BUILD_BUG_ON(SWP_TYPE_SHIFT < SWP_PFN_BITS);
 
 	return is_migration_entry(entry) || is_device_private_entry(entry) ||
-	       is_device_exclusive_entry(entry);
+	       is_device_exclusive_entry(entry) || is_hwpoison_entry(entry);
 }
 
 struct page_vma_mapped_walk;
@@ -561,35 +591,6 @@ static inline int is_pmd_migration_entry
 }
 #endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
 
-#ifdef CONFIG_MEMORY_FAILURE
-
-/*
- * Support for hardware poisoned pages
- */
-static inline swp_entry_t make_hwpoison_entry(struct page *page)
-{
-	BUG_ON(!PageLocked(page));
-	return swp_entry(SWP_HWPOISON, page_to_pfn(page));
-}
-
-static inline int is_hwpoison_entry(swp_entry_t entry)
-{
-	return swp_type(entry) == SWP_HWPOISON;
-}
-
-#else
-
-static inline swp_entry_t make_hwpoison_entry(struct page *page)
-{
-	return swp_entry(0, 0);
-}
-
-static inline int is_hwpoison_entry(swp_entry_t swp)
-{
-	return 0;
-}
-#endif
-
 static inline int non_swap_entry(swp_entry_t entry)
 {
 	return swp_type(entry) >= MAX_SWAPFILES;
_

Patches currently in -mm which might be from osalvador@suse.de are


