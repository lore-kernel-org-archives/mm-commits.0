Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3E39C83F2C
	for <mm-commits@archiver.kernel.org>; Tue,  5 Sep 2023 16:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244073AbjIEQfE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354932AbjIEP4k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Sep 2023 11:56:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BC6912A
        for <mm-commits@vger.kernel.org>; Tue,  5 Sep 2023 08:56:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C05E1603F3
        for <mm-commits@vger.kernel.org>; Tue,  5 Sep 2023 15:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A115C433C8;
        Tue,  5 Sep 2023 15:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693929396;
        bh=t15RS/1Imo2jqmtMt3ijJJKVH2ZcB0plPjBs0MfW2b4=;
        h=Date:To:From:Subject:From;
        b=lETdNeWBTmJAu6jz3C4p+Hhkvfr/Ke8g7jJuEK8lSuWOeubgRQvBA8rZtUsDj3CyG
         HCQL/aZ7XYD8bpr1JItggWUXIhQwV/R9ZNjBTSTTRp4h2VSQ1JfhE6TtBvcyGds26/
         N+5LZNNQyQTfsuIdtsreyX9f10A1DwbWoWgZx6b8=
Date:   Tue, 05 Sep 2023 08:56:35 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        yuancan@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-fix-hugetlb-page-number-decrease-failed-on-movable-nodes.patch added to mm-unstable branch
Message-Id: <20230905155636.2A115C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb_vmemmap: fix hugetlb page number decrease failed on movable nodes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-fix-hugetlb-page-number-decrease-failed-on-movable-nodes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-fix-hugetlb-page-number-decrease-failed-on-movable-nodes.patch

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
From: Yuan Can <yuancan@huawei.com>
Subject: mm: hugetlb_vmemmap: fix hugetlb page number decrease failed on movable nodes
Date: Tue, 5 Sep 2023 20:45:03 +0800

The decreasing of hugetlb pages number failed with the following message
given:

 sh: page allocation failure: order:0, mode:0x204cc0(GFP_KERNEL|__GFP_RETRY_MAYFAIL|__GFP_THISNODE)
 CPU: 1 PID: 112 Comm: sh Not tainted 6.5.0-rc7-... #45
 Hardware name: linux,dummy-virt (DT)
 Call trace:
  dump_backtrace.part.6+0x84/0xe4
  show_stack+0x18/0x24
  dump_stack_lvl+0x48/0x60
  dump_stack+0x18/0x24
  warn_alloc+0x100/0x1bc
  __alloc_pages_slowpath.constprop.107+0xa40/0xad8
  __alloc_pages+0x244/0x2d0
  hugetlb_vmemmap_restore+0x104/0x1e4
  __update_and_free_hugetlb_folio+0x44/0x1f4
  update_and_free_hugetlb_folio+0x20/0x68
  update_and_free_pages_bulk+0x4c/0xac
  set_max_huge_pages+0x198/0x334
  nr_hugepages_store_common+0x118/0x178
  nr_hugepages_store+0x18/0x24
  kobj_attr_store+0x18/0x2c
  sysfs_kf_write+0x40/0x54
  kernfs_fop_write_iter+0x164/0x1dc
  vfs_write+0x3a8/0x460
  ksys_write+0x6c/0x100
  __arm64_sys_write+0x1c/0x28
  invoke_syscall+0x44/0x100
  el0_svc_common.constprop.1+0x6c/0xe4
  do_el0_svc+0x38/0x94
  el0_svc+0x28/0x74
  el0t_64_sync_handler+0xa0/0xc4
  el0t_64_sync+0x174/0x178
 Mem-Info:
  ...

The reason is that the hugetlb pages being released are allocated from
movable nodes, and with hugetlb_optimize_vmemmap enabled, vmemmap pages
need to be allocated from the same node during the hugetlb pages
releasing. With GFP_KERNEL and __GFP_THISNODE set, allocating from movable
node is always failed. Fix this problem by removing __GFP_THISNODE.

Link: https://lkml.kernel.org/r/20230905124503.24899-1-yuancan@huawei.com
Fixes: ad2fa3717b74 ("mm: hugetlb: alloc the vmemmap pages associated with each HugeTLB page")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-fix-hugetlb-page-number-decrease-failed-on-movable-nodes
+++ a/mm/hugetlb_vmemmap.c
@@ -381,7 +381,7 @@ static int vmemmap_remap_free(unsigned l
 static int alloc_vmemmap_page_list(unsigned long start, unsigned long end,
 				   struct list_head *list)
 {
-	gfp_t gfp_mask = GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_THISNODE;
+	gfp_t gfp_mask = GFP_KERNEL | __GFP_RETRY_MAYFAIL;
 	unsigned long nr_pages = (end - start) >> PAGE_SHIFT;
 	int nid = page_to_nid((struct page *)start);
 	struct page *page, *next;
_

Patches currently in -mm which might be from yuancan@huawei.com are

mm-hugetlb_vmemmap-fix-hugetlb-page-number-decrease-failed-on-movable-nodes.patch

