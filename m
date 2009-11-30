From: akpm@linux-foundation.org
Subject: + kfifo-add-record-handling-functions-fix.patch added to -mm tree
Date: Mon, 30 Nov 2009 15:48:33 -0800
Message-ID: <200911302348.nAUNmXau014240@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753856AbZK3Xsl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Nov 2009 18:48:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stefani@seibold.net


The patch titled
     kfifo-add-record-handling-functions-fix
has been added to the -mm tree.  Its filename is
     kfifo-add-record-handling-functions-fix.patch

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
Subject: kfifo-add-record-handling-functions-fix
From: Stefani Seibold <stefani@seibold.net>

The following patch undef temporary used defines after the last usage.

The patch-set is against kfifo API v.07, which is currently included in
the -mm tree

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfifo.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/kfifo.h~kfifo-add-record-handling-functions-fix include/linux/kfifo.h
--- a/include/linux/kfifo.h~kfifo-add-record-handling-functions-fix
+++ a/include/linux/kfifo.h
@@ -296,6 +296,7 @@ static inline unsigned int __kfifo_peek_
 		l |= __KFIFO_GET(fifo, 1, 8);
 
 	return l;
+#undef	__KFIFO_GET
 }
 
 /**
@@ -315,6 +316,7 @@ static inline void __kfifo_poke_n(struct
 
 	if (--recsize)
 		__KFIFO_PUT(fifo, 1, n, 8);
+#undef	__KFIFO_PUT
 }
 
 /**
_

Patches currently in -mm which might be from stefani@seibold.net are

drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-media-video-cx23885-needs-kfifo-updates.patch
kfifo-move-struct-kfifo-in-place.patch
kfifo-move-out-spinlock.patch
kfifo-cleanup-namespace.patch
kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out.patch
kfifo-add-define_kfifo-and-friends-add-very-tiny-functions.patch
kfifo-add-define_kfifo-and-friends-add-very-tiny-functions-fix.patch
kfifo-add-kfifo_skip-kfifo_from_user-and-kfifo_to_user.patch
kfifo-add-record-handling-functions.patch
kfifo-add-record-handling-functions-fix.patch

