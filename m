From: akpm@linux-foundation.org
Subject: [nacked] lib-vsprintf-fix-invalid-arg-check.patch removed from -mm tree
Date: Fri, 12 Nov 2010 11:42:14 -0800
Message-ID: <201011121942.oACJgEFc027950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60537 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752091Ab0KLTmv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Nov 2010 14:42:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: segooon@gmail.com, andre.goddard@gmail.com, bjorn.helgaas@hp.com, fweisbec@gmail.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     lib/vsprintf.c: fix invalid arg check
has been removed from the -mm tree.  Its filename was
     lib-vsprintf-fix-invalid-arg-check.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib/vsprintf.c: fix invalid arg check
From: Vasiliy Kulikov <segooon@gmail.com>

"size" is size_t.  If we want to check whether it was underflowed then we
should cast it to ssize_t instead of int.  When sizeof(size_t) >
sizeof(int) the code sees UINT_MAX as underflow, but it is not.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Cc: Andr Goddard Rosa <andre.goddard@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/vsprintf.c~lib-vsprintf-fix-invalid-arg-check lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintf-fix-invalid-arg-check
+++ a/lib/vsprintf.c
@@ -1290,7 +1290,7 @@ int vsnprintf(char *buf, size_t size, co
 
 	/* Reject out-of-range values early.  Large positive sizes are
 	   used for unknown buffer sizes. */
-	if (WARN_ON_ONCE((int) size < 0))
+	if (WARN_ON_ONCE((ssize_t) size < 0))
 		return 0;
 
 	str = buf;
_

Patches currently in -mm which might be from segooon@gmail.com are

origin.patch
drivers-misc-apds9802alsc-fix-signedness-bug.patch
linux-next.patch
memstick-core-fix-device_register-error-handling.patch

