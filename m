Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1489AECAAD4
	for <mm-commits@archiver.kernel.org>; Mon, 29 Aug 2022 20:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiH2Upl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Aug 2022 16:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiH2Upk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2022 16:45:40 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D1F255BA
        for <mm-commits@vger.kernel.org>; Mon, 29 Aug 2022 13:45:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 26FA8CE13BE
        for <mm-commits@vger.kernel.org>; Mon, 29 Aug 2022 20:45:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15590C433D6;
        Mon, 29 Aug 2022 20:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661805934;
        bh=bsmBvc8EYLIMuAcVc+tInaeVUYCiyv1ai8Hz8wquzXU=;
        h=Date:To:From:Subject:From;
        b=Idd57NR9UeNVEfe4Dd27fOcccX+PD8NwgUHIjQodEWzDU1GvGl24JdlKOOlQzrv6J
         bkhXV7OWG6pIdm0TohWdhsfcR2CZuUlkqdRoMEPR+UouThbTfdscVJpS6hLXjGX/nA
         MAA35yCh/m2KselS3BMfkB67NSUCEfEzk6HLUGU4=
Date:   Mon, 29 Aug 2022 13:45:32 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, liushixin2@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-remove-redundant-config_transparent_hugepage.patch added to mm-unstable branch
Message-Id: <20220829204534.15590C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: remove redundant CONFIG_TRANSPARENT_HUGEPAGE
has been added to the -mm mm-unstable branch.  Its filename is
     mm-thp-remove-redundant-config_transparent_hugepage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-remove-redundant-config_transparent_hugepage.patch

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
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/thp: remove redundant CONFIG_TRANSPARENT_HUGEPAGE
Date: Mon, 29 Aug 2022 17:51:25 +0800

Simplify code by removing redundant CONFIG_TRANSPARENT_HUGEPAGE judgment.

No functional change.

Link: https://lkml.kernel.org/r/20220829095125.3284567-1-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/pgtable.h~mm-thp-remove-redundant-config_transparent_hugepage
+++ a/include/linux/pgtable.h
@@ -1289,8 +1289,7 @@ static inline int pgd_devmap(pgd_t pgd)
 #endif
 
 #if !defined(CONFIG_TRANSPARENT_HUGEPAGE) || \
-	(defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
-	 !defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD))
+	!defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
 static inline int pud_trans_huge(pud_t pud)
 {
 	return 0;
_

Patches currently in -mm which might be from liushixin2@huawei.com are

revert-frontswap-remove-support-for-multiple-ops.patch
revert-mm-mark-swap_lock-and-swap_active_head-static.patch
revert-frontswap-simplify-frontswap_register_ops.patch
mm-zswap-replace-zswap_init_started-failed-with-zswap_init_state.patch
mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement.patch
mm-zswap-skip-confusing-print-info.patch
mm-thp-simplify-has_transparent_hugepage-by-using-is_builtin.patch
mm-thp-remove-redundant-config_transparent_hugepage.patch

