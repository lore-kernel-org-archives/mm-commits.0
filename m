Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01BEAC433EF
	for <mm-commits@archiver.kernel.org>; Tue,  7 Jun 2022 00:47:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232744AbiFGAru (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Jun 2022 20:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbiFGArt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2022 20:47:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB1D11459
        for <mm-commits@vger.kernel.org>; Mon,  6 Jun 2022 17:47:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78BE3B80EC4
        for <mm-commits@vger.kernel.org>; Tue,  7 Jun 2022 00:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3026EC385A9;
        Tue,  7 Jun 2022 00:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654562865;
        bh=ClVwG9ZQ1e0t53+HuzCidJjpGe6X6OxZLd9OQNIvXwI=;
        h=Date:To:From:Subject:From;
        b=shwnNGs//hCT1nHONreF8GKvMUICXuhV74tUJXOlAgr011Fa3BfjRWhcqlv8YmGOV
         FO7S4BhqDzgm2BJeF2NiV0OT0+zYhyb00AeKN8Ip1BCD1oLbv6EkE+KuoqFEEuAWzh
         bHwCJ29Le1AWTysP9sRGcDL7FRFMAaTXow1v61sM=
Date:   Mon, 06 Jun 2022 17:47:44 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        roman.gushchin@linux.dev, kent.overstreet@gmail.com,
        hdanton@sina.com, dchinner@redhat.com,
        christophe.jaillet@wanadoo.fr, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20220607004745.3026EC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers-fix
Date: Mon Jun  6 05:46:42 PM PDT 2022

remove WARN_ON_ONCE(), per Roman

Reported-by: syzbot+300d27c79fe6d4cbcc39@syzkaller.appspotmail.com
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers-fix
+++ a/mm/vmscan.c
@@ -650,7 +650,7 @@ void register_shrinker_prepared(struct s
 	down_write(&shrinker_rwsem);
 	list_add_tail(&shrinker->list, &shrinker_list);
 	shrinker->flags |= SHRINKER_REGISTERED;
-	WARN_ON_ONCE(shrinker_debugfs_add(shrinker));
+	shrinker_debugfs_add(shrinker);
 	up_write(&shrinker_rwsem);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-checkpatch-fixes.patch
mm-remove-the-vma-linked-list-fix-fix.patch
mm-remove-the-vma-linked-list-fix-fix-fix.patch
mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix.patch
mm-introduce-clear_highpage_tagged-fix.patch
kasan-fix-zeroing-vmalloc-memory-with-hw_tags-fix.patch
mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix-fix.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-factor-helpers-for-memory_failure_dev_pagemap-fix.patch
xfs-support-cow-in-fsdax-mode-fix.patch
mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers-fix.patch

