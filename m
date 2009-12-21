From: akpm@linux-foundation.org
Subject: [folded] kfifo-add-define_kfifo-and-friends-add-very-tiny-functions-fix.patch removed from -mm tree
Date: Mon, 21 Dec 2009 14:34:15 -0800
Message-ID: <200912212234.nBLMYFu8032574@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750976AbZLUWe3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Dec 2009 17:34:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefani@seibold.net, mm-commits@vger.kernel.org


The patch titled
     kfifo-add-define_kfifo-and-friends-add-very-tiny-functions fix
has been removed from the -mm tree.  Its filename was
     kfifo-add-define_kfifo-and-friends-add-very-tiny-functions-fix.patch

This patch was dropped because it was folded into kfifo-add-define_kfifo-and-friends-add-very-tiny-functions.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kfifo-add-define_kfifo-and-friends-add-very-tiny-functions fix
From: Stefani Seibold <stefani@seibold.net>

The following patch undef temporary used defines after the last usage.

The patch-set is against kfifo API v.07, which is currently included in
the -mm tree

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfifo.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/linux/kfifo.h~kfifo-add-define_kfifo-and-friends-add-very-tiny-functions-fix include/linux/kfifo.h
--- a/include/linux/kfifo.h~kfifo-add-define_kfifo-and-friends-add-very-tiny-functions-fix
+++ a/include/linux/kfifo.h
@@ -55,6 +55,7 @@ struct kfifo {
  * Macros for declaration and initialization of the kfifo datatype
  */
 
+/* helper macro */
 #define __kfifo_initializer(s, b) \
 	(struct kfifo) { \
 		.size	= s, \
@@ -102,6 +103,8 @@ union { \
 	unsigned char name##kfifo_buffer[size]; \
 	struct kfifo name = __kfifo_initializer(size, name##kfifo_buffer)
 
+#undef __kfifo_initializer
+
 extern void kfifo_init(struct kfifo *fifo, unsigned char *buffer,
 			unsigned int size);
 extern __must_check int kfifo_alloc(struct kfifo *fifo, unsigned int size,
_

Patches currently in -mm which might be from stefani@seibold.net are

kfifo-move-struct-kfifo-in-place.patch
kfifo-move-out-spinlock.patch
kfifo-cleanup-namespace.patch
kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out.patch
kfifo-fix-warn_unused_result.patch
kfifo-add-define_kfifo-and-friends-add-very-tiny-functions.patch
kfifo-add-define_kfifo-and-friends-add-very-tiny-functions-fix.patch
kfifo-add-kfifo_skip-kfifo_from_user-and-kfifo_to_user.patch
kfifo-add-record-handling-functions.patch
kfifo-add-record-handling-functions-fix.patch
media-video-cx23888-driver-ported-to-new-kfifo-api.patch
media-video-cx23888-driver-ported-to-new-kfifo-api-fix.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch

