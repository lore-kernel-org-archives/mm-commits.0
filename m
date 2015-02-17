From: akpm@linux-foundation.org
Subject: [folded-merged]
 eventfd-dont-take-the-spinlock-in-eventfd_poll-fix-2.patch removed from -mm tree
Date: Tue, 17 Feb 2015 13:37:49 -0800
Message-ID: <54e3b4ad.gOUSMYIN9ye0lOZ5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36303 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbbBQVhu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Feb 2015 16:37:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, clm@fb.com, mm-commits@vger.kernel.org


The patch titled
     Subject: eventfd: type bug in eventfd_poll()
has been removed from the -mm tree.  Its filename was
     eventfd-dont-take-the-spinlock-in-eventfd_poll-fix-2.patch

This patch was dropped because it was folded into eventfd-dont-take-the-spinlock-in-eventfd_poll.patch

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
eventfd-dont-take-the-spinlock-in-eventfd_poll.patch

