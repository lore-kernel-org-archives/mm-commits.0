Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E87EECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:32:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbiILDcD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiILDaC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:30:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D32FB1F8
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 736F66116E
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF466C433D7;
        Mon, 12 Sep 2022 03:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953365;
        bh=tHVrQp5my1M+VWljcDhpSv75yigpzJTHX7jp1p5Rtfo=;
        h=Date:To:From:Subject:From;
        b=IDt30R+8XVSTupVvOp9UmRie+4XQzamf+XeJzclRnUzSLAmv1nvPtKkzHRR9YvE4l
         XjVONyAorXsqrjzVeTH+Vo+jO2TJ7hROnuC2KFyN/VgeRYN9S2PV0+QY4W4llrs3Mt
         Febp6Mq5JGZY/XQYK/xMd41NZOpq8rB8CMcnqs9U=
Date:   Sun, 11 Sep 2022 20:29:25 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hwpoison-fix-extra-put_page-in-soft_offline_page.patch removed from -mm tree
Message-Id: <20220912032925.CF466C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, hwpoison: fix extra put_page() in soft_offline_page()
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-fix-extra-put_page-in-soft_offline_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm, hwpoison: fix extra put_page() in soft_offline_page()
Date: Thu, 18 Aug 2022 21:00:13 +0800

When hwpoison_filter() refuses to soft offline a page, the page refcnt
incremented previously by MF_COUNT_INCREASED would have been consumed via
get_hwpoison_page() if ret <= 0.  So the put_ref_page() here will put the
extra one.  Remove it to fix the issue.

Link: https://lkml.kernel.org/r/20220818130016.45313-4-linmiaohe@huawei.com
Fixes: 9113eaf331bf ("mm/memory-failure.c: add hwpoison_filter for soft offline")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-fix-extra-put_page-in-soft_offline_page
+++ a/mm/memory-failure.c
@@ -2591,8 +2591,6 @@ retry:
 	if (hwpoison_filter(page)) {
 		if (ret > 0)
 			put_page(page);
-		else
-			put_ref_page(ref_page);
 
 		mutex_unlock(&mf_mutex);
 		return -EOPNOTSUPP;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch
mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch
mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch
mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon.patch
mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings.patch
mm-hwpoison-cleanup-some-obsolete-comments.patch
writeback-remove-unused-macro-dirty_full_scope.patch

