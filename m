From: akpm@linux-foundation.org
Subject: + userfaultfd-provide-pid-in-userfault-msg.patch added to -mm
 tree
Date: Wed, 02 Aug 2017 14:29:44 -0700
Message-ID: <59824448.fpyz4TPpVQ4FC/hd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41412 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751067AbdHBV3p (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 17:29:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.perevalov@samsung.com, aarcange@redhat.com, dgilbert@redhat.com, maxime.coquelin@redhat.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: provide pid in userfault msg
has been added to the -mm tree.  Its filename is
     userfaultfd-provide-pid-in-userfault-msg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-provide-pid-in-userfault-msg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-provide-pid-in-userfault-msg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: userfaultfd: provide pid in userfault msg

It could be useful for calculating downtime during postcopy live migration
per vCPU.  Side observer or application itself will be informed about
proper task's sleep during userfaultfd processing.

Process's thread id is being provided when user requeste it
by setting UFFD_FEATURE_THREAD_ID bit into uffdio_api.features.

Link: http://lkml.kernel.org/r/20170802165145.22628-6-aarcange@redhat.com
Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Maxime Coquelin <maxime.coquelin@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c                 |    8 ++++++--
 include/uapi/linux/userfaultfd.h |   10 +++++++---
 2 files changed, 13 insertions(+), 5 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-provide-pid-in-userfault-msg fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-provide-pid-in-userfault-msg
+++ a/fs/userfaultfd.c
@@ -181,7 +181,8 @@ static inline void msg_init(struct uffd_
 
 static inline struct uffd_msg userfault_msg(unsigned long address,
 					    unsigned int flags,
-					    unsigned long reason)
+					    unsigned long reason,
+					    unsigned int features)
 {
 	struct uffd_msg msg;
 	msg_init(&msg);
@@ -205,6 +206,8 @@ static inline struct uffd_msg userfault_
 		 * write protect fault.
 		 */
 		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_WP;
+	if (features & UFFD_FEATURE_THREAD_ID)
+		msg.arg.pagefault.ptid = task_pid_vnr(current);
 	return msg;
 }
 
@@ -425,7 +428,8 @@ int handle_userfault(struct vm_fault *vm
 
 	init_waitqueue_func_entry(&uwq.wq, userfaultfd_wake_function);
 	uwq.wq.private = current;
-	uwq.msg = userfault_msg(vmf->address, vmf->flags, reason);
+	uwq.msg = userfault_msg(vmf->address, vmf->flags, reason,
+			ctx->features);
 	uwq.ctx = ctx;
 	uwq.waken = false;
 
diff -puN include/uapi/linux/userfaultfd.h~userfaultfd-provide-pid-in-userfault-msg include/uapi/linux/userfaultfd.h
--- a/include/uapi/linux/userfaultfd.h~userfaultfd-provide-pid-in-userfault-msg
+++ a/include/uapi/linux/userfaultfd.h
@@ -24,7 +24,8 @@
 			   UFFD_FEATURE_EVENT_UNMAP |		\
 			   UFFD_FEATURE_MISSING_HUGETLBFS |	\
 			   UFFD_FEATURE_MISSING_SHMEM |		\
-			   UFFD_FEATURE_SIGBUS)
+			   UFFD_FEATURE_SIGBUS |		\
+			   UFFD_FEATURE_THREAD_ID)
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
@@ -79,6 +80,7 @@ struct uffd_msg {
 		struct {
 			__u64	flags;
 			__u64	address;
+			__u32   ptid;
 		} pagefault;
 
 		struct {
@@ -158,8 +160,9 @@ struct uffdio_api {
 	 * UFFD_FEATURE_SIGBUS feature means no page-fault
 	 * (UFFD_EVENT_PAGEFAULT) event will be delivered, instead
 	 * a SIGBUS signal will be sent to the faulting process.
-	 * The application process can enable this behavior by adding
-	 * it to uffdio_api.features.
+	 *
+	 * UFFD_FEATURE_THREAD_ID pid of the page faulted task_struct will
+	 * be returned, if feature is not requested 0 will be returned.
 	 */
 #define UFFD_FEATURE_PAGEFAULT_FLAG_WP		(1<<0)
 #define UFFD_FEATURE_EVENT_FORK			(1<<1)
@@ -169,6 +172,7 @@ struct uffdio_api {
 #define UFFD_FEATURE_MISSING_SHMEM		(1<<5)
 #define UFFD_FEATURE_EVENT_UNMAP		(1<<6)
 #define UFFD_FEATURE_SIGBUS			(1<<7)
+#define UFFD_FEATURE_THREAD_ID			(1<<8)
 	__u64 features;
 
 	__u64 ioctls;
_

Patches currently in -mm which might be from a.perevalov@samsung.com are

userfaultfd-provide-pid-in-userfault-msg.patch

