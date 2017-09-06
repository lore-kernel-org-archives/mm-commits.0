From: akpm@linux-foundation.org
Subject: [patch 091/119] mm: userfaultfd: add feature to request
 for a signal delivery
Date: Wed, 06 Sep 2017 16:23:39 -0700
Message-ID: <20170906232339.jgd5L8seW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50816 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753150AbdIFXXl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:23:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, prakash.sangappa@oracle.com, rppt@linux.vnet.ibm.com, shuah@kernel.org, torvalds@linux-foundation.org

From: Prakash Sangappa <prakash.sangappa@oracle.com>
Subject: mm: userfaultfd: add feature to request for a signal delivery

In some cases, userfaultfd mechanism should just deliver a SIGBUS signal
to the faulting process, instead of the page-fault event.  Dealing with
page-fault event using a monitor thread can be an overhead in these cases.
For example applications like the database could use the signaling
mechanism for robustness purpose.

Database uses hugetlbfs for performance reason.  Files on hugetlbfs
filesystem are created and huge pages allocated using fallocate() API. 
Pages are deallocated/freed using fallocate() hole punching support. 
These files are mmapped and accessed by many processes as shared memory. 
The database keeps track of which offsets in the hugetlbfs file have pages
allocated.

Any access to mapped address over holes in the file, which can occur due
to bugs in the application, is considered invalid and expect the process
to simply receive a SIGBUS.  However, currently when a hole in the file is
accessed via the mapped address, kernel/mm attempts to automatically
allocate a page at page fault time, resulting in implicitly filling the
hole in the file.  This may not be the desired behavior for applications
like the database that want to explicitly manage page allocations of
hugetlbfs files.

Using userfaultfd mechanism with this support to get a signal, database
application can prevent pages from being allocated implicitly when
processes access mapped address over holes in the file.

This patch adds UFFD_FEATURE_SIGBUS feature to userfaultfd mechnism to
request for a SIGBUS signal.

See following for previous discussion about the database requirement
leading to this proposal as suggested by Andrea.

http://www.spinics.net/lists/linux-mm/msg129224.html

Link: http://lkml.kernel.org/r/1501552446-748335-2-git-send-email-prakash.sangappa@oracle.com
Signed-off-by: Prakash Sangappa <prakash.sangappa@oracle.com>
Reviewed-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c                 |    3 +++
 include/uapi/linux/userfaultfd.h |   10 +++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff -puN fs/userfaultfd.c~userfaultfd-add-feature-to-request-for-a-signal-delivery fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-add-feature-to-request-for-a-signal-delivery
+++ a/fs/userfaultfd.c
@@ -370,6 +370,9 @@ int handle_userfault(struct vm_fault *vm
 	VM_BUG_ON(reason & ~(VM_UFFD_MISSING|VM_UFFD_WP));
 	VM_BUG_ON(!(reason & VM_UFFD_MISSING) ^ !!(reason & VM_UFFD_WP));
 
+	if (ctx->features & UFFD_FEATURE_SIGBUS)
+		goto out;
+
 	/*
 	 * If it's already released don't get it. This avoids to loop
 	 * in __get_user_pages if userfaultfd_release waits on the
diff -puN include/uapi/linux/userfaultfd.h~userfaultfd-add-feature-to-request-for-a-signal-delivery include/uapi/linux/userfaultfd.h
--- a/include/uapi/linux/userfaultfd.h~userfaultfd-add-feature-to-request-for-a-signal-delivery
+++ a/include/uapi/linux/userfaultfd.h
@@ -23,7 +23,8 @@
 			   UFFD_FEATURE_EVENT_REMOVE |	\
 			   UFFD_FEATURE_EVENT_UNMAP |		\
 			   UFFD_FEATURE_MISSING_HUGETLBFS |	\
-			   UFFD_FEATURE_MISSING_SHMEM)
+			   UFFD_FEATURE_MISSING_SHMEM |		\
+			   UFFD_FEATURE_SIGBUS)
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
@@ -153,6 +154,12 @@ struct uffdio_api {
 	 * UFFD_FEATURE_MISSING_SHMEM works the same as
 	 * UFFD_FEATURE_MISSING_HUGETLBFS, but it applies to shmem
 	 * (i.e. tmpfs and other shmem based APIs).
+	 *
+	 * UFFD_FEATURE_SIGBUS feature means no page-fault
+	 * (UFFD_EVENT_PAGEFAULT) event will be delivered, instead
+	 * a SIGBUS signal will be sent to the faulting process.
+	 * The application process can enable this behavior by adding
+	 * it to uffdio_api.features.
 	 */
 #define UFFD_FEATURE_PAGEFAULT_FLAG_WP		(1<<0)
 #define UFFD_FEATURE_EVENT_FORK			(1<<1)
@@ -161,6 +168,7 @@ struct uffdio_api {
 #define UFFD_FEATURE_MISSING_HUGETLBFS		(1<<4)
 #define UFFD_FEATURE_MISSING_SHMEM		(1<<5)
 #define UFFD_FEATURE_EVENT_UNMAP		(1<<6)
+#define UFFD_FEATURE_SIGBUS			(1<<7)
 	__u64 features;
 
 	__u64 ioctls;
_
