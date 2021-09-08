Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33B5DC433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:19:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1162660187
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345390AbhIHCUQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:20:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:59324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235450AbhIHCUO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:20:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A305F60187;
        Wed,  8 Sep 2021 02:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631067541;
        bh=+TXJXDDbQWNhb/Gi64OqF2RdBY9qT9SBBKGW39jbDsc=;
        h=Date:From:To:Subject:From;
        b=X1cfkT+ATjxrVeEkf95WlnHuYQa/ae5+N9otv7eSwchHc097h3FLjkszvCeZEHirJ
         V6Pr62SBC0KjqbaAyrLLyrVCrsgWV1u1x1N81bRMQ7yTikBRyBkk9LU8IEZdN6mnb0
         /oeRjDQXDO0suTV4Aj7RL1J8X+6/Vyrz9cV2uRis=
Date:   Tue, 07 Sep 2021 19:19:01 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        sfr@canb.auug.org.au, sjpark@amazon.de
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-damon-implement-primitives-for-the-virtual-memory-addres?=
 =?US-ASCII?Q?s-spaces-fix-2.patch?= removed from -mm tree
Message-ID: <20210908021901.8BghyHOay%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/Kconfig: Remove unnecessary PAGE_EXTENSION setup
has been removed from the -mm tree.  Its filename was
     mm-damon-implement-primitives-for-the-virtual-memory-address-spaces-fix-2.patch

This patch was dropped because it was folded into mm-damon-implement-primitives-for-the-virtual-memory-address-spaces.patch

------------------------------------------------------
From: SeongJae Park <sjpark@amazon.de>
Subject: mm/damon/Kconfig: Remove unnecessary PAGE_EXTENSION setup

Commit 13d49dbd0123 ("mm/damon: implement primitives for the virtual
memory address spaces") of linux-mm[1] makes DAMON_VADDR to set
PAGE_IDLE_FLAG.  PAGE_IDLE_FLAG sets PAGE_EXTENSION if !64BIT.  However,
DAMON_VADDR do the same work again.  This commit removes the unnecessary
duplicate.

[1] https://github.com/hnaz/linux-mm/commit/13d49dbd0123

Link: https://lkml.kernel.org/r/20210806095153.6444-2-sj38.park@gmail.com
Fixes: 13d49dbd0123 ("mm/damon: implement primitives for the virtual memory address spaces")
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/damon/Kconfig~mm-damon-implement-primitives-for-the-virtual-memory-address-spaces-fix-2
+++ a/mm/damon/Kconfig
@@ -15,7 +15,6 @@ config DAMON
 config DAMON_VADDR
 	bool "Data access monitoring primitives for virtual address spaces"
 	depends on DAMON && MMU
-	select PAGE_EXTENSION if !64BIT
 	select PAGE_IDLE_FLAG
 	help
 	  This builds the default data access monitoring primitives for DAMON
_

Patches currently in -mm which might be from sjpark@amazon.de are

mm-introduce-data-access-monitor-damon.patch
mm-damon-core-implement-region-based-sampling.patch
mm-damon-adaptively-adjust-regions.patch
mm-idle_page_tracking-make-pg_idle-reusable.patch
mm-damon-implement-primitives-for-the-virtual-memory-address-spaces.patch
mm-damon-implement-primitives-for-the-virtual-memory-address-spaces-fix-3.patch
mm-damon-add-a-tracepoint.patch
mm-damon-implement-a-debugfs-based-user-space-interface.patch
mm-damon-dbgfs-export-kdamond-pid-to-the-user-space.patch
mm-damon-dbgfs-support-multiple-contexts.patch
documentation-add-documents-for-damon.patch
mm-damon-add-kunit-tests.patch
mm-damon-add-user-space-selftests.patch
maintainers-update-for-damon.patch

