Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26FA7C10F1E
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:18:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbiLLCSY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:18:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbiLLCQu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:16:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A4CDFE5
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:15:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 032AD60EB9
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:15:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA03C433D2;
        Mon, 12 Dec 2022 02:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811306;
        bh=LxLMw1SlKDtio4opjKhRuzobm1goNCklBnMulVpmaYQ=;
        h=Date:To:From:Subject:From;
        b=hflvtgey3U6S/mGM4nLrlLNTTyz0QECPTvJkisSIQRIPFhF+OLUAdtPuGiafE2Ffv
         ouL38dAdxX9Y7arNoJQVU4j/s9j8635HMfrtRbtzAm0QP03NGRiIPgeKZg02ea0YIv
         L22ummrpPMZ4WfZ+i0kMIG/+JbZo6IcNapQoDnLc=
Date:   Sun, 11 Dec 2022 18:15:05 -0800
To:     mm-commits@vger.kernel.org, shli@fusionio.com, riel@redhat.com,
        hughd@google.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-cond_resched-in-swapin_walk_pmd_entry.patch removed from -mm tree
Message-Id: <20221212021506.5EA03C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add cond_resched() in swapin_walk_pmd_entry()
has been removed from the -mm tree.  Its filename was
     mm-add-cond_resched-in-swapin_walk_pmd_entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: add cond_resched() in swapin_walk_pmd_entry()
Date: Mon, 5 Dec 2022 22:03:27 +0800

When handling MADV_WILLNEED in madvise(), a soflockup may occurr in
swapin_walk_pmd_entry() if swapping in lots of memory on a slow device. 
Add a cond_resched() to avoid the possible softlockup.

Link: https://lkml.kernel.org/r/20221205140327.72304-1-wangkefeng.wang@huawei.com
Fixes: 1998cc048901 ("mm: make madvise(MADV_WILLNEED) support swap file prefetch")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Shaohua Li <shli@fusionio.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/madvise.c~mm-add-cond_resched-in-swapin_walk_pmd_entry
+++ a/mm/madvise.c
@@ -223,6 +223,7 @@ static int swapin_walk_pmd_entry(pmd_t *
 			put_page(page);
 	}
 	swap_read_unplug(splug);
+	cond_resched();
 
 	return 0;
 }
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hwposion-support-recovery-from-ksm_might_need_to_copy.patch

