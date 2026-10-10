Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B234B44C6;
	Sat, 10 Oct 2026 19:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791659559; cv=none; b=gtMkmhNys7Lb0kfjhq2W65juujoQNzQAmaWBbCgwSNAk97jQO0IuznZxS6xzOJ20TGE5cg7GYj/DO+TVCsZdPat2RxiH28/no6MTfLTCMiEvOl85FaJlJ5aLa6Cp2uAzM3ZVMhX/Nu8gLjhiHlVw7JB90ED2lDMCFP3NAX75B3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791659559; c=relaxed/simple;
	bh=C8dhOMAvzqB/pWyOA2TQ56vcpMFtnMqp/TrZUi2v4sQ=;
	h=Date:To:From:Subject:Message-Id; b=R0GUOLOC0RJ4ldWmUXDj6EQ8K8ZeUiJVZk4frvuQHbHpCHLnwoE9Kzczxnbk/7PGJG2xLWRAwbjShOykkhAIvGz8yjhICCZzop2y5TR02cz8tHv6oUDpYvXpC3hC5lBEXmJcEEOAPviN3hGIRNlHxzkl33yHQaO3IzwPx6Iksms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MxXSYgDM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MxXSYgDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87391F00893;
	Sat, 10 Oct 2026 19:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791659551;
	bh=qV7XfIQNA4NXHQcnMvIujTdMhhEhzpF1e19HABkRIkw=;
	h=Date:To:From:Subject;
	b=MxXSYgDMHHR7yZ/YNf7GSyF19lPLEZvsB7S9aAgyzEe0T1ZyP5AefvuPTOgdMFwZD
	 xCUUItAs9kpHoUIlOW7TnL/+5ILo7CtWwz3T6xjBr0/AyK/ZWbV7URHsLzK7GMIvmv
	 K2Cc5PmXATgqdN3a7/dMYZZwoyDbhebVEHT2aFs0=
Date: Sat, 10 Oct 2026 12:12:31 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,stable@vger.kernel.org,pjw@kernel.org,palmer@dabbelt.com,osalvador@suse.de,mark.rutland@arm.com,kevin.brodsky@arm.com,david@kernel.org,dave.hansen@intel.com,catalin.marinas@arm.com,bjorn@rivosinc.com,apopple@nvidia.com,aou@eecs.berkeley.edu,alex@ghiti.fr,agordeev@linux.ibm.com,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch added to mm-unstable branch
Message-Id: <20261010191231.C87391F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64/mm: fix destructor for unconstructed hotplug page tables
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Muchun Song <muchun.song@linux.dev>
Subject: arm64/mm: fix destructor for unconstructed hotplug page tables
Date: Sat, 10 Oct 2026 19:24:57 +0800

Commit c594b83457cc ("arm64: mm: call pagetable dtor when freeing
hot-removed page tables") made free_hotplug_pgtable_page()
unconditionally run the page-table destructor. This matches page tables
allocated by the arm64 mapping code, which runs the corresponding
constructors.

However, arm64 also uses the generic sparse-vmemmap population code.
Runtime intermediate page tables allocated by that code do not run a
page-table constructor. Freeing one during memory hot-remove therefore
runs a destructor without a matching constructor and corrupts
NR_PAGETABLE accounting.

Free intermediate page-table pages through pagetable_free(). It runs the
destructor only for constructor-backed pages and then releases the page
through the page-table freeing path.

Link: https://lore.kernel.org/20261010112457.49485-5-songmuchun@bytedance.com
Fixes: c594b83457cc ("arm64: mm: call pagetable dtor when freeing hot-removed page tables")
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Björn Töpel <bjorn@rivosinc.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: <stable@vger.kernel.org>
---

 arch/arm64/mm/mmu.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/arm64/mm/mmu.c~arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables
+++ a/arch/arm64/mm/mmu.c
@@ -1495,8 +1495,7 @@ static void free_hotplug_page_range(stru
 
 static void free_hotplug_pgtable_page(struct page *page)
 {
-	pagetable_dtor(page_ptdesc(page));
-	free_hotplug_page_range(page, PAGE_SIZE, NULL);
+	pagetable_free(page_ptdesc(page));
 }
 
 static bool pgtable_range_aligned(unsigned long start, unsigned long end,
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-sparse-vmemmap-drop-vmemmap_populate_dax.patch
mm-sparse-vmemmap-support-device-dax-in-common-vmemmap-path.patch
mm-sparse-vmemmap-drop-device-dax-specific-population-path.patch
mm-sparse-vmemmap-remove-the-unused-ptpfn-argument.patch
mm-sparse-vmemmap-open-code-vmemmap_populate_address.patch
mm-mm_init-add-zone-mismatch-warning-during-page-init.patch
mm-fix-missing-page-table-destructor-in-pagetable_free.patch
riscv-mm-fix-hotplug-page-table-destructor-handling.patch
riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch

