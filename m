From: akpm@linux-foundation.org
Subject: [patch 056/142] userfaultfd: non-cooperative: add mremap() event
Date: Wed, 22 Feb 2017 15:42:34 -0800
Message-ID: <58ae21ea.aAZhBVnpNT9ASXXU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48452 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934649AbdBVXmo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:42:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, xemul@parallels.com, RAPOPORT@il.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com

From: Pavel Emelyanov <xemul@parallels.com>
Subject: userfaultfd: non-cooperative: add mremap() event

The event denotes that an area [start:end] moves to different location. 
Length change isn't reported as "new" addresses, if they appear on the
uffd reader side they will not contain any data and the latter can just
zeromap them.

Waiting for the event ACK is also done outside of mmap sem, as
for fork event.

Link: http://lkml.kernel.org/r/20161216144821.5183-12-aarcange@redhat.com
Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c                 |   37 +++++++++++++++++++++++++++++
 include/linux/userfaultfd_k.h    |   17 +++++++++++++
 include/uapi/linux/userfaultfd.h |   11 +++++++-
 mm/mremap.c                      |   17 +++++++++----
 4 files changed, 76 insertions(+), 6 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-non-cooperative-add-mremap-event fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-non-cooperative-add-mremap-event
+++ a/fs/userfaultfd.c
@@ -596,6 +596,43 @@ void dup_userfaultfd_complete(struct lis
 	}
 }
 
