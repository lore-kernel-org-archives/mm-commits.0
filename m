Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB7EC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 21:19:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343500AbhKXVWd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Nov 2021 16:22:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:40860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343498AbhKXVWd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Nov 2021 16:22:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F4F160F5B;
        Wed, 24 Nov 2021 21:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637788763;
        bh=hv69YNBo/ugzVQnyxLCSpAZc1bgSD0U9NqJ2gxo9v7w=;
        h=Date:From:To:Subject:From;
        b=acJa+JrQf8Inh1aFENHejUlmyNmmCmSSCakHgIx5YAwmAaN2tKLY+5rfuvHBK1tNk
         Psx6aF0gJGXCeQqaFEH0YHP/N3OAVDfRZ4HIVax0h5ynsYro1haOqAp9bakSxWsM00
         KGKanVZ/NQPW4SkYUchLbaz2s6HOpZAXOLApAKNo=
Date:   Wed, 24 Nov 2021 13:19:22 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, dan.j.williams@intel.com, dave.jiang@intel.com,
        hch@lst.de, jane.chu@oracle.com, jgg@nvidia.com, jgg@ziepe.ca,
        jhubbard@nvidia.com, joao.m.martins@oracle.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, songmuchun@bytedance.com,
        vishal.l.verma@intel.com, willy@infradead.org
Subject:  +
 device-dax-set-mapping-prior-to-vmf_insert_pfn_pmdpud.patch added to -mm
 tree
Message-ID: <20211124211922.mK509vl73%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: set mapping prior to vmf_insert_pfn{,_pmd,pud}()
has been added to the -mm tree.  Its filename is
     device-dax-set-mapping-prior-to-vmf_insert_pfn_pmdpud.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/device-dax-set-mapping-prior-to-vmf_insert_pfn_pmdpud.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/device-dax-set-mapping-prior-to-vmf_insert_pfn_pmdpud.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joao Martins <joao.m.martins@oracle.com>
Subject: device-dax: set mapping prior to vmf_insert_pfn{,_pmd,pud}()

Normally, the @page mapping is set prior to inserting the page into a page
table entry.  Make device-dax adhere to the same ordering, rather than
setting mapping after the PTE is inserted.

The address_space never changes and it is always associated with the same
inode and underlying pages.  So, the page mapping is set once but cleared
when the struct pages are removed/freed (i.e.  after
{devm_}memunmap_pages()).

Link: https://lkml.kernel.org/r/20211124191005.20783-10-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/device.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/dax/device.c~device-dax-set-mapping-prior-to-vmf_insert_pfn_pmdpud
+++ a/drivers/dax/device.c
@@ -121,6 +121,8 @@ static vm_fault_t __dev_dax_pte_fault(st
 
 	*pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
 
+	dax_set_mapping(vmf, *pfn, fault_size);
+
 	return vmf_insert_mixed(vmf->vma, vmf->address, *pfn);
 }
 
@@ -161,6 +163,8 @@ static vm_fault_t __dev_dax_pmd_fault(st
 
 	*pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
 
+	dax_set_mapping(vmf, *pfn, fault_size);
+
 	return vmf_insert_pfn_pmd(vmf, *pfn, vmf->flags & FAULT_FLAG_WRITE);
 }
 
@@ -203,6 +207,8 @@ static vm_fault_t __dev_dax_pud_fault(st
 
 	*pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
 
+	dax_set_mapping(vmf, *pfn, fault_size);
+
 	return vmf_insert_pfn_pud(vmf, *pfn, vmf->flags & FAULT_FLAG_WRITE);
 }
 #else
@@ -245,8 +251,6 @@ static vm_fault_t dev_dax_huge_fault(str
 		rc = VM_FAULT_SIGBUS;
 	}
 
-	if (rc == VM_FAULT_NOPAGE)
-		dax_set_mapping(vmf, pfn, fault_size);
 	dax_read_unlock(id);
 
 	return rc;
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

memory-failure-fetch-compound_head-after-pgmap_pfn_valid.patch
mm-page_alloc-split-prep_compound_page-into-head-and-tail-subparts.patch
mm-page_alloc-refactor-memmap_init_zone_device-page-init.patch
mm-memremap-add-zone_device-support-for-compound-pages.patch
device-dax-use-align-for-determining-pgoff.patch
device-dax-use-struct_size.patch
device-dax-ensure-dev_dax-pgmap-is-valid-for-dynamic-devices.patch
device-dax-factor-out-page-mapping-initialization.patch
device-dax-set-mapping-prior-to-vmf_insert_pfn_pmdpud.patch
device-dax-compound-devmap-support.patch

