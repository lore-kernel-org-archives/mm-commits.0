From: akpm@linux-foundation.org
Subject: [merged] eventfd-change-int-to-__u64-in-eventfd_signal.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:35:14 -0700
Message-ID: <20120601193514.58558A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:34132 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933353Ab2FATfU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:35:20 -0400
Received: by qabg24 with SMTP id g24so93380qab.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:35:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: handai.szj@taobao.com, davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     Subject: eventfd: change int to __u64 in eventfd_signal()
has been removed from the -mm tree.  Its filename was
     eventfd-change-int-to-__u64-in-eventfd_signal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Sha Zhengju <handai.szj@taobao.com>
Subject: eventfd: change int to __u64 in eventfd_signal()

eventfd_ctx->count is an __u64 counter which is allowed to reach
ULLONG_MAX.  eventfd_write() adds a __u64 value to "count", but the kernel
side eventfd_signal() only adds an int value to it.  Make them consistent.

[akpm@linux-foundation.org: update interface documentation]
Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventfd.c            |   12 ++++--------
 include/linux/eventfd.h |    2 +-
 2 files changed, 5 insertions(+), 9 deletions(-)

diff -puN fs/eventfd.c~eventfd-change-int-to-__u64-in-eventfd_signal fs/eventfd.c
--- a/fs/eventfd.c~eventfd-change-int-to-__u64-in-eventfd_signal
+++ a/fs/eventfd.c
@@ -46,20 +46,16 @@ struct eventfd_ctx {
  * value, and we signal this as overflow condition by returining a POLLERR
  * to poll(2).
  *
- * Returns @n in case of success, a non-negative number lower than @n in case
- * of overflow, or the following error codes:
- *
- * -EINVAL    : The value of @n is negative.
+ * Returns the amount by which the counter was incrememnted.  This will be less
+ * than @n if the counter has overflowed.
  */
-int eventfd_signal(struct eventfd_ctx *ctx, int n)
+__u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
 {
 	unsigned long flags;
 
-	if (n < 0)
-		return -EINVAL;
 	spin_lock_irqsave(&ctx->wqh.lock, flags);
 	if (ULLONG_MAX - ctx->count < n)
-		n = (int) (ULLONG_MAX - ctx->count);
+		n = ULLONG_MAX - ctx->count;
 	ctx->count += n;
 	if (waitqueue_active(&ctx->wqh))
 		wake_up_locked_poll(&ctx->wqh, POLLIN);
diff -puN include/linux/eventfd.h~eventfd-change-int-to-__u64-in-eventfd_signal include/linux/eventfd.h
--- a/include/linux/eventfd.h~eventfd-change-int-to-__u64-in-eventfd_signal
+++ a/include/linux/eventfd.h
@@ -34,7 +34,7 @@ void eventfd_ctx_put(struct eventfd_ctx 
 struct file *eventfd_fget(int fd);
 struct eventfd_ctx *eventfd_ctx_fdget(int fd);
 struct eventfd_ctx *eventfd_ctx_fileget(struct file *file);
-int eventfd_signal(struct eventfd_ctx *ctx, int n);
+__u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n);
 ssize_t eventfd_ctx_read(struct eventfd_ctx *ctx, int no_wait, __u64 *cnt);
 int eventfd_ctx_remove_wait_queue(struct eventfd_ctx *ctx, wait_queue_t *wait,
 				  __u64 *cnt);
_

Patches currently in -mm which might be from handai.szj@taobao.com are

origin.patch

