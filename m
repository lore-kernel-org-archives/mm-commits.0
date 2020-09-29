Return-Path: <SRS0=qjDH=DG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D692C4727C
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 20:08:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 199C420848
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 20:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601410098;
	bh=v8zmL6JHyY8q3LCkh1qbGaz8xeE2lASK65sF8eQLtqE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=bciRitSxemkOTqnMMDwWF009n37x6IT8oM8s6f0Kl0iKCKv2RcTMK4KP6QdvazzP9
	 7JH+gSY1ZaBDJJIlB9EOFNl1zmzoajLkVYXMTCKZ44bJUq66+3tR3bo1UiGQ89E9dg
	 gOs8H9z7OhGs7x/ja83rwQHFshHKNjkQ+dQCdsbg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728761AbgI2UIR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Sep 2020 16:08:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728362AbgI2UIR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 29 Sep 2020 16:08:17 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26DDC2076A;
        Tue, 29 Sep 2020 20:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601410096;
        bh=v8zmL6JHyY8q3LCkh1qbGaz8xeE2lASK65sF8eQLtqE=;
        h=Date:From:To:Subject:From;
        b=wcwGiQJtxlvDytxVQpwHucGC3FRmc7w3MFOLZwzQzPJcUdWfjCEkm04cm2BUeeOpO
         Ts6Z/V5rtRRgnwvq2PsVZf3AdUsYWer8gIMMdIJlYLZlTEwjTaxUcJD4DlcOi0neRo
         Bu0YqCbqDZI8QwetiK4USrZeM9uQoQeoqlSrjv/E=
Date:   Tue, 29 Sep 2020 13:08:15 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, linmiaohe@huawei.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, vdavydov.dev@gmail.com
Subject:  [to-be-updated]
 mm-memcontrol-remove-obsolete-comment-of-mem_cgroup_unmark_under_oom.patch
 removed from -mm tree
Message-ID: <20200929200815.swv6e9YbY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: remove obsolete comment of mem_cgroup_unmark_under_oom()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-remove-obsolete-comment-of-mem_cgroup_unmark_under_oom.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: memcontrol: remove obsolete comment of mem_cgroup_unmark_under_oom()

Since commit 79dfdaccd1d5 ("memcg: make oom_lock 0 and 1 based rather than
counter"), the mem_cgroup_unmark_under_oom() is added and the comment of
the mem_cgroup_oom_unlock() is moved here.  But this comment make no sense
here because mem_cgroup_oom_lock() does not operate on under_oom field.

Link: https://lkml.kernel.org/r/20200917105900.4337-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-remove-obsolete-comment-of-mem_cgroup_unmark_under_oom
+++ a/mm/memcontrol.c
@@ -1825,10 +1825,6 @@ static void mem_cgroup_unmark_under_oom(
 {
 	struct mem_cgroup *iter;
 
-	/*
-	 * When a new child is created while the hierarchy is under oom,
-	 * mem_cgroup_oom_lock() may not be called. Watch for underflow.
-	 */
 	spin_lock(&memcg_oom_lock);
 	for_each_mem_cgroup_tree(iter, memcg)
 		if (iter->under_oom > 0)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swap-fix-confusing-comment-in-release_pages.patch
mm-swap_slotsc-remove-always-zero-and-unused-return-value-of-enable_swap_slots_cache.patch
mm-remove-useless-out-label-in-__swap_writepage.patch
mm-fix-incomplete-comment-in-lru_cache_add_inactive_or_unevictable.patch
mm-memcontrol-correct-the-comment-of-mem_cgroup_iter.patch
mm-page_counter-correct-the-obsolete-func-name-in-the-comment-of-page_counter_try_charge.patch
mm-use-helper-function-mapping_allow_writable.patch
mm-mmap-use-helper-function-allow_write_access-in-__remove_shared_vm_struct.patch
mm-mempool-add-else-to-split-mutually-exclusive-case.patch
mm-vmstat-use-helper-macro-abs.patch
mm-fix-some-broken-comments.patch
mm-use-helper-function-put_write_access.patch
percpu_counter-use-helper-macro-abs.patch
mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

