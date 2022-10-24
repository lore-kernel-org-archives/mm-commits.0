Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDE97C38A2D
	for <mm-commits@archiver.kernel.org>; Tue, 25 Oct 2022 00:08:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbiJYAIc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Oct 2022 20:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbiJYAHe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2022 20:07:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5963A105CD7
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 15:25:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5F17615D9
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 22:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E71C433D6;
        Mon, 24 Oct 2022 22:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666650358;
        bh=f5+++rGEMgpOUlzX8+RO4xeSczv3eFXvID+5q89cuB8=;
        h=Date:To:From:Subject:From;
        b=De96N31uH5cATxk+DenLlYAfyQyt0n8oOA64bdQlSAUW0E3t/vrFLzJ6yziHlr2eV
         nVKqeOyjNe3BL+TlENPlMGmFd4O6Chpiai7z0WBs1JBtqRQgViwZaG52H4FJ6t5zfD
         2kCIODgyz6y42QAi7hqdou5MlBAeHesmf5Ix02cU=
Date:   Mon, 24 Oct 2022 15:25:57 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-reclaimlru_sort-remove-unnecessarily-included-headers.patch added to mm-unstable branch
Message-Id: <20221024222558.02E71C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/{reclaim,lru_sort}: remove unnecessarily included headers
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-reclaimlru_sort-remove-unnecessarily-included-headers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-reclaimlru_sort-remove-unnecessarily-included-headers.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/{reclaim,lru_sort}: remove unnecessarily included headers
Date: Mon, 24 Oct 2022 20:49:19 +0000

Some headers that 'reclaim.c' and 'lru_sort.c' are including are
unnecessary now owing to previous cleanups and refactorings.  Remove
those.

Link: https://lkml.kernel.org/r/20221024204919.18524-12-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |    2 --
 mm/damon/reclaim.c  |    2 --
 2 files changed, 4 deletions(-)

--- a/mm/damon/lru_sort.c~mm-damon-reclaimlru_sort-remove-unnecessarily-included-headers
+++ a/mm/damon/lru_sort.c
@@ -8,9 +8,7 @@
 #define pr_fmt(fmt) "damon-lru-sort: " fmt
 
 #include <linux/damon.h>
-#include <linux/ioport.h>
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/workqueue.h>
 
 #include "modules-common.h"
--- a/mm/damon/reclaim.c~mm-damon-reclaimlru_sort-remove-unnecessarily-included-headers
+++ a/mm/damon/reclaim.c
@@ -8,9 +8,7 @@
 #define pr_fmt(fmt) "damon-reclaim: " fmt
 
 #include <linux/damon.h>
-#include <linux/ioport.h>
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/workqueue.h>
 
 #include "modules-common.h"
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-split-out-damos-charged-region-skip-logic-into-a-new-function.patch
mm-damon-core-split-damos-application-logic-into-a-new-function.patch
mm-damon-core-split-out-scheme-stat-update-logic-into-a-new-function.patch
mm-damon-core-split-out-scheme-quota-adjustment-logic-into-a-new-function.patch
mm-damon-sysfs-use-damon_addr_range-for-regions-start-and-end-values.patch
mm-damon-sysfs-remove-parameters-of-damon_sysfs_region_alloc.patch
mm-damon-sysfs-move-sysfs_lock-to-common-module.patch
mm-damon-sysfs-move-unsigned-long-range-directory-to-common-module.patch
mm-damon-sysfs-split-out-kdamond-independent-schemes-stats-update-logic-into-a-new-function.patch
mm-damon-modules-deduplicate-init-steps-for-damon-context-setup.patch
mm-damon-reclaimlru_sort-remove-unnecessarily-included-headers.patch

