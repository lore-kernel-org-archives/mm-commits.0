Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 299F8C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 12 May 2022 18:16:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357370AbiELSQn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 14:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357532AbiELSQj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 14:16:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F282CBE39
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 11:16:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E401B82A4F
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 18:16:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36022C385B8;
        Thu, 12 May 2022 18:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652379395;
        bh=Ga790d1K+E2YwINOwrYi181PCoVR2YVHQIXnHNRkEKk=;
        h=Date:To:From:Subject:From;
        b=d//mI0W8ld+RYI8lwaEGafhVxnqiIyTgMOBPijyo2FUm2JMTVWwhT9mjz8ihDOgzC
         2D92PfU6Otq8WNkMNRK6iVXcgTU1H+c7YqWzoZrACoycSVCJTMkoQ2HCt6QMDt23cT
         OsJMwiCVP0VMD8t+izezDtzTlWfTglMNTDVHOWTM=
Date:   Thu, 12 May 2022 11:16:34 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        Liam.Howlett@oracle.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-start-tracking-vmas-with-maple-tree-fix-2.patch added to mm-unstable branch
Message-Id: <20220512181635.36022C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: fix leak on expand_downwards() and expand_upwards()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-start-tracking-vmas-with-maple-tree-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-start-tracking-vmas-with-maple-tree-fix-2.patch

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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: mm/mmap: fix leak on expand_downwards() and expand_upwards()

A memory leak is possible in the race and error path in both
expand_downwards() and expand_upwards() due to the maple tree
preallocations.  Fix these by always destroying the maple state.

Link: https://lkml.kernel.org/r/20220512175915.1814885-1-Liam.Howlett@oracle.com
Fixes: a760774e7b7b (mm: start tracking VMAs with maple tree)
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/mmap.c~mm-start-tracking-vmas-with-maple-tree-fix-2
+++ a/mm/mmap.c
@@ -2664,6 +2664,7 @@ int expand_upwards(struct vm_area_struct
 	khugepaged_enter_vma_merge(vma, vma->vm_flags);
 	validate_mm(mm);
 	validate_mm_mt(mm);
+	mas_destroy(&mas);
 	return error;
 }
 #endif /* CONFIG_STACK_GROWSUP || CONFIG_IA64 */
@@ -2751,6 +2752,7 @@ int expand_downwards(struct vm_area_stru
 	anon_vma_unlock_write(vma->anon_vma);
 	khugepaged_enter_vma_merge(vma, vma->vm_flags);
 	validate_mm(mm);
+	mas_destroy(&mas);
 	return error;
 }
 
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple-tree-add-new-data-structure-fix.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix.patch
mm-start-tracking-vmas-with-maple-tree-fix-2.patch

