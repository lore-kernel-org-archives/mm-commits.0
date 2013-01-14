From: akpm@linux-foundation.org
Subject: [merged] fs-execc-work-around-icc-miscompilation.patch removed from -mm tree
Date: Mon, 14 Jan 2013 12:38:28 -0800
Message-ID: <20130114203828.A5F5B100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:61579 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758732Ab3ANUi3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jan 2013 15:38:29 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so536914vcd.1
        for <mm-commits@vger.kernel.org>; Mon, 14 Jan 2013 12:38:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xi.wang@gmail.com, jbaron@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/exec.c: work around icc miscompilation
has been removed from the -mm tree.  Its filename was
     fs-execc-work-around-icc-miscompilation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xi Wang <xi.wang@gmail.com>
Subject: fs/exec.c: work around icc miscompilation

The tricky problem is this check:

	if (i++ >= max)

icc (mis)optimizes this check as:

	if (++i > max)

The check now becomes a no-op since max is MAX_ARG_STRINGS (0x7FFFFFFF).

This is "allowed" by the C standard, assuming i++ never overflows,
because signed integer overflow is undefined behavior.  This optimization
effectively reverts the previous commit 362e6663ef ("exec.c, compat.c:
fix count(), compat_count() bounds checking") that tries to fix the check.

This patch simply moves ++ after the check.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/exec.c~fs-execc-work-around-icc-miscompilation fs/exec.c
--- a/fs/exec.c~fs-execc-work-around-icc-miscompilation
+++ a/fs/exec.c
@@ -434,8 +434,9 @@ static int count(struct user_arg_ptr arg
 			if (IS_ERR(p))
 				return -EFAULT;
 
-			if (i++ >= max)
+			if (i >= max)
 				return -E2BIG;
+			++i;
 
 			if (fatal_signal_pending(current))
 				return -ERESTARTNOHAND;
_

Patches currently in -mm which might be from xi.wang@gmail.com are

origin.patch
linux-next.patch
drivers-usb-gadget-amd5536udcc-avoid-calling-dma_pool_create-with-null-dev.patch
mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch

