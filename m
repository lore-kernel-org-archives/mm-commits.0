From: akpm@linux-foundation.org
Subject: + lib-vsprintf-fix-invalid-arg-check.patch added to -mm tree
Date: Wed, 10 Nov 2010 13:08:40 -0800
Message-ID: <201011102108.oAAL8ep4006086@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756747Ab0KJVJN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Nov 2010 16:09:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segooon@gmail.com, andre.goddard@gmail.com, bjorn.helgaas@hp.com, fweisbec@gmail.com, joe@perches.com


The patch titled
     lib/vsprintf.c: fix invalid arg check
has been added to the -mm tree.  Its filename is
     lib-vsprintf-fix-invalid-arg-check.patch

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
linux-next.patch
drivers-misc-apds9802alsc-fix-signedness-bug.patch
lib-vsprintf-fix-invalid-arg-check.patch
memstick-core-fix-device_register-error-handling.patch

