Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C691EF0BC
	for <mm-commits@vger.kernel.org>; Wed,  5 Mar 2025 23:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741218287; cv=none; b=WiXH7Lb4ZBUOwoGYumZOcnEz+EMdFXf8IpREpdKR2+E7Ie6CAfNdusg6yLVQpp3XR/1518ugkZkZX83fJ6qCGBuUlGDVIVy7YeDMjvBIb8Pd3i122KMtlDceWxh1IxoMwTkq7f2OtcAl8UctLHfYL+jQ/0plt0K6VFnHyv0NLcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741218287; c=relaxed/simple;
	bh=cBqp04W7No05c52/WpjMSCQfVBqpG+Q6OtBIU3EZoYs=;
	h=Date:To:From:Subject:Message-Id; b=CMKlC789p57JJ2CBvBWjuiXGkpQi+c7m5cfYnWYCb3y3wuut4AlWEGZW9U9UKb9DWS5b5o2NEVMiurHrKxwPli2gfoE+txfqa7r3Jshoc6xv28eKmOOlvWWrCe5LFXivedYjdWv0HnHm/Zk35j43zVMi2CGsPQmQblEbKp8/THU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eAV2VGwJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eAV2VGwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD4AC4CED1;
	Wed,  5 Mar 2025 23:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741218286;
	bh=cBqp04W7No05c52/WpjMSCQfVBqpG+Q6OtBIU3EZoYs=;
	h=Date:To:From:Subject:From;
	b=eAV2VGwJQGFvOaKztQ8U2OuKj+VIATyCHR68+3lD1BIsFw9Naf7DpQI5dozRwaWyN
	 mqD82shOL9IsGwQTVwZOIrmy1gyIQrOkRMzxBDznCF32Y3wyJL9y7cwCl9XYPjyCr0
	 BfkK4jDNRX9bv6eK4tKCmM3gEO5KJveGl6M1Dczo=
Date: Wed, 05 Mar 2025 15:44:46 -0800
To: mm-commits@vger.kernel.org,mika.westerberg@linux.intel.com,lizhijian@fujitsu.com,Jonathan.Cameron@huawei.com,ilpo.jarvinen@linux.intel.com,huang.ying.caritas@gmail.com,dan.j.williams@intel.com,bhelgaas@google.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] resource-fix-resource-leak-in-get_free_mem_region-fix.patch removed from -mm tree
Message-Id: <20250305234446.CCD4AC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: resource-fix-resource-leak-in-get_free_mem_region-fix
has been removed from the -mm tree.  Its filename was
     resource-fix-resource-leak-in-get_free_mem_region-fix.patch

This patch was dropped because it was folded into resource-fix-resource-leak-in-get_free_mem_region.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: resource-fix-resource-leak-in-get_free_mem_region-fix
Date: Tue Mar  4 04:11:59 PM PST 2025

fix braceology

Cc: Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Dan Wiliams <dan.j.williams@intel.com>
Cc: "Huang, Ying" <huang.ying.caritas@gmail.com>
Cc: Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Li Zhijian <lizhijian@fujitsu.com>
Cc: Mika Westeberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/resource.c~resource-fix-resource-leak-in-get_free_mem_region-fix
+++ a/kernel/resource.c
@@ -1998,10 +1998,11 @@ get_free_mem_region(struct device *dev,
 	if (flags & GFR_REQUEST_REGION) {
 		free_resource(res);
 		devres_free(dr);
-	} else if (dev)
+	} else if (dev) {
 		devm_release_action(dev, remove_free_mem_region, res);
-	else
+	} else {
 		free_resource(res);
+	}
 
 	return ERR_PTR(-ERANGE);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

nfs-fix-nfs_release_folio-to-not-deadlock-via-kcompactd-writeback-fix.patch
userfaultfd-do-not-block-on-locking-a-large-folio-with-raised-refcount-fix.patch
mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise-fix-checkpatch-fixes.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix.patch
selftests-mm-print-some-details-when-uffd-stress-gets-bad-params-fix.patch
selftests-mm-dont-fail-uffd-stress-if-too-many-cpus-fix.patch
mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix.patch
mm-mremap-initial-refactor-of-move_vma-fix.patch
mm-mremap-thread-state-through-move-page-table-operation-fix.patch
mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option-fix.patch
lib-plistc-add-shortcut-for-plist_requeue-fix.patch
scsi-lpfc-convert-timeouts-to-secs_to_jiffies-fix.patch
signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset-fix.patch
resource-fix-resource-leak-in-get_free_mem_region.patch

