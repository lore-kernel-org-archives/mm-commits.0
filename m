From: akpm@linux-foundation.org
Subject: +
 userfaultfd-non-cooperative-add-madvise-event-for-madv_dontneed-request.patch added to -mm tree
Date: Wed, 04 Jan 2017 16:53:45 -0800
Message-ID: <586d9919.lsfMg91+a19zfP/r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36192 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935141AbdAEAyU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 19:54:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@parallels.com, RAPOPORT@il.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: non-cooperative: add madvise() event for MADV_DONTNEED request
has been added to the -mm tree.  Its filename is
     userfaultfd-non-cooperative-add-madvise-event-for-madv_dontneed-request.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-non-cooperative-add-madvise-event-for-madv_dontneed-request.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-non-cooperative-add-madvise-event-for-madv_dontneed-request.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Emelyanov <xemul@parallels.com>
Subject: userfaultfd: non-cooperative: add madvise() event for MADV_DONTNEED request

If the page is punched out of the address space the uffd reader should
know this and zeromap the respective area in case of the #PF event.

Link: http://lkml.kernel.org/r/20161216144821.5183-14-aarcange@redhat.com
Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c                 |   28 ++++++++++++++++++++++++++++
 include/linux/userfaultfd_k.h    |   12 ++++++++++++
 include/uapi/linux/userfaultfd.h |   10 +++++++++-
 mm/madvise.c                     |    2 ++
 4 files changed, 51 insertions(+), 1 deletion(-)

diff -puN fs/userfaultfd.c~userfaultfd-non-cooperative-add-madvise-event-for-madv_dontneed-request fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-non-cooperative-add-madvise-event-for-madv_dontneed-request
+++ a/fs/userfaultfd.c
@@ -600,6 +600,34 @@ void mremap_userfaultfd_complete(struct
 	userfaultfd_event_wait_completion(ctx, &ewq);
 }
 
+void madvise_userfault_dontneed(struct vm_area_struct *vma,
+				struct vm_area_struct **prev,
+				unsigned long start, unsigned long end)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	struct userfaultfd_ctx *ctx;
+	struct userfaultfd_wait_queue ewq;
+
+	ctx = vma->vm_userfaultfd_ctx.ctx;
+	if (!ctx || !(ctx->features & UFFD_FEATURE_EVENT_MADVDONTNEED))
+		return;
+
+	userfaultfd_ctx_get(ctx);
+	up_read(&mm->mmap_sem);
+
+	*prev = NULL; /* We wait for ACK w/o the mmap semaphore */
+
+	msg_init(&ewq.msg);
+
+	ewq.msg.event = UFFD_EVENT_MADVDONTNEED;
+	ewq.msg.arg.madv_dn.start = start;
+	ewq.msg.arg.madv_dn.end = end;
+
+	userfaultfd_event_wait_completion(ctx, &ewq);
+
+	down_read(&mm->mmap_sem);
+}
+
 static int userfaultfd_release(struct inode *inode, struct file *file)
 {
 	struct userfaultfd_ctx *ctx = file->private_data;
diff -puN include/linux/userfaultfd_k.h~userfaultfd-non-cooperative-add-madvise-event-for-madv_dontneed-request include/linux/userfaultfd_k.h
--- a/include/linux/userfaultfd_k.h~userfaultfd-non-cooperative-add-madvise-event-for-madv_dontneed-request
+++ a/include/linux/userfaultfd_k.h
@@ -61,6 +61,11 @@ extern void mremap_userfaultfd_complete(
 					unsigned long from, unsigned long to,
 					unsigned long len);
 
+extern void madvise_userfault_dontneed(struct vm_area_struct *vma,
+				       struct vm_area_struct **prev,
+				       unsigned long start,
+				       unsigned long end);
+
 #else /* CONFIG_USERFAULTFD */
 
 /* mm helpers */
@@ -106,6 +111,13 @@ static inline void mremap_userfaultfd_co
 					       unsigned long len)
 {
 }
+
+static inline void madvise_userfault_dontneed(struct vm_area_struct *vma,
+					      struct vm_area_struct **prev,
+					      unsigned long start,
+					      unsigned long end)
+{
+}
 #endif /* CONFIG_USERFAULTFD */
 
 #endif /* _LINUX_USERFAULTFD_K_H */
diff -puN include/uapi/linux/userfaultfd.h~userfaultfd-non-cooperative-add-madvise-event-for-madv_dontneed-request include/uapi/linux/userfaultfd.h
--- a/include/uapi/linux/userfaultfd.h~userfaultfd-non-cooperative-add-madvise-event-for-madv_dontneed-request
+++ a/include/uapi/linux/userfaultfd.h
@@ -19,7 +19,8 @@
  */
 #define UFFD_API ((__u64)0xAA)
 #define UFFD_API_FEATURES (UFFD_FEATURE_EVENT_FORK |	    \
-			   UFFD_FEATURE_EVENT_REMAP)
+			   UFFD_FEATURE_EVENT_REMAP |	    \
+			   UFFD_FEATURE_EVENT_MADVDONTNEED)
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
@@ -84,6 +85,11 @@ struct uffd_msg {
 		} remap;
 
 		struct {
+			__u64	start;
+			__u64	end;
+		} madv_dn;
+
+		struct {
 			/* unused reserved fields */
 			__u64	reserved1;
 			__u64	reserved2;
@@ -98,6 +104,7 @@ struct uffd_msg {
 #define UFFD_EVENT_PAGEFAULT	0x12
 #define UFFD_EVENT_FORK		0x13
 #define UFFD_EVENT_REMAP	0x14
+#define UFFD_EVENT_MADVDONTNEED	0x15
 
 /* flags for UFFD_EVENT_PAGEFAULT */
 #define UFFD_PAGEFAULT_FLAG_WRITE	(1<<0)	/* If this was a write fault */
@@ -119,6 +126,7 @@ struct uffdio_api {
 #define UFFD_FEATURE_PAGEFAULT_FLAG_WP		(1<<0)
 #define UFFD_FEATURE_EVENT_FORK			(1<<1)
 #define UFFD_FEATURE_EVENT_REMAP		(1<<2)
+#define UFFD_FEATURE_EVENT_MADVDONTNEED		(1<<3)
 	__u64 features;
 
 	__u64 ioctls;
diff -puN mm/madvise.c~userfaultfd-non-cooperative-add-madvise-event-for-madv_dontneed-request mm/madvise.c
--- a/mm/madvise.c~userfaultfd-non-cooperative-add-madvise-event-for-madv_dontneed-request
+++ a/mm/madvise.c
@@ -10,6 +10,7 @@
 #include <linux/syscalls.h>
 #include <linux/mempolicy.h>
 #include <linux/page-isolation.h>
+#include <linux/userfaultfd_k.h>
 #include <linux/hugetlb.h>
 #include <linux/falloc.h>
 #include <linux/sched.h>
@@ -477,6 +478,7 @@ static long madvise_dontneed(struct vm_a
 		return -EINVAL;
 
 	zap_page_range(vma, start, end - start, NULL);
+	madvise_userfault_dontneed(vma, prev, start, end);
 	return 0;
 }
 
_

Patches currently in -mm which might be from xemul@parallels.com are

userfaultfd-non-cooperative-split-the-find_userfault-routine.patch
userfaultfd-non-cooperative-add-ability-to-report-non-pf-events-from-uffd-descriptor.patch
userfaultfd-non-cooperative-add-fork-event.patch
userfaultfd-non-cooperative-add-mremap-event.patch
userfaultfd-non-cooperative-add-madvise-event-for-madv_dontneed-request.patch

