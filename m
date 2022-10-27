Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55676FA3740
	for <mm-commits@archiver.kernel.org>; Thu, 27 Oct 2022 20:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236954AbiJ0UM3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Oct 2022 16:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236906AbiJ0ULv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2022 16:11:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2228A7CE
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 13:11:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A03F624C9
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 20:11:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA70C433D6;
        Thu, 27 Oct 2022 20:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666901509;
        bh=5ES27lkiiqISd8hKjP0+hldAJKhi/yUAPBdVBOkXL2k=;
        h=Date:To:From:Subject:From;
        b=y6Njz36kDoObhNbs8CSi9Kj2NaCU1Zw9vxTQh1Ov1F1hmvsV0rZwbUKc+REvpNOOA
         nti9BW5tAi0HFaSNqd5gn3xhUMc0Fa9A5ltHffA8+pDtywOkoHMcwPUktNbA8UKbTb
         abiVsWfDbKI87lu0Q9c+/SPPrwPBv29piC0hYvrE=
Date:   Thu, 27 Oct 2022 13:11:48 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-reclaimlru_sort-remove-unnecessarily-included-headers.patch added to mm-unstable branch
Message-Id: <20221027201149.8EA70C433D6@smtp.kernel.org>
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
Date: Wed, 26 Oct 2022 22:59:43 +0000

Some headers that 'reclaim.c' and 'lru_sort.c' are including are
unnecessary now owing to previous cleanups and refactorings.  Remove
those.

Link: https://lkml.kernel.org/r/20221026225943.100429-13-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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
mm-damon-sysfs-split-out-schemes-directory-implementation-to-separate-file.patch
mm-damon-modules-deduplicate-init-steps-for-damon-context-setup.patch
mm-damon-reclaimlru_sort-remove-unnecessarily-included-headers.patch
mm-damon-reclaim-enable-and-disable-synchronously.patch
selftests-damon-add-tests-for-damon_reclaims-enabled-parameter.patch
mm-damon-lru_sort-enable-and-disable-synchronously.patch
selftests-damon-add-tests-for-damon_lru_sorts-enabled-parameter.patch

