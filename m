From: akpm@linux-foundation.org
Subject: - typesh-dont-expose-struct-ustat-to-userspace.patch removed from -mm tree
Date: Tue, 27 May 2008 00:27:00 -0700
Message-ID: <200805270727.m4R7R0xq014719@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33890 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755993AbYE0Hdp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 03:33:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: max@stro.at, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     types.h: don't expose struct ustat to userspace
has been removed from the -mm tree.  Its filename was
     typesh-dont-expose-struct-ustat-to-userspace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: types.h: don't expose struct ustat to userspace
From: maximilian attems <max@stro.at>

<linux/types.h> can't be used together with <sys/ustat.h> because they
both define struct ustat:

    $ cat test.c
    #include <sys/ustat.h>
    #include <linux/types.h>
    $ gcc -c test.c
    In file included from test.c:2:
    /usr/include/linux/types.h:165: error: redefinition of 'struct ustat'

has been reported a while ago to debian, but seems to have been
lost in cat fighting: http://bugs.debian.org/429064

Signed-off-by: maximilian attems <max@stro.at>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/types.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/types.h~typesh-dont-expose-struct-ustat-to-userspace include/linux/types.h
--- a/include/linux/types.h~typesh-dont-expose-struct-ustat-to-userspace
+++ a/include/linux/types.h
@@ -197,8 +197,6 @@ typedef u64 resource_size_t;
 typedef u32 resource_size_t;
 #endif
 
-#endif	/* __KERNEL__ */
