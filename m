From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-non-cooperative-rename-event_madvdontneed-to-event_remove.patch removed from -mm tree
Date: Mon, 27 Feb 2017 12:24:31 -0800
Message-ID: <58b48aff.Y341yjuiX6S+V8KR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60408 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751745AbdB0UYq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:24:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, aarcange@redhat.com, hillf.zj@alibaba-inc.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: non-cooperative: rename *EVENT_MADVDONTNEED to *EVENT_REMOVE
has been removed from the -mm tree.  Its filename was
     userfaultfd-non-cooperative-rename-event_madvdontneed-to-event_remove.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd: non-cooperative: rename *EVENT_MADVDONTNEED to *EVENT_REMOVE

Patch series "userfaultfd: non-cooperative: add madvise() event for
MADV_REMOVE request".

These patches add notification of madvise(MADV_REMOVE) event to
non-cooperative userfaultfd monitor.

The first pacth renames EVENT_MADVDONTNEED to EVENT_REMOVE along with
relevant functions and structures.  Using _REMOVE instead of _MADVDONTNEED
describes the event semantics more clearly and I hope it's not too late
for such change in the ABI.



This patch (of 3):

The UFFD_EVENT_MADVDONTNEED purpose is to notify uffd monitor about
removal of certain range from address space tracked by userfaultfd. 
Hence, UFFD_EVENT_REMOVE seems to better reflect the operation semantics. 
Respectively, 'madv_dn' field of uffd_msg is renamed to 'remove' and the
madvise_userfault_dontneed callback is renamed to userfaultfd_remove.

Link: http://lkml.kernel.org/r/1484814154-1557-2-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c                         |   14 +++++++-------
 include/linux/userfaultfd_k.h            |   16 ++++++++--------
 include/uapi/linux/userfaultfd.h         |    8 ++++----
 mm/madvise.c                             |    2 +-
 tools/testing/selftests/vm/userfaultfd.c |   16 ++++++++--------
 5 files changed, 28 insertions(+), 28 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-non-cooperative-rename-event_madvdontneed-to-event_remove fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-non-cooperative-rename-event_madvdontneed-to-event_remove
+++ a/fs/userfaultfd.c
@@ -681,16 +681,16 @@ void mremap_userfaultfd_complete(struct
 	userfaultfd_event_wait_completion(ctx, &ewq);
 }
 
-void madvise_userfault_dontneed(struct vm_area_struct *vma,
-				struct vm_area_struct **prev,
-				unsigned long start, unsigned long end)
+void userfaultfd_remove(struct vm_area_struct *vma,
+			struct vm_area_struct **prev,
+			unsigned long start, unsigned long end)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct userfaultfd_ctx *ctx;
 	struct userfaultfd_wait_queue ewq;
 
 	ctx = vma->vm_userfaultfd_ctx.ctx;
-	if (!ctx || !(ctx->features & UFFD_FEATURE_EVENT_MADVDONTNEED))
+	if (!ctx || !(ctx->features & UFFD_FEATURE_EVENT_REMOVE))
 		return;
 
 	userfaultfd_ctx_get(ctx);
@@ -700,9 +700,9 @@ void madvise_userfault_dontneed(struct v
 
 	msg_init(&ewq.msg);
 
-	ewq.msg.event = UFFD_EVENT_MADVDONTNEED;
-	ewq.msg.arg.madv_dn.start = start;
-	ewq.msg.arg.madv_dn.end = end;
+	ewq.msg.event = UFFD_EVENT_REMOVE;
+	ewq.msg.arg.remove.start = start;
+	ewq.msg.arg.remove.end = end;
 
 	userfaultfd_event_wait_completion(ctx, &ewq);
 
diff -puN include/linux/userfaultfd_k.h~userfaultfd-non-cooperative-rename-event_madvdontneed-to-event_remove include/linux/userfaultfd_k.h
--- a/include/linux/userfaultfd_k.h~userfaultfd-non-cooperative-rename-event_madvdontneed-to-event_remove
+++ a/include/linux/userfaultfd_k.h
@@ -61,10 +61,10 @@ extern void mremap_userfaultfd_complete(
 					unsigned long from, unsigned long to,
 					unsigned long len);
 
-extern void madvise_userfault_dontneed(struct vm_area_struct *vma,
-				       struct vm_area_struct **prev,
-				       unsigned long start,
-				       unsigned long end);
+extern void userfaultfd_remove(struct vm_area_struct *vma,
+			       struct vm_area_struct **prev,
+			       unsigned long start,
+			       unsigned long end);
 
 #else /* CONFIG_USERFAULTFD */
 
@@ -112,10 +112,10 @@ static inline void mremap_userfaultfd_co
 {
 }
 
-static inline void madvise_userfault_dontneed(struct vm_area_struct *vma,
-					      struct vm_area_struct **prev,
-					      unsigned long start,
-					      unsigned long end)
+static inline void userfaultfd_remove(struct vm_area_struct *vma,
+				      struct vm_area_struct **prev,
+				      unsigned long start,
+				      unsigned long end)
 {
 }
 #endif /* CONFIG_USERFAULTFD */
diff -puN include/uapi/linux/userfaultfd.h~userfaultfd-non-cooperative-rename-event_madvdontneed-to-event_remove include/uapi/linux/userfaultfd.h
--- a/include/uapi/linux/userfaultfd.h~userfaultfd-non-cooperative-rename-event_madvdontneed-to-event_remove
+++ a/include/uapi/linux/userfaultfd.h
@@ -20,7 +20,7 @@
 #define UFFD_API ((__u64)0xAA)
 #define UFFD_API_FEATURES (UFFD_FEATURE_EVENT_FORK |		\
 			   UFFD_FEATURE_EVENT_REMAP |		\
-			   UFFD_FEATURE_EVENT_MADVDONTNEED |	\
+			   UFFD_FEATURE_EVENT_REMOVE |	\
 			   UFFD_FEATURE_MISSING_HUGETLBFS |	\
 			   UFFD_FEATURE_MISSING_SHMEM)
 #define UFFD_API_IOCTLS				\
