Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAF25CD3425
	for <mm-commits@archiver.kernel.org>; Tue, 19 Sep 2023 00:23:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbjISAXM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Sep 2023 20:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjISAXL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Sep 2023 20:23:11 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E7F8E
        for <mm-commits@vger.kernel.org>; Mon, 18 Sep 2023 17:23:05 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C0CC433C8;
        Tue, 19 Sep 2023 00:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695082984;
        bh=zEYGGEoSSPAMeR6wvmK9u92UrFfeYWlh+5S63sjoqI4=;
        h=Date:To:From:Subject:From;
        b=HjCORIxbG9cm+/09uteb2g7J4AX48E7fB6DijQHRnkdQiAI+XDD1O63PRvEkJGbr1
         ZrSv5GS2+KdoPuHh5b5GkmG/frB9+qfAhwjqbxr4HO6Tu8+cbkfxJMQaRzKxwyKVww
         Hbn3ZXrDr29ASmTFroEkSu3YlPaQ8Ln941yFyiFc=
Date:   Mon, 18 Sep 2023 17:23:03 -0700
To:     mm-commits@vger.kernel.org, jgg@nvidia.com, apopple@nvidia.com,
        jannh@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-document-mmu_notifier_invalidate_range_start_nonblock.patch added to mm-unstable branch
Message-Id: <20230919002304.A9C0CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: document mmu_notifier_invalidate_range_start_nonblock()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-document-mmu_notifier_invalidate_range_start_nonblock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-document-mmu_notifier_invalidate_range_start_nonblock.patch

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

mm-document-mmu_notifier_invalidate_range_start_nonblock.patch

