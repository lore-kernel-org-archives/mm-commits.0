Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC845C4167B
	for <mm-commits@archiver.kernel.org>; Thu, 30 Nov 2023 22:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377161AbjK3W0T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Nov 2023 17:26:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377150AbjK3W0P (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2023 17:26:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDEA710DC
        for <mm-commits@vger.kernel.org>; Thu, 30 Nov 2023 14:26:21 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F48C433C9;
        Thu, 30 Nov 2023 22:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701383181;
        bh=HSVIJhISLZ2t1WPkyMSBVWoLX9n60RHH6ClDq/Cl/vo=;
        h=Date:To:From:Subject:From;
        b=JeAUZ5I+WcJDspx3f8wKbEOkTFLTsE+QUj3bVBP5fzHPjoFJ2KdmZJadzruPa5G/K
         KZ2eEWhcFNDgFTC2uy2T1/ZhRqp3sihaYzw/rY8V+imINEAmHSsJBKsYuUs/4UTKNp
         Ph0dOwVR8uzK7xYADhbNz4fFkr6xoOoTT98VxLu4=
Date:   Thu, 30 Nov 2023 14:26:20 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, sidhartha.kumar@oracle.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-use-a-folio-in-do_cow_fault.patch added to mm-unstable branch
Message-Id: <20231130222621.78F48C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory: use a folio in do_cow_fault()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-use-a-folio-in-do_cow_fault.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-use-a-folio-in-do_cow_fault.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory: use a folio in do_cow_fault()
Date: Sat, 18 Nov 2023 10:32:31 +0800

Use folio_prealloc() helper and convert to use a folio in do_cow_fault(),
which save five compound_head() calls.

Link: https://lkml.kernel.org/r/20231118023232.1409103-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/mm/memory.c~mm-memory-use-a-folio-in-do_cow_fault
+++ a/mm/memory.c
@@ -4656,6 +4656,7 @@ static vm_fault_t do_read_fault(struct v
 static vm_fault_t do_cow_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
+	struct folio *folio;
 	vm_fault_t ret;
 
 	ret = vmf_can_call_fault(vmf);
@@ -4664,16 +4665,11 @@ static vm_fault_t do_cow_fault(struct vm
 	if (ret)
 		return ret;
 
-	vmf->cow_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vmf->address);
-	if (!vmf->cow_page)
+	folio = folio_prealloc(vma->vm_mm, vma, vmf->address, false);
+	if (!folio)
 		return VM_FAULT_OOM;
 
-	if (mem_cgroup_charge(page_folio(vmf->cow_page), vma->vm_mm,
-				GFP_KERNEL)) {
-		put_page(vmf->cow_page);
-		return VM_FAULT_OOM;
-	}
-	folio_throttle_swaprate(page_folio(vmf->cow_page), GFP_KERNEL);
+	vmf->cow_page = &folio->page;
 
 	ret = __do_fault(vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
@@ -4682,7 +4678,7 @@ static vm_fault_t do_cow_fault(struct vm
 		return ret;
 
 	copy_user_highpage(vmf->cow_page, vmf->page, vmf->address, vma);
-	__SetPageUptodate(vmf->cow_page);
+	__folio_mark_uptodate(folio);
 
 	ret |= finish_fault(vmf);
 	unlock_page(vmf->page);
@@ -4691,7 +4687,7 @@ static vm_fault_t do_cow_fault(struct vm
 		goto uncharge_out;
 	return ret;
 uncharge_out:
-	put_page(vmf->cow_page);
+	folio_put(folio);
 	return ret;
 }
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-ksm-use-more-folio-api-in-ksm_might_need_to_copy.patch
mm-memory-use-a-folio-in-validate_page_before_insert.patch
mm-memory-rename-page_copy_prealloc-to-folio_prealloc.patch
mm-memory-use-a-folio-in-do_cow_fault.patch
mm-memory-use-folio_prealloc-in-wp_page_copy.patch

