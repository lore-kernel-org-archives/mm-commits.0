Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB289C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:09:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbiANWJD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:09:03 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60572 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiANWJC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:09:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FEFFB825F5
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:09:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ABFFC36AE9;
        Fri, 14 Jan 2022 22:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198140;
        bh=DlxIKWoIIBJ6DIUVppCn1s3lQaDYGfLGvk8Cw0emKH0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=TBE9jCN14aBf+yYyQt4xJ8DWpgRhVo8Z6Rqa92XScQXY5W+c+vHjd5JRE/jZId4Kt
         yrzxfNNl1GVU1Ros8334SttGIsXdbBGSeUARZhTKFBWOiP2DFzMypHvlI3yFMn4Tez
         fXiOvwvRB3XVEM0MeeGM5PLGaqHuIeDi4D9h1Yu8=
Date:   Fri, 14 Jan 2022 14:08:59 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sunnanyong@huawei.com,
        torvalds@linux-foundation.org, wangkefeng.wang@huawei.com
Subject:  [patch 110/146] mm: ksm: fix use-after-free kasan report
 in ksm_might_need_to_copy
Message-ID: <20220114220859.RBibTk8EB%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
