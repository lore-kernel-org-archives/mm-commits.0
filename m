Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A301C5D60
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274507; cv=none; b=hLY7kpY36nFU3GjsM6MEfhxTazFBWquU6IodEfZQO1uEuzvJE7uzEmIOCgfzhIMOgr/E6pL6ITEbH1VS5LZTO9YC6L8rIo21Fdsieb9NSG45DMpHkdimU5Z0oKdHh+Q+gh2KiLkxnuktE6p/nlg4G0hf9zS1rMfFm7whjgHk2/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274507; c=relaxed/simple;
	bh=0hDSdlU8O8bRsj+/iswWvMImYO3Hpg6kzG4e8z1MvtY=;
	h=Date:To:From:Subject:Message-Id; b=SHYAczNb3Q2LmDA5lbE3p5TcXv9p8KseKkQTlkO1txFYZz1t3bIwWsYv6jEb1iQ+q6sQSs99rE9EBkUDSUkLAh8fquYioT+/c+b21jL0GmvcKzn5TLfFt41t+XdPxLojItgqptMVY2GvVs3RYVzDNCD4IZO5dD5e65sWCNmLuHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NKR0Yrdc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NKR0Yrdc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB7DC4CEEA;
	Tue, 18 Mar 2025 05:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274507;
	bh=0hDSdlU8O8bRsj+/iswWvMImYO3Hpg6kzG4e8z1MvtY=;
	h=Date:To:From:Subject:From;
	b=NKR0YrdcjVMzCmPpy6Z5nBaMLB37Uhbw1r4OfspcAjBnkMtSLN9768yuwLl74z0gc
	 sR1790blT2Wq4dTIaUJKywAwNGKPc2of88jf6FbWQfkoIHrJrE86bFxcefOzclOpeJ
	 7FX/yVrtkcp9aANVMA3ylIzUTMqUoxva2P4Js/Ws=
Date: Mon, 17 Mar 2025 22:08:27 -0700
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,vgoyal@redhat.com,tytso@mit.edu,svens@linux.ibm.com,peterx@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,logang@deltatee.com,linmiaohe@huawei.com,lina@asahilina.net,kernel@xen0n.name,jhubbard@nvidia.com,jgg@ziepe.ca,jgg@nvidia.com,jack@suse.cz,ira.weiny@intel.com,hch@lst.de,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,djwong@kernel.org,david@redhat.com,david@fromorbit.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,borntraeger@linux.ibm.com,bhelgaas@google.com,balbirs@nvidia.com,alison.schofield@intel.com,agordeev@linux.ibm.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-dont-allow-foll_longterm-pinning-of-fs-dax-pages.patch removed from -mm tree
Message-Id: <20250318050827.7FB7DC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: don't allow FOLL_LONGTERM pinning of FS DAX pages
has been removed from the -mm tree.  Its filename was
     mm-gup-dont-allow-foll_longterm-pinning-of-fs-dax-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/gup: don't allow FOLL_LONGTERM pinning of FS DAX pages
Date: Fri, 28 Feb 2025 14:31:12 +1100

Longterm pinning of FS DAX pages should already be disallowed by various
pXX_devmap checks.  However a future change will cause these checks to be
invalid for FS DAX pages so make folio_is_longterm_pinnable() return false
for FS DAX pages.

Link: https://lkml.kernel.org/r/250a31876704b79f7c65b159f3c835e547f052df.1740713401.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
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

 include/linux/memremap.h |   11 +++++++++++
 include/linux/mm.h       |    7 +++++++
 2 files changed, 18 insertions(+)

--- a/include/linux/memremap.h~mm-gup-dont-allow-foll_longterm-pinning-of-fs-dax-pages
+++ a/include/linux/memremap.h
@@ -187,6 +187,17 @@ static inline bool folio_is_device_coher
 	return is_device_coherent_page(&folio->page);
 }
 
+static inline bool is_fsdax_page(const struct page *page)
+{
+	return is_zone_device_page(page) &&
+		page_pgmap(page)->type == MEMORY_DEVICE_FS_DAX;
+}
+
+static inline bool folio_is_fsdax(const struct folio *folio)
+{
+	return is_fsdax_page(&folio->page);
+}
+
 #ifdef CONFIG_ZONE_DEVICE
 void zone_device_page_init(struct page *page);
 void *memremap_pages(struct dev_pagemap *pgmap, int nid);
--- a/include/linux/mm.h~mm-gup-dont-allow-foll_longterm-pinning-of-fs-dax-pages
+++ a/include/linux/mm.h
@@ -2115,6 +2115,13 @@ static inline bool folio_is_longterm_pin
 	if (folio_is_device_coherent(folio))
 		return false;
 
+	/*
+	 * Filesystems can only tolerate transient delays to truncate and
+	 * hole-punch operations
+	 */
+	if (folio_is_fsdax(folio))
+		return false;
+
 	/* Otherwise, non-movable zone folios can be pinned. */
 	return !folio_is_zone_movable(folio);
 
_

Patches currently in -mm which might be from apopple@nvidia.com are


