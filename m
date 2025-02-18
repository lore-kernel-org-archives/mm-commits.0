Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95F71AB52F
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 04:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739854102; cv=none; b=tidI/rL+XT4E3F/H3U/Ox6iOM3QB/5gHjkebSrSvu5sgNPuzZtByCZySdEygIIExVXeMjPGZl31Zylg1RHu2jBdR9oB7TxXDLTRAFictgjZb8gJ0M4X6H0roBTd4LYmm3bIBHOs5FqB0st2FDPuRHUd9VmKXWXpjxc3BS/5coZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739854102; c=relaxed/simple;
	bh=+AUHUuF8o5tcd7/JMdV6nmZev9+skbAh9W4G9Bu6MhU=;
	h=Date:To:From:Subject:Message-Id; b=GswyOLEH1n5uz77Gh20o1B4NYYFRSRPqD7peml5krKYK7NWBkc+8fvtQ/1awd6rW2vLaGuP0e0qGVVqkFwEQ3G5AMS26rujfQvvvazfXlv7WrqT9kmktcGZv0g8JUu+ArUfxx3OibpQPRgNjVzz56wqFkqZPEB0oeHZTk640NzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FA2XN6Q2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FA2XN6Q2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C2DC4CEE2;
	Tue, 18 Feb 2025 04:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739854102;
	bh=+AUHUuF8o5tcd7/JMdV6nmZev9+skbAh9W4G9Bu6MhU=;
	h=Date:To:From:Subject:From;
	b=FA2XN6Q2dcjDyfHba7zo6GJwNe9XYlU3/C8hAuWuswVly6B0lH2+Cso0Co9t3GdEA
	 w41cxYpwWprv4TdpFjMThi0D569nOrx1g3tbEs3hMlWwi4Go3YQZBWU5+GiQ+Vz2V4
	 Gt1bS952B64OXRdSXBQOMiZZdubK6gE5PjI7ROhw=
Date: Mon, 17 Feb 2025 20:48:21 -0800
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,vgoyal@redhat.com,tytso@mit.edu,svens@linux.ibm.com,peterx@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,logang@deltatee.com,linmiaohe@huawei.com,lina@asahilina.net,kernel@xen0n.name,jhubbard@nvidia.com,jgg@ziepe.ca,jgg@nvidia.com,jack@suse.cz,ira.weiny@intel.com,hch@lst.de,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,djwong@kernel.org,david@redhat.com,david@fromorbit.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,borntraeger@linux.ibm.com,bhelgaas@google.com,balbirs@nvidia.com,apopple@nvidia.com,alison.schofield@intel.com,agordeev@linux.ibm.com,dan.j.williams@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dcssblk-mark-dax-broken-remove-fs_dax_limited-support.patch added to mm-unstable branch
Message-Id: <20250218044822.74C2DC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dcssblk: mark DAX broken, remove FS_DAX_LIMITED support
has been added to the -mm mm-unstable branch.  Its filename is
     dcssblk-mark-dax-broken-remove-fs_dax_limited-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dcssblk-mark-dax-broken-remove-fs_dax_limited-support.patch

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
From: Dan Williams <dan.j.williams@intel.com>
Subject: dcssblk: mark DAX broken, remove FS_DAX_LIMITED support
Date: Tue, 18 Feb 2025 14:55:34 +1100

The dcssblk driver has long needed special case supoprt to enable limited
dax operation, so called CONFIG_FS_DAX_LIMITED.  This mode works around
the incomplete support for ZONE_DEVICE on s390 by forgoing the ability of
dax-mapped pages to support GUP.

Now, pending cleanups to fsdax that fix its reference counting [1] depend
on the ability of all dax drivers to supply ZONE_DEVICE pages.

To allow that work to move forward, dax support needs to be paused for
dcssblk until ZONE_DEVICE support arrives.  That work has been known for a
few years [2], and the removal of "pte_devmap" requirements [3] makes the
conversion easier.

For now, place the support behind CONFIG_BROKEN, and remove PFN_SPECIAL
(dcssblk was the only user).

