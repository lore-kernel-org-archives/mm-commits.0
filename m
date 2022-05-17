Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6576C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 17 May 2022 19:47:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbiEQTrn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 May 2022 15:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiEQTrm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 May 2022 15:47:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B44E37BC5
        for <mm-commits@vger.kernel.org>; Tue, 17 May 2022 12:47:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 260FF61680
        for <mm-commits@vger.kernel.org>; Tue, 17 May 2022 19:47:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 745A2C34100;
        Tue, 17 May 2022 19:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652816857;
        bh=oSM7577d3VzjroFbPnsgBqAMWukZA7RrdErvu6YJC2Y=;
        h=Date:To:From:Subject:From;
        b=sCiOGFyJxuWNhl/RXdVqY+3Flecl/d78Oti1mP4noRCEbCcNKMSeHEOmjN3cpkgra
         OVKIqQFWu1Y6LBjBSiMQqL9xG7IVjLfy9grkG3nFYpFND5gnFQ0d6Bws72J6cAPbiN
         U5HkduHTto5tjF2w1288kLQZnmGtN54ZwivQfMN8=
Date:   Tue, 17 May 2022 12:47:36 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        paulmck@kernel.org, minchan@kernel.org, joaodias@google.com,
        jhubbard@nvidia.com, david@redhat.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-fix-is_pinnable_page-against-on-cma-page-fix.patch removed from -mm tree
Message-Id: <20220517194737.745A2C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-fix-is_pinnable_page-against-on-cma-page-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-is_pinnable_page-against-on-cma-page-fix.patch

This patch was dropped because it was folded into mm-fix-is_pinnable_page-against-on-cma-page.patch

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
mm-fix-is_pinnable_page-against-on-cma-page.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

