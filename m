Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4878FC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 20 Apr 2022 22:20:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382766AbiDTWWy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Apr 2022 18:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357109AbiDTWWv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Apr 2022 18:22:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18C029833
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 15:20:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA8FEB81104
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 22:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CFBC385A0;
        Wed, 20 Apr 2022 22:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650493201;
        bh=wJ961UHZRo+sapsE1K/7bJHUJvooiSJpM3XNvLu3bEg=;
        h=Date:To:From:Subject:From;
        b=zcuZiwpc8/J74m1iKA8+Hmu4NKniNoPjLcukeSytgI+tzGUulvA8Od3+ASyNJzeL0
         HnUEtdRwS/L2dWSFnGyJy4KoNM92gYr/MEomAoeRtVft17MoHTbBQd4XgCr+HNAfXg
         aHC8dR+yZUQ7mL96n/TW1vTHwJjGg+AJmLrXNVXQ=
Date:   Wed, 20 Apr 2022 15:20:00 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-start-tracking-vmas-with-maple-tree-fix.patch added to -mm tree
Message-Id: <20220420222001.52CFBC385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix commit "mm: start tracking VMAs with maple tree"
has been added to the -mm tree.  Its filename is
     mm-start-tracking-vmas-with-maple-tree-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-start-tracking-vmas-with-maple-tree-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-start-tracking-vmas-with-maple-tree-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm: fix commit "mm: start tracking VMAs with maple tree"

Hold the lock for the destruction of the maple tree to avoid lockdep
issues - and potentially process_mrelease.

Link: https://lkml.kernel.org/r/20220420134336.bny7wza3ez2ldjsd@revolver
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap.c~mm-start-tracking-vmas-with-maple-tree-fix
+++ a/mm/mmap.c
@@ -3319,9 +3319,9 @@ void exit_mmap(struct mm_struct *mm)
 		cond_resched();
 	}
 	mm->mmap = NULL;
-	mmap_write_unlock(mm);
 	trace_exit_mmap(mm);
 	__mt_destroy(&mm->mm_mt);
+	mmap_write_unlock(mm);
 	vm_unacct_memory(nr_accounted);
 }
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple-tree-add-new-data-structure-fix-2.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch

