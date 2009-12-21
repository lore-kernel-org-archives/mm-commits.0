From: akpm@linux-foundation.org
Subject: [folded] kfifo-add-record-handling-functions-fix.patch removed from -mm tree
Date: Mon, 21 Dec 2009 14:34:30 -0800
Message-ID: <200912212234.nBLMYUTS032577@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753582AbZLUWen (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Dec 2009 17:34:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefani@seibold.net, mm-commits@vger.kernel.org


The patch titled
     kfifo-add-record-handling-functions-fix
has been removed from the -mm tree.  Its filename was
     kfifo-add-record-handling-functions-fix.patch

This patch was dropped because it was folded into kfifo-add-record-handling-functions.patch

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

kfifo-move-struct-kfifo-in-place.patch
kfifo-move-out-spinlock.patch
kfifo-cleanup-namespace.patch
kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out.patch
kfifo-fix-warn_unused_result.patch
kfifo-add-define_kfifo-and-friends-add-very-tiny-functions.patch
kfifo-add-kfifo_skip-kfifo_from_user-and-kfifo_to_user.patch
kfifo-add-record-handling-functions.patch
kfifo-add-record-handling-functions-fix.patch
media-video-cx23888-driver-ported-to-new-kfifo-api.patch
media-video-cx23888-driver-ported-to-new-kfifo-api-fix.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch

