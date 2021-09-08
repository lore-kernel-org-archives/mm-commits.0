Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E186C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:17:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FCF061101
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:17:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235450AbhIHCSj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:18:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346910AbhIHCSj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:18:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8621560187;
        Wed,  8 Sep 2021 02:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631067450;
        bh=KIluVt1lTU/7FRNqoM4LbAtSgQeu6keK9PrPProMmyc=;
        h=Date:From:To:Subject:From;
        b=ZCI4LmkAhKto/ZSDAFSDfDk47nw/A2FNEwG2VvpM0viOgMKTAE57tyAxredHDcHtr
         j5dd1RoEWfcpD5G7AJMZDqbCmQVhlwHjaooGogeDR7c9Rd10k21gXHp0cuh5JKNQxN
         TOOlFsOxBXQ1219NL9WhctpotQFUpUnMYBhQUaus=
Date:   Tue, 07 Sep 2021 19:17:30 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        sfr@canb.auug.org.au, sjpark@amazon.de
Subject:  [folded-merged]
 mm-idle_page_tracking-make-pg_idle-reusable-fix.patch removed from -mm tree
Message-ID: <20210908021730.8AwwetEWa%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/PAGE_IDLE_FLAG: Set PAGE_EXTENSION for none-64BIT
has been removed from the -mm tree.  Its filename was
     mm-idle_page_tracking-make-pg_idle-reusable-fix.patch

This patch was dropped because it was folded into mm-idle_page_tracking-make-pg_idle-reusable.patch

------------------------------------------------------
From: SeongJae Park <sjpark@amazon.de>
Subject: mm/PAGE_IDLE_FLAG: Set PAGE_EXTENSION for none-64BIT

Commit 128fd80c4c07 ("mm/idle_page_tracking: Make PG_idle reusable") of
linux-mm[1] allows PAGE_IDLE_FLAG to be set without PAGE_EXTENSION while
64BIT is not set.  This makes 'enum page_ext_flags' undefined, so build
fails as below for the config (!64BIT, !PAGE_EXTENSION, and
IDLE_PAGE_FLAG).

    $ make ARCH=i386 allnoconfig
    $ echo 'CONFIG_PAGE_IDLE_FLAG=y' >> .config
    $ make olddefconfig
    $ make ARCH=i386
    [...]
    ../include/linux/page_idle.h: In function `folio_test_young':
    ../include/linux/page_idle.h:25:18: error: `PAGE_EXT_YOUNG' undeclared (first use in this function); did you mean `PAGEOUTRUN'?
       return test_bit(PAGE_EXT_YOUNG, &page_ext->flags);
    [...]

This commit fixes this issue by making PAGE_EXTENSION to be set when 64BIT
is not set and PAGE_IDLE_FLAG is set.

[1] https://github.com/hnaz/linux-mm/commit/128fd80c4c07

Link: https://lkml.kernel.org/r/20210806095153.6444-1-sj38.park@gmail.com
Fixes: 128fd80c4c07 ("mm/idle_page_tracking: Make PG_idle reusable")
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/Kconfig~mm-idle_page_tracking-make-pg_idle-reusable-fix
+++ a/mm/Kconfig
@@ -741,6 +741,7 @@ config DEFERRED_STRUCT_PAGE_INIT
 
 config PAGE_IDLE_FLAG
 	bool "Add PG_idle and PG_young flags"
+	select PAGE_EXTENSION if !64BIT
 	help
 	  This feature adds PG_idle and PG_young flags in 'struct page'.  PTE
 	  Accessed bit writers can set the state of the bit in the flags to let
@@ -749,7 +750,6 @@ config PAGE_IDLE_FLAG
 config IDLE_PAGE_TRACKING
 	bool "Enable idle page tracking"
 	depends on SYSFS && MMU
-	select PAGE_EXTENSION if !64BIT
 	select PAGE_IDLE_FLAG
 	help
 	  This feature allows to estimate the amount of user pages that have
_

Patches currently in -mm which might be from sjpark@amazon.de are

mm-introduce-data-access-monitor-damon.patch
mm-damon-core-implement-region-based-sampling.patch
mm-damon-adaptively-adjust-regions.patch
mm-idle_page_tracking-make-pg_idle-reusable.patch
mm-idle_page_tracking-make-pg_idle-reusable-fix-2.patch
mm-damon-implement-primitives-for-the-virtual-memory-address-spaces.patch
mm-damon-implement-primitives-for-the-virtual-memory-address-spaces-fix-2.patch
mm-damon-implement-primitives-for-the-virtual-memory-address-spaces-fix-3.patch
mm-damon-add-a-tracepoint.patch
mm-damon-implement-a-debugfs-based-user-space-interface.patch
mm-damon-dbgfs-export-kdamond-pid-to-the-user-space.patch
mm-damon-dbgfs-support-multiple-contexts.patch
documentation-add-documents-for-damon.patch
mm-damon-add-kunit-tests.patch
mm-damon-add-user-space-selftests.patch
maintainers-update-for-damon.patch

