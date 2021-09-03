Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46FD2C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:00:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 350596113A
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:00:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350498AbhICVBW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:01:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350205AbhICVBO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:01:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EC126112E;
        Fri,  3 Sep 2021 21:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702813;
        bh=IpbKJgiiKKuGmXWDNVecGtO2gk4RCN1R98mcz6Jygks=;
        h=Date:From:To:Subject:From;
        b=knnhT/AR8OrSCMCuy9VAq8zPzKHUUsBq+lf4jHcl6auyaAd2y+i/5mpUJkHsX9G3i
         jebTL1fRfZmxLGlyIGsBcSQpgOmsPvm9EEiBPAtUQ16hm6HFGoa31zWybtpmU3Jv2W
         Z10HI4WR6yAfQMcxtPspNL3BdrPC4D4a6LkuDB3E=
Date:   Fri, 03 Sep 2021 14:00:13 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, axboe@kernel.dk, axelrasmussen@google.com,
        mm-commits@vger.kernel.org, namit@vmware.com, peterx@redhat.com,
        rppt@linux.vnet.ibm.com, viro@zeniv.linux.org.uk
Subject:  [merged]
 userfaultfd-prevent-concurrent-api-initialization.patch removed from -mm
 tree
Message-ID: <20210903210013.cCh012kFc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: prevent concurrent API initialization
has been removed from the -mm tree.  Its filename was
     userfaultfd-prevent-concurrent-api-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nadav Amit <namit@vmware.com>
Subject: userfaultfd: prevent concurrent API initialization

userfaultfd assumes that the enabled features are set once and never
changed after UFFDIO_API ioctl succeeded.

