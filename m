Return-Path: <SRS0=MO2u=DC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14F5CC4346E
	for <mm-commits@archiver.kernel.org>; Fri, 25 Sep 2020 02:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B925420EDD
	for <mm-commits@archiver.kernel.org>; Fri, 25 Sep 2020 02:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601001469;
	bh=Lc+ty4px+9TVZ2zJRp0uCz1OGTN7lNiCJkorfgk6ERM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=NYrrPHCo4fXOsMVlvnPbUCgpC8YB+7kJ94K0NeRDZGu8bSM/FlMptVxAonMsSgy2I
	 MSyo8vtMQMOtdCGEu3suUyBp0ktD2eMSevp45LKvhfCNciV1TyJgtquklN8ZY55Q3b
	 cwrAotwpQDeW2noa8K3ZjuBqDYre64jVcnNKTZoc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgIYCht (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Sep 2020 22:37:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726676AbgIYCht (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 24 Sep 2020 22:37:49 -0400
Received: from X1 (unknown [104.245.68.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC25E207C4;
        Fri, 25 Sep 2020 02:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601001468;
        bh=Lc+ty4px+9TVZ2zJRp0uCz1OGTN7lNiCJkorfgk6ERM=;
        h=Date:From:To:Subject:From;
        b=qvvwA9vlmOJ5Lcfaea6C//jl/2VCExiahy9LMJmPc/lJWhmqU/zB3VnWgIXtlSKeK
         GkMmq5h4BA2QXSXtlMv891aSvHRyeYwTFY0ue845uOphtj7M2Ngy7LejBs0VBV4Z2A
         Nx1Xt3B3AiEgopyN68EQRw2dUPa7o1DST93jNI9U=
Date:   Thu, 24 Sep 2020 19:37:48 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com
Subject:  +
 =?us-ascii?Q?mm-swap=5Fslotsc-remove-always-zero-and-unused-return-value-?=
 =?us-ascii?Q?of-enable=5Fswap=5Fslots=5Fcache.patch?= added to -mm tree
Message-ID: <20200925023748.uTpnC%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap_slots.c: remove always zero and unused return value of enable_swap_slots_cache()
has been added to the -mm tree.  Its filename is
     mm-swap_slotsc-remove-always-zero-and-unused-return-value-of-enable_swap_slots_cache.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-swap_slotsc-remove-always-zero-and-unused-return-value-of-enable_swap_slots_cache.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-swap_slotsc-remove-always-zero-and-unused-return-value-of-enable_swap_slots_cache.patch

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
Subject: mm/swap_slots.c: remove always zero and unused return value of enable_swap_slots_cache()

enable_swap_slots_cache() always return zero and its return value is just
ignored by the caller.  So make enable_swap_slots_cache() void.

Link: https://lkml.kernel.org/r/20200924113554.50614-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap_slots.h |    2 +-
 mm/swap_slots.c            |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/include/linux/swap_slots.h~mm-swap_slotsc-remove-always-zero-and-unused-return-value-of-enable_swap_slots_cache
+++ a/include/linux/swap_slots.h
@@ -23,7 +23,7 @@ struct swap_slots_cache {
 
 void disable_swap_slots_cache_lock(void);
 void reenable_swap_slots_cache_unlock(void);
-int enable_swap_slots_cache(void);
+void enable_swap_slots_cache(void);
 int free_swap_slot(swp_entry_t entry);
 
 extern bool swap_slot_cache_enabled;
--- a/mm/swap_slots.c~mm-swap_slotsc-remove-always-zero-and-unused-return-value-of-enable_swap_slots_cache
+++ a/mm/swap_slots.c
@@ -237,7 +237,7 @@ static int free_slot_cache(unsigned int
 	return 0;
 }
 
-int enable_swap_slots_cache(void)
+void enable_swap_slots_cache(void)
 {
 	mutex_lock(&swap_slots_cache_enable_mutex);
 	if (!swap_slot_cache_initialized) {
@@ -255,7 +255,6 @@ int enable_swap_slots_cache(void)
 	__reenable_swap_slots_cache();
 out_unlock:
 	mutex_unlock(&swap_slots_cache_enable_mutex);
-	return 0;
 }
 
 /* called with swap slot cache's alloc lock held */
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swap-fix-confusing-comment-in-release_pages.patch
mm-swap_slotsc-remove-always-zero-and-unused-return-value-of-enable_swap_slots_cache.patch
mm-memcontrol-correct-the-comment-of-mem_cgroup_iter.patch
mm-page_counter-correct-the-obsolete-func-name-in-the-comment-of-page_counter_try_charge.patch
mm-memcontrol-remove-obsolete-comment-of-mem_cgroup_unmark_under_oom.patch
mm-use-helper-function-mapping_allow_writable.patch
mm-mmap-use-helper-function-allow_write_access-in-__remove_shared_vm_struct.patch
mm-vmstat-use-helper-macro-abs.patch
mm-fix-some-broken-comments.patch
mm-use-helper-function-put_write_access.patch
mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

