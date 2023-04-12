Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4304CC7619A
	for <mm-commits@archiver.kernel.org>; Wed, 12 Apr 2023 21:23:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjDLVXy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Apr 2023 17:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbjDLVXx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Apr 2023 17:23:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BBAF19A1
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 14:23:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C968C62FC0
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 21:23:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DF8C433EF;
        Wed, 12 Apr 2023 21:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681334630;
        bh=QckCkJbllkBu4bDFDLKCaCJepQdsX42SdmuWawLbxww=;
        h=Date:To:From:Subject:From;
        b=GjMT1WQB9FMZw24x+oHyGWt2EfTgOhLipK1z/CeiiAos6efG9Qwp5jfppFLXSPt1/
         SzCImXOGoUy2U7tdTQah/U76YT199HLouwqi5QzKD9Slg4LBp6sIuEuULDWrGCIbeN
         qfgqyp8W5wcrNBV/DPO1XMYQ/yXGDp3yRYtgtXss=
Date:   Wed, 12 Apr 2023 14:23:49 -0700
To:     mm-commits@vger.kernel.org, venki@google.com, sbsiddha@gmail.com,
        khlebnikov@openvz.org, jgross@suse.com, dan.j.williams@intel.com,
        buddy.zhang@biscuitos.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-keep-memory-type-same-on-devmem-page-fault.patch added to mm-hotfixes-unstable branch
Message-Id: <20230412212350.30DF8C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: keep memory type same on DEVMEM Page-Fault
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-keep-memory-type-same-on-devmem-page-fault.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-keep-memory-type-same-on-devmem-page-fault.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "buddy.zhang" <buddy.zhang@biscuitos.cn>
Subject: mm: keep memory type same on DEVMEM Page-Fault
Date: Sun, 19 Mar 2023 11:37:50 +0800

On X86 architecture, supports memory type on Page-table, such as PTE is
PAT/PCD/PWD, which can setup up Memory Type as WC/WB/WT/UC etc.  Then,
Virtual address from userspace or kernel space can map to same physical
page, if each page table has different memory type, then it's confused to
have more memory type for same physical page.

On DEVMEM, the 'remap_pfn_range()' keep memory type same on different
mapping. But if it happen on Page-Fault route, such as code:

 19 static vm_fault_t vm_fault(struct vm_fault *vmf)
 20 {
 21         struct vm_area_struct *vma = vmf->vma;
 22         unsigned long address = vmf->address;
 23         struct page *fault_page;
 24         unsigned long pfn;
 25         int r;
 26
 27         /* Allocate Page as DEVMEM */
 28         fault_page = alloc_page(GFP_KERNEL);
 29         if (!fault_page) {
 30                 printk("ERROR: NO Free Memory from DEVMEM.\n");
 31                 r = -ENOMEM;
 32                 goto err_alloc;
 33         }
 34         pfn = page_to_pfn(fault_page);
 35
 36         /* Clear PAT Attribute */
 37         pgprot_val(vma->vm_page_prot) &= ~(_PAGE_PCD | _PAGE_PWT | _PAGE_PAT);
 38
 39         /* Change Memory Type for Direct-Mapping Area */
 40         arch_io_reserve_memtype_wc(PFN_PHYS(pfn), PAGE_SIZE);
 41         pgprot_val(vma->vm_page_prot) |= cachemode2protval(_PAGE_CACHE_MODE_WT);
 42
 43         /* Establish pte and INC _mapcount for page */
 44         vm_flags_set(vma, VM_MIXEDMAP);
 45         if (vm_insert_page(vma, address, fault_page))
 46                 return -EAGAIN;
 47
 48         /* Add refcount for page */
 49         atomic_inc(&fault_page->_refcount);
 50         /* bind fault page */
 51         vmf->page = fault_page;
 52
 53         return 0;
 54
 55 err_alloc:
 56         return r;
 57 }
 58
 59 static const struct vm_operations_struct BiscuitOS_vm_ops = {
 60         .fault  = vm_fault,
 61 };
 62
 63 static int BiscuitOS_mmap(struct file *filp, struct vm_area_struct *vma)
 64 {
 65         /* setup vm_ops */
 66         vma->vm_ops = &BiscuitOS_vm_ops;
 67
 68         return 0;
 69 }

If invoke arch_io_reserve_memtype_wc() on Line-40, and modify memory type
as WC for Direct-Mapping area, and then setup meory type as WT on Line-41,
then invoke 'vm_insert_page()' to create mapping, so you can see:

    | <----- Usespace -----> | <- Kernel space -> |
----+------+---+-------------+---+---+------------+--
    |      |   |             |   |   |            |
----+------+---+-------------+---+---+------------+--
           WT|                     |WC
             o-------o    o--------o
                   WT|    |WC
                     V    V
-------------------+--------+------------------------
                   | DEVMEM |
-------------------+--------+------------------------
Physical Address Space

For this case, OS should check memory type before mapping on
'vm_insert_page()', and keep memory type same, so add check on function:

07 int vm_insert_page(struct vm_area_struct *vma, unsigned long addr,
08                         struct page *page)
09 {
10         if (addr < vma->vm_start || addr >= vma->vm_end)
11                 return -EFAULT;
12         if (!page_count(page))
13                 return -EINVAL;
14         if (!(vma->vm_flags & VM_MIXEDMAP)) {
15                 BUG_ON(mmap_read_trylock(vma->vm_mm));
16                 BUG_ON(vma->vm_flags & VM_PFNMAP);
17                 vm_flags_set(vma, VM_MIXEDMAP);
18         }
19         if (track_pfn_remap(vma, &vma->vm_page_prot,
20                         page_to_pfn(page), addr, PAGE_SIZE))
21                 return -EINVAL;
22         return insert_page(vma, addr, page, vma->vm_page_prot);
23 }

And line 19 to 21, when mapping different memory type on this route, the
'track_pfn_remap()' will notify error and change request as current, e.g.

x86/PAT: APP:88 map pfn RAM range req write-through for [mem 0x025c1000-0x025c1fff], got write-combining

And then, we can keep memory type same on Page-fault route for DEVMEM, the end:

    | <----- Usespace -----> | <- Kernel space -> |
----+------+---+-------------+---+---+------------+--
    |      |   |             |   |   |            |
----+------+---+-------------+---+---+------------+--
           WT|                     |WC
             o---(X)----o----------o
                        |WC
                        V
-------------------+--------+------------------------
                   | DEVMEM |
-------------------+--------+------------------------

Link: https://lkml.kernel.org/r/20230319033750.475200-1-buddy.zhang@biscuitos.cn
Signed-off-by: Buddy Zhang <buddy.zhang@biscuitos.cn>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Suresh Siddha <sbsiddha@gmail.com>
Cc: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/memory.c~mm-keep-memory-type-same-on-devmem-page-fault
+++ a/mm/memory.c
@@ -1989,6 +1989,9 @@ int vm_insert_page(struct vm_area_struct
 		BUG_ON(vma->vm_flags & VM_PFNMAP);
 		vm_flags_set(vma, VM_MIXEDMAP);
 	}
+	if (track_pfn_remap(vma, &vma->vm_page_prot,
+			page_to_pfn(page), addr, PAGE_SIZE))
+		return -EINVAL;
 	return insert_page(vma, addr, page, vma->vm_page_prot);
 }
 EXPORT_SYMBOL(vm_insert_page);
_

Patches currently in -mm which might be from buddy.zhang@biscuitos.cn are

mm-keep-memory-type-same-on-devmem-page-fault.patch

