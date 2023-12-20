Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7704B143
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 22:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cWHriIiM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCACC433D9;
	Wed, 20 Dec 2023 22:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703111941;
	bh=ECbM5z3IgxB0vS+a0IJNfUecb0FCpD2gJZunwvG3ChI=;
	h=Date:To:From:Subject:From;
	b=cWHriIiMk1d3Bc4px/oOOdlFCxjOrXaS9DJl3Pd4VPcfRV6X6OANC9qYsBgvduv+w
	 Orxmzn2s4lMKi/6rCGuJibImLOaxDMWvPkzeB+v16+UL0+P/37biHm83K5YY2drhDW
	 4h8knWQ+mUMuKS4jgUd+ZKrV6mqHThKup8Kja5Rk=
Date: Wed, 20 Dec 2023 14:39:00 -0800
To: mm-commits@vger.kernel.org,lkp@intel.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-thp-introduce-multi-size-thp-sysfs-interface-fix.patch removed from -mm tree
Message-Id: <20231220223901.6CCACC433D9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: thp: fix build warning when CONFIG_SYSFS is disabled
has been removed from the -mm tree.  Its filename was
     mm-thp-introduce-multi-size-thp-sysfs-interface-fix.patch

This patch was dropped because it was folded into mm-thp-introduce-multi-size-thp-sysfs-interface.patch

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: thp: fix build warning when CONFIG_SYSFS is disabled
Date: Mon, 11 Dec 2023 12:53:20 +0000

huge_anon_orders_lock is used only to serialize sysfs writers.  So move
its definition so that it is within the CONFIG_SYSFS ifdefery to suppress
"defined but not used" warning when sysfs is disabled.

Link: https://lkml.kernel.org/r/20231211125320.3997543-1-ryan.roberts@arm.com
Fixes: ("mm: thp: Introduce multi-size THP sysfs interface")
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

mm-allow-deferred-splitting-of-arbitrary-anon-large-folios.patch
mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch
mm-thp-introduce-multi-size-thp-sysfs-interface.patch
mm-thp-support-allocation-of-anonymous-multi-size-thp.patch
mm-thp-support-allocation-of-anonymous-multi-size-thp-fix.patch
selftests-mm-kugepaged-restore-thp-settings-at-exit.patch
selftests-mm-factor-out-thp-settings-management.patch
selftests-mm-support-multi-size-thp-interface-in-thp_settings.patch
selftests-mm-khugepaged-enlighten-for-multi-size-thp.patch
selftests-mm-cow-generalize-do_run_with_thp-helper.patch
selftests-mm-cow-add-tests-for-anonymous-multi-size-thp.patch
selftests-mm-log-run_vmtestssh-results-in-tap-format.patch