Link: http://lore.kernel.org/cover.9f0e45d52f5cff58807831b6b867084d0b14b61c.1725941415.git-series.apopple@nvidia.com [1]
Link: http://lore.kernel.org/20210820210318.187742e8@thinkpad/ [2]
Link: http://lore.kernel.org/4511465a4f8429f45e2ac70d2e65dc5e1df1eb47.1725941415.git-series.apopple@nvidia.com [3]
Link: https://lkml.kernel.org/r/f6a6adc9628745c5545378dcbd64fe68ea8e5ae2.1739850794.git-series.apopple@nvidia.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Tested-by: Alexander Gordeev <agordeev@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Asahi Lina <lina@asahilina.net>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/dax.rst |    1 -
 drivers/s390/block/Kconfig        |   12 ++++++++++--
 drivers/s390/block/dcssblk.c      |   27 +++++++++++++++++----------
 3 files changed, 27 insertions(+), 13 deletions(-)

--- a/Documentation/filesystems/dax.rst~dcssblk-mark-dax-broken-remove-fs_dax_limited-support
+++ a/Documentation/filesystems/dax.rst
@@ -207,7 +207,6 @@ implement direct_access.
 
 These block devices may be used for inspiration:
 - brd: RAM backed block device driver
-- dcssblk: s390 dcss block device driver
 - pmem: NVDIMM persistent memory driver
 
 
--- a/drivers/s390/block/dcssblk.c~dcssblk-mark-dax-broken-remove-fs_dax_limited-support
+++ a/drivers/s390/block/dcssblk.c
@@ -534,6 +534,21 @@ static const struct attribute_group *dcs
 	NULL,
 };
 
+static int dcssblk_setup_dax(struct dcssblk_dev_info *dev_info)
+{
+	struct dax_device *dax_dev;
+
+	if (!IS_ENABLED(CONFIG_DCSSBLK_DAX))
+		return 0;
+
+	dax_dev = alloc_dax(dev_info, &dcssblk_dax_ops);
+	if (IS_ERR(dax_dev))
+		return PTR_ERR(dax_dev);
+	set_dax_synchronous(dax_dev);
+	dev_info->dax_dev = dax_dev;
+	return dax_add_host(dev_info->dax_dev, dev_info->gd);
+}
+
 /*
  * device attribute for adding devices
  */
@@ -547,7 +562,6 @@ dcssblk_add_store(struct device *dev, st
 	int rc, i, j, num_of_segments;
 	struct dcssblk_dev_info *dev_info;
 	struct segment_info *seg_info, *temp;
-	struct dax_device *dax_dev;
 	char *local_buf;
 	unsigned long seg_byte_size;
 
@@ -674,14 +688,7 @@ dcssblk_add_store(struct device *dev, st
 	if (rc)
 		goto put_dev;
 
-	dax_dev = alloc_dax(dev_info, &dcssblk_dax_ops);
-	if (IS_ERR(dax_dev)) {
-		rc = PTR_ERR(dax_dev);
-		goto put_dev;
-	}
-	set_dax_synchronous(dax_dev);
-	dev_info->dax_dev = dax_dev;
-	rc = dax_add_host(dev_info->dax_dev, dev_info->gd);
+	rc = dcssblk_setup_dax(dev_info);
 	if (rc)
 		goto out_dax;
 
@@ -917,7 +924,7 @@ __dcssblk_direct_access(struct dcssblk_d
 		*kaddr = __va(dev_info->start + offset);
 	if (pfn)
 		*pfn = __pfn_to_pfn_t(PFN_DOWN(dev_info->start + offset),
-				PFN_DEV|PFN_SPECIAL);
+				      PFN_DEV);
 
 	return (dev_sz - offset) / PAGE_SIZE;
 }
--- a/drivers/s390/block/Kconfig~dcssblk-mark-dax-broken-remove-fs_dax_limited-support
+++ a/drivers/s390/block/Kconfig
@@ -4,13 +4,21 @@ comment "S/390 block device drivers"
 
 config DCSSBLK
 	def_tristate m
-	select FS_DAX_LIMITED
-	select DAX
 	prompt "DCSSBLK support"
 	depends on S390 && BLOCK
 	help
 	  Support for dcss block device
 
+config DCSSBLK_DAX
+	def_bool y
+	depends on DCSSBLK
+	# requires S390 ZONE_DEVICE support
+	depends on BROKEN
+	select DAX
+	prompt "DCSSBLK DAX support"
+	help
+	  Enable DAX operation for the dcss block device
+
 config DASD
 	def_tristate y
 	prompt "Support for DASD devices"
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

dcssblk-mark-dax-broken-remove-fs_dax_limited-support.patch

