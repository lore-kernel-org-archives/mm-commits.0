From: akpm@linux-foundation.org
Subject: + fs-execc-work-around-icc-miscompilation.patch added to -mm tree
Date: Mon, 07 Jan 2013 13:44:47 -0800
Message-ID: <20130107214447.A89ED100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:56985 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644Ab3AGVos (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 16:44:48 -0500
Received: by mail-gg0-f201.google.com with SMTP id o6so2136276ggm.0
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 13:44:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xi.wang@gmail.com, jbaron@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: fs/exec.c: work around icc miscompilation
has been added to the -mm tree.  Its filename is
     fs-execc-work-around-icc-miscompilation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
fs-execc-work-around-icc-miscompilation.patch
drivers-usb-gadget-amd5536udcc-avoid-calling-dma_pool_create-with-null-dev.patch
mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch

