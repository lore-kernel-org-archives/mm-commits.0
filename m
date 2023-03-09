Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56CCAC6FD1C
	for <mm-commits@archiver.kernel.org>; Thu,  9 Mar 2023 23:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbjCIXTI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Mar 2023 18:19:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbjCIXTG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Mar 2023 18:19:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35DEAF2888
        for <mm-commits@vger.kernel.org>; Thu,  9 Mar 2023 15:18:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5D6861D23
        for <mm-commits@vger.kernel.org>; Thu,  9 Mar 2023 23:18:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24625C433EF;
        Thu,  9 Mar 2023 23:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678403931;
        bh=ecfVNKxb4uNlTd6E5FRvScOukwKoLU+WzuriQlJtZFs=;
        h=Date:To:From:Subject:From;
        b=V9lnZuVoxq097yys1VJvPxlrGdjn4rA5b6PiQ5kTY8efDM0PvBjoZQr70GkjbrDco
         jpGmLBFb3x8Y3w9ZdCaRAzwY3tUc3x0uNBV/rAlTZy5KFIQB6w9UxPp6+CFP4zZlkz
         DWpWGAmUSbpn7KaStXNlUFD4MjxCmbTaNH9tEs8U=
Date:   Thu, 09 Mar 2023 15:18:50 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        willy@infradead.org, p.raghav@samsung.com, keescook@chromium.org,
        hughd@google.com, david@redhat.com, dave@stgolabs.net,
        brauner@kernel.org, a.manzanares@samsung.com, mcgrof@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-move-reclaim-check-early-on-writepages.patch added to mm-unstable branch
Message-Id: <20230309231851.24625C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: move reclaim check early on writepages()
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-move-reclaim-check-early-on-writepages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-move-reclaim-check-early-on-writepages.patch

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
Cc: Adam Manzanares <a.manzanares@samsung.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
---


--- a/mm/shmem.c~shmem-move-reclaim-check-early-on-writepages
+++ a/mm/shmem.c
@@ -1323,6 +1323,16 @@ static int shmem_writepage(struct page *
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
@@ -1343,18 +1353,6 @@ static int shmem_writepage(struct page *
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

shmem-remove-check-for-folio-lock-on-writepage.patch
shmem-set-shmem_writepage-variables-early.patch
shmem-move-reclaim-check-early-on-writepages.patch
shmem-skip-page-split-if-were-not-reclaiming.patch
shmem-update-documentation.patch
shmem-add-support-to-ignore-swap.patch

