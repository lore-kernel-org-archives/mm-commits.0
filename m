Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DBACC433EF
	for <mm-commits@archiver.kernel.org>; Sat, 14 May 2022 01:16:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiENBQl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 21:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiENBQk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 21:16:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE594F118B
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 17:48:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FE0661C22
        for <mm-commits@vger.kernel.org>; Sat, 14 May 2022 00:18:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6ADCC385AA;
        Sat, 14 May 2022 00:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652487523;
        bh=gT/MT2nPKFk32RDzVC8xZD9VqBf/kMWQyGB0XFZa590=;
        h=Date:To:From:Subject:From;
        b=jEyklcnMVn8pc4clNvsA3RQuQ+IlSbyNXdoRAOOyVv6N5MFoxQBP4yZgivCRnUB2O
         ktA3im1y0By/R+H9f+d8rZdn5HyRa7d0frsW9pIJ0lm5j71viasrZIydcttYbvQwa9
         RrYcMs7LwUbbvNHnknJLMo89haHuRBXxGTPn0xDA=
Date:   Fri, 13 May 2022 17:18:43 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        paulmck@kernel.org, minchan@kernel.org, joaodias@google.com,
        jhubbard@nvidia.com, david@redhat.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-is_pinnable_page-against-on-cma-page-fix.patch added to mm-unstable branch
Message-Id: <20220514001843.C6ADCC385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-is_pinnable_page-against-on-cma-page-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-is_pinnable_page-against-on-cma-page-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-is_pinnable_page-against-on-cma-page-fix.patch

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
Subject: mm-fix-is_pinnable_page-against-on-cma-page-fix
Date: Fri May 13 05:15:26 PM PDT 2022

MIGRATE_CMA and MIGRATE_ISOLATE are not bitwise, per Minchan

Cc: David Hildenbrand <david@redhat.com>
Cc: John Dias <joaodias@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-fix-is_pinnable_page-against-on-cma-page-fix
+++ a/include/linux/mm.h
@@ -1635,7 +1635,7 @@ static inline bool is_pinnable_page(stru
 	int __mt = get_pageblock_migratetype(page);
 	int mt = __READ_ONCE(__mt);
 
-	if (mt & (MIGRATE_CMA | MIGRATE_ISOLATE))
+	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
 		return false;
 #endif
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

assoc_array-fix-bug_on-during-garbage-collect-fix.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch
mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
tmpfs-fix-undefined-behaviour-in-shmem_reconfigure-fix.patch
mm-fix-is_pinnable_page-against-on-cma-page-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

