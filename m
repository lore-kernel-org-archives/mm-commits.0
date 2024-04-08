Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773BE146599;
	Mon,  8 Apr 2024 20:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712606789; cv=none; b=YRFdZ94CpfZhp4qLQVrbR9xP9l2JgaFErBHG/CmdRuTWpAJhAVJLISSoWdQOjhiYhYOQ6yYMD086yxUksYNff+r3so/gTMsgwWrsKjLoXffYU92W57O9r/zq2ZcAQlzKOAOba1GWLrB2n4A8Wj3hmUQtdrLD4UawbWAWoK8OIwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712606789; c=relaxed/simple;
	bh=eFE2dH4ytMIV14GgPA1GBe0ikpGJetNo1z24JXkUMSY=;
	h=Date:To:From:Subject:Message-Id; b=qVSXesdY16bH4d7dIIm/XuD3CsLCDXwj8orhICkNHUf+yZgR7bHzx6FnHnUw5BDjWZywHlguj2Hprw4uFvXqHi8EXGPggPyZrwImVRzJXQ4zmtUYei9Nu5vGH+BnaXFmjr7e8iKg5mBnPINVPbzm2kjjt3+FAi4zf+TQdZqX7i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HdwKx4zN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HdwKx4zN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06BD1C433C7;
	Mon,  8 Apr 2024 20:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712606789;
	bh=eFE2dH4ytMIV14GgPA1GBe0ikpGJetNo1z24JXkUMSY=;
	h=Date:To:From:Subject:From;
	b=HdwKx4zNHOgyCsOQOoJzKWFQ5dgXsC9aLI5S3WDgCX5YOrLx3pWk9ZAa3a9OYnifh
	 kqxFoRPCTfmLlrpGEn1NS/uSTBAxgpfAq6AzOO/WscA+kEPF39u/ksl/R0tvJ2L3lQ
	 1vKFbztQW+iZRXvh6jt80lbvnJosVR5cnK0RLSnU=
Date: Mon, 08 Apr 2024 13:06:28 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,stable@vger.kernel.org,peterx@redhat.com,linmiaohe@huawei.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmswapops-update-check-in-is_pfn_swap_entry-for-hwpoison-entries.patch added to mm-hotfixes-unstable branch
Message-Id: <20240408200629.06BD1C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,swapops: update check in is_pfn_swap_entry for hwpoison entries
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mmswapops-update-check-in-is_pfn_swap_entry-for-hwpoison-entries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmswapops-update-check-in-is_pfn_swap_entry-for-hwpoison-entries.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mmpage_owner-update-metadata-for-tail-pages.patch
mmpage_owner-fix-refcount-imbalance.patch
mmpage_owner-fix-accounting-of-pages-when-migrating.patch
mmpage_owner-fix-printing-of-stack-records.patch
mmswapops-update-check-in-is_pfn_swap_entry-for-hwpoison-entries.patch

