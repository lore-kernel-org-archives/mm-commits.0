Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00510C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:27:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347838AbiATV1p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:27:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37980 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377882AbiATV1o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:27:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9814061715
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:27:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE48EC340E0;
        Thu, 20 Jan 2022 21:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714064;
        bh=UEk7Cw/hVrdY/8rP3Z8rMjUwbHOAlPqc1MxUwOn0OKk=;
        h=Date:From:To:Subject:From;
        b=GAi926A4V38gepPd/IEDpTaBdbTiHT8MKGSRldWiRexR2bE9WDNT4kYcLAGr14glh
         toYEuIiT7/HlxIf9hW0VGd/V3Xa2sXtkGRBy9cEVhtYv32Xex7BYPBFCH3GAjpZxYl
         jbTRmri+G+3BnRlw7kaJEZykisgerM9P1BJ6Ygik=
Date:   Thu, 20 Jan 2022 13:27:43 -0800
From:   akpm@linux-foundation.org
To:     hughd@google.com, mm-commits@vger.kernel.org,
        sunnanyong@huawei.com, wangkefeng.wang@huawei.com
Subject:  [merged]
 mm-ksm-fix-use-after-free-kasan-report-in-ksm_might_need_to_copy.patch
 removed from -mm tree
Message-ID: <20220120212743.eXS6u_XvN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: ksm: fix use-after-free kasan report in ksm_might_need_to_copy
has been removed from the -mm tree.  Its filename was
     mm-ksm-fix-use-after-free-kasan-report-in-ksm_might_need_to_copy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nanyong Sun <sunnanyong@huawei.com>
Subject: mm: ksm: fix use-after-free kasan report in ksm_might_need_to_copy

When under the stress of swapping in/out with KSM enabled, there is a low
probability that kasan reports the BUG of use-after-free in
ksm_might_need_to_copy() when do swap in.  The freed object is the
anon_vma got from page_anon_vma(page).

It is because a swapcache page associated with one anon_vma now needed for
another anon_vma, but the page's original vma was unmapped and the
anon_vma was freed.  In this case the if condition below always return
false and then alloc a new page to copy.  Swapin process then use the new
page and can continue to run well, so this is harmless actually.

} else if (anon_vma->root == vma->anon_vma->root &&
                 page->index == linear_page_index(vma, address)) {

This patch exchange the order of above two judgment statement to avoid the
kasan warning.  Let cpu run "page->index == linear_page_index(vma,
address)" firstly and return false basically to skip the read of
anon_vma->root which may trigger the kasan use-after-free warning.

==================================================================
BUG: KASAN: use-after-free in ksm_might_need_to_copy+0x12e/0x5b0
Read of size 8 at addr ffff88be9977dbd0 by task khugepaged/694

 CPU: 8 PID: 694 Comm: khugepaged Kdump: loaded Tainted: G OE - 4.18.0.x86_64
 Hardware name: 1288H V5/BC11SPSC0, BIOS 7.93 01/14/2021
Call Trace:
 dump_stack+0xf1/0x19b
 print_address_description+0x70/0x360
 kasan_report+0x1b2/0x330
 ksm_might_need_to_copy+0x12e/0x5b0
 do_swap_page+0x452/0xe70
 __collapse_huge_page_swapin+0x24b/0x720
 khugepaged_scan_pmd+0xcae/0x1ff0
 khugepaged+0x8ee/0xd70
 kthread+0x1a2/0x1d0
 ret_from_fork+0x1f/0x40

Allocated by task 2306153:
 kasan_kmalloc+0xa0/0xd0
 kmem_cache_alloc+0xc0/0x1c0
 anon_vma_clone+0xf7/0x380
 anon_vma_fork+0xc0/0x390
 copy_process+0x447b/0x4810
 _do_fork+0x118/0x620
 do_syscall_64+0x112/0x360
 entry_SYSCALL_64_after_hwframe+0x65/0xca

Freed by task 2306242:
 __kasan_slab_free+0x130/0x180
 kmem_cache_free+0x78/0x1d0
 unlink_anon_vmas+0x19c/0x4a0
 free_pgtables+0x137/0x1b0
 exit_mmap+0x133/0x320
 mmput+0x15e/0x390
 do_exit+0x8c5/0x1210
 do_group_exit+0xb5/0x1b0
 __x64_sys_exit_group+0x21/0x30
 do_syscall_64+0x112/0x360
 entry_SYSCALL_64_after_hwframe+0x65/0xca

The buggy address belongs to the object at ffff88be9977dba0
 which belongs to the cache anon_vma_chain of size 64
The buggy address is located 48 bytes inside of
 64-byte region [ffff88be9977dba0, ffff88be9977dbe0)
The buggy address belongs to the page:
page:ffffea00fa65df40 count:1 mapcount:0 mapping:ffff888107717800 index:0x0
flags: 0x17ffffc0000100(slab)
==================================================================

Link: https://lkml.kernel.org/r/20211202102940.1069634-1-sunnanyong@huawei.com
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/ksm.c~mm-ksm-fix-use-after-free-kasan-report-in-ksm_might_need_to_copy
+++ a/mm/ksm.c
@@ -2576,8 +2576,8 @@ struct page *ksm_might_need_to_copy(stru
 			return page;	/* no need to copy it */
 	} else if (!anon_vma) {
 		return page;		/* no need to copy it */
-	} else if (anon_vma->root == vma->anon_vma->root &&
-		 page->index == linear_page_index(vma, address)) {
+	} else if (page->index == linear_page_index(vma, address) &&
+			anon_vma->root == vma->anon_vma->root) {
 		return page;		/* still no need to copy it */
 	}
 	if (!PageUptodate(page))
_

Patches currently in -mm which might be from sunnanyong@huawei.com are


