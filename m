From: akpm@linux-foundation.org
Subject: - scrub-non-__glibc__-checks-in-linux-socketh-and-linux-stath.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:51:04 -0800
Message-ID: <200702112251.l1BMp41l015916@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60074 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932746AbXBKWvH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:51:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     scrub non-__GLIBC__ checks in linux/socket.h and linux/stat.h
has been removed from the -mm tree.  Its filename was
     scrub-non-__glibc__-checks-in-linux-socketh-and-linux-stath.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: scrub non-__GLIBC__ checks in linux/socket.h and linux/stat.h
From: "Mike Frysinger" <vapier.adi@gmail.com>

Userspace should be worrying about userspace, so having the socket.h
and stat.h pollute the namespace in the non-glibc case is wrong and
pretty much prevents any other libc from utilizing these headers
sanely unless they set up the __GLIBC__ define themselves (which
sucks)

Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/socket.h |    2 +-
 include/linux/stat.h   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/socket.h~scrub-non-__glibc__-checks-in-linux-socketh-and-linux-stath include/linux/socket.h
--- a/include/linux/socket.h~scrub-non-__glibc__-checks-in-linux-socketh-and-linux-stath
+++ a/include/linux/socket.h
@@ -16,7 +16,7 @@ struct __kernel_sockaddr_storage {
 				/* _SS_MAXSIZE value minus size of ss_family */
 } __attribute__ ((aligned(_K_SS_ALIGNSIZE)));	/* force desired alignment */
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+#ifdef __KERNEL__
 
 #include <asm/socket.h>			/* arch-dependent defines	*/
 #include <linux/sockios.h>		/* the SIOCxxx I/O controls	*/
diff -puN include/linux/stat.h~scrub-non-__glibc__-checks-in-linux-socketh-and-linux-stath include/linux/stat.h
--- a/include/linux/stat.h~scrub-non-__glibc__-checks-in-linux-socketh-and-linux-stath
+++ a/include/linux/stat.h
@@ -7,7 +7,7 @@
 
 #endif
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+#ifdef __KERNEL__
 
 #define S_IFMT  00170000
 #define S_IFSOCK 0140000
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
search-a-little-harder-for-mkimage.patch
