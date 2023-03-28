Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE6ACC76196
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:23:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjC1XXb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbjC1XWI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:22:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3914F2717
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:22:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCBABB81F54
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:22:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614E5C433D2;
        Tue, 28 Mar 2023 23:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045724;
        bh=9ybI+neBjC9yyhk8sg6QzaXPnFgErTtDGQQnxJbLpDs=;
        h=Date:To:From:Subject:From;
        b=IzW48QW94uURaKPH3IMNtGx/l/IRS43VEg7FzXxBmGqxyFAUPqMDTrecCHjw5UBQr
         HUAtAGLuOZb0BU2GuqLKocbHi3iA8UiRqD4XKlRZDrUditFDmdfbuRjHO4gwPg8p+I
         5/pbPK4uG3nv2xKvaqrIlzEGVOqTZnm9AKiPEgQM=
Date:   Tue, 28 Mar 2023 16:22:03 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        xhao@linux.alibaba.com, willy@infradead.org, p.raghav@samsung.com,
        keescook@chromium.org, hughd@google.com, david@redhat.com,
        dave@stgolabs.net, brauner@kernel.org, a.manzanares@samsung.com,
        mcgrof@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-skip-page-split-if-were-not-reclaiming.patch removed from -mm tree
Message-Id: <20230328232204.614E5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: skip page split if we're not reclaiming
has been removed from the -mm tree.  Its filename was
     shmem-skip-page-split-if-were-not-reclaiming.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: shmem: skip page split if we're not reclaiming
Date: Thu, 9 Mar 2023 15:05:43 -0800

In theory when info->flags & VM_LOCKED we should not be getting
shem_writepage() called so we should be verifying this with a
WARN_ON_ONCE().  Since we should not be swapping then best to ensure we
also don't do the folio split earlier too.  So just move the check early
to avoid folio splits in case its a dubious call.

We also have a similar early bail when !total_swap_pages so just move that
earlier to avoid the possible folio split in the same situation.

Link: https://lkml.kernel.org/r/20230309230545.2930737-5-mcgrof@kernel.org
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Tested-by: Xin Hao <xhao@linux.alibaba.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Cc: Adam Manzanares <a.manzanares@samsung.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/shmem.c~shmem-skip-page-split-if-were-not-reclaiming
+++ a/mm/shmem.c
@@ -1357,6 +1357,12 @@ static int shmem_writepage(struct page *
 	if (WARN_ON_ONCE(!wbc->for_reclaim))
 		goto redirty;
 
+	if (WARN_ON_ONCE(info->flags & VM_LOCKED))
+		goto redirty;
+
+	if (!total_swap_pages)
+		goto redirty;
+
 	/*
 	 * If /sys/kernel/mm/transparent_hugepage/shmem_enabled is "always" or
 	 * "force", drivers/gpu/drm/i915/gem/i915_gem_shmem.c gets huge pages,
@@ -1372,10 +1378,6 @@ static int shmem_writepage(struct page *
 	}
 
 	index = folio->index;
-	if (info->flags & VM_LOCKED)
-		goto redirty;
-	if (!total_swap_pages)
-		goto redirty;
 
 	/*
 	 * This is somewhat ridiculous, but without plumbing a SWAP_MAP_FALLOC
_

Patches currently in -mm which might be from mcgrof@kernel.org are


