From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-change-the-read-api-to-return-a-uffd_msg.patch removed from -mm tree
Date: Tue, 08 Sep 2015 11:04:23 -0700
Message-ID: <55ef2327.QGzh2ljCBjG/mV2F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59657 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386AbbIHSE2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:04:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, andreslc@google.com, dave.hansen@intel.com, dgilbert@redhat.com, hannes@cmpxchg.org, hughd@google.com, kirill@shutemov.name, luto@amacapital.net, mgorman@suse.de, pbonzini@redhat.com, peter.huangpeng@huawei.com, pfeiner@google.com, riel@redhat.com, sanidhya.gatech@gmail.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: change the read API to return a uffd_msg
has been removed from the -mm tree.  Its filename was
     userfaultfd-change-the-read-api-to-return-a-uffd_msg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: change the read API to return a uffd_msg

I had requests to return the full address (not the page aligned one) to
userland.

It's not entirely clear how the page offset could be relevant because
userfaults aren't like SIGBUS that can sigjump to a different place and it
actually skip resolving the fault depending on a page offset.  There's
currently no real way to skip the fault especially because after a
UFFDIO_COPY|ZEROPAGE, the fault is optimized to be retried within the
kernel without having to return to userland first (not even self modifying
code replacing the .text that touched the faulting address would prevent
the fault to be repeated).  Userland cannot skip repeating the fault even
more so if the fault was triggered by a KVM secondary page fault or any
get_user_pages or any copy-user inside some syscall which will return to
kernel code.  The second time FAULT_FLAG_RETRY_NOWAIT won't be set leading
to a SIGBUS being raised because the userfault can't wait if it cannot
release the mmap_map first (and FAULT_FLAG_RETRY_NOWAIT is required for
that).

Still returning userland a proper structure during the read() on the uffd,
can allow to use the current UFFD_API for the future non-cooperative
extensions too and it looks cleaner as well.  Once we get additional
fields there's no point to return the fault address page aligned anymore
to reuse the bits below PAGE_SHIFT.

The only downside is that the read() syscall will read 32bytes instead of
8bytes but that's not going to be measurable overhead.

The total number of new events that can be extended or of new future bits
for already shipped events, is limited to 64 by the features field of the
uffdio_api structure.  If more will be needed a bump of UFFD_API will be
required.

[akpm@linux-foundation.org: use __packed]
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Cc: zhang.zhanghailiang@huawei.com
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Feiner <pfeiner@google.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Huangpeng (Peter)" <peter.huangpeng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/userfaultfd.txt |   12 ++--
 fs/userfaultfd.c                 |   79 ++++++++++++++++-------------
 include/uapi/linux/userfaultfd.h |   70 ++++++++++++++++++++-----
 3 files changed, 108 insertions(+), 53 deletions(-)

diff -puN Documentation/vm/userfaultfd.txt~userfaultfd-change-the-read-api-to-return-a-uffd_msg Documentation/vm/userfaultfd.txt
--- a/Documentation/vm/userfaultfd.txt~userfaultfd-change-the-read-api-to-return-a-uffd_msg
+++ a/Documentation/vm/userfaultfd.txt
@@ -46,11 +46,13 @@ is a corner case that would currently re
 When first opened the userfaultfd must be enabled invoking the
 UFFDIO_API ioctl specifying a uffdio_api.api value set to UFFD_API (or
 a later API version) which will specify the read/POLLIN protocol
-userland intends to speak on the UFFD. The UFFDIO_API ioctl if
-successful (i.e. if the requested uffdio_api.api is spoken also by the
-running kernel), will return into uffdio_api.features and
-uffdio_api.ioctls two 64bit bitmasks of respectively the activated
-feature of the read(2) protocol and the generic ioctl available.
+userland intends to speak on the UFFD and the uffdio_api.features
+userland requires. The UFFDIO_API ioctl if successful (i.e. if the
+requested uffdio_api.api is spoken also by the running kernel and the
+requested features are going to be enabled) will return into
+uffdio_api.features and uffdio_api.ioctls two 64bit bitmasks of
+respectively all the available features of the read(2) protocol and
+the generic ioctl available.
 
 Once the userfaultfd has been enabled the UFFDIO_REGISTER ioctl should
 be invoked (if present in the returned uffdio_api.ioctls bitmask) to
