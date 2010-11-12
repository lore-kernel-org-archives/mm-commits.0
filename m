From: akpm@linux-foundation.org
Subject: + fs-select-fix-information-leak-to-userspace.patch added to -mm tree
Date: Fri, 12 Nov 2010 12:09:12 -0800
Message-ID: <201011122009.oACK9Cmw029170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932539Ab0KLUJn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Nov 2010 15:09:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segooon@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     fs/select.c: fix information leak to userspace
has been added to the -mm tree.  Its filename is
     fs-select-fix-information-leak-to-userspace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/select.c: fix information leak to userspace
From: Vasiliy Kulikov <segooon@gmail.com>

On some architectures __kernel_suseconds_t is int.  On these archs struct
timeval has padding bytes at the end.  This struct is copied to userspace
with these padding bytes uninitialized.  This leads to leaking of contents
of kernel stack memory.

This bug was added with v2.6.27-rc5-286-gb773ad4.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/select.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/select.c~fs-select-fix-information-leak-to-userspace fs/select.c
--- a/fs/select.c~fs-select-fix-information-leak-to-userspace
+++ a/fs/select.c
@@ -306,6 +306,7 @@ static int poll_select_copy_remaining(st
 		rts.tv_sec = rts.tv_nsec = 0;
 
 	if (timeval) {
+		memset(&rtv, 0, sizeof(rtv));
 		rtv.tv_sec = rts.tv_sec;
 		rtv.tv_usec = rts.tv_nsec / NSEC_PER_USEC;
 
_

Patches currently in -mm which might be from segooon@gmail.com are

origin.patch
drivers-misc-apds9802alsc-fix-signedness-bug.patch
linux-next.patch
fs-select-fix-information-leak-to-userspace.patch
fs-select-fix-information-leak-to-userspace-fix.patch
memstick-core-fix-device_register-error-handling.patch

