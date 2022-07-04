Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B0B9C43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232647AbiGDBJh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiGDBJd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:09:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11224626B
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:09:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6117B80BD1
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1ADC341C7;
        Mon,  4 Jul 2022 01:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656896969;
        bh=5W+gR9O7V9LFAGHaBw6zU13RRy32dubqiYdgpFcSbuY=;
        h=Date:To:From:Subject:From;
        b=dy/1diOhhMmzq43HEOixtE3rJWv/8yKy9JWRArh15dFzgx9RTm7Vi1T26sa2MGzPJ
         FEjjGBFP8vicEW1lqxayQpIw+Fi8mswfTv3dtJ+YBHkPMdC4SGMKlFkZ5jxgCDZJUC
         L7Ta8CIkJd7BcfNYgrWDChOJ3YChosVYvlPJh49E=
Date:   Sun, 03 Jul 2022 18:09:28 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-damon-reclaim-remove-a-paragraph-that-been-obsolete-due-to-online-tuning-support.patch removed from -mm tree
Message-Id: <20220704010929.5D1ADC341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/admin-guide/damon/reclaim: remove a paragraph that been obsolete due to online tuning support
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-damon-reclaim-remove-a-paragraph-that-been-obsolete-due-to-online-tuning-support.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/damon/reclaim: remove a paragraph that been obsolete due to online tuning support
Date: Mon, 6 Jun 2022 18:23:05 +0000

Patch series "mm/damon: trivial cleanups".

This patchset contains trivial cleansups for DAMON code.


This patch (of 6):

Commit 81a84182c343 ("Docs/admin-guide/mm/damon/reclaim: document
'commit_inputs' parameter") has documented the 'commit_inputs' parameter
which allows online parameter update, but it didn't remove a paragraph
saying the online parameter update is impossible.  This commit removes the
obsolete paragraph.

Link: https://lkml.kernel.org/r/20220606182310.48781-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20220606182310.48781-2-sj@kernel.org
Fixes: 81a84182c343 ("Docs/admin-guide/mm/damon/reclaim: document 'commit_inputs' parameter")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/reclaim.rst |    6 ------
 1 file changed, 6 deletions(-)

--- a/Documentation/admin-guide/mm/damon/reclaim.rst~docs-admin-guide-damon-reclaim-remove-a-paragraph-that-been-obsolete-due-to-online-tuning-support
+++ a/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -48,12 +48,6 @@ DAMON_RECLAIM utilizes module parameters
 ``damon_reclaim.<parameter>=<value>`` on the kernel boot command line or write
 proper values to ``/sys/modules/damon_reclaim/parameters/<parameter>`` files.
 
-Note that the parameter values except ``enabled`` are applied only when
-DAMON_RECLAIM starts.  Therefore, if you want to apply new parameter values in
-runtime and DAMON_RECLAIM is already enabled, you should disable and re-enable
-it via ``enabled`` parameter file.  Writing of the new values to proper
-parameter values should be done before the re-enablement.
-
 Below are the description of each parameter.
 
 enabled
_

Patches currently in -mm which might be from sj@kernel.org are

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

