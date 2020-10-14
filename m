Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EFFDC433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27E2022248
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709195;
	bh=WNU5jMfAyFHUTseCb6WQgNInW7J5aEMhXEXWai+N+Bs=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ZEpyLukHNKexAyspfzEAGXvCyzzqew2Pf7xjCZ2oQSGsxYhPUNOpnlIl8JvSFgMvb
	 QPilkFv8jKuVzG95ssaUfk0v51eQkKYjA2iyHWIGoD2LzvG/mSj75J4kirHXxJJxe/
	 v3YdnEBs8lOT2wX6EhSFKjQ1jeq2B7gTMOApAGFM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389552AbgJNU7y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:59:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:50320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387696AbgJNU7y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:59:54 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FBAB20725;
        Wed, 14 Oct 2020 20:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709192;
        bh=WNU5jMfAyFHUTseCb6WQgNInW7J5aEMhXEXWai+N+Bs=;
        h=Date:From:To:Subject:From;
        b=ABxEyw+DpROaDz0033ihPx0vYOB2i+OXWF/J1umO93Qzv/2EjcSp0NROMGmIrHen3
         IpsAcTiQpMiDuRLHJg5itXdx1Pd5k9zSuvnyvsDqiBsFIRfOuS3gIHvg3yS1+XJJZr
         Dxlruax4MDq2GJpBv+XZdKi9vUrM/N6RNmQdDqag=
Date:   Wed, 14 Oct 2020 13:59:52 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-remove-unnecessary-goto-out-in-_swap_info_get.patch removed from -mm
 tree
Message-ID: <20201014205952.Rilm7YWmV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile.c: remove unnecessary goto out in _swap_info_get()
has been removed from the -mm tree.  Its filename was
     mm-remove-unnecessary-goto-out-in-_swap_info_get.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swapfile.c: remove unnecessary goto out in _swap_info_get()

It's unnecessary to goto the out label while out label is just below.

Link: https://lkml.kernel.org/r/20200930102549.1885-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/swapfile.c~mm-remove-unnecessary-goto-out-in-_swap_info_get
+++ a/mm/swapfile.c
@@ -1184,7 +1184,6 @@ static struct swap_info_struct *_swap_in
 
 bad_free:
 	pr_err("swap_info_get: %s%08lx\n", Unused_offset, entry.val);
-	goto out;
 out:
 	return NULL;
 }
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-vmstat-use-helper-macro-abs.patch
mm-fix-some-broken-comments.patch
mm-use-helper-function-put_write_access.patch
percpu_counter-use-helper-macro-abs.patch
mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

