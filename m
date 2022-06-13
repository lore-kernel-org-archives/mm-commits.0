Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95B87CCA47B
	for <mm-commits@archiver.kernel.org>; Mon, 13 Jun 2022 20:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbiFMUlw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jun 2022 16:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343499AbiFMUlF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jun 2022 16:41:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10F4A462
        for <mm-commits@vger.kernel.org>; Mon, 13 Jun 2022 12:40:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BE1DB811EC
        for <mm-commits@vger.kernel.org>; Mon, 13 Jun 2022 19:40:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4217DC34114;
        Mon, 13 Jun 2022 19:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655149248;
        bh=Qp/nB0YOLaGCuzwdj093FE2uOZQr5Pzd+goLLgGy9kY=;
        h=Date:To:From:Subject:From;
        b=QuL0xiYyEPCR5GQse5Gc/nnfS/6rcSewl5m7qBEmNeYTRtvR5aX/d8tgegOJ/o4bo
         9TUQyCknz6pe+6xAb2aIA6s63P65dOm4DofTlf37FpVHb5yiMbX7mcjuINLFWOtN84
         K0Os3ROSedpHTtJm7iOBdY0i2WdQOEvvqzaK/iUI=
Date:   Mon, 13 Jun 2022 12:40:47 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-damon-sysfs-document-lru_deprio-scheme-action.patch added to mm-unstable branch
Message-Id: <20220613194048.4217DC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/damon/sysfs: document 'LRU_DEPRIO' scheme action
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-damon-sysfs-document-lru_deprio-scheme-action.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-damon-sysfs-document-lru_deprio-scheme-action.patch

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
Subject: Docs/admin-guide/damon/sysfs: document 'LRU_DEPRIO' scheme action
Date: Mon, 13 Jun 2022 19:22:59 +0000

This commit documents the 'LRU_DEPRIO' scheme action for DAMON sysfs
interface.`

Link: https://lkml.kernel.org/r/20220613192301.8817-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-damon-sysfs-document-lru_deprio-scheme-action
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -265,6 +265,7 @@ that can be written to and read from the
  - ``hugepage``: Call ``madvise()`` for the region with ``MADV_HUGEPAGE``
  - ``nohugepage``: Call ``madvise()`` for the region with ``MADV_NOHUGEPAGE``
  - ``lru_prio``: Prioritize the region on its LRU lists.
+ - ``lru_deprio``: Deprioritize the region on its LRU lists.
  - ``stat``: Do nothing but count the statistics
 
 schemes/<N>/access_pattern/
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-schedule-damon_reclaim_timer-only-after-system_wq-is-initialized.patch
docs-admin-guide-damon-reclaim-remove-a-paragraph-that-been-obsolete-due-to-online-tuning-support.patch
mm-damon-dbgfssysfs-move-target_has_pid-from-dbgfs-to-damonh.patch
mm-damon-reclaim-deduplicate-commit_inputs-handling.patch
mm-damon-sysfs-deduplicate-inputs-applying.patch
mm-damon-reclaim-make-enabled-checking-timer-simpler.patch
mm-damon-reclaim-add-damon_reclaim_-prefix-to-enabled_store.patch
mm-damon-dbgfs-add-and-use-mappings-between-schemes-action-inputs-and-damos_action-values.patch
mm-damon-paddr-use-a-separate-function-for-damos_pageout-handling.patch
mm-damon-schemes-add-lru_prio-damos-action.patch
docs-admin-guide-damon-sysfs-document-lru_prio-scheme-action.patch
mm-damon-schemes-add-lru_deprio-action.patch
docs-admin-guide-damon-sysfs-document-lru_deprio-scheme-action.patch
mm-damon-introduce-damon-based-lru-lists-sorting.patch
docs-admin-guide-damon-add-a-document-for-damon_lru_sort.patch

