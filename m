Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8A51A9B4D
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274500; cv=none; b=BQaovmVm750czA4BAOPZTJi1jaRZ3tQHIcPvT4zbTsR48/PMqG5WZRWXUQc99hiu+Mq8oV0zcU3+dLwgIqhLsoAVyEkg9/0oZmBHlTV0OvxV1w/4MLrp9uuSpmzMO6FA95zQ4bScVyjlvH1knUssNSCJYvxMrqiJ8/Jiw7f6iQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274500; c=relaxed/simple;
	bh=no6bocLirb3CMBTRQAJweGTE5WkCIqvQ+mJntwG1V6c=;
	h=Date:To:From:Subject:Message-Id; b=hBZXjYPEXDijxNoK4GSkPqx4vcEPclvIjZqOqS0CoN6iPZAbARHmreEJepUIGCb9wBWRAfxJHX39KpkLb+7BIp+Wb+siFAlz/ap2xvUoB/p2C0l/elmnI+hz0tWBCVCEgXc6qdhdX68UMgpVd9RI80H6psRFVvYbnmf/zHvOrsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1oKK88tr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1oKK88tr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6767DC4CEDD;
	Tue, 18 Mar 2025 05:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274500;
	bh=no6bocLirb3CMBTRQAJweGTE5WkCIqvQ+mJntwG1V6c=;
	h=Date:To:From:Subject:From;
	b=1oKK88trlU/VTt4bhaI2iIBSiKM5rYrpfecyFxHOFdU96vo4iMI0OQ8RrohPcT11/
	 8Bc2tjhHubdQqCm46lyi+b1WrIVjomAox8ExxbYIlJ1j0GXi+xCpZ7qnEL1+Gol5uv
	 t/FwdQd3Se4jqIHnxMub+HAXHmkclmpBJMRhqWls=
Date: Mon, 17 Mar 2025 22:08:19 -0700
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,vgoyal@redhat.com,tytso@mit.edu,svens@linux.ibm.com,peterx@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,logang@deltatee.com,linmiaohe@huawei.com,lina@asahilina.net,kernel@xen0n.name,jhubbard@nvidia.com,jgg@ziepe.ca,jgg@nvidia.com,jack@suse.cz,ira.weiny@intel.com,hch@lst.de,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,djwong@kernel.org,david@redhat.com,david@fromorbit.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,borntraeger@linux.ibm.com,bhelgaas@google.com,balbirs@nvidia.com,alison.schofield@intel.com,agordeev@linux.ibm.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-add-vmf_insert_page_mkwrite.patch removed from -mm tree
Message-Id: <20250318050820.6767DC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: add vmf_insert_page_mkwrite()
has been removed from the -mm tree.  Its filename was
     mm-memory-add-vmf_insert_page_mkwrite.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/memory: add vmf_insert_page_mkwrite()
Date: Fri, 28 Feb 2025 14:31:08 +1100

Currently to map a DAX page the DAX driver calls vmf_insert_pfn.  This
creates a special devmap PTE entry for the pfn but does not take a
reference on the underlying struct page for the mapping.  This is because
DAX page refcounts are treated specially, as indicated by the presence of
a devmap entry.

To allow DAX page refcounts to be managed the same as normal page
refcounts introduce vmf_insert_page_mkwrite().  This will take a reference
on the underlying page much the same as vmf_insert_page, except it also
permits upgrading an existing mapping to be writable if
requested/possible.

Link: https://lkml.kernel.org/r/4ce3aa984c060f370105e0bfef1035869578be47.1740713401.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Asahi Lina <lina@asahilina.net>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: Dan Wiliams <dan.j.williams@intel.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: linmiaohe <linmiaohe@huawei.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Michael "Camp Drill Sergeant" Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 ++
 mm/memory.c        |   20 ++++++++++++++++++++
 2 files changed, 22 insertions(+)

--- a/include/linux/mm.h~mm-memory-add-vmf_insert_page_mkwrite
+++ a/include/linux/mm.h
@@ -3644,6 +3644,8 @@ int vm_map_pages(struct vm_area_struct *
 				unsigned long num);
 int vm_map_pages_zero(struct vm_area_struct *vma, struct page **pages,
 				unsigned long num);
+vm_fault_t vmf_insert_page_mkwrite(struct vm_fault *vmf, struct page *page,
+			bool write);
 vm_fault_t vmf_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn);
 vm_fault_t vmf_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
--- a/mm/memory.c~mm-memory-add-vmf_insert_page_mkwrite
+++ a/mm/memory.c
@@ -2643,6 +2643,26 @@ static vm_fault_t __vm_insert_mixed(stru
 	return VM_FAULT_NOPAGE;
 }
 
+vm_fault_t vmf_insert_page_mkwrite(struct vm_fault *vmf, struct page *page,
+			bool write)
+{
+	pgprot_t pgprot = vmf->vma->vm_page_prot;
+	unsigned long addr = vmf->address;
+	int err;
+
+	if (addr < vmf->vma->vm_start || addr >= vmf->vma->vm_end)
+		return VM_FAULT_SIGBUS;
+
+	err = insert_page(vmf->vma, addr, page, pgprot, write);
+	if (err == -ENOMEM)
+		return VM_FAULT_OOM;
+	if (err < 0 && err != -EBUSY)
+		return VM_FAULT_SIGBUS;
+
+	return VM_FAULT_NOPAGE;
+}
+EXPORT_SYMBOL_GPL(vmf_insert_page_mkwrite);
+
 vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 		pfn_t pfn)
 {
_

Patches currently in -mm which might be from apopple@nvidia.com are


