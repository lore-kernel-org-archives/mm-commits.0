Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19EF1C32EB;
	Thu, 17 Oct 2024 07:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729150136; cv=none; b=DV4Dk8yTMFL8Rf7dDGzdBVNO1lu5ki7IGDT+6BNh/9ThzyzxTpMSyWWmt1YSBt9VXBl/uSd9g4haTtoOWvMIBEG5cXRUXdnXtT14i8B3ZKa33SUtWNezOrv28otl9CpRNFaeCS8+wRLOBPR0dSyiLCbiR37ORG8TwWbGQd+mN9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729150136; c=relaxed/simple;
	bh=1PhE4FWclHaqkRbk0+pOQCogPIGHwdy//XBM/b5ne04=;
	h=Date:To:From:Subject:Message-Id; b=htegMl2qCASR0dcPIc6NhzktK2DuAgoGv7vSfxYYifTRsSSnbQ3k3bfAK/qG8Iqjez+m3g0NYZ3K7CjnuvSz681wXrCzmdTWO24b9JMK997/iERYWGZbgLvzRZI0/fcb1+I1H+8vJ4AaaB4RkjnaNvxt/XQ2BiI/xSa6BnciJbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C6M/v7NZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C6M/v7NZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F625C4CEC3;
	Thu, 17 Oct 2024 07:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729150136;
	bh=1PhE4FWclHaqkRbk0+pOQCogPIGHwdy//XBM/b5ne04=;
	h=Date:To:From:Subject:From;
	b=C6M/v7NZ6YfpxKxt+LBTdKSxf7tL4UqNUR2egH+D60cRVXzIF0Ju9KhRHmjvd4hYa
	 MSE8ErATVsRA8WmqpPRama/r38QEaIk2neQjw4kAnjIyn3MwZX8uof6D0tfvCqkeSF
	 UkIVB/v+HbM6FChOoXbnbOVFCfKnN5IE/DJcXKKE=
Date: Thu, 17 Oct 2024 00:28:56 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,thuth@redhat.com,stable@vger.kernel.org,ryan.roberts@arm.com,imbrenda@linux.ibm.com,hughd@google.com,frankja@linux.ibm.com,borntraeger@linux.ibm.com,bfu@redhat.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-dont-install-pmd-mappings-when-thps-are-disabled-by-the-hw-process-vma.patch removed from -mm tree
Message-Id: <20241017072856.9F625C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: don't install PMD mappings when THPs are disabled by the hw/process/vma
has been removed from the -mm tree.  Its filename was
     mm-dont-install-pmd-mappings-when-thps-are-disabled-by-the-hw-process-vma.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: don't install PMD mappings when THPs are disabled by the hw/process/vma
Date: Fri, 11 Oct 2024 12:24:45 +0200

We (or rather, readahead logic :) ) might be allocating a THP in the
pagecache and then try mapping it into a process that explicitly disabled
THP: we might end up installing PMD mappings.

This is a problem for s390x KVM, which explicitly remaps all PMD-mapped
THPs to be PTE-mapped in s390_enable_sie()->thp_split_mm(), before
starting the VM.

For example, starting a VM backed on a file system with large folios
supported makes the VM crash when the VM tries accessing such a mapping
using KVM.

Is it also a problem when the HW disabled THP using
TRANSPARENT_HUGEPAGE_UNSUPPORTED?  At least on x86 this would be the case
without X86_FEATURE_PSE.

In the future, we might be able to do better on s390x and only disallow
PMD mappings -- what s390x and likely TRANSPARENT_HUGEPAGE_UNSUPPORTED
really wants.  For now, fix it by essentially performing the same check as
would be done in __thp_vma_allowable_orders() or in shmem code, where this
works as expected, and disallow PMD mappings, making us fallback to PTE
mappings.

Link: https://lkml.kernel.org/r/20241011102445.934409-3-david@redhat.com
Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Leo Fu <bfu@redhat.com>
Tested-by: Thomas Huth <thuth@redhat.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/memory.c~mm-dont-install-pmd-mappings-when-thps-are-disabled-by-the-hw-process-vma
+++ a/mm/memory.c
@@ -4920,6 +4920,15 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 	pmd_t entry;
 	vm_fault_t ret = VM_FAULT_FALLBACK;
 
+	/*
+	 * It is too late to allocate a small folio, we already have a large
+	 * folio in the pagecache: especially s390 KVM cannot tolerate any
+	 * PMD mappings, but PTE-mapped THP are fine. So let's simply refuse any
+	 * PMD mappings if THPs are disabled.
+	 */
+	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vma->vm_flags))
+		return ret;
+
 	if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
 		return ret;
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-pagewalk-fix-usage-of-pmd_leaf-pud_leaf-without-present-check.patch
selftests-mm-hugetlb_fault_after_madv-use-default-hguetlb-page-size.patch
selftests-mm-hugetlb_fault_after_madv-improve-test-output.patch

