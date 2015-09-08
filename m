From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-allocate-the-userfaultfd_ctx-cacheline-aligned.patch removed
 from -mm tree
Date: Tue, 08 Sep 2015 11:04:32 -0700
Message-ID: <55ef2330.ntyvDmzGcn+TpEMY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59699 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386AbbIHSEe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:04:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, andreslc@google.com, dave.hansen@intel.com, dgilbert@redhat.com, hannes@cmpxchg.org, hughd@google.com, kirill@shutemov.name, luto@amacapital.net, mgorman@suse.de, pbonzini@redhat.com, peter.huangpeng@huawei.com, pfeiner@google.com, riel@redhat.com, sanidhya.gatech@gmail.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: allocate the userfaultfd_ctx cacheline aligned
has been removed from the -mm tree.  Its filename was
     userfaultfd-allocate-the-userfaultfd_ctx-cacheline-aligned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: allocate the userfaultfd_ctx cacheline aligned

Use proper slab to guarantee alignment.

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

 fs/userfaultfd.c |   39 +++++++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 8 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-allocate-the-userfaultfd_ctx-cacheline-aligned fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-allocate-the-userfaultfd_ctx-cacheline-aligned
+++ a/fs/userfaultfd.c
@@ -27,20 +27,26 @@
 #include <linux/ioctl.h>
 #include <linux/security.h>
 
+static struct kmem_cache *userfaultfd_ctx_cachep __read_mostly;
+
 enum userfaultfd_state {
 	UFFD_STATE_WAIT_API,
 	UFFD_STATE_RUNNING,
 };
 
+/*
+ * Start with fault_pending_wqh and fault_wqh so they're more likely
+ * to be in the same cacheline.
+ */
 struct userfaultfd_ctx {
-	/* pseudo fd refcounting */
-	atomic_t refcount;
 	/* waitqueue head for the pending (i.e. not read) userfaults */
 	wait_queue_head_t fault_pending_wqh;
 	/* waitqueue head for the userfaults */
 	wait_queue_head_t fault_wqh;
 	/* waitqueue head for the pseudo fd to wakeup poll/read */
 	wait_queue_head_t fd_wqh;
+	/* pseudo fd refcounting */
+	atomic_t refcount;
 	/* userfaultfd syscall flags */
 	unsigned int flags;
 	/* state machine */
@@ -130,7 +136,7 @@ static void userfaultfd_ctx_put(struct u
 		VM_BUG_ON(spin_is_locked(&ctx->fd_wqh.lock));
 		VM_BUG_ON(waitqueue_active(&ctx->fd_wqh));
 		mmput(ctx->mm);
-		kfree(ctx);
+		kmem_cache_free(userfaultfd_ctx_cachep, ctx);
 	}
 }
 
@@ -1028,6 +1034,15 @@ static const struct file_operations user
 	.llseek		= noop_llseek,
 };
 
+static void init_once_userfaultfd_ctx(void *mem)
+{
+	struct userfaultfd_ctx *ctx = (struct userfaultfd_ctx *) mem;
+
+	init_waitqueue_head(&ctx->fault_pending_wqh);
+	init_waitqueue_head(&ctx->fault_wqh);
+	init_waitqueue_head(&ctx->fd_wqh);
+}
+
 /**
  * userfaultfd_file_create - Creates an userfaultfd file pointer.
  * @flags: Flags for the userfaultfd file.
@@ -1058,14 +1073,11 @@ static struct file *userfaultfd_file_cre
 		goto out;
 
 	file = ERR_PTR(-ENOMEM);
-	ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
+	ctx = kmem_cache_alloc(userfaultfd_ctx_cachep, GFP_KERNEL);
 	if (!ctx)
 		goto out;
 
 	atomic_set(&ctx->refcount, 1);
-	init_waitqueue_head(&ctx->fault_pending_wqh);
-	init_waitqueue_head(&ctx->fault_wqh);
-	init_waitqueue_head(&ctx->fd_wqh);
 	ctx->flags = flags;
 	ctx->state = UFFD_STATE_WAIT_API;
 	ctx->released = false;
@@ -1076,7 +1088,7 @@ static struct file *userfaultfd_file_cre
 	file = anon_inode_getfile("[userfaultfd]", &userfaultfd_fops, ctx,
 				  O_RDWR | (flags & UFFD_SHARED_FCNTL_FLAGS));
 	if (IS_ERR(file))
-		kfree(ctx);
+		kmem_cache_free(userfaultfd_ctx_cachep, ctx);
 out:
 	return file;
 }
@@ -1105,3 +1117,14 @@ err_put_unused_fd:
 
 	return error;
 }
+
+static int __init userfaultfd_init(void)
+{
+	userfaultfd_ctx_cachep = kmem_cache_create("userfaultfd_ctx_cache",
+						sizeof(struct userfaultfd_ctx),
+						0,
+						SLAB_HWCACHE_ALIGN|SLAB_PANIC,
+						init_once_userfaultfd_ctx);
+	return 0;
+}
+__initcall(userfaultfd_init);
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-selftest-update-userfaultfd-x86-32bit-syscall-number.patch

