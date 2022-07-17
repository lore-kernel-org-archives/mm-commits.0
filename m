Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF18BC43334
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jul 2022 23:29:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbiGQX3R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 19:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiGQX3Q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 19:29:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1622212622
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 16:29:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5DD360EEB
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 23:29:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB771C341C0;
        Sun, 17 Jul 2022 23:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658100555;
        bh=f3FztXt+P859bI4dMTgDqbkbm1tXo7cybLbxIZ57uU8=;
        h=Date:To:From:Subject:From;
        b=e5hE+QSnqJGANV65WidgHDHC4lt6n379iupR/e7zDach5SgwLaqz80nHmmJhjc2kg
         F78OXFK2TrffbhNQmYvadL5WiGgQef4RwzED2cuK/Vbj044Uuw4KSWliavGfZAZEDB
         Arzzo1OpQUGomBXqfMckU5FhJqYVwI61QDxj5AT8=
Date:   Sun, 17 Jul 2022 16:29:14 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, vbabka@suse.cz,
        nsaenzju@redhat.com, mtosatti@redhat.com, m.szyprowski@samsung.com,
        minchan@kernel.org, mhocko@kernel.org, mgorman@techsingularity.net,
        lkp@intel.com, hughd@google.com, dan.carpenter@oracle.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch removed from -mm tree
Message-Id: <20220717232914.EB771C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch

This patch was dropped because it was folded into mm-page_alloc-protect-pcp-lists-with-a-spinlock.patch

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

mm-page_alloc-protect-pcp-lists-with-a-spinlock.patch
android-binder-stop-saving-a-pointer-to-the-vma-fix.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch

