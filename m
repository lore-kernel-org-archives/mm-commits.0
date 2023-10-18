Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8D44CDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 16:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbjJRQSr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 12:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbjJRQSo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 12:18:44 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7B598
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 09:18:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E3BC433C7;
        Wed, 18 Oct 2023 16:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697645922;
        bh=Sc5pTHi3xFDEBV5Y2rojlp7t8bxzMrszdRm/PBnxIcw=;
        h=Date:To:From:Subject:From;
        b=bJ+G2xMUhRY6cYUmf9M6nG++dO/Yjo/Ze204yIvGnJj00WZTcFCI99p+z5zgT93VZ
         vIVRRjmchFNa5wf7Z/ROIOQeoGAzvLk959faRnbj4nhfl69XolaDNX4PkBDMZw9Ef3
         lwqtkJQE4qdWgcO7CUA2jEk9OaRqbal/+Gn4b5rc=
Date:   Wed, 18 Oct 2023 09:18:42 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, david@redhat.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-add-nr_split-to-trace_mm_migrate_pages-stats-fix.patch added to mm-unstable branch
Message-Id: <20231018161842.A1E3BC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-migrate-add-nr_split-to-trace_mm_migrate_pages-stats-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-add-nr_split-to-trace_mm_migrate_pages-stats-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-add-nr_split-to-trace_mm_migrate_pages-stats-fix.patch

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
Subject: mm-migrate-add-nr_split-to-trace_mm_migrate_pages-stats-fix
Date: Wed Oct 18 09:17:30 AM PDT 2023

cleanup per Huang, Ying

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-add-nr_split-to-trace_mm_migrate_pages-stats-fix
+++ a/mm/migrate.c
@@ -1686,7 +1686,7 @@ static int migrate_pages_batch(struct li
 
 					if (!ret) {
 						stats->nr_thp_split += is_thp;
-						stats->nr_split += is_large;
+						stats->nr_split++;
 						break;
 					} else if (reason == MR_LONGTERM_PIN &&
 						   ret == -EAGAIN) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2.patch
mm-add-printf-attribute-to-shrinker_debugfs_name_alloc-fix.patch
mm-kmem-make-memcg-keep-a-reference-to-the-original-objcg-fix.patch
mm-kmemleak-split-__create_object-into-two-functions-checkpatch-fixes.patch
mm-migrate-add-nr_split-to-trace_mm_migrate_pages-stats-fix.patch
mark-stuff-as-__ro_after_init-checkpatch-fixes.patch
mark-stuff-as-__ro_after_init-fix.patch

