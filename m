From: akpm@linux-foundation.org
Subject: + userfaultfd-provide-pid-in-userfault-msg-add-feat-union.patch
 added to -mm tree
Date: Wed, 02 Aug 2017 14:29:46 -0700
Message-ID: <5982444a.sOC9FTA8tlDxiuBx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41420 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751067AbdHBV3r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 17:29:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, a.perevalov@samsung.com, dgilbert@redhat.com, maxime.coquelin@redhat.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: provide pid in userfault msg - add feat union
has been added to the -mm tree.  Its filename is
     userfaultfd-provide-pid-in-userfault-msg-add-feat-union.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-provide-pid-in-userfault-msg-add-feat-union.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-provide-pid-in-userfault-msg-add-feat-union.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: provide pid in userfault msg - add feat union

No ABI change, but this will make it more explicit to software that ptid
is only available if requested by passing UFFD_FEATURE_THREAD_ID to
UFFDIO_API.  The fact it's a union will also self document it shouldn't be
taken for granted there's a tpid there.

Link: http://lkml.kernel.org/r/20170802165145.22628-7-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Alexey Perevalov <a.perevalov@samsung.com>
Cc: Maxime Coquelin <maxime.coquelin@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c                 |    2 +-
 include/uapi/linux/userfaultfd.h |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-provide-pid-in-userfault-msg-add-feat-union fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-provide-pid-in-userfault-msg-add-feat-union
+++ a/fs/userfaultfd.c
@@ -207,7 +207,7 @@ static inline struct uffd_msg userfault_
 		 */
 		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_WP;
 	if (features & UFFD_FEATURE_THREAD_ID)
-		msg.arg.pagefault.ptid = task_pid_vnr(current);
+		msg.arg.pagefault.feat.ptid = task_pid_vnr(current);
 	return msg;
 }
 
diff -puN include/uapi/linux/userfaultfd.h~userfaultfd-provide-pid-in-userfault-msg-add-feat-union include/uapi/linux/userfaultfd.h
--- a/include/uapi/linux/userfaultfd.h~userfaultfd-provide-pid-in-userfault-msg-add-feat-union
+++ a/include/uapi/linux/userfaultfd.h
@@ -80,7 +80,9 @@ struct uffd_msg {
 		struct {
 			__u64	flags;
 			__u64	address;
-			__u32   ptid;
+			union {
+				__u32 ptid;
+			} feat;
 		} pagefault;
 
 		struct {
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-hugetlbfs-remove-superfluous-page-unlock-in-vm_shared-case.patch
userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist.patch
userfaultfd-selftest-explicit-failure-if-the-sigbus-test-failed.patch
userfaultfd-call-userfaultfd_unmap_prep-only-if-__split_vma-succeeds.patch
userfaultfd-provide-pid-in-userfault-msg-add-feat-union.patch

