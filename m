Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F572C00144
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:08:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239614AbiG3BI0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239604AbiG3BIV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281933B979
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B627161BB6
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179EDC433D7;
        Sat, 30 Jul 2022 01:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143300;
        bh=0HPRM+YkvVMrLt3wwwDw/kjy09ST/dpxYGS04k43Hfw=;
        h=Date:To:From:Subject:From;
        b=qudOSK9gG+1BHaZKmnjfLzq9FLUUvzrNrnuy+XSOW4jXmDCdnesMAETR6ijwPTlm2
         APUEMACUuWw83FCv6Hg2xYuVPtxSWq3NP0SRNP6vWa9wlf9BqfmWTsi1H03TvgdZIL
         N0jvIkoNAMiqPpMT/NgbDggitGqTBBGPMnvt3Izw=
Date:   Fri, 29 Jul 2022 18:08:19 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-obsolete-comment-in-do_fault_around.patch removed from -mm tree
Message-Id: <20220730010820.179EDC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove obsolete comment in do_fault_around()
has been removed from the -mm tree.  Its filename was
     mm-remove-obsolete-comment-in-do_fault_around.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: remove obsolete comment in do_fault_around()
Date: Sat, 16 Jul 2022 16:03:59 +0800

Since commit 7267ec008b5c ("mm: postpone page table allocation until we
have page to map"), do_fault_around is not called with page table lock
held.  Cleanup the corresponding comments.

Link: https://lkml.kernel.org/r/20220716080359.38791-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/memory.c~mm-remove-obsolete-comment-in-do_fault_around
+++ a/mm/memory.c
@@ -4439,10 +4439,6 @@ late_initcall(fault_around_debugfs);
  * It uses vm_ops->map_pages() to map the pages, which skips the page if it's
  * not ready to be mapped: not up-to-date, locked, etc.
  *
- * This function is called with the page table lock taken. In the split ptlock
- * case the page table lock only protects only those entries which belong to
- * the page table corresponding to the fault address.
- *
  * This function doesn't cross the VMA boundaries, in order to call map_pages()
  * only once.
  *
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch

