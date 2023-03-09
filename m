Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6286FC61DA4
	for <mm-commits@archiver.kernel.org>; Thu,  9 Mar 2023 23:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbjCIXTQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Mar 2023 18:19:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbjCIXTI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Mar 2023 18:19:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C43F288D
        for <mm-commits@vger.kernel.org>; Thu,  9 Mar 2023 15:18:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 798B0B8212A
        for <mm-commits@vger.kernel.org>; Thu,  9 Mar 2023 23:18:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F0CC433D2;
        Thu,  9 Mar 2023 23:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678403933;
        bh=L0PqRS2H3BthBxDmpjWwi1cql01WRUAsFNyKk8paWLI=;
        h=Date:To:From:Subject:From;
        b=tPCwa72KTRvMGl5HBC49Euc4bFwcoDlCXWrx7rn7ufJojchsk/gm3yW4JgXVUdKwj
         fWcbRU4h4iH+5RdpiH4teG1yNMbzTNU6g1heZaUC3+D+H/tkmHV198iLwx9TQsUz9K
         YPYnSBy9NdAY6/vMY6dNctqg4aiM6/1ZZUEVByQk=
Date:   Thu, 09 Mar 2023 15:18:52 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        willy@infradead.org, p.raghav@samsung.com, keescook@chromium.org,
        hughd@google.com, david@redhat.com, dave@stgolabs.net,
        brauner@kernel.org, a.manzanares@samsung.com, mcgrof@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-skip-page-split-if-were-not-reclaiming.patch added to mm-unstable branch
Message-Id: <20230309231852.F0F0CC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: skip page split if we're not reclaiming
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-skip-page-split-if-were-not-reclaiming.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-skip-page-split-if-were-not-reclaiming.patch

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
Cc: Adam Manzanares <a.manzanares@samsung.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
---


--- a/mm/shmem.c~shmem-skip-page-split-if-were-not-reclaiming
+++ a/mm/shmem.c
@@ -1332,6 +1332,12 @@ static int shmem_writepage(struct page *
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
@@ -1347,10 +1353,6 @@ static int shmem_writepage(struct page *
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

shmem-remove-check-for-folio-lock-on-writepage.patch
shmem-set-shmem_writepage-variables-early.patch
shmem-move-reclaim-check-early-on-writepages.patch
shmem-skip-page-split-if-were-not-reclaiming.patch
shmem-update-documentation.patch
shmem-add-support-to-ignore-swap.patch

