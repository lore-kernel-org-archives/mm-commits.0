From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-wp-uffdio_register_mode_wp-documentation-update.patch removed
 from -mm tree
Date: Tue, 07 Apr 2020 18:58:21 -0700
Message-ID: <20200408015821.uqaqnf1Iv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgDHB6X (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:58:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, bgeffon@google.com, bobbypowers@gmail.com, cracauer@cons.org, david@redhat.com, dgilbert@redhat.com, dplotnikov@virtuozzo.com, gokhale2@llnl.gov, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, kirill@shutemov.name, mcfadden8@llnl.gov, mgorman@suse.de, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, peterx@redhat.com, riel@redhat.com, rppt@linux.vnet.ibm.com, shli@fb.com, xemul@openvz.org


The patch titled
     Subject: userfaultfd: wp: UFFDIO_REGISTER_MODE_WP documentation update
has been removed from the -mm tree.  Its filename was
     userfaultfd-wp-uffdio_register_mode_wp-documentation-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Martin Cracauer <cracauer@cons.org>
Subject: userfaultfd: wp: UFFDIO_REGISTER_MODE_WP documentation update

Add documentation about the write protection support.

[peterx@redhat.com: rewrite in rst format; fixups here and there]
Link: http://lkml.kernel.org/r/20200220163112.11409-17-peterx@redhat.com
Signed-off-by: Martin Cracauer <cracauer@cons.org>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Reviewed-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Bobby Powers <bobbypowers@gmail.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Marty McFadden <mcfadden8@llnl.gov>
Cc: Maya Gokhale <gokhale2@llnl.gov>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/userfaultfd.rst |   51 +++++++++++++++++
 1 file changed, 51 insertions(+)

--- a/Documentation/admin-guide/mm/userfaultfd.rst~userfaultfd-wp-uffdio_register_mode_wp-documentation-update
+++ a/Documentation/admin-guide/mm/userfaultfd.rst
@@ -108,6 +108,57 @@ UFFDIO_COPY. They're atomic as in guaran
 half copied page since it'll keep userfaulting until the copy has
 finished.
 
+Notes:
+
+- If you requested UFFDIO_REGISTER_MODE_MISSING when registering then
+  you must provide some kind of page in your thread after reading from
+  the uffd.  You must provide either UFFDIO_COPY or UFFDIO_ZEROPAGE.
+  The normal behavior of the OS automatically providing a zero page on
+  an annonymous mmaping is not in place.
+
+- None of the page-delivering ioctls default to the range that you
+  registered with.  You must fill in all fields for the appropriate
+  ioctl struct including the range.
+
+- You get the address of the access that triggered the missing page
+  event out of a struct uffd_msg that you read in the thread from the
+  uffd.  You can supply as many pages as you want with UFFDIO_COPY or
+  UFFDIO_ZEROPAGE.  Keep in mind that unless you used DONTWAKE then
+  the first of any of those IOCTLs wakes up the faulting thread.
+
+- Be sure to test for all errors including (pollfd[0].revents &
+  POLLERR).  This can happen, e.g. when ranges supplied were
+  incorrect.
+
+Write Protect Notifications
+---------------------------
+
+This is equivalent to (but faster than) using mprotect and a SIGSEGV
+signal handler.
+
+Firstly you need to register a range with UFFDIO_REGISTER_MODE_WP.
+Instead of using mprotect(2) you use ioctl(uffd, UFFDIO_WRITEPROTECT,
+struct *uffdio_writeprotect) while mode = UFFDIO_WRITEPROTECT_MODE_WP
+in the struct passed in.  The range does not default to and does not
+have to be identical to the range you registered with.  You can write
+protect as many ranges as you like (inside the registered range).
+Then, in the thread reading from uffd the struct will have
+msg.arg.pagefault.flags & UFFD_PAGEFAULT_FLAG_WP set. Now you send
+ioctl(uffd, UFFDIO_WRITEPROTECT, struct *uffdio_writeprotect) again
+while pagefault.mode does not have UFFDIO_WRITEPROTECT_MODE_WP set.
+This wakes up the thread which will continue to run with writes. This
+allows you to do the bookkeeping about the write in the uffd reading
+thread before the ioctl.
+
+If you registered with both UFFDIO_REGISTER_MODE_MISSING and
+UFFDIO_REGISTER_MODE_WP then you need to think about the sequence in
+which you supply a page and undo write protect.  Note that there is a
+difference between writes into a WP area and into a !WP area.  The
+former will have UFFD_PAGEFAULT_FLAG_WP set, the latter
+UFFD_PAGEFAULT_FLAG_WRITE.  The latter did not fail on protection but
+you still need to supply a page when UFFDIO_REGISTER_MODE_MISSING was
+used.
+
 QEMU/KVM
 ========
 
_

Patches currently in -mm which might be from cracauer@cons.org are
