Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D0BCC761A6
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:23:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjC1XXV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjC1XWH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:22:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F156BE
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:22:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4D34619EF
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A097C433D2;
        Tue, 28 Mar 2023 23:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045723;
        bh=KDDSES/ncNwZ3OE+bvEjem1uSCLklelMTnBW8QmM2XI=;
        h=Date:To:From:Subject:From;
        b=n7X5YGs/J0WytRvAu97r68NNXMUzKXtCN64pyfry/MnizjM9KktDjzoSob4j4EAZj
         9+GhW2Ccy1gc0ymQk5SfD8dlS7HdRWvyIKRJnwqNTqk715IGoxufiEHcFJMxPxEikz
         5/xt1dW6RLRN0OypBvS4GRG7GIZRG1FsDD1ew6Ss=
Date:   Tue, 28 Mar 2023 16:22:02 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        xhao@linux.alibaba.com, willy@infradead.org, p.raghav@samsung.com,
        keescook@chromium.org, hughd@google.com, david@redhat.com,
        dave@stgolabs.net, brauner@kernel.org, a.manzanares@samsung.com,
        mcgrof@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-move-reclaim-check-early-on-writepages.patch removed from -mm tree
Message-Id: <20230328232203.3A097C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: move reclaim check early on writepages()
has been removed from the -mm tree.  Its filename was
     shmem-move-reclaim-check-early-on-writepages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: shmem: move reclaim check early on writepages()
Date: Thu, 9 Mar 2023 15:05:42 -0800

i915_gem requires huge folios to be split when swapping.  However we have
check for usage of writepages() to ensure it used only for swap purposes
later.  Avoid the splits if we're not being called for reclaim, even if
they should in theory not happen.

This makes the conditions easier to follow on shem_writepage().

Link: https://lkml.kernel.org/r/20230309230545.2930737-4-mcgrof@kernel.org
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
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

 mm/shmem.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/mm/shmem.c~shmem-move-reclaim-check-early-on-writepages
+++ a/mm/shmem.c
@@ -1348,6 +1348,16 @@ static int shmem_writepage(struct page *
 	pgoff_t index;
 
 	/*
+	 * Our capabilities prevent regular writeback or sync from ever calling
+	 * shmem_writepage; but a stacking filesystem might use ->writepage of
+	 * its underlying filesystem, in which case tmpfs should write out to
+	 * swap only in response to memory pressure, and not for the writeback
+	 * threads or sync.
+	 */
+	if (WARN_ON_ONCE(!wbc->for_reclaim))
+		goto redirty;
+
+	/*
 	 * If /sys/kernel/mm/transparent_hugepage/shmem_enabled is "always" or
 	 * "force", drivers/gpu/drm/i915/gem/i915_gem_shmem.c gets huge pages,
 	 * and its shmem_writeback() needs them to be split when swapping.
@@ -1368,18 +1378,6 @@ static int shmem_writepage(struct page *
 		goto redirty;
 
 	/*
-	 * Our capabilities prevent regular writeback or sync from ever calling
-	 * shmem_writepage; but a stacking filesystem might use ->writepage of
-	 * its underlying filesystem, in which case tmpfs should write out to
-	 * swap only in response to memory pressure, and not for the writeback
-	 * threads or sync.
-	 */
-	if (!wbc->for_reclaim) {
-		WARN_ON_ONCE(1);	/* Still happens? Tell us about it! */
-		goto redirty;
-	}
-
-	/*
 	 * This is somewhat ridiculous, but without plumbing a SWAP_MAP_FALLOC
 	 * value into swapfile.c, the only way we can correctly account for a
 	 * fallocated folio arriving here is now to initialize it and write it.
_

Patches currently in -mm which might be from mcgrof@kernel.org are


