Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 807DEECAAA1
	for <mm-commits@archiver.kernel.org>; Thu, 27 Oct 2022 20:15:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbiJ0UPY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Oct 2022 16:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235982AbiJ0UPX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2022 16:15:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDE550059
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 13:15:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8E9CB82705
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 20:15:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21231C433C1;
        Thu, 27 Oct 2022 20:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666901717;
        bh=zAKETobHugwKomKLedgs3mLUr1TD5xfX00WhFViY0rc=;
        h=Date:To:From:Subject:From;
        b=0u4kHFM7RZ1gqDU7qSH4oQuqSH6oAq862VqNxbAQPcgSR0YMZf7gm3m759MwuRcAp
         6H0d5AxtcdkY1CmavohAk8zEFTPSBezHX34EcU63twhKBnL6eA+WvFvCmcpIloIdLV
         u66GsI+9kRvsIf5LWcy6gzXyB8BtrSNJ9VbQyvWo=
Date:   Thu, 27 Oct 2022 13:15:16 -0700
To:     mm-commits@vger.kernel.org, vpetrucci@gmail.com, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-describe-the-rules-of-sysfs-region-directories.patch added to mm-unstable branch
Message-Id: <20221027201517.21231C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: describe the rules of sysfs region directories
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-describe-the-rules-of-sysfs-region-directories.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-describe-the-rules-of-sysfs-region-directories.patch

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
Subject: Docs/admin-guide/mm/damon/usage: describe the rules of sysfs region directories
Date: Mon, 24 Oct 2022 17:46:18 +0000

Patch series "Docs/admin-buide/mm/damon/usage: minor fixes".

DAMON usage document contains an unclear description and a wrong usage
example.  This patchset fixes the two minor problems.


This patch (of 2):

Target region directories of DAMON sysfs interface should contain no
overlap and sorted by the address, but not clearly documented.  Actually,
a user had an issue[1] due to the poor documentation.  Add clear
description of it on the usage document.

[1] https://lore.kernel.org/damon/CAEZ6=UNUcH2BvJj++OrT=XQLdkidU79wmCO=tantSOB36pPNTg@mail.gmail.com/

Link: https://lkml.kernel.org/r/20221024174619.15600-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20221024174619.15600-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Vinicius Petrucci <vpetrucci@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-describe-the-rules-of-sysfs-region-directories
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -235,6 +235,9 @@ In each region directory, you will find
 can set and get the start and end addresses of the initial monitoring target
 region by writing to and reading from the files, respectively.
 
+Each region should not overlap with others.  ``end`` of directory ``N`` should
+be equal or smaller than ``start`` of directory ``N+1``.
+
 contexts/<N>/schemes/
 ---------------------
 
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
docs-admin-guide-mm-damon-usage-describe-the-rules-of-sysfs-region-directories.patch
docs-admin-guide-mm-damon-usage-fix-wrong-usage-example-of-init_regions-file.patch