diff -puN fs/userfaultfd.c~userfaultfd-change-the-read-api-to-return-a-uffd_msg fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-change-the-read-api-to-return-a-uffd_msg
+++ a/fs/userfaultfd.c
@@ -50,7 +50,7 @@ struct userfaultfd_ctx {
 };
 
 struct userfaultfd_wait_queue {
-	unsigned long address;
+	struct uffd_msg msg;
 	wait_queue_t wq;
 	bool pending;
 	struct userfaultfd_ctx *ctx;
@@ -77,7 +77,8 @@ static int userfaultfd_wake_function(wai
 	/* len == 0 means wake all */
 	start = range->start;
 	len = range->len;
-	if (len && (start > uwq->address || start + len <= uwq->address))
+	if (len && (start > uwq->msg.arg.pagefault.address ||
+		    start + len <= uwq->msg.arg.pagefault.address))
 		goto out;
 	ret = wake_up_state(wq->private, mode);
 	if (ret)
@@ -135,28 +136,43 @@ static void userfaultfd_ctx_put(struct u
 	}
 }
 
-static inline unsigned long userfault_address(unsigned long address,
-					      unsigned int flags,
-					      unsigned long reason)
+static inline void msg_init(struct uffd_msg *msg)
 {
-	BUILD_BUG_ON(PAGE_SHIFT < UFFD_BITS);
-	address &= PAGE_MASK;
+	BUILD_BUG_ON(sizeof(struct uffd_msg) != 32);
+	/*
+	 * Must use memset to zero out the paddings or kernel data is
+	 * leaked to userland.
+	 */
+	memset(msg, 0, sizeof(struct uffd_msg));
+}
+
+static inline struct uffd_msg userfault_msg(unsigned long address,
+					    unsigned int flags,
+					    unsigned long reason)
+{
+	struct uffd_msg msg;
+	msg_init(&msg);
+	msg.event = UFFD_EVENT_PAGEFAULT;
+	msg.arg.pagefault.address = address;
 	if (flags & FAULT_FLAG_WRITE)
 		/*
-		 * Encode "write" fault information in the LSB of the
-		 * address read by userland, without depending on
-		 * FAULT_FLAG_WRITE kernel internal value.
+		 * If UFFD_FEATURE_PAGEFAULT_FLAG_WRITE was set in the
+		 * uffdio_api.features and UFFD_PAGEFAULT_FLAG_WRITE
+		 * was not set in a UFFD_EVENT_PAGEFAULT, it means it
+		 * was a read fault, otherwise if set it means it's
+		 * a write fault.
 		 */
-		address |= UFFD_BIT_WRITE;
+		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_WRITE;
 	if (reason & VM_UFFD_WP)
 		/*
-		 * Encode "reason" fault information as bit number 1
-		 * in the address read by userland. If bit number 1 is
-		 * clear it means the reason is a VM_FAULT_MISSING
-		 * fault.
+		 * If UFFD_FEATURE_PAGEFAULT_FLAG_WP was set in the
+		 * uffdio_api.features and UFFD_PAGEFAULT_FLAG_WP was
+		 * not set in a UFFD_EVENT_PAGEFAULT, it means it was
+		 * a missing fault, otherwise if set it means it's a
+		 * write protect fault.
 		 */
-		address |= UFFD_BIT_WP;
-	return address;
+		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_WP;
+	return msg;
 }
 
 /*
@@ -242,7 +258,7 @@ int handle_userfault(struct vm_area_stru
 
 	init_waitqueue_func_entry(&uwq.wq, userfaultfd_wake_function);
 	uwq.wq.private = current;
-	uwq.address = userfault_address(address, flags, reason);
+	uwq.msg = userfault_msg(address, flags, reason);
 	uwq.pending = true;
 	uwq.ctx = ctx;
 
@@ -398,7 +414,7 @@ static unsigned int userfaultfd_poll(str
 }
 
 static ssize_t userfaultfd_ctx_read(struct userfaultfd_ctx *ctx, int no_wait,
-				    __u64 *addr)
+				    struct uffd_msg *msg)
 {
 	ssize_t ret;
 	DECLARE_WAITQUEUE(wait, current);
@@ -416,8 +432,8 @@ static ssize_t userfaultfd_ctx_read(stru
 			 * disappear from under us.
 			 */
 			uwq->pending = false;
-			/* careful to always initialize addr if ret == 0 */
-			*addr = uwq->address;
+			/* careful to always initialize msg if ret == 0 */
+			*msg = uwq->msg;
 			spin_unlock(&ctx->fault_wqh.lock);
 			ret = 0;
 			break;
@@ -447,8 +463,7 @@ static ssize_t userfaultfd_read(struct f
 {
 	struct userfaultfd_ctx *ctx = file->private_data;
 	ssize_t _ret, ret = 0;
-	/* careful to always initialize addr if ret == 0 */
-	__u64 uninitialized_var(addr);
+	struct uffd_msg msg;
 	int no_wait = file->f_flags & O_NONBLOCK;
 
 	if (ctx->state == UFFD_STATE_WAIT_API)
@@ -456,16 +471,16 @@ static ssize_t userfaultfd_read(struct f
 	BUG_ON(ctx->state != UFFD_STATE_RUNNING);
 
 	for (;;) {
-		if (count < sizeof(addr))
+		if (count < sizeof(msg))
 			return ret ? ret : -EINVAL;
-		_ret = userfaultfd_ctx_read(ctx, no_wait, &addr);
+		_ret = userfaultfd_ctx_read(ctx, no_wait, &msg);
 		if (_ret < 0)
 			return ret ? ret : _ret;
-		if (put_user(addr, (__u64 __user *) buf))
+		if (copy_to_user((__u64 __user *) buf, &msg, sizeof(msg)))
 			return ret ? ret : -EFAULT;
-		ret += sizeof(addr);
-		buf += sizeof(addr);
-		count -= sizeof(addr);
+		ret += sizeof(msg);
+		buf += sizeof(msg);
+		count -= sizeof(msg);
 		/*
 		 * Allow to read more than one fault at time but only
 		 * block if waiting for the very first one.
@@ -873,17 +888,15 @@ static int userfaultfd_api(struct userfa
 	if (ctx->state != UFFD_STATE_WAIT_API)
 		goto out;
 	ret = -EFAULT;
-	if (copy_from_user(&uffdio_api, buf, sizeof(__u64)))
+	if (copy_from_user(&uffdio_api, buf, sizeof(uffdio_api)))
 		goto out;
-	if (uffdio_api.api != UFFD_API) {
-		/* careful not to leak info, we only read the first 8 bytes */
+	if (uffdio_api.api != UFFD_API || uffdio_api.features) {
 		memset(&uffdio_api, 0, sizeof(uffdio_api));
 		if (copy_to_user(buf, &uffdio_api, sizeof(uffdio_api)))
 			goto out;
 		ret = -EINVAL;
 		goto out;
 	}
-	/* careful not to leak info, we only read the first 8 bytes */
 	uffdio_api.features = UFFD_API_FEATURES;
 	uffdio_api.ioctls = UFFD_API_IOCTLS;
 	ret = -EFAULT;
diff -puN include/uapi/linux/userfaultfd.h~userfaultfd-change-the-read-api-to-return-a-uffd_msg include/uapi/linux/userfaultfd.h
--- a/include/uapi/linux/userfaultfd.h~userfaultfd-change-the-read-api-to-return-a-uffd_msg
+++ a/include/uapi/linux/userfaultfd.h
@@ -11,9 +11,15 @@
 
 #include <linux/types.h>
 
+#include <linux/compiler.h>
+
 #define UFFD_API ((__u64)0xAA)
-/* FIXME: add "|UFFD_FEATURE_WP" to UFFD_API_FEATURES after implementing it */
-#define UFFD_API_FEATURES (UFFD_FEATURE_WRITE_BIT)
+/*
+ * After implementing the respective features it will become:
+ * #define UFFD_API_FEATURES (UFFD_FEATURE_PAGEFAULT_FLAG_WP | \
+ *			      UFFD_FEATURE_EVENT_FORK)
+ */
+#define UFFD_API_FEATURES (0)
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
@@ -45,26 +51,60 @@
 #define UFFDIO_WAKE		_IOR(UFFDIO, _UFFDIO_WAKE,	\
 				     struct uffdio_range)
 
-/*
- * Valid bits below PAGE_SHIFT in the userfault address read through
- * the read() syscall.
- */
-#define UFFD_BIT_WRITE	(1<<0)	/* this was a write fault, MISSING or WP */
-#define UFFD_BIT_WP	(1<<1)	/* handle_userfault() reason VM_UFFD_WP */
-#define UFFD_BITS	2	/* two above bits used for UFFD_BIT_* mask */
+/* read() structure */
+struct uffd_msg {
+	__u8	event;
+
+	__u8	reserved1;
+	__u16	reserved2;
+	__u32	reserved3;
+
+	union {
+		struct {
+			__u64	flags;
+			__u64	address;
+		} pagefault;
+
+		struct {
+			/* unused reserved fields */
+			__u64	reserved1;
+			__u64	reserved2;
+			__u64	reserved3;
+		} reserved;
+	} arg;
+} __packed;
 
 /*
- * Features reported in uffdio_api.features field
+ * Start at 0x12 and not at 0 to be more strict against bugs.
  */
-#define UFFD_FEATURE_WRITE_BIT	(1<<0) /* Corresponds to UFFD_BIT_WRITE */
-#define UFFD_FEATURE_WP_BIT	(1<<1) /* Corresponds to UFFD_BIT_WP */
+#define UFFD_EVENT_PAGEFAULT	0x12
+#if 0 /* not available yet */
+#define UFFD_EVENT_FORK		0x13
+#endif
+
+/* flags for UFFD_EVENT_PAGEFAULT */
+#define UFFD_PAGEFAULT_FLAG_WRITE	(1<<0)	/* If this was a write fault */
+#define UFFD_PAGEFAULT_FLAG_WP		(1<<1)	/* If reason is VM_UFFD_WP */
 
 struct uffdio_api {
-	/* userland asks for an API number */
+	/* userland asks for an API number and the features to enable */
 	__u64 api;
-
-	/* kernel answers below with the available features for the API */
+	/*
+	 * Kernel answers below with the all available features for
+	 * the API, this notifies userland of which events and/or
+	 * which flags for each event are enabled in the current
+	 * kernel.
+	 *
+	 * Note: UFFD_EVENT_PAGEFAULT and UFFD_PAGEFAULT_FLAG_WRITE
+	 * are to be considered implicitly always enabled in all kernels as
+	 * long as the uffdio_api.api requested matches UFFD_API.
+	 */
+#if 0 /* not available yet */
+#define UFFD_FEATURE_PAGEFAULT_FLAG_WP		(1<<0)
+#define UFFD_FEATURE_EVENT_FORK			(1<<1)
+#endif
 	__u64 features;
+
 	__u64 ioctls;
 };
 
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-selftest-update-userfaultfd-x86-32bit-syscall-number.patch

