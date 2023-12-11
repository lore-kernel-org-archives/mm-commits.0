Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1393F4E1AD
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 17:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mGU9kr+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E92C433C8;
	Mon, 11 Dec 2023 17:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702316242;
	bh=IOBLem/mSToOHTit24TuoYR1AYomL0LKN+fQtY8Zb7g=;
	h=Date:To:From:Subject:From;
	b=mGU9kr+5WulyBWVqapRYPaaLMaUVSwskT0a3y6Shp3aCmL2vd6pfrytyzMn9BAMq9
	 2WJzmbE7TS7n/T4KlxSlR1WCaR0rCmccao+r8kir+loaeFlyZxnLKmXg1HYSLZgfd9
	 CqoLqXjyLazYWBN6WFA9j/HVvX090yW4TNBeDw/4=
Date: Mon, 11 Dec 2023 09:37:21 -0800
To: mm-commits@vger.kernel.org,lkp@intel.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-introduce-multi-size-thp-sysfs-interface-fix.patch added to mm-unstable branch
Message-Id: <20231211173722.87E92C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: thp: Fix build warning when CONFIG_SYSFS is disabled
has been added to the -mm mm-unstable branch.  Its filename is
     mm-thp-introduce-multi-size-thp-sysfs-interface-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-introduce-multi-size-thp-sysfs-interface-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: thp: Fix build warning when CONFIG_SYSFS is disabled
Date: Mon, 11 Dec 2023 12:53:20 +0000

huge_anon_orders_lock is used only to serialize sysfs writers.  So move
its definition so that it is within the CONFIG_SYSFS ifdefery to suppress
"defined but not used" warning when sysfs is disabled.

Link: https://lkml.kernel.org/r/20231211125320.3997543-1-ryan.roberts@arm.com
Fixes: fe2c9313a8c0 ("mm: thp: Introduce multi-size THP sysfs interface")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202312111916.YbsHxKPq-lkp@intel.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-thp-introduce-multi-size-thp-sysfs-interface-fix
+++ a/mm/huge_memory.c
@@ -77,7 +77,6 @@ unsigned long huge_zero_pfn __read_mostl
 unsigned long huge_anon_orders_always __read_mostly;
 unsigned long huge_anon_orders_madvise __read_mostly;
 unsigned long huge_anon_orders_inherit __read_mostly;
-static DEFINE_SPINLOCK(huge_anon_orders_lock);
 
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 unsigned long vm_flags, bool smaps,
@@ -442,6 +441,7 @@ static const struct attribute_group huge
 
 static void hugepage_exit_sysfs(struct kobject *hugepage_kobj);
 static void thpsize_release(struct kobject *kobj);
+static DEFINE_SPINLOCK(huge_anon_orders_lock);
 static LIST_HEAD(thpsize_list);
 
 struct thpsize {
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-readahead-do-not-allow-order-1-folio.patch
mm-allow-deferred-splitting-of-arbitrary-anon-large-folios.patch
mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch
mm-thp-introduce-multi-size-thp-sysfs-interface.patch
mm-thp-introduce-multi-size-thp-sysfs-interface-fix.patch
mm-thp-support-allocation-of-anonymous-multi-size-thp.patch
selftests-mm-kugepaged-restore-thp-settings-at-exit.patch
selftests-mm-factor-out-thp-settings-management.patch
selftests-mm-support-multi-size-thp-interface-in-thp_settings.patch
selftests-mm-khugepaged-enlighten-for-multi-size-thp.patch
selftests-mm-cow-generalize-do_run_with_thp-helper.patch
selftests-mm-cow-add-tests-for-anonymous-multi-size-thp.patch

