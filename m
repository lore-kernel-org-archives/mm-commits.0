Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0E1539A
	for <mm-commits@vger.kernel.org>; Wed,  5 Mar 2025 00:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741133558; cv=none; b=bjAcApK1kZJGphLja0P5t+lUitk8xYo5GgNtTfChkK0qsFCkeZVWbfudG1uDJ47YuJiP90jDgAe7th7VlRofYChQfdXRNk2Xs5Nay+XwabbbNOtdUPm0dpuhmftktYaQkytTgazPWUPHTlag3dnZq9E4yBn4w7LHV83IS36/oRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741133558; c=relaxed/simple;
	bh=E3q05nCxCbX1oaDSPakjDJt2D713ydwZNZuYm+ZNAq4=;
	h=Date:To:From:Subject:Message-Id; b=LxPRbZdSoz+yUogNBrpyZmAXk9ZRv2yyvaCK4FqlQzp+K4ov+Mnn6l69KVYhuKveBQZE0kvtDDNjJ0eRF9m/Y88hgj/opjBDX19Me3c/dqdFraSZ2c1SgRPNmWIgPMIZB12JwHZE2kR0K1qgU7Ckc16DdeCRcl29jNjlK8/nBLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eYJwpPZD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eYJwpPZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78AAC4CEE5;
	Wed,  5 Mar 2025 00:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741133557;
	bh=E3q05nCxCbX1oaDSPakjDJt2D713ydwZNZuYm+ZNAq4=;
	h=Date:To:From:Subject:From;
	b=eYJwpPZD4Hq8UFD2r0HPdC4/dTU7Wjor4eFwHcYCr2OC9j9trvU6z1z5ufksLbwFu
	 KqRX4lKPpIjA+zmXUkpLjAYoF02cCaWAtDsVYSb8I5whg3KK5XyG7onOo98p4wzJe1
	 g1KHlnr58d8L8P5eJhVik7ppK6MSdwWmhHJspgik=
Date: Tue, 04 Mar 2025 16:12:37 -0800
To: mm-commits@vger.kernel.org,mika.westerberg@linux.intel.com,lizhijian@fujitsu.com,Jonathan.Cameron@huawei.com,ilpo.jarvinen@linux.intel.com,huang.ying.caritas@gmail.com,dan.j.williams@intel.com,bhelgaas@google.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + resource-fix-resource-leak-in-get_free_mem_region-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250305001237.B78AAC4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: resource-fix-resource-leak-in-get_free_mem_region-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     resource-fix-resource-leak-in-get_free_mem_region-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/resource-fix-resource-leak-in-get_free_mem_region-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix.patch
mm-mremap-initial-refactor-of-move_vma-fix.patch
mm-mremap-thread-state-through-move-page-table-operation-fix.patch
mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option-fix.patch
lib-plistc-add-shortcut-for-plist_requeue-fix.patch
scsi-lpfc-convert-timeouts-to-secs_to_jiffies-fix.patch
signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset-fix.patch
resource-fix-resource-leak-in-get_free_mem_region-fix.patch