+void mremap_userfaultfd_prep(struct vm_area_struct *vma,
+			     struct vm_userfaultfd_ctx *vm_ctx)
+{
+	struct userfaultfd_ctx *ctx;
+
+	ctx = vma->vm_userfaultfd_ctx.ctx;
+	if (ctx && (ctx->features & UFFD_FEATURE_EVENT_REMAP)) {
+		vm_ctx->ctx = ctx;
+		userfaultfd_ctx_get(ctx);
+	}
+}
+
+void mremap_userfaultfd_complete(struct vm_userfaultfd_ctx vm_ctx,
+				 unsigned long from, unsigned long to,
+				 unsigned long len)
+{
+	struct userfaultfd_ctx *ctx = vm_ctx.ctx;
+	struct userfaultfd_wait_queue ewq;
+
+	if (!ctx)
+		return;
+
+	if (to & ~PAGE_MASK) {
+		userfaultfd_ctx_put(ctx);
+		return;
+	}
+
+	msg_init(&ewq.msg);
+
+	ewq.msg.event = UFFD_EVENT_REMAP;
+	ewq.msg.arg.remap.from = from;
+	ewq.msg.arg.remap.to = to;
+	ewq.msg.arg.remap.len = len;
+
+	userfaultfd_event_wait_completion(ctx, &ewq);
+}
+
 static int userfaultfd_release(struct inode *inode, struct file *file)
 {
 	struct userfaultfd_ctx *ctx = file->private_data;
diff -puN include/linux/userfaultfd_k.h~userfaultfd-non-cooperative-add-mremap-event include/linux/userfaultfd_k.h
--- a/include/linux/userfaultfd_k.h~userfaultfd-non-cooperative-add-mremap-event
+++ a/include/linux/userfaultfd_k.h
@@ -55,6 +55,12 @@ static inline bool userfaultfd_armed(str
 extern int dup_userfaultfd(struct vm_area_struct *, struct list_head *);
 extern void dup_userfaultfd_complete(struct list_head *);
 
+extern void mremap_userfaultfd_prep(struct vm_area_struct *,
+				    struct vm_userfaultfd_ctx *);
+extern void mremap_userfaultfd_complete(struct vm_userfaultfd_ctx,
+					unsigned long from, unsigned long to,
+					unsigned long len);
+
 #else /* CONFIG_USERFAULTFD */
 
 /* mm helpers */
@@ -89,6 +95,17 @@ static inline void dup_userfaultfd_compl
 {
 }
 
+static inline void mremap_userfaultfd_prep(struct vm_area_struct *vma,
+					   struct vm_userfaultfd_ctx *ctx)
+{
+}
+
+static inline void mremap_userfaultfd_complete(struct vm_userfaultfd_ctx ctx,
+					       unsigned long from,
+					       unsigned long to,
+					       unsigned long len)
+{
+}
 #endif /* CONFIG_USERFAULTFD */
 
 #endif /* _LINUX_USERFAULTFD_K_H */
diff -puN include/uapi/linux/userfaultfd.h~userfaultfd-non-cooperative-add-mremap-event include/uapi/linux/userfaultfd.h
--- a/include/uapi/linux/userfaultfd.h~userfaultfd-non-cooperative-add-mremap-event
+++ a/include/uapi/linux/userfaultfd.h
@@ -18,7 +18,8 @@
  * means the userland is reading).
  */
 #define UFFD_API ((__u64)0xAA)
-#define UFFD_API_FEATURES (UFFD_FEATURE_EVENT_FORK)
+#define UFFD_API_FEATURES (UFFD_FEATURE_EVENT_FORK |	    \
+			   UFFD_FEATURE_EVENT_REMAP)
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
@@ -77,6 +78,12 @@ struct uffd_msg {
 		} fork;
 
 		struct {
+			__u64	from;
+			__u64	to;
+			__u64	len;
+		} remap;
+
+		struct {
 			/* unused reserved fields */
 			__u64	reserved1;
 			__u64	reserved2;
@@ -90,6 +97,7 @@ struct uffd_msg {
  */
 #define UFFD_EVENT_PAGEFAULT	0x12
 #define UFFD_EVENT_FORK		0x13
+#define UFFD_EVENT_REMAP	0x14
 
 /* flags for UFFD_EVENT_PAGEFAULT */
 #define UFFD_PAGEFAULT_FLAG_WRITE	(1<<0)	/* If this was a write fault */
@@ -110,6 +118,7 @@ struct uffdio_api {
 	 */
 #define UFFD_FEATURE_PAGEFAULT_FLAG_WP		(1<<0)
 #define UFFD_FEATURE_EVENT_FORK			(1<<1)
+#define UFFD_FEATURE_EVENT_REMAP		(1<<2)
 	__u64 features;
 
 	__u64 ioctls;
diff -puN mm/mremap.c~userfaultfd-non-cooperative-add-mremap-event mm/mremap.c
--- a/mm/mremap.c~userfaultfd-non-cooperative-add-mremap-event
+++ a/mm/mremap.c
@@ -22,6 +22,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/uaccess.h>
 #include <linux/mm-arch-hooks.h>
+#include <linux/userfaultfd_k.h>
 
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
@@ -250,7 +251,8 @@ unsigned long move_page_tables(struct vm
 
 static unsigned long move_vma(struct vm_area_struct *vma,
 		unsigned long old_addr, unsigned long old_len,
-		unsigned long new_len, unsigned long new_addr, bool *locked)
+		unsigned long new_len, unsigned long new_addr,
+		bool *locked, struct vm_userfaultfd_ctx *uf)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *new_vma;
@@ -309,6 +311,7 @@ static unsigned long move_vma(struct vm_
 		old_addr = new_addr;
 		new_addr = err;
 	} else {
+		mremap_userfaultfd_prep(new_vma, uf);
 		arch_remap(mm, old_addr, old_addr + old_len,
 			   new_addr, new_addr + new_len);
 	}
@@ -413,7 +416,8 @@ static struct vm_area_struct *vma_to_res
 }
 
 static unsigned long mremap_to(unsigned long addr, unsigned long old_len,
-		unsigned long new_addr, unsigned long new_len, bool *locked)
+		unsigned long new_addr, unsigned long new_len, bool *locked,
+		struct vm_userfaultfd_ctx *uf)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
@@ -458,7 +462,7 @@ static unsigned long mremap_to(unsigned
 	if (offset_in_page(ret))
 		goto out1;
 
-	ret = move_vma(vma, addr, old_len, new_len, new_addr, locked);
+	ret = move_vma(vma, addr, old_len, new_len, new_addr, locked, uf);
 	if (!(offset_in_page(ret)))
 		goto out;
 out1:
@@ -497,6 +501,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 	unsigned long ret = -EINVAL;
 	unsigned long charged = 0;
 	bool locked = false;
+	struct vm_userfaultfd_ctx uf = NULL_VM_UFFD_CTX;
 
 	if (flags & ~(MREMAP_FIXED | MREMAP_MAYMOVE))
 		return ret;
@@ -523,7 +528,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 
 	if (flags & MREMAP_FIXED) {
 		ret = mremap_to(addr, old_len, new_addr, new_len,
-				&locked);
+				&locked, &uf);
 		goto out;
 	}
 
@@ -592,7 +597,8 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 			goto out;
 		}
 
-		ret = move_vma(vma, addr, old_len, new_len, new_addr, &locked);
+		ret = move_vma(vma, addr, old_len, new_len, new_addr,
+			       &locked, &uf);
 	}
 out:
 	if (offset_in_page(ret)) {
@@ -602,5 +608,6 @@ out:
 	up_write(&current->mm->mmap_sem);
 	if (locked && new_len > old_len)
 		mm_populate(new_addr + old_len, new_len - old_len);
+	mremap_userfaultfd_complete(uf, addr, new_addr, old_len);
 	return ret;
 }
_
