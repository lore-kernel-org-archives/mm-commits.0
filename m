Return-Path: <SRS0=qjDH=DG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5121FC4727C
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 00:34:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1987E2193E
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 00:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601339684;
	bh=8HQOMwWoPIR20OdLvJYUoKQi+Ioe7Hg6tks38WkcMDE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=WDBm78e0ff/3fiBye0Ks4/VgJMr63uXIHQRZoPsL8++SjUMhmSHuaD3yYxgAq8cq2
	 /2m2P69nFFYTp884LAZNDKhqcjLC8l+c4p09RmenlC+6UT8pbT86H5Xr2Js0GJk7tB
	 73oyTg1VPh2/C5JHfG0oz9e7xfFgzoe/ZTqh2W7E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgI2Aen (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Sep 2020 20:34:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbgI2Aen (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Sep 2020 20:34:43 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A628921BE5;
        Tue, 29 Sep 2020 00:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601339682;
        bh=8HQOMwWoPIR20OdLvJYUoKQi+Ioe7Hg6tks38WkcMDE=;
        h=Date:From:To:Subject:From;
        b=t4EaN88rfBHbfQk3dprFxzHGI8LF5++TRoRBx3Pf11gVi/KK5GLRfcVmos3mY5lnW
         ursmnINaPQe5Q0YcZKN0cHFGCMClVlGIjRdxneiqkhWcig8ApID1LsvB3IumV/G8mr
         a5vlGzdm3XLjyBg70nLJL2DhgbP6Il2cdwfd1DFo=
Date:   Mon, 28 Sep 2020 17:34:42 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org
Subject:  + percpu_counter-use-helper-macro-abs.patch added to -mm
 tree
Message-ID: <20200929003442.fSD7-wUXx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/percpu_counter.c: use helper macro abs()
has been added to the -mm tree.  Its filename is
     percpu_counter-use-helper-macro-abs.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/percpu_counter-use-helper-macro-abs.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/percpu_counter-use-helper-macro-abs.patch

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
Subject: lib/percpu_counter.c: use helper macro abs()

Use helper macro abs() to simplify the "x >= t || x <= -t" cmp.

Link: https://lkml.kernel.org/r/20200927122746.5964-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/percpu_counter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/percpu_counter.c~percpu_counter-use-helper-macro-abs
+++ a/lib/percpu_counter.c
@@ -85,7 +85,7 @@ void percpu_counter_add_batch(struct per
 
 	preempt_disable();
 	count = __this_cpu_read(*fbc->counters) + amount;
-	if (count >= batch || count <= -batch) {
+	if (abs(count) >= batch) {
 		unsigned long flags;
 		raw_spin_lock_irqsave(&fbc->lock, flags);
 		fbc->count += count;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swap-fix-confusing-comment-in-release_pages.patch
mm-swap_slotsc-remove-always-zero-and-unused-return-value-of-enable_swap_slots_cache.patch
mm-remove-useless-out-label-in-__swap_writepage.patch
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

