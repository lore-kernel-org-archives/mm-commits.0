Return-Path: <SRS0=qjDH=DG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F968C2D0A8
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 00:36:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2348521BE5
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 00:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601339762;
	bh=rom0AtmYOY1JSX6NoA+vRjJq8SD477lgy+x13M7xIDY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=PsI3BpVGtM7zMXJKf0uIIjJ8NV3EBL1T6zlGXHBT/H96OjO86npsZ9y/xGr/gU97j
	 x5bJwDAe8Iss+1mO8w+v5glXg4WkmeZy5fFwepQ0msaRjs4fZ1Nyq3VYABHBS87oFn
	 kgIGfiRsatB99y1ELQsfbENOT7xPnCR7NP/7OMEU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbgI2AgB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Sep 2020 20:36:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726522AbgI2AgB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Sep 2020 20:36:01 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A643F2193E;
        Tue, 29 Sep 2020 00:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601339759;
        bh=rom0AtmYOY1JSX6NoA+vRjJq8SD477lgy+x13M7xIDY=;
        h=Date:From:To:Subject:From;
        b=lwArEO6UInnkbpfhN6s8VA93k0hCEOqk+nLVMKof9G1q2CSUlHakFqS6Ko71Ewzke
         jzwGG/t5H0hgUIWdbl2ONDCV0AWgDa6jhl8ssP6lvNc1pw5Bw5fkbvsckL9zwR2pSL
         t02dJxPsrkELVEYxdNtrW1NHfOL8wzA6HKNLF3DE=
Date:   Mon, 28 Sep 2020 17:35:59 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        shakeelb@google.com
Subject:  +
 mm-fix-incomplete-comment-in-lru_cache_add_inactive_or_unevictable.patch
 added to -mm tree
Message-ID: <20200929003559.2Hl8S6fE_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap.c: fix incomplete comment in lru_cache_add_inactive_or_unevictable()
has been added to the -mm tree.  Its filename is
     mm-fix-incomplete-comment-in-lru_cache_add_inactive_or_unevictable.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-incomplete-comment-in-lru_cache_add_inactive_or_unevictable.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-incomplete-comment-in-lru_cache_add_inactive_or_unevictable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swap.c: fix incomplete comment in lru_cache_add_inactive_or_unevictable()

Since commit 9c4e6b1a7027 ("mm, mlock, vmscan: no more skipping
pagevecs"), unevictable pages do not goes directly back onto zone's
unevictable list.

Link: https://lkml.kernel.org/r/20200927122209.59328-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/swap.c~mm-fix-incomplete-comment-in-lru_cache_add_inactive_or_unevictable
+++ a/mm/swap.c
@@ -481,9 +481,7 @@ EXPORT_SYMBOL(lru_cache_add);
  * @vma:   vma in which page is mapped for determining reclaimability
  *
  * Place @page on the inactive or unevictable LRU list, depending on its
- * evictability.  Note that if the page is not evictable, it goes
- * directly back onto it's zone's unevictable list, it does NOT use a
- * per cpu pagevec.
+ * evictability.
  */
 void lru_cache_add_inactive_or_unevictable(struct page *page,
 					 struct vm_area_struct *vma)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swap-fix-confusing-comment-in-release_pages.patch
mm-swap_slotsc-remove-always-zero-and-unused-return-value-of-enable_swap_slots_cache.patch
mm-remove-useless-out-label-in-__swap_writepage.patch
mm-fix-incomplete-comment-in-lru_cache_add_inactive_or_unevictable.patch
mm-memcontrol-correct-the-comment-of-mem_cgroup_iter.patch
mm-page_counter-correct-the-obsolete-func-name-in-the-comment-of-page_counter_try_charge.patch
mm-memcontrol-remove-obsolete-comment-of-mem_cgroup_unmark_under_oom.patch
mm-use-helper-function-mapping_allow_writable.patch
mm-mmap-use-helper-function-allow_write_access-in-__remove_shared_vm_struct.patch
mm-mempool-add-else-to-split-mutually-exclusive-case.patch
mm-vmstat-use-helper-macro-abs.patch
mm-fix-some-broken-comments.patch
mm-use-helper-function-put_write_access.patch
percpu_counter-use-helper-macro-abs.patch
mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

