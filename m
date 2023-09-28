Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 457A7E732EA
	for <mm-commits@archiver.kernel.org>; Thu, 28 Sep 2023 16:37:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjI1Qhl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Sep 2023 12:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjI1Qhk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Sep 2023 12:37:40 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46EAF98;
        Thu, 28 Sep 2023 09:37:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D428BC433C8;
        Thu, 28 Sep 2023 16:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695919058;
        bh=MmGDBtL7vWwLKH0oOK2GPmhNtX8tnZqWovjVu4q+8WM=;
        h=Date:To:From:Subject:From;
        b=O7/Wrkb9VCJWLWVuhHyORkup0+3i90DZmwiIKlxaLDvQIWOyuVnmdz+AyudBXfNXv
         VHF8jl3rYa8X3UUZk7bU2iF2vl5sT/yc8gxJv0ooxFOfZrcdik2/ayWiUhKUTDvTgu
         0QnoP72+Z08xOztykWGjn4IMzvH56jAT9c8o89/s=
Date:   Thu, 28 Sep 2023 09:37:38 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        stable@vger.kernel.org, shy828301@gmail.com, mhocko@suse.com,
        hughd@google.com, surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-lock-vmas-skipped-by-a-failed-queue_pages_range.patch removed from -mm tree
Message-Id: <20230928163738.D428BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: lock VMAs skipped by a failed queue_pages_range()
has been removed from the -mm tree.  Its filename was
     mm-lock-vmas-skipped-by-a-failed-queue_pages_range.patch

This patch was dropped because it is obsolete

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
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
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

selftests-mm-add-uffdio_remap-ioctl-test.patch

