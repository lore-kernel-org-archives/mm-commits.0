Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5789C6FD19
	for <mm-commits@archiver.kernel.org>; Mon, 13 Mar 2023 19:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjCMTqu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Mar 2023 15:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCMTqt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Mar 2023 15:46:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A44848DB
        for <mm-commits@vger.kernel.org>; Mon, 13 Mar 2023 12:46:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91856B81190
        for <mm-commits@vger.kernel.org>; Mon, 13 Mar 2023 19:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DADDC433D2;
        Mon, 13 Mar 2023 19:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678736805;
        bh=ef9t0pj3JGtL8QOaquXt23PBQjU1rP62GwRTSMZ+6Bk=;
        h=Date:To:From:Subject:From;
        b=DYD2sT2Yq3bf/0hQ1t9yT8Wdn5pMS7CxUzAFK2LcgXvhLk9zZL/QtS0xbAg2/7yFF
         8BcRa9EtXdz0E39WB/7WdTK5Vple2WZOnqziHtPRf47qe1MHD3lotDao0nH6xnHWpV
         eeqExtb/plzngCDa8qdcMonNLEs6n9dt6mPvT6BQ=
Date:   Mon, 13 Mar 2023 12:46:44 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-directly-use-is_enabledconfig_hwpoison_inject.patch added to mm-unstable branch
Message-Id: <20230313194645.4DADDC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory-failure: directly use IS_ENABLED(CONFIG_HWPOISON_INJECT)
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-directly-use-is_enabledconfig_hwpoison_inject.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-directly-use-is_enabledconfig_hwpoison_inject.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory-failure: directly use IS_ENABLED(CONFIG_HWPOISON_INJECT)
Date: Mon, 13 Mar 2023 13:39:29 +0800

It's more clear and simple to just use IS_ENABLED(CONFIG_HWPOISON_INJECT)
to check whether or not to enable HWPoison injector module instead of
CONFIG_HWPOISON_INJECT/CONFIG_HWPOISON_INJECT_MODULE.

Link: https://lkml.kernel.org/r/20230313053929.84607-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memory-failure.c~mm-memory-failure-directly-use-is_enabledconfig_hwpoison_inject
+++ a/mm/memory-failure.c
@@ -168,7 +168,7 @@ static bool page_handle_poison(struct pa
 	return true;
 }
 
-#if defined(CONFIG_HWPOISON_INJECT) || defined(CONFIG_HWPOISON_INJECT_MODULE)
+#if IS_ENABLED(CONFIG_HWPOISON_INJECT)
 
 u32 hwpoison_filter_enable = 0;
 u32 hwpoison_filter_dev_major = ~0U;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-huge_memory-convert-__do_huge_pmd_anonymous_page-to-use-a-folio.patch
mm-memory-use-folio_throttle_swaprate-in-do_swap_page.patch
mm-memory-use-folio_throttle_swaprate-in-page_copy_prealloc.patch
mm-memory-use-folio_throttle_swaprate-in-wp_page_copy.patch
mm-memory-use-folio_throttle_swaprate-in-do_anonymous_page.patch
mm-memory-use-folio_throttle_swaprate-in-do_cow_fault.patch
mm-swap-remove-unneeded-cgroup_throttle_swaprate.patch
mm-damon-paddr-minor-refactor-of-damon_pa_pageout.patch
mm-damon-paddr-minor-refactor-of-damon_pa_mark_accessed_or_deactivate.patch
mm-damon-paddr-fix-missing-folio_sz-update-in-damon_pa_young.patch
mm-memory-failure-directly-use-is_enabledconfig_hwpoison_inject.patch

