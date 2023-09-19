Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80897CD3425
	for <mm-commits@archiver.kernel.org>; Tue, 19 Sep 2023 00:27:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbjISA1i (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Sep 2023 20:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjISA1h (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Sep 2023 20:27:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036198E;
        Mon, 18 Sep 2023 17:27:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97964C433C7;
        Tue, 19 Sep 2023 00:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695083251;
        bh=g3ABoZpTXRrJ3m0aZJ0JzRedadCHAOBBwtRrIrrlKUk=;
        h=Date:To:From:Subject:From;
        b=zLyemXFk3z5hG1CEUS4eh98G7++NXQ0btTJVUzSHJvsFwpkMrqE6ScPaNS5atOEyf
         niJodp7Lm0iQmXnYP84QXjWu5jfORwWyMyrC/g1NZACXwClbPC3yFBnP1+VqYwadpr
         IZ+kj+bNq3OordQGQfFIRRO6gp+uPGKX+1MK6bdI=
Date:   Mon, 18 Sep 2023 17:27:31 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        stable@vger.kernel.org, shy828301@gmail.com, mhocko@suse.com,
        hughd@google.com, surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-lock-vmas-skipped-by-a-failed-queue_pages_range.patch added to mm-hotfixes-unstable branch
Message-Id: <20230919002731.97964C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: lock VMAs skipped by a failed queue_pages_range()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-lock-vmas-skipped-by-a-failed-queue_pages_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-lock-vmas-skipped-by-a-failed-queue_pages_range.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: lock VMAs skipped by a failed queue_pages_range()
Date: Mon, 18 Sep 2023 14:16:08 -0700

When queue_pages_range() encounters an unmovable page, it terminates its
page walk.  This walk, among other things, locks the VMAs in the range. 
This termination might result in some VMAs being left unlocked after
queue_pages_range() completes.  Since do_mbind() continues to operate on
these VMAs despite the failure from queue_pages_range(), it will encounter
an unlocked VMA, leading to a BUG().

This mbind() behavior has been modified several times before and might
need some changes to either finish the page walk even in the presence of
unmovable pages or to error out immediately after the failure to
queue_pages_range().  However that requires more discussions, so to fix
the immediate issue, explicitly lock the VMAs in the range if
queue_pages_range() failed.  The added condition does not save much but is
added for documentation purposes to understand when this extra locking is
needed.

Link: https://lkml.kernel.org/r/20230918211608.3580629-1-surenb@google.com
Fixes: 49b0638502da ("mm: enable page walking API to lock vmas during the walk")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: syzbot+b591856e0f0139f83023@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000f392a60604a65085@google.com/
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/mempolicy.c~mm-lock-vmas-skipped-by-a-failed-queue_pages_range
+++ a/mm/mempolicy.c
@@ -1342,6 +1342,9 @@ static long do_mbind(unsigned long start
 	vma_iter_init(&vmi, mm, start);
 	prev = vma_prev(&vmi);
 	for_each_vma_range(vmi, vma, end) {
+		/* If queue_pages_range failed then not all VMAs might be locked */
+		if (ret)
+			vma_start_write(vma);
 		err = mbind_range(&vmi, vma, &prev, start, end, new);
 		if (err)
 			break;
_

Patches currently in -mm which might be from surenb@google.com are

mm-lock-vmas-skipped-by-a-failed-queue_pages_range.patch

