Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81281C4338F
	for <mm-commits@archiver.kernel.org>; Fri, 13 Aug 2021 20:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D189610FA
	for <mm-commits@archiver.kernel.org>; Fri, 13 Aug 2021 20:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233983AbhHMUQB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Aug 2021 16:16:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233875AbhHMUP6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 13 Aug 2021 16:15:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AF4A610CC;
        Fri, 13 Aug 2021 20:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628885731;
        bh=sfEoI1IX7gpqabI9miy0CymvEUYrpboG5UU0pGQg3uk=;
        h=Date:From:To:Subject:From;
        b=eEDhirnnaygOUjb//6Uhs45gp+yuqRYcPWd9qCoPJzfgfz0Qb+AorRglE6pUn1+ra
         3+3yMLiFuS7/pjWc4EUDW1ZmKI1MxyeThUzvKI30t1xRLfXb9RlBljYVGRjJ0r2spI
         LYzS9nR7mCUlCwTOyje7ajURbiy7Fake5f1QNegQ=
Date:   Fri, 13 Aug 2021 13:15:31 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, valdis.kletnieks@vt.edu,
        akpm@linux-foundation.org, sjpark@amazon.de
Subject:  + mm-idle_page_tracking-make-pg_idle-reusable-fix-2.patch
 added to -mm tree
Message-ID: <20210813201531.ZQq66%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/Kconfig: Hide PAGE_IDLE_FLAG from users
has been added to the -mm tree.  Its filename is
     mm-idle_page_tracking-make-pg_idle-reusable-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-idle_page_tracking-make-pg_idle-reusable-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-idle_page_tracking-make-pg_idle-reusable-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sjpark@amazon.de>
Subject: mm/damon/Kconfig: Hide PAGE_IDLE_FLAG from users

Commit 2a058a1a9914 ("mm/idle_page_tracking: make PG_idle reusable") of
linux-mm[1] makes CONFIG_PAGE_IDLE_FLAG option to be presented to the
user.  However, the option is hard to be understood by users.  Also, it is
not intended to be set by users but other kernel subsystems like DAMON or
IDLE_PAGE_TRACKING.  To avoid confusions, this commit removes the prompt
so that the option is not presented to the user.

[1] https://github.com/hnaz/linux-mm/commit/2a058a1a9914

Link: https://lkml.kernel.org/r/20210813081238.34705-1-sj38.park@gmail.com
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/Kconfig~mm-idle_page_tracking-make-pg_idle-reusable-fix-2
+++ a/mm/Kconfig
@@ -740,7 +740,7 @@ config DEFERRED_STRUCT_PAGE_INIT
 	  initialisation.
 
 config PAGE_IDLE_FLAG
-	bool "Add PG_idle and PG_young flags"
+	bool
 	select PAGE_EXTENSION if !64BIT
 	help
 	  This adds PG_idle and PG_young flags to 'struct page'.  PTE Accessed
_

Patches currently in -mm which might be from sjpark@amazon.de are

mm-introduce-data-access-monitor-damon.patch
mm-damon-core-implement-region-based-sampling.patch
mm-damon-adaptively-adjust-regions.patch
mm-idle_page_tracking-make-pg_idle-reusable.patch
mm-idle_page_tracking-make-pg_idle-reusable-fix.patch
mm-idle_page_tracking-make-pg_idle-reusable-fix-2.patch
mm-damon-implement-primitives-for-the-virtual-memory-address-spaces.patch
mm-damon-implement-primitives-for-the-virtual-memory-address-spaces-fix-2.patch
mm-damon-add-a-tracepoint.patch
mm-damon-implement-a-debugfs-based-user-space-interface.patch
mm-damon-dbgfs-export-kdamond-pid-to-the-user-space.patch
mm-damon-dbgfs-support-multiple-contexts.patch
documentation-add-documents-for-damon.patch
mm-damon-add-kunit-tests.patch
mm-damon-add-user-space-selftests.patch
maintainers-update-for-damon.patch

