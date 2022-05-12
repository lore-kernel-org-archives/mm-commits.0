Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 807D2C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 12 May 2022 19:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358086AbiELTqP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 15:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358177AbiELTqC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 15:46:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559712229D
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 12:46:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E419461C2F
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 19:46:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F2AC385B8;
        Thu, 12 May 2022 19:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652384760;
        bh=51v1v5UHERdW8gF+oz1S/e045EeTOqEEoM/TbFQY9OI=;
        h=Date:To:From:Subject:From;
        b=UH6ze3J4+AxPAy4s+df3vfogwzv7UTb+ZykDgon4VrfA569uuTbBOA9R/83/OFswn
         D+FLsM74NUshs36jiibJiKNTibcNf17AEN7C5yMAgTl7CnO/oiLXzdR8ZUZBP5UKkK
         p4qIvj2n5diejCKyqvJM3YCyD8DCTZg35E72hNqc=
Date:   Thu, 12 May 2022 12:45:59 -0700
To:     mm-commits@vger.kernel.org, mgorman@techsingularity.net,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch added to mm-unstable branch
Message-Id: <20220512194600.35F2AC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch

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
Subject: mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes

WARNING: braces {} are not necessary for any arm of this statement
#158: FILE: mm/page_alloc.c:3211:
+		if (zone) {
[...]
+		} else {
[...]

total: 0 errors, 1 warnings, 115 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-page_alloc-remotely-drain-per-cpu-lists.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes
+++ a/mm/page_alloc.c
@@ -3208,11 +3208,10 @@ static void __drain_all_pages(struct zon
 	}
 
 	for_each_cpu(cpu, &cpus_with_pcps) {
-		if (zone) {
+		if (zone)
 			drain_pages_zone(cpu, zone);
-		} else {
+		else
 			drain_pages(cpu);
-		}
 	}
 
 	mutex_unlock(&pcpu_drain_mutex);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

assoc_array-fix-bug_on-during-garbage-collect-fix.patch
mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch
mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration-fix.patch
mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

