Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC11915D1
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 06:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757743422; cv=none; b=bu9HjLWJZ+zzeMStoKtcl5tYIIgUenRHmo7GfOJR70BkzujnYFjEX3F5kJFV+A/B5F161BRx9PQvsGZgt3dVNfI2n/KNL9GLaDUIiVydQ8F9wZwO5rHUFTFJqD7JzSzmgU8h8kil+1omfneenO5KA8+OFyhF9AMU4yTjAa5kBGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757743422; c=relaxed/simple;
	bh=X82C45ShpojpIPmCshsK8SLErkHBfR21BQ/sZPNQeS0=;
	h=Date:To:From:Subject:Message-Id; b=UhXP/eSp6mGyjAA4dWqxF0p665UWpAuFupv6vtx9tGqNWRCWxozSImkQSuQv/vcAWxDWa+sV192DAGVe18zzGNTjmJHQ6auJkN+a8bpasiyMzvnzWUrr2CUXyp5ewY0i4PbA5sZqFEMq5ZMDx0biOkmlbJYb6V3F7IQ6Sw6XSX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KAprNNqd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KAprNNqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC4DC4CEEB;
	Sat, 13 Sep 2025 06:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757743422;
	bh=X82C45ShpojpIPmCshsK8SLErkHBfR21BQ/sZPNQeS0=;
	h=Date:To:From:Subject:From;
	b=KAprNNqdZvYNvECP8MiUrhwC3Qi/qH3LB0riQyu7x2IqKxl2Y44LTGJ2cuiuiZGzT
	 YG2/uI2cUQLsVcNp42xflPs+u77N2t2Cw5iOWjPk+/ec5dHGP9rIvymqX53oWGbm3I
	 pKnEe0psPO5fC1umP7rQvjxpPO54hi5YorLu1ahM=
Date: Fri, 12 Sep 2025 23:03:41 -0700
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,lkp@intel.com,balbirs@nvidia.com,agordeev@linux.ibm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20250913060342.3DC4DC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix
Date: Fri Sep 12 10:55:48 PM PDT 2025

fix s390 build

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202509131255.x9EfvIGt-lkp@intel.com/
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/shadow.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/kasan/shadow.c~kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix
+++ a/mm/kasan/shadow.c
@@ -319,7 +319,7 @@ static int kasan_populate_vmalloc_pte(pt
 	}
 	spin_unlock(&init_mm.page_table_lock);
 
-	(void)arch_enter_lazy_mmu_mode();
+	arch_enter_lazy_mmu_mode();
 
 	return 0;
 }
@@ -494,7 +494,7 @@ static int kasan_depopulate_vmalloc_pte(
 	if (likely(!none))
 		__free_page(pfn_to_page(pte_pfn(pte)));
 
-	(void)arch_enter_lazy_mmu_mode();
+	arch_enter_lazy_mmu_mode();
 
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix.patch
mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix.patch
mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix-fix.patch
mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors-fix.patch
memcg-optimize-exit-to-user-space-fix.patch
memfd-move-mfd_all_flags-definition-to-memfdh.patch
mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch
mm-filemap-align-last_index-to-folio-size-fix-fix.patch
mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix.patch
panic-remove-redundant-panic-cpu-backtrace-fix.patch
crash-add-kunit-tests-for-crash_exclude_mem_range-fix.patch