@@ -92,7 +92,7 @@ struct uffd_msg {
 		struct {
 			__u64	start;
 			__u64	end;
-		} madv_dn;
+		} remove;
 
 		struct {
 			/* unused reserved fields */
@@ -109,7 +109,7 @@ struct uffd_msg {
 #define UFFD_EVENT_PAGEFAULT	0x12
 #define UFFD_EVENT_FORK		0x13
 #define UFFD_EVENT_REMAP	0x14
-#define UFFD_EVENT_MADVDONTNEED	0x15
+#define UFFD_EVENT_REMOVE	0x15
 
 /* flags for UFFD_EVENT_PAGEFAULT */
 #define UFFD_PAGEFAULT_FLAG_WRITE	(1<<0)	/* If this was a write fault */
@@ -155,7 +155,7 @@ struct uffdio_api {
 #define UFFD_FEATURE_PAGEFAULT_FLAG_WP		(1<<0)
 #define UFFD_FEATURE_EVENT_FORK			(1<<1)
 #define UFFD_FEATURE_EVENT_REMAP		(1<<2)
-#define UFFD_FEATURE_EVENT_MADVDONTNEED		(1<<3)
+#define UFFD_FEATURE_EVENT_REMOVE		(1<<3)
 #define UFFD_FEATURE_MISSING_HUGETLBFS		(1<<4)
 #define UFFD_FEATURE_MISSING_SHMEM		(1<<5)
 	__u64 features;
diff -puN mm/madvise.c~userfaultfd-non-cooperative-rename-event_madvdontneed-to-event_remove mm/madvise.c
--- a/mm/madvise.c~userfaultfd-non-cooperative-rename-event_madvdontneed-to-event_remove
+++ a/mm/madvise.c
@@ -479,7 +479,7 @@ static long madvise_dontneed(struct vm_a
 	if (!can_madv_dontneed_vma(vma))
 		return -EINVAL;
 
-	madvise_userfault_dontneed(vma, prev, start, end);
+	userfaultfd_remove(vma, prev, start, end);
 	zap_page_range(vma, start, end - start);
 	return 0;
 }
diff -puN tools/testing/selftests/vm/userfaultfd.c~userfaultfd-non-cooperative-rename-event_madvdontneed-to-event_remove tools/testing/selftests/vm/userfaultfd.c
--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-non-cooperative-rename-event_madvdontneed-to-event_remove
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -398,12 +398,12 @@ static void *uffd_poll_thread(void *arg)
 			uffd = msg.arg.fork.ufd;
 			pollfd[0].fd = uffd;
 			break;
-		case UFFD_EVENT_MADVDONTNEED:
-			uffd_reg.range.start = msg.arg.madv_dn.start;
-			uffd_reg.range.len = msg.arg.madv_dn.end -
-				msg.arg.madv_dn.start;
+		case UFFD_EVENT_REMOVE:
+			uffd_reg.range.start = msg.arg.remove.start;
+			uffd_reg.range.len = msg.arg.remove.end -
+				msg.arg.remove.start;
 			if (ioctl(uffd, UFFDIO_UNREGISTER, &uffd_reg.range))
-				fprintf(stderr, "madv_dn failure\n"), exit(1);
+				fprintf(stderr, "remove failure\n"), exit(1);
 			break;
 		case UFFD_EVENT_REMAP:
 			area_dst = (char *)(unsigned long)msg.arg.remap.to;
@@ -570,7 +570,7 @@ static int userfaultfd_open(int features
  * mremap, the entire monitored area is accessed in a single pass for
  * HUGETLB_TEST.
  * The release of the pages currently generates event only for
- * anonymous memory (UFFD_EVENT_MADVDONTNEED), hence it is not checked
+ * anonymous memory (UFFD_EVENT_REMOVE), hence it is not checked
  * for hugetlb and shmem.
  */
 static int faulting_process(void)
@@ -715,14 +715,14 @@ static int userfaultfd_events_test(void)
 	pid_t pid;
 	char c;
 
-	printf("testing events (fork, remap, madv_dn): ");
+	printf("testing events (fork, remap, remove): ");
 	fflush(stdout);
 
 	if (release_pages(area_dst))
 		return 1;
 
 	features = UFFD_FEATURE_EVENT_FORK | UFFD_FEATURE_EVENT_REMAP |
-		UFFD_FEATURE_EVENT_MADVDONTNEED;
+		UFFD_FEATURE_EVENT_REMOVE;
 	if (userfaultfd_open(features) < 0)
 		return 1;
 	fcntl(uffd, F_SETFL, uffd_flags | O_NONBLOCK);
_

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are


