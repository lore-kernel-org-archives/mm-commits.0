From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-wp-dont-wake-up-when-doing-write-protect.patch removed from -mm
 tree
Date: Tue, 07 Apr 2020 18:58:18 -0700
Message-ID: <20200408015818.EhsbFu62s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726504AbgDHB6U (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:58:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, bgeffon@google.com, bobbypowers@gmail.com, cracauer@cons.org, david@redhat.com, dgilbert@redhat.com, dplotnikov@virtuozzo.com, gokhale2@llnl.gov, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, kirill@shutemov.name, mcfadden8@llnl.gov, mgorman@suse.de, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, peterx@redhat.com, riel@redhat.com, rppt@linux.vnet.ibm.com, shli@fb.com, xemul@openvz.org


The patch titled
     Subject: userfaultfd: wp: don't wake up when doing write protect
has been removed from the -mm tree.  Its filename was
     userfaultfd-wp-dont-wake-up-when-doing-write-protect.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: userfaultfd: wp: don't wake up when doing write protect

It does not make sense to try to wake up any waiting thread when we're
write-protecting a memory region.  Only wake up when resolving a write
protected page fault.

Link: http://lkml.kernel.org/r/20200220163112.11409-16-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Bobby Powers <bobbypowers@gmail.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Martin Cracauer <cracauer@cons.org>
Cc: Marty McFadden <mcfadden8@llnl.gov>
Cc: Maya Gokhale <gokhale2@llnl.gov>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/fs/userfaultfd.c~userfaultfd-wp-dont-wake-up-when-doing-write-protect
+++ a/fs/userfaultfd.c
@@ -1812,6 +1812,7 @@ static int userfaultfd_writeprotect(stru
 	struct uffdio_writeprotect uffdio_wp;
 	struct uffdio_writeprotect __user *user_uffdio_wp;
 	struct userfaultfd_wake_range range;
+	bool mode_wp, mode_dontwake;
 
 	if (READ_ONCE(ctx->mmap_changing))
 		return -EAGAIN;
@@ -1830,18 +1831,20 @@ static int userfaultfd_writeprotect(stru
 	if (uffdio_wp.mode & ~(UFFDIO_WRITEPROTECT_MODE_DONTWAKE |
 			       UFFDIO_WRITEPROTECT_MODE_WP))
 		return -EINVAL;
-	if ((uffdio_wp.mode & UFFDIO_WRITEPROTECT_MODE_WP) &&
-	     (uffdio_wp.mode & UFFDIO_WRITEPROTECT_MODE_DONTWAKE))
+
+	mode_wp = uffdio_wp.mode & UFFDIO_WRITEPROTECT_MODE_WP;
+	mode_dontwake = uffdio_wp.mode & UFFDIO_WRITEPROTECT_MODE_DONTWAKE;
+
+	if (mode_wp && mode_dontwake)
 		return -EINVAL;
 
 	ret = mwriteprotect_range(ctx->mm, uffdio_wp.range.start,
-				  uffdio_wp.range.len, uffdio_wp.mode &
-				  UFFDIO_WRITEPROTECT_MODE_WP,
+				  uffdio_wp.range.len, mode_wp,
 				  &ctx->mmap_changing);
 	if (ret)
 		return ret;
 
-	if (!(uffdio_wp.mode & UFFDIO_WRITEPROTECT_MODE_DONTWAKE)) {
+	if (!mode_wp && !mode_dontwake) {
 		range.start = uffdio_wp.range.start;
 		range.len = uffdio_wp.range.len;
 		wake_userfault(ctx, &range);
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-mempolicy-allow-lookup_node-to-handle-fatal-signal.patch
mm-gup-mark-lock-taken-only-after-a-successful-retake.patch
