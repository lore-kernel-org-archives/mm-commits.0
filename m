Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCF316BE34
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 22:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723588895; cv=none; b=e/g4L9Ymsq9oU0/cShYqKEHHAeBh7uzvLZY2bocWNEzvqisO3zXwOvbFEiCuePYA/EgzFndQ53F+SKJWhKAsFXaWxZLUboz0f6tOS1zrcTYihkd0m4wP93Ttughkk1IurOzbFxrh3sbJ3LCXf97pnkVgyongmYukkURE3Q/S7t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723588895; c=relaxed/simple;
	bh=q3RhmrirqDedpRorlqxmvQ6AT4ev2S9S99Q7BTCT9vw=;
	h=Date:To:From:Subject:Message-Id; b=jUqBdt3gTFV+I4bACaOYKB96sxXs+v60EJDV9ELSK/BsXPzBGmS5HLJ+L+2AoOcqOGDkN/Dg1t2FPNXO72Vgd8U61NKUz2PYNHg75sS1XUeSs1MRFeSGWLbUQryp9mIktmoqn0wCn+NdldRMsCvNqbXhrhKQTKiQ7/B3nv/flHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TMFLuhQv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TMFLuhQv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6EDC32782;
	Tue, 13 Aug 2024 22:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723588894;
	bh=q3RhmrirqDedpRorlqxmvQ6AT4ev2S9S99Q7BTCT9vw=;
	h=Date:To:From:Subject:From;
	b=TMFLuhQvQRLVUrT6hECajBm6TWXQOsvIK6ayyb0HC5P6SYHrs2+876CAs27e6ALrN
	 kCoeZEoV46OrDy5oGK8NSf9x5lZXMRIvE29HOQmvQ6GOwRcohNROPfOrHoUQglaEU1
	 G257aFaYt23ksaFmqAj3mzrXIB4EmxjZGfBGUNFM=
Date: Tue, 13 Aug 2024 15:41:33 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,chrisl@kernel.org,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-use-xa_get_order-to-get-the-swap-entry-order.patch added to mm-unstable branch
Message-Id: <20240813224134.4A6EDC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: filemap: use xa_get_order() to get the swap entry order
has been added to the -mm mm-unstable branch.  Its filename is
     mm-filemap-use-xa_get_order-to-get-the-swap-entry-order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-use-xa_get_order-to-get-the-swap-entry-order.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: filemap: use xa_get_order() to get the swap entry order
Date: Mon, 12 Aug 2024 15:42:05 +0800

In the following patches, shmem will support the swap out of large folios,
which means the shmem mappings may contain large order swap entries, so
using xa_get_order() to get the folio order of the shmem swap entry to
update the '*start' correctly.

Link: https://lkml.kernel.org/r/6876d55145c1cc80e79df7884aa3a62e397b101d.1723434324.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/filemap.c~mm-filemap-use-xa_get_order-to-get-the-swap-entry-order
+++ a/mm/filemap.c
@@ -2055,6 +2055,8 @@ unsigned find_get_entries(struct address
 		folio = fbatch->folios[idx];
 		if (!xa_is_value(folio))
 			nr = folio_nr_pages(folio);
+		else
+			nr = 1 << xa_get_order(&mapping->i_pages, indices[idx]);
 		*start = indices[idx] + nr;
 	}
 	return folio_batch_count(fbatch);
@@ -2119,6 +2121,8 @@ put:
 		folio = fbatch->folios[idx];
 		if (!xa_is_value(folio))
 			nr = folio_nr_pages(folio);
+		else
+			nr = 1 << xa_get_order(&mapping->i_pages, indices[idx]);
 		*start = indices[idx] + nr;
 	}
 	return folio_batch_count(fbatch);
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-simplify-the-suitable-huge-orders-validation-for-tmpfs.patch
mm-shmem-rename-shmem_is_huge-to-shmem_huge_global_enabled.patch
mm-shmem-move-shmem_huge_global_enabled-into-shmem_allowable_huge_orders.patch
mm-swap-extend-swap_shmem_alloc-to-support-batch-swap_map_shmem-flag-setting.patch
mm-shmem-extend-shmem_partial_swap_usage-to-support-large-folio-swap.patch
mm-filemap-use-xa_get_order-to-get-the-swap-entry-order.patch
mm-shmem-use-swap_free_nr-to-free-shmem-swap-entries.patch
mm-shmem-support-large-folio-allocation-for-shmem_replace_folio.patch
mm-shmem-drop-folio-reference-count-using-nr_pages-in-shmem_delete_from_page_cache.patch
mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large.patch
mm-shmem-support-large-folio-swap-out.patch

