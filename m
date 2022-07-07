Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 914E8C43334
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jul 2022 20:09:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236185AbiGGUJ3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Jul 2022 16:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236725AbiGGUJX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jul 2022 16:09:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CD660537
        for <mm-commits@vger.kernel.org>; Thu,  7 Jul 2022 13:09:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAA14B823FA
        for <mm-commits@vger.kernel.org>; Thu,  7 Jul 2022 20:09:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C41C3411E;
        Thu,  7 Jul 2022 20:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657224559;
        bh=aYJst4PNCayBDH6ZD6/tMJdey79xkSSLLm9Mc/j3VOM=;
        h=Date:To:From:Subject:From;
        b=pPyc/KoK6CY/FNJFWEZVAkKa3XQ8ezxLzKhpbSV0PNZgTC7lAPekYmQ3GrLAf/hoB
         pSS12xZPzqARsZpEAxVohxm4opWuhQgfrI+XW5MMdMKu6rdf66bfQghWTT60COGAdb
         zrr98U9mzvSpWgBNrusVAVTLkzLLHlPxg8FWu+CQ=
Date:   Thu, 07 Jul 2022 13:09:18 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, vbabka@suse.cz,
        nsaenzju@redhat.com, mtosatti@redhat.com, m.szyprowski@samsung.com,
        minchan@kernel.org, mhocko@kernel.org, mgorman@techsingularity.net,
        lkp@intel.com, hughd@google.com, dan.carpenter@oracle.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch added to mm-unstable branch
Message-Id: <20220707200919.90C41C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch

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
Subject: mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix
Date: Thu Jul  7 01:06:35 PM PDT 2022

add missing local_unlock_irqrestore() on contention path

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/page_alloc.c~mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix
+++ a/mm/page_alloc.c
@@ -3792,6 +3792,7 @@ static struct page *rmqueue_pcplist(stru
 	pcp_trylock_prepare(UP_flags);
 	if (!spin_trylock(&pcp->lock)) {
 		pcp_trylock_finish(UP_flags);
+		local_unlock_irqrestore(&pagesets.lock, flags);
 		return NULL;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

android-binder-stop-saving-a-pointer-to-the-vma-fix.patch
mm-remove-the-vma-linked-list-fix-2-fix.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-factor-helpers-for-memory_failure_dev_pagemap-fix.patch
xfs-support-cow-in-fsdax-mode-fix.patch
mm-thp-kill-transparent_hugepage_active-fix.patch
mm-thp-kill-transparent_hugepage_active-fix-fix.patch
mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch
x86-mm-move-protection_map-inside-the-platform-fix.patch

