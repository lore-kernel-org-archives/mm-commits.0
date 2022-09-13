Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB432C54EE9
	for <mm-commits@archiver.kernel.org>; Tue, 13 Sep 2022 23:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiIMX5L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Sep 2022 19:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiIMX5K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2022 19:57:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C88481E5
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 16:57:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C07DA60F3D
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 23:57:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13201C433C1;
        Tue, 13 Sep 2022 23:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663113429;
        bh=TBmn6mR1jwxWJD1TwrjhLkkx2DO9xTlQj0mfhjfq7gk=;
        h=Date:To:From:Subject:From;
        b=mpuyuqoty5LxgnulWxJaFO/LaqgBcp/GkHwKZcmwkGJ9Fy4w7HmCtqowgsuMVFY/3
         jGFdwbEdnTFYIoT10kPhfJv+bMoFQVwrFnU6KA2AUfaaG+Gd2McuR/NEEBajNKBuYe
         AwJvVImiMWhkrwcZqby+GuzU8DnhsLGS3dcdKWLg=
Date:   Tue, 13 Sep 2022 16:57:08 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        shy828301@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix.patch added to mm-unstable branch
Message-Id: <20220913235709.13201C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     subject: mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix.patch

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
From: Yang Shi <shy828301@gmail.com>
subject: mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix
Date: Tue, 13 Sep 2022 09:14:15 -0700

Link: https://lkml.kernel.org/r/CAHbLzkrr3PvKjs2vanVi5JFTQQ3R7hSNRWoHhAw+gBWOcFurcw@mail.gmail.com
Fixes: 7d8faaf155454 ("mm/madvise: introduce MADV_COLLAPSE sync hugepage collapse")
Signed-off-by:: Yang Shi <shy828301@gmail.com>
Reported-by: syzbot+915f3e317adb0e85835f@syzkaller.appspotmail.com
Cc: "Zach O'Keefe" <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/khugepaged.c~mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix
+++ a/mm/khugepaged.c
@@ -2438,6 +2438,8 @@ int madvise_collapse(struct vm_area_stru
 				last_fail = result;
 				goto out_nolock;
 			}
+
+			hend = vma->vm_end & HPAGE_PMD_MASK;
 		}
 		mmap_assert_locked(mm);
 		memset(cc->node_load, 0, sizeof(cc->node_load));
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-gup-fix-the-fast-gup-race-against-thp-collapse.patch
powerpc-64s-radix-dont-need-to-broadcast-ipi-for-radix-pmd-collapse-flush.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix.patch

