From: akpm@linux-foundation.org
Subject: [merged] userfaultfd-require-uffdio_api-before-other-ioctls.patch removed from -mm tree
Date: Tue, 08 Sep 2015 11:04:56 -0700
Message-ID: <55ef2348.BulGYben3HkLz6qV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272AbbIHSE5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:04:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dave.hansen@intel.com, torvalds@linux-foundation.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: require UFFDIO_API before other ioctls
has been removed from the -mm tree.  Its filename was
     userfaultfd-require-uffdio_api-before-other-ioctls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: require UFFDIO_API before other ioctls

UFFDIO_API was already forced before read/poll could work.  This makes the
code more strict to force it also for all other ioctls.

All users would already have been required to call UFFDIO_API before
invoking other ioctls but this makes it more explicit.

This will ensure we can change all ioctls (all but UFFDIO_API/struct
uffdio_api) with a bump of uffdio_api.api.

There's no actual plan or need to change the API or the ioctl, the current
API already should cover fine even the non cooperative usage, but this is
just for the longer term future just in case.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/userfaultfd.c~userfaultfd-require-uffdio_api-before-other-ioctls fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-require-uffdio_api-before-other-ioctls
+++ a/fs/userfaultfd.c
@@ -577,7 +577,6 @@ static ssize_t userfaultfd_read(struct f
 
 	if (ctx->state == UFFD_STATE_WAIT_API)
 		return -EINVAL;
-	BUG_ON(ctx->state != UFFD_STATE_RUNNING);
 
 	for (;;) {
 		if (count < sizeof(msg))
@@ -1115,6 +1114,9 @@ static long userfaultfd_ioctl(struct fil
 	int ret = -EINVAL;
 	struct userfaultfd_ctx *ctx = file->private_data;
 
+	if (cmd != UFFDIO_API && ctx->state == UFFD_STATE_WAIT_API)
+		return -EINVAL;
+
 	switch(cmd) {
 	case UFFDIO_API:
 		ret = userfaultfd_api(ctx, arg);
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-selftest-update-userfaultfd-x86-32bit-syscall-number.patch

