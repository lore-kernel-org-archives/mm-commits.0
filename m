From: akpm@linux-foundation.org
Subject: [merged] uio-mark-uioh-functions-__kernel__-only.patch removed from -mm tree
Date: Thu, 30 Jul 2009 13:37:40 -0700
Message-ID: <200907302037.n6UKbeI7011873@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752122AbZG3UiH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 16:38:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, hch@infradead.org, sam@ravnborg.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     uio: mark uio.h functions __KERNEL__ only
has been removed from the -mm tree.  Its filename was
     uio-mark-uioh-functions-__kernel__-only.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uio: mark uio.h functions __KERNEL__ only
From: Jiri Slaby <jirislaby@gmail.com>

To avoid userspace build failures such as:

.../linux/uio.h:37: error: expected `=', `,', `;', `asm' or `__attribute__' before `iov_length'
.../linux/uio.h:47: error: expected declaration specifiers or `...' before `size_t'

move uio functions inside a __KERNEL__ block.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/uio.h |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN include/linux/uio.h~uio-mark-uioh-functions-__kernel__-only include/linux/uio.h
--- a/include/linux/uio.h~uio-mark-uioh-functions-__kernel__-only
+++ a/include/linux/uio.h
@@ -19,15 +19,6 @@ struct iovec
 	__kernel_size_t iov_len; /* Must be size_t (1003.1g) */
 };
 
-#ifdef __KERNEL__
-
-struct kvec {
-	void *iov_base; /* and that should *never* hold a userland pointer */
-	size_t iov_len;
-};
-
-#endif
-
 /*
  *	UIO_MAXIOV shall be at least 16 1003.1g (5.4.1.1)
  */
@@ -35,6 +26,13 @@ struct kvec {
 #define UIO_FASTIOV	8
 #define UIO_MAXIOV	1024
 
+#ifdef __KERNEL__
+
+struct kvec {
+	void *iov_base; /* and that should *never* hold a userland pointer */
+	size_t iov_len;
+};
+
 /*
  * Total number of bytes covered by an iovec.
  *
@@ -53,5 +51,6 @@ static inline size_t iov_length(const st
 }
 
 unsigned long iov_shorten(struct iovec *iov, unsigned long nr_segs, size_t to);
+#endif
 
 #endif
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
linux-next.patch
toshiba_acpi-return-on-a-fail-path.patch
mtd-sst25l-fix-lock-imbalance.patch
isdn-hisax-fix-lock-imbalance.patch
icom-converting-space-to-tabs.patch
cyclades-read-buffer-overflow.patch
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch
reiser4.patch

