From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-mempolicy-allow-lookup_node-to-handle-fatal-signal.patch added to -mm
 tree
Date: Mon, 06 Apr 2020 18:43:38 -0700
Message-ID: <20200407014338.yCBV5HTV6%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgDGBnj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 21:43:39 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, peterx@redhat.com


The patch titled
     Subject: mm/mempolicy: allow lookup_node() to handle fatal signal
has been added to the -mm tree.  Its filename is
     mm-mempolicy-allow-lookup_node-to-handle-fatal-signal.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-allow-lookup_node-to-handle-fatal-signal.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-allow-lookup_node-to-handle-fatal-signal.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -902,7 +902,10 @@ static int lookup_node(struct mm_struct
 
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

mm-mempolicy-allow-lookup_node-to-handle-fatal-signal.patch
mm-merge-parameters-for-change_protection.patch
userfaultfd-wp-apply-_page_uffd_wp-bit.patch
userfaultfd-wp-drop-_page_uffd_wp-properly-when-fork.patch
userfaultfd-wp-add-pmd_swp_uffd_wp-helpers.patch
userfaultfd-wp-support-swap-and-page-migration.patch
khugepaged-skip-collapse-if-uffd-wp-detected.patch
userfaultfd-wp-dont-wake-up-when-doing-write-protect.patch
userfaultfd-wp-declare-_uffdio_writeprotect-conditionally.patch
userfaultfd-selftests-refactor-statistics.patch
userfaultfd-selftests-add-write-protect-test.patch
