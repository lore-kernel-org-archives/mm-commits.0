Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F5F0C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 13 Jun 2022 20:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbiFMUlu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jun 2022 16:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245683AbiFMUlF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jun 2022 16:41:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 092C962C8
        for <mm-commits@vger.kernel.org>; Mon, 13 Jun 2022 12:40:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 946BF61556
        for <mm-commits@vger.kernel.org>; Mon, 13 Jun 2022 19:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72A9C34114;
        Mon, 13 Jun 2022 19:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655149244;
        bh=POufKOG48w5GGKi9JrrKgSkrWIlFZF+6zJjaa7+Xd3U=;
        h=Date:To:From:Subject:From;
        b=k0zBsOULl4O2JQmq3Ciw3N1u1PaCRd4+/MbP+dOnjtjeGxAVK5eke+eTO/f0rXA7s
         t9V0oBm+ddoxw5BjMjEiK9Lmq3/nz5Lb67hxwBAVaRK161pmqP2CL3xBMPxcSQbEpA
         U5c9aCO6cZEj3HIVhLuUxJLiDwmSkOfG6h7RJn+4=
Date:   Mon, 13 Jun 2022 12:40:43 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-damon-sysfs-document-lru_prio-scheme-action.patch added to mm-unstable branch
Message-Id: <20220613194043.E72A9C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/admin-guide/damon/sysfs: document 'LRU_PRIO' scheme action
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-damon-sysfs-document-lru_prio-scheme-action.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-damon-sysfs-document-lru_prio-scheme-action.patch

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
Subject: Docs/admin-guide/damon/sysfs: document 'LRU_PRIO' scheme action
Date: Mon, 13 Jun 2022 19:22:57 +0000

This commit documents the 'lru_prio' scheme action for DAMON sysfs
interface.

Link: https://lkml.kernel.org/r/20220613192301.8817-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-damon-sysfs-document-lru_prio-scheme-action
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -264,6 +264,7 @@ that can be written to and read from the
  - ``pageout``: Call ``madvise()`` for the region with ``MADV_PAGEOUT``
  - ``hugepage``: Call ``madvise()`` for the region with ``MADV_HUGEPAGE``
  - ``nohugepage``: Call ``madvise()`` for the region with ``MADV_NOHUGEPAGE``
+ - ``lru_prio``: Prioritize the region on its LRU lists.
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

