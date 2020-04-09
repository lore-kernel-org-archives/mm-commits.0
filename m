From: akpm@linux-foundation.org
Subject: [alternative-merged]
 mm-mempolicy-allow-lookup_node-to-handle-fatal-signal.patch removed from
 -mm tree
Date: Wed, 08 Apr 2020 17:05:27 -0700
Message-ID: <20200409000527.Le32G2U_-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbgDIAF2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Apr 2020 20:05:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, peterx@redhat.com


The patch titled
     Subject: mm/mempolicy: allow lookup_node() to handle fatal signal
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-allow-lookup_node-to-handle-fatal-signal.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/mempolicy: allow lookup_node() to handle fatal signal

lookup_node() uses gup to pin the page and get node information.  It
checks against ret>=0 assuming the page will be filled in.  However it's
also possible that gup will return zero, for example, when the thread is
quickly killed with a fatal signal.  Teach lookup_node() to gracefully
return an error -EFAULT if it happens.

Link: http://lkml.kernel.org/r/20200407004745.GA48345@xz-x1
Fixes: 4426e945df58 ("mm/gup: allow VM_FAULT_RETRY for multiple times")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: syzbot+693dc11fcb53120b5559@syzkaller.appspotmail.com
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-mempolicy-allow-lookup_node-to-handle-fatal-signal
+++ a/mm/mempolicy.c
@@ -901,7 +901,10 @@ static int lookup_node(struct mm_struct
 
 	int locked = 1;
 	err = get_user_pages_locked(addr & PAGE_MASK, 1, 0, &p, &locked);
-	if (err >= 0) {
+	if (err == 0) {
+		/* E.g. GUP interupted by fatal signal */
+		err = -EFAULT;
+	} else if (err > 0) {
 		err = page_to_nid(p);
 		put_page(p);
 	}
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-gup-mark-lock-taken-only-after-a-successful-retake.patch