However, currently, UFFDIO_API can be called concurrently from two
different threads, succeed on both threads and leave userfaultfd's
features in non-deterministic state.  Theoretically, other uffd operations
(ioctl's and page-faults) can be dispatched while adversely affected by
such changes of features.

Moreover, the writes to ctx->state and ctx->features are not ordered,
which can - theoretically, again - let userfaultfd_ioctl() think that
userfaultfd API completed, while the features are still not initialized.

To avoid races, it is arguably best to get rid of ctx->state.  Since there
are only 2 states, record the API initialization in ctx->features as the
uppermost bit and remove ctx->state.

Link: https://lkml.kernel.org/r/20210808020724.1022515-3-namit@vmware.com
Fixes: 9cd75c3cd4c3d ("userfaultfd: non-cooperative: add ability to report non-PF events from uffd descriptor")
Signed-off-by: Nadav Amit <namit@vmware.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   91 +++++++++++++++++++++------------------------
 1 file changed, 44 insertions(+), 47 deletions(-)

--- a/fs/userfaultfd.c~userfaultfd-prevent-concurrent-api-initialization
+++ a/fs/userfaultfd.c
@@ -33,11 +33,6 @@ int sysctl_unprivileged_userfaultfd __re
 
 static struct kmem_cache *userfaultfd_ctx_cachep __read_mostly;
 
-enum userfaultfd_state {
-	UFFD_STATE_WAIT_API,
-	UFFD_STATE_RUNNING,
-};
-
 /*
  * Start with fault_pending_wqh and fault_wqh so they're more likely
  * to be in the same cacheline.
@@ -69,8 +64,6 @@ struct userfaultfd_ctx {
 	unsigned int flags;
 	/* features requested from the userspace */
 	unsigned int features;
-	/* state machine */
-	enum userfaultfd_state state;
 	/* released */
 	bool released;
 	/* memory mappings are changing because of non-cooperative event */
@@ -104,6 +97,14 @@ struct userfaultfd_wake_range {
 	unsigned long len;
 };
 
+/* internal indication that UFFD_API ioctl was successfully executed */
+#define UFFD_FEATURE_INITIALIZED		(1u << 31)
+
+static bool userfaultfd_is_initialized(struct userfaultfd_ctx *ctx)
+{
+	return ctx->features & UFFD_FEATURE_INITIALIZED;
+}
+
 static int userfaultfd_wake_function(wait_queue_entry_t *wq, unsigned mode,
 				     int wake_flags, void *key)
 {
@@ -667,7 +668,6 @@ int dup_userfaultfd(struct vm_area_struc
 
 		refcount_set(&ctx->refcount, 1);
 		ctx->flags = octx->flags;
-		ctx->state = UFFD_STATE_RUNNING;
 		ctx->features = octx->features;
 		ctx->released = false;
 		atomic_set(&ctx->mmap_changing, 0);
@@ -944,38 +944,33 @@ static __poll_t userfaultfd_poll(struct
 
 	poll_wait(file, &ctx->fd_wqh, wait);
 
-	switch (ctx->state) {
-	case UFFD_STATE_WAIT_API:
+	if (!userfaultfd_is_initialized(ctx))
 		return EPOLLERR;
-	case UFFD_STATE_RUNNING:
-		/*
-		 * poll() never guarantees that read won't block.
-		 * userfaults can be waken before they're read().
-		 */
-		if (unlikely(!(file->f_flags & O_NONBLOCK)))
-			return EPOLLERR;
-		/*
-		 * lockless access to see if there are pending faults
-		 * __pollwait last action is the add_wait_queue but
-		 * the spin_unlock would allow the waitqueue_active to
-		 * pass above the actual list_add inside
-		 * add_wait_queue critical section. So use a full
-		 * memory barrier to serialize the list_add write of
-		 * add_wait_queue() with the waitqueue_active read
-		 * below.
-		 */
-		ret = 0;
-		smp_mb();
-		if (waitqueue_active(&ctx->fault_pending_wqh))
-			ret = EPOLLIN;
-		else if (waitqueue_active(&ctx->event_wqh))
-			ret = EPOLLIN;
 
-		return ret;
-	default:
-		WARN_ON_ONCE(1);
+	/*
+	 * poll() never guarantees that read won't block.
+	 * userfaults can be waken before they're read().
+	 */
+	if (unlikely(!(file->f_flags & O_NONBLOCK)))
 		return EPOLLERR;
-	}
+	/*
+	 * lockless access to see if there are pending faults
+	 * __pollwait last action is the add_wait_queue but
+	 * the spin_unlock would allow the waitqueue_active to
+	 * pass above the actual list_add inside
+	 * add_wait_queue critical section. So use a full
+	 * memory barrier to serialize the list_add write of
+	 * add_wait_queue() with the waitqueue_active read
+	 * below.
+	 */
+	ret = 0;
+	smp_mb();
+	if (waitqueue_active(&ctx->fault_pending_wqh))
+		ret = EPOLLIN;
+	else if (waitqueue_active(&ctx->event_wqh))
+		ret = EPOLLIN;
+
+	return ret;
 }
 
 static const struct file_operations userfaultfd_fops;
@@ -1170,7 +1165,7 @@ static ssize_t userfaultfd_read(struct f
 	int no_wait = file->f_flags & O_NONBLOCK;
 	struct inode *inode = file_inode(file);
 
-	if (ctx->state == UFFD_STATE_WAIT_API)
+	if (!userfaultfd_is_initialized(ctx))
 		return -EINVAL;
 
 	for (;;) {
@@ -1909,9 +1904,10 @@ out:
 static inline unsigned int uffd_ctx_features(__u64 user_features)
 {
 	/*
-	 * For the current set of features the bits just coincide
+	 * For the current set of features the bits just coincide. Set
+	 * UFFD_FEATURE_INITIALIZED to mark the features as enabled.
 	 */
-	return (unsigned int)user_features;
+	return (unsigned int)user_features | UFFD_FEATURE_INITIALIZED;
 }
 
 /*
@@ -1924,12 +1920,10 @@ static int userfaultfd_api(struct userfa
 {
 	struct uffdio_api uffdio_api;
 	void __user *buf = (void __user *)arg;
+	unsigned int ctx_features;
 	int ret;
 	__u64 features;
 
-	ret = -EINVAL;
-	if (ctx->state != UFFD_STATE_WAIT_API)
-		goto out;
 	ret = -EFAULT;
 	if (copy_from_user(&uffdio_api, buf, sizeof(uffdio_api)))
 		goto out;
@@ -1953,9 +1947,13 @@ static int userfaultfd_api(struct userfa
 	ret = -EFAULT;
 	if (copy_to_user(buf, &uffdio_api, sizeof(uffdio_api)))
 		goto out;
-	ctx->state = UFFD_STATE_RUNNING;
+
 	/* only enable the requested features for this uffd context */
-	ctx->features = uffd_ctx_features(features);
+	ctx_features = uffd_ctx_features(features);
+	ret = -EINVAL;
+	if (cmpxchg(&ctx->features, 0, ctx_features) != 0)
+		goto err_out;
+
 	ret = 0;
 out:
 	return ret;
@@ -1972,7 +1970,7 @@ static long userfaultfd_ioctl(struct fil
 	int ret = -EINVAL;
 	struct userfaultfd_ctx *ctx = file->private_data;
 
-	if (cmd != UFFDIO_API && ctx->state == UFFD_STATE_WAIT_API)
+	if (cmd != UFFDIO_API && !userfaultfd_is_initialized(ctx))
 		return -EINVAL;
 
 	switch(cmd) {
@@ -2086,7 +2084,6 @@ SYSCALL_DEFINE1(userfaultfd, int, flags)
 	refcount_set(&ctx->refcount, 1);
 	ctx->flags = flags;
 	ctx->features = 0;
-	ctx->state = UFFD_STATE_WAIT_API;
 	ctx->released = false;
 	atomic_set(&ctx->mmap_changing, 0);
 	ctx->mm = current->mm;
_

Patches currently in -mm which might be from namit@vmware.com are


