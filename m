Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7A77E107
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248357; cv=none; b=iBd6M6UX0wUENUP6aK8/GtwM2hF29IgRU/qQ6ryll61txCuSTR7K/91O9vmPlBfQWPy9BfDzCTFuGcPXXW9y1wMmV+iptAcsV1QRhH117CBaDeky05JJdu1wLJEQe9RbMZPcEXtgROwjoN+2fF5n+3jvuGH9JJ7uIqLVJUYGQCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248357; c=relaxed/simple;
	bh=S97Q6R6WaLQNyGtfFz7Yg3SPY1IXGFpeRyC48psEF0s=;
	h=Date:To:From:Subject:Message-Id; b=m4tjhpsujd5c+0PH4fLHa3oXZPLUXx4ZWpkk/S63JKAG+8pJkKIvyToVJHaUG1jK4+ymAA8Jo4d1Q4tln1E8TmgSC1AIp48KbQzSgOBA+otwee33zN7zmbWWL8mziufEevvt5SPFPHeBPPVCELrjMzMF3ws5OeA2CjSINjnK0pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P7wZVzY+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P7wZVzY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998C9C4CEC2;
	Mon,  2 Sep 2024 03:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248356;
	bh=S97Q6R6WaLQNyGtfFz7Yg3SPY1IXGFpeRyC48psEF0s=;
	h=Date:To:From:Subject:From;
	b=P7wZVzY+w6EoMAG8Mo1g1Q7DRBZIgNW9OdmbsvNEafwVe3fyopGEsn6SzW5b2YcU4
	 V/l1z/PXxrfX5mpiSxiQ/dCQOshnVv7tBhb08J+LgNVtJNuejZ7Q7L7zNnwyVC80am
	 0l0dmhJsInQ7tvFeDcZ37cAFGf9FOWKlf8zMqHTA=
Date: Sun, 01 Sep 2024 20:39:16 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,jani.nikula@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fault-inject-improve-build-for-config_fault_injection=n-fix-2.patch removed from -mm tree
Message-Id: <20240902033916.998C9C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fault-inject-improve-build-for-config_fault_injection=n-fix-2
has been removed from the -mm tree.  Its filename was
     fault-inject-improve-build-for-config_fault_injection=n-fix-2.patch

This patch was dropped because it was folded into fault-inject-improve-build-for-config_fault_injection=n.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fault-inject-improve-build-for-config_fault_injection=n-fix-2
Date: Thu Aug 15 02:41:21 PM PDT 2024

fix drivers/misc/xilinx_tmr_inject.c

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202408160254.7w492KEu-lkp@intel.com/
Cc: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/xilinx_tmr_inject.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/misc/xilinx_tmr_inject.c~fault-inject-improve-build-for-config_fault_injection=n-fix-2
+++ a/drivers/misc/xilinx_tmr_inject.c
@@ -12,6 +12,7 @@
 #include <asm/xilinx_mb_manager.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/debugfs.h>
 #include <linux/platform_device.h>
 #include <linux/fault-inject.h>
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-contig_alloc-support-__gfp_comp-fix.patch
selftests-mm-add-more-mseal-traversal-tests-fix.patch
selftests-mm-add-more-mseal-traversal-tests-fix-fix.patch
mm-remove-pageactive-fix.patch
selftests-test_zswap-add-test-for-hierarchical-zswapwriteback-fix.patch
mm-count-the-number-of-anonymous-thps-per-size-fix.patch
mm-memory-failure-add-unmap_poisoned_folio-fix.patch
mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix-fix.patch
lib-maple_treec-remove-unused-functions.patch
fault-inject-improve-build-for-config_fault_injection=n.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-3.patch

