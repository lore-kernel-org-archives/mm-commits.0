From: akpm@linux-foundation.org
Subject: + eventfd-change-int-to-__u64-in-eventfd_signal.patch added to -mm tree
Date: Wed, 18 Apr 2012 16:53:54 -0700
Message-ID: <20120418235354.DE285A01F8@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:62030 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753741Ab2DRXx5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Apr 2012 19:53:57 -0400
Received: by laai8 with SMTP id i8so380131laa.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Apr 2012 16:53:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: handai.szj@taobao.com, davidel@xmailserver.org


The patch titled
     Subject: eventfd: change int to __u64 in eventfd_signal()
has been added to the -mm tree.  Its filename is
     eventfd-change-int-to-__u64-in-eventfd_signal.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sha Zhengju <handai.szj@taobao.com>
Subject: eventfd: change int to __u64 in eventfd_signal()

eventfd_ctx->count is an __u64 counter which is allowed to reach
ULLONG_MAX.  eventfd_write() adds a __u64 value to "count", but the kernel
side eventfd_signal() only adds an int value to it.  Make them consistent.

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventfd.c            |    6 ++----
 include/linux/eventfd.h |    2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff -puN fs/eventfd.c~eventfd-change-int-to-__u64-in-eventfd_signal fs/eventfd.c
--- a/fs/eventfd.c~eventfd-change-int-to-__u64-in-eventfd_signal
+++ a/fs/eventfd.c
@@ -51,15 +51,13 @@ struct eventfd_ctx {
  *
  * -EINVAL    : The value of @n is negative.
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
Subject: Subject: eventfd: change int to __u64 in eventfd_signal()

Patches currently in -mm which might be from handai.szj@taobao.com are

memcg-make-threshold-index-in-the-right-position.patch
memcg-revise-the-position-of-threshold-index-while-unregistering-event.patch
eventfd-change-int-to-__u64-in-eventfd_signal.patch
eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch

