From: akpm@linux-foundation.org
Subject: [merged] fs-select-fix-information-leak-to-userspace.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:07:07 -0800
Message-ID: <201101132009.p0DK9m23029982@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56617 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933680Ab1AMUKR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:10:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: segooon@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs/select.c: fix information leak to userspace
has been removed from the -mm tree.  Its filename was
     fs-select-fix-information-leak-to-userspace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/select.c: fix information leak to userspace
From: Vasiliy Kulikov <segooon@gmail.com>

On some architectures __kernel_suseconds_t is int.  On these archs struct
timeval has padding bytes at the end.  This struct is copied to userspace
with these padding bytes uninitialized.  This leads to leaking of contents
of kernel stack memory.

This bug was added with v2.6.27-rc5-286-gb773ad4.

[akpm@linux-foundation.org: avoid the memset on architectures which don't need it]
Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/select.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/select.c~fs-select-fix-information-leak-to-userspace fs/select.c
--- a/fs/select.c~fs-select-fix-information-leak-to-userspace
+++ a/fs/select.c
@@ -306,6 +306,8 @@ static int poll_select_copy_remaining(st
 		rts.tv_sec = rts.tv_nsec = 0;
 
 	if (timeval) {
+		if (sizeof(rtv) > sizeof(rtv.tv_sec) + sizeof(rtv.tv_usec))
+			memset(&rtv, 0, sizeof(rtv));
 		rtv.tv_sec = rts.tv_sec;
 		rtv.tv_usec = rts.tv_nsec / NSEC_PER_USEC;
 
_

Patches currently in -mm which might be from segooon@gmail.com are

origin.patch
linux-next.patch

