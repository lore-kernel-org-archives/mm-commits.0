Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6074E7F14B
	for <mm-commits@archiver.kernel.org>; Wed, 27 Sep 2023 01:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjI0BqH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Sep 2023 21:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235103AbjI0BoG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Sep 2023 21:44:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B246B1FC6
        for <mm-commits@vger.kernel.org>; Tue, 26 Sep 2023 17:51:07 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48637C433C9;
        Wed, 27 Sep 2023 00:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695775867;
        bh=5uNdh0TTB3gHxzjZ93b6wGw9j66XGv9cBcEGOzmqKQg=;
        h=Date:To:From:Subject:From;
        b=d/1JrsqsOTKioLLjwGdnWZJUGHNHGenfSgJ1ls7Yfy3J7NZ2/an0YvVLfkNTYsno1
         aQi+SJuIya+03xRiupyTm/m75jNm8oJ4nEy3qHuKD/Vl4IUUMq+Xxdhe2J05iKkwOd
         DJSYZa+up55agBfznK3E38JDPGFbde3QbC5Q282o=
Date:   Tue, 26 Sep 2023 17:51:06 -0700
To:     mm-commits@vger.kernel.org, shr@devkernel.io, riel@surriel.com,
        hannes@cmpxchg.org, david@redhat.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-document-smart-scan-mode-fix-2.patch added to mm-unstable branch
Message-Id: <20230927005107.48637C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-ksm-document-smart-scan-mode-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-document-smart-scan-mode-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-document-smart-scan-mode-fix-2.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-ksm-document-smart-scan-mode-fix
Date: Tue Sep 26 05:48:29 PM PDT 2023

document that smart_scan defaults to on

Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/ksm.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/ksm.rst~mm-ksm-document-smart-scan-mode-fix-2
+++ a/Documentation/admin-guide/mm/ksm.rst
@@ -156,12 +156,12 @@ stable_node_chains_prune_millisecs
         ``max_page_sharing`` yet.
 
 smart_scan
-        By default KSM checks every candidate page for each scan. It does
-        not take into account historic information. When smart scan is
+        Historically KSM checked every candidate page for each scan. It did
+        not take into account historic information.  When smart scan is
         enabled, pages that have previously not been de-duplicated get
         skipped. How often these pages are skipped depends on how often
         de-duplication has already been tried and failed. By default this
-        optimization is disabled. The ``pages_skipped`` metric shows how
+        optimization is enabled.  The ``pages_skipped`` metric shows how
         effective the setting is.
 
 The effectiveness of KSM and MADV_MERGEABLE is shown in ``/sys/kernel/mm/ksm/``:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-memcg-reconsider-kmemlimit_in_bytes-deprecation-fix.patch
mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim-fix.patch
mm-hugetlb-skip-initialization-of-gigantic-tail-struct-pages-if-freed-by-hvo-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2.patch
mm-ksm-add-smart-page-scanning-mode-fix.patch
mm-ksm-document-smart-scan-mode-fix.patch
mm-ksm-document-smart-scan-mode-fix-2.patch
kthread-add-kthread_stop_put-v2-fix.patch

