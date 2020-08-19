Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D2E3C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 03:50:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19FAC20829
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 03:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597809045;
	bh=jvKae6t6Z+7E22IdlHn2mKP9mhHKBdJMOzI+nxaDn3Y=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=b1bQ0PjRE+tVACs3vTLJhZoP+pfsQLja2N2SoKqK9CpM8rzbNxdBRx+OdsUypVxw2
	 a7SDINENgZ6hTRm/5sEJfGIZWfbWg5G2ruLgG/gAfyqTDJ6Isf6Yf/DPSSdTKG8pab
	 IRTtZ3RvlG/VxkAwfIcFo83aKHbruLV5okNZ7Kt8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgHSDuo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 23:50:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgHSDum (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 23:50:42 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 588A320829;
        Wed, 19 Aug 2020 03:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597809041;
        bh=jvKae6t6Z+7E22IdlHn2mKP9mhHKBdJMOzI+nxaDn3Y=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=aYoHRxCJnGTFuEopdUpXjAbwqIUTsQ5uEMF7eys0Ypxoz6aDb3tHE1ZsKYidrysC1
         Cf7ckO7O+3aWvSOiZ6zXBpjHnL3uC+ZxiQWK+nP6Pjvpeq2ygAuL8edlpeRZaZAza/
         569IZ5P+Ee28rtCjn5Sg9BJMVl6dpHXIKC3SfTFY=
Date:   Tue, 18 Aug 2020 20:50:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, alex.shi@linux.alibaba.com, guro@fb.com,
        hannes@cmpxchg.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, mhocko@kernel.org,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        richard.weiyang@gmail.com, vdavydov.dev@gmail.com,
        willy@infradead.org
Subject:  + mm-memcg-remove-useless-check-on-page-mem_cgroup.patch
 added to -mm tree
Message-ID: <20200819035039.cm20Ie4TP%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: bail out early from swap accounting when memcg is disabled
has been added to the -mm tree.  Its filename is
     mm-memcg-remove-useless-check-on-page-mem_cgroup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-remove-useless-check-on-page-mem_cgroup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-remove-useless-check-on-page-mem_cgroup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/memcg: bail out early from swap accounting when memcg is disabled

If we disabled memcg by cgroup_disable=memory, page->memcg will be NULL
and so the charge is skipped and that will trigger a warning like below. 
Let's return from the funcs earlier.

 anon flags:0x5005b48008000d(locked|uptodate|dirty|swapbacked)
 raw: 005005b48008000d dead000000000100 dead000000000122 ffff8897c7c76ad1
 raw: 0000000000000022 0000000000000000 0000000200000000 0000000000000000
 page dumped because: VM_WARN_ON_ONCE_PAGE(!memcg)
...
 RIP: 0010:vprintk_emit+0x1f7/0x260
 Code: 00 84 d2 74 72 0f b6 15 27 58 64 01 48 c7 c0 00 d4 72 82 84 d2 74 09 f3 90 0f b6 10 84 d2 75 f7 e8 de 0d 00 00 4c 89 e7 57 9d <0f> 1f 44 00 00 e9 62 ff ff ff 80 3d 88 c9 3a 01 00 0f 85 54 fe ff
 RSP: 0018:ffffc9000faab358 EFLAGS: 00000202
 RAX: ffffffff8272d400 RBX: 000000000000005e RCX: ffff88afd80d0040
 RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000202
 RBP: ffffc9000faab3a8 R08: ffffffff8272d440 R09: 0000000000022480
 R10: 00120c77be68bfac R11: 0000000000cd7568 R12: 0000000000000202
 R13: 0057ffffc0080005 R14: ffffffff820a0130 R15: ffffc9000faab3e8
 ? vprintk_emit+0x140/0x260
 vprintk_default+0x1a/0x20
 vprintk_func+0x4f/0xc4
 ? vprintk_func+0x4f/0xc4
 printk+0x53/0x6a
 ? xas_load+0xc/0x80
 __dump_page.cold.6+0xff/0x4ee
 ? xas_init_marks+0x23/0x50
 ? xas_store+0x30/0x40
 ? free_swap_slot+0x43/0xd0
 ? put_swap_page+0x119/0x320
 ? update_load_avg+0x82/0x580
 dump_page+0x9/0xb
 mem_cgroup_try_charge_swap+0x16e/0x1d0
 get_swap_page+0x130/0x210
 add_to_swap+0x41/0xc0
 shrink_page_list+0x99e/0xdf0
 shrink_inactive_list+0x199/0x360
 shrink_lruvec+0x40d/0x650
 ? _cond_resched+0x14/0x30
 ? _cond_resched+0x14/0x30
 shrink_node+0x226/0x6e0
 do_try_to_free_pages+0xd0/0x400
 try_to_free_pages+0xef/0x130
 __alloc_pages_slowpath.constprop.127+0x38d/0xbd0
 ? ___slab_alloc+0x31d/0x6f0
 __alloc_pages_nodemask+0x27f/0x2c0
 alloc_pages_vma+0x75/0x220
 shmem_alloc_page+0x46/0x90
 ? release_pages+0x1ae/0x410
 shmem_alloc_and_acct_page+0x77/0x1c0
 shmem_getpage_gfp+0x162/0x910
 shmem_fault+0x74/0x210
 ? filemap_map_pages+0x29c/0x410
 __do_fault+0x37/0x190
 handle_mm_fault+0x120a/0x1770
 exc_page_fault+0x251/0x450
 ? asm_exc_page_fault+0x8/0x30
 asm_exc_page_fault+0x1e/0x30

Link: http://lkml.kernel.org/r/abd9276b-31f8-a51d-43d6-6c8ae93237dc@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/memcontrol.c~mm-memcg-remove-useless-check-on-page-mem_cgroup
+++ a/mm/memcontrol.c
@@ -7098,6 +7098,9 @@ void mem_cgroup_swapout(struct page *pag
 	VM_BUG_ON_PAGE(PageLRU(page), page);
 	VM_BUG_ON_PAGE(page_count(page), page);
 
+	if (mem_cgroup_disabled())
+		return;
+
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return;
 
@@ -7163,6 +7166,9 @@ int mem_cgroup_try_charge_swap(struct pa
 	struct mem_cgroup *memcg;
 	unsigned short oldid;
 
+	if (mem_cgroup_disabled())
+		return 0;
+
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return 0;
 
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

mm-memcg-warning-on-memcg-after-readahead-page-charged.patch
mm-memcg-remove-useless-check-on-page-mem_cgroup.patch
mm-thp-move-lru_add_page_tail-func-to-huge_memoryc.patch
mm-thp-clean-up-lru_add_page_tail.patch
mm-thp-remove-code-path-which-never-got-into.patch
mm-thp-narrow-lru-locking.patch

