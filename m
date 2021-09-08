Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58EC5C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:17:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43C22610A3
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:17:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347014AbhIHCSn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:18:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346910AbhIHCSm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:18:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2A126103D;
        Wed,  8 Sep 2021 02:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631067455;
        bh=XtQtp6dvx1RXrvi81JjQY3V/pURypMUtpMIT2NwAmQ4=;
        h=Date:From:To:Subject:From;
        b=0vTJdPaHz1kgDCISx6oRv/CvAVGrU3Fz/ZQWcbIKBMEvCtYHYtkvZeUijDT4m29I7
         1gsdZY7CwLD1WnkRu0TWoxBIgfYDIz2p7MMdS3zaEXn6bMTtSwmfU6KoiRH1EABIBL
         zwMufyoQlhhgYQbF5pvrzI8l4/lGgyRgODRpw9so=
Date:   Tue, 07 Sep 2021 19:17:35 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        sjpark@amazon.de, valdis.kletnieks@vt.edu
Subject:  [folded-merged]
 mm-idle_page_tracking-make-pg_idle-reusable-fix-2.patch removed from -mm
 tree
Message-ID: <20210908021735.Kn39mcc4F%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/Kconfig: Hide PAGE_IDLE_FLAG from users
has been removed from the -mm tree.  Its filename was
     mm-idle_page_tracking-make-pg_idle-reusable-fix-2.patch

This patch was dropped because it was folded into mm-idle_page_tracking-make-pg_idle-reusable.patch

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

