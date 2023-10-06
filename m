Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBC2BE94125
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:47:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233789AbjJFVro (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233828AbjJFVrb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:47:31 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F0212A
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 14:47:29 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A7AC433C9;
        Fri,  6 Oct 2023 21:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628849;
        bh=4LE8FhYz1iH+O+gBRtI+/mRQQYyFTwT/TLWqq5w5eUk=;
        h=Date:To:From:Subject:From;
        b=vudoLC6apA9dEkSeMuZF/i5QClr7okXlbudYVsl+ijG5I6TohA70pat0PJfzeeSRY
         kOu0v4erQpOjfvcobvAX0yux7JH7e4SfzbMNEI8JJYVvugaBTlP0XR5YmnHmy/ma6j
         LVavPQDzDgGPRSmaoi4JUrjBjUkLDbXCKynlKj94=
Date:   Fri, 06 Oct 2023 14:47:26 -0700
To:     mm-commits@vger.kernel.org, jgg@nvidia.com, apopple@nvidia.com,
        jannh@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-document-mmu_notifier_invalidate_range_start_nonblock.patch removed from -mm tree
Message-Id: <20231006214728.C9A7AC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: document mmu_notifier_invalidate_range_start_nonblock()
has been removed from the -mm tree.  Its filename was
     mm-document-mmu_notifier_invalidate_range_start_nonblock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: mm: document mmu_notifier_invalidate_range_start_nonblock()
Date: Mon, 18 Sep 2023 22:18:32 +0200

Document what mmu_notifier_invalidate_range_start_nonblock() is for.  Also
add a __must_check annotation to signal that callers must bail out if a
notifier vetoes the operation.

Link: https://lkml.kernel.org/r/20230918201832.265108-1-jannh@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/include/linux/mmu_notifier.h~mm-document-mmu_notifier_invalidate_range_start_nonblock
+++ a/include/linux/mmu_notifier.h
@@ -459,7 +459,14 @@ mmu_notifier_invalidate_range_start(stru
 	lock_map_release(&__mmu_notifier_invalidate_range_start_map);
 }
 
-static inline int
+/*
+ * This version of mmu_notifier_invalidate_range_start() avoids blocking, but it
+ * can return an error if a notifier can't proceed without blocking, in which
+ * case you're not allowed to modify PTEs in the specified range.
+ *
+ * This is mainly intended for OOM handling.
+ */
+static inline int __must_check
 mmu_notifier_invalidate_range_start_nonblock(struct mmu_notifier_range *range)
 {
 	int ret = 0;
_

Patches currently in -mm which might be from jannh@google.com are


