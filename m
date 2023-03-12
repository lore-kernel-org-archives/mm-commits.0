Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92D62C6FD19
	for <mm-commits@archiver.kernel.org>; Sun, 12 Mar 2023 20:51:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbjCLUvF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 12 Mar 2023 16:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbjCLUvD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 12 Mar 2023 16:51:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7A43CE2A
        for <mm-commits@vger.kernel.org>; Sun, 12 Mar 2023 13:50:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C921960FE4
        for <mm-commits@vger.kernel.org>; Sun, 12 Mar 2023 20:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2507EC433D2;
        Sun, 12 Mar 2023 20:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678654246;
        bh=hDYrbuZW8DLBli5FvJs1pOp79lIO4dKIT/NUETmDxWY=;
        h=Date:To:From:Subject:From;
        b=ovDsol9WDR29Rh+5+N+DHYUpFv8+r8BbceAgApfyPXmjf9p6uhphOsVjBKfO9XdaT
         mW673gOGPi8YYK60lNaBcsJ4BC6CB7Zy0m/Lr3APFjrJRynMqmr4w/5H20Ej+dC70m
         khViaodxdCVPSDbp448AZ2BAUkQjoGMybVtOkvPA=
Date:   Sun, 12 Mar 2023 13:50:45 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-correct-hwpoison_inject-config.patch added to mm-unstable branch
Message-Id: <20230312205046.2507EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory-failure: correct HWPOISON_INJECT config
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-correct-hwpoison_inject-config.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-correct-hwpoison_inject-config.patch

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
Subject: mm: memory-failure: correct HWPOISON_INJECT config
Date: Fri, 10 Mar 2023 21:38:43 +0800

Use IS_ENABLED(CONFIG_HWPOISON_INJECT) to check whether or not to enable
HWPoison injector module.

Link: https://lkml.kernel.org/r/20230310133843.76883-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memory-failure.c~mm-memory-failure-correct-hwpoison_inject-config
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
mm-memory-failure-correct-hwpoison_inject-config.patch

