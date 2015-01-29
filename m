From: akpm@linux-foundation.org
Subject: + eventfd-dont-take-the-spinlock-in-eventfd_poll-fix-2.patch
 added to -mm tree
Date: Thu, 29 Jan 2015 13:16:36 -0800
Message-ID: <54caa334.kemSBBbCYuBLxY8b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58504 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbbA2VQh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Jan 2015 16:16:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, clm@fb.com, mm-commits@vger.kernel.org


The patch titled
     Subject: eventfd: type bug in eventfd_poll()
has been added to the -mm tree.  Its filename is
     eventfd-dont-take-the-spinlock-in-eventfd_poll-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/eventfd-dont-take-the-spinlock-in-eventfd_poll-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/eventfd-dont-take-the-spinlock-in-eventfd_poll-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: eventfd: type bug in eventfd_poll()

Since "count" is an unsigned int, then these conditions are never true:

        if (count == ULLONG_MAX)
                events |= POLLERR;
        if (ULLONG_MAX - 1 > count)
                events |= POLLOUT;

It should be a u64, because that's what ctx->count is.  Also GCC
complains that "flags" is unused.

Fixes: a90de8a54127 ('eventfd: don't take the spinlock in eventfd_poll')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Chris Mason <clm@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/eventfd.c~eventfd-dont-take-the-spinlock-in-eventfd_poll-fix-2 fs/eventfd.c
--- a/fs/eventfd.c~eventfd-dont-take-the-spinlock-in-eventfd_poll-fix-2
+++ a/fs/eventfd.c
@@ -118,7 +118,7 @@ static unsigned int eventfd_poll(struct
 {
 	struct eventfd_ctx *ctx = file->private_data;
 	unsigned int events = 0;
-	unsigned int count;
+	u64 count;
 
 	poll_wait(file, &ctx->wqh, wait);
 	smp_rmb();
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
ocfs2-o2net-silence-uninitialized-variable-warning.patch
mm-remove-rest-usage-of-vm_nonlinear-and-pte_file-fix.patch
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4-fix.patch
slab-embed-memcg_cache_params-to-kmem_cache-fix.patch
eventfd-dont-take-the-spinlock-in-eventfd_poll-fix-2.patch
linux-next.patch

