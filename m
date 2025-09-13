Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1AB11CA9
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 00:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757724974; cv=none; b=A0jLv7cK3q/n5mKOqs+BDlnzEnQ7QDyBBXBjKCx+exlQgTFNQcn3XNjZ+FkNfbRsJieH+OOAKFy8qYD3ajSJqAYUAfZx90QnVlkjQYvzfQH+uDaPnvyyE8W0aPvmKDiYpv6UkAnvz0DwjyluVvaBhfVxmRM66H5n+Ij0WDUfGMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757724974; c=relaxed/simple;
	bh=eP8FJxtAs9c6abQChQ5KTvvazc4b+GBh2xuUIGyViuM=;
	h=Date:To:From:Subject:Message-Id; b=QSCa01AEJSdlTIhmr+2VI7vyNiskebcrLlVxUT4eXFelKxQgZntgLhGvjR84d0mHQtJ7wpvV1zuoQPRxJ4eDtNOADSuchOuTSgDwissrMOfieIR3yFUXFo1jxORV1g2YYZIcuHLO0ctL7gv4qgbmYRpcc8grMUQtqesBSzcV/wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B7PXrIza; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B7PXrIza"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74AA8C4CEF1;
	Sat, 13 Sep 2025 00:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757724974;
	bh=eP8FJxtAs9c6abQChQ5KTvvazc4b+GBh2xuUIGyViuM=;
	h=Date:To:From:Subject:From;
	b=B7PXrIzacQ8VghGVy+opMx/pTZ9mEWSKrc35eSTD2evF//J7IQ0+hkdXEnzrryvGw
	 EuatjRasULTAdQTF+gW/qmPshpNPTyn7pJFef9vCcJ29/bFyRI8T0+WwlIZJOzkMzi
	 037AZ8dsZHnBeY2BsYa+sWsHlgSlVZgGdHKimj0A=
Date: Fri, 12 Sep 2025 17:56:13 -0700
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,agordeev@linux.ibm.com,balbirs@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode.patch added to mm-hotfixes-unstable branch
Message-Id: <20250913005614.74AA8C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: Fix warnings caused by use of arch_enter_lazy_mmu_mode()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode.patch

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
From: Balbir Singh <balbirs@nvidia.com>
Subject: kasan: Fix warnings caused by use of arch_enter_lazy_mmu_mode()
Date: Sat, 13 Sep 2025 09:55:15 +1000

commit c519c3c0a113 ("mm/kasan: avoid lazy MMU mode hazards") introduced
the use of arch_enter_lazy_mmu_mode(), which results in the compiler
complaining about "statement has no effect", when
__HAVE_ARCH_LAZY_MMU_MODE is not defined in include/linux/pgtable.h

The exact warning/error is:

In file included from ./include/linux/kasan.h:37,
                 from mm/kasan/shadow.c:14:
mm/kasan/shadow.c: In function `kasan_populate_vmalloc_pte':
./include/linux/pgtable.h:247:41: error: statement with no effect [-Werror=unused-value]
  247 | #define arch_enter_lazy_mmu_mode()      (LAZY_MMU_DEFAULT)
      |                                         ^
mm/kasan/shadow.c:322:9: note: in expansion of macro `arch_enter_lazy_mmu_mode'
  322 |         arch_enter_lazy_mmu_mode();
      |         ^~~~~~~~~~~~~~~~~~~~~~~~

Fix the issue by explicitly casting the use of the function to void,
since the returned state is not forwarded/retained

Link: https://lkml.kernel.org/r/20250912235515.367061-1-balbirs@nvidia.com
Fixes: c519c3c0a113 ("mm/kasan: avoid lazy MMU mode hazards")
Signed-off-by: Balbir Singh <balbirs@nvidia.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/shadow.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/kasan/shadow.c~kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode
+++ a/mm/kasan/shadow.c
@@ -319,7 +319,7 @@ static int kasan_populate_vmalloc_pte(pt
 	}
 	spin_unlock(&init_mm.page_table_lock);
 
-	arch_enter_lazy_mmu_mode();
+	(void)arch_enter_lazy_mmu_mode();
 
 	return 0;
 }
@@ -494,7 +494,7 @@ static int kasan_depopulate_vmalloc_pte(
 	if (likely(!none))
 		__free_page(pfn_to_page(pte_pfn(pte)));
 
-	arch_enter_lazy_mmu_mode();
+	(void)arch_enter_lazy_mmu_mode();
 
 	return 0;
 }
_

Patches currently in -mm which might be from balbirs@nvidia.com are

kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode.patch
mm-zone_device-support-large-zone-device-private-folios.patch
mm-huge_memory-add-device-private-thp-support-to-pmd-operations.patch
mm-rmap-extend-rmap-and-migration-support-device-private-entries.patch
mm-huge_memory-implement-device-private-thp-splitting.patch
mm-migrate_device-handle-partially-mapped-folios-during-collection.patch
mm-migrate_device-implement-thp-migration-of-zone-device-pages.patch
mm-memory-fault-add-thp-fault-handling-for-zone-device-private-pages.patch
lib-test_hmm-add-zone-device-private-thp-test-infrastructure.patch
mm-memremap-add-driver-callback-support-for-folio-splitting.patch
mm-migrate_device-add-thp-splitting-during-migration.patch
lib-test_hmm-add-large-page-allocation-failure-testing.patch
selftests-mm-hmm-tests-new-tests-for-zone-device-thp-migration.patch
selftests-mm-hmm-tests-new-throughput-tests-including-thp.patch
gpu-drm-nouveau-enable-thp-support-for-gpu-memory-migration.patch

