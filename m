From: akpm@linux-foundation.org
Subject: [merged]
 xattr-guard-against-simultaneous-glibc-header-inclusion-v2.patch removed
 from -mm tree
Date: Fri, 04 Apr 2014 12:32:36 -0700
Message-ID: <533f08d4.EX1AnMnHakX0ZRbs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43181 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409AbaDDTch (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:32:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, allan@archlinux.org, akpm@linux-foundation.org, serge.hallyn@ubuntu.com

Subject: [merged] xattr-guard-against-simultaneous-glibc-header-inclusion-v2.patch removed from -mm tree
To: serge.hallyn@ubuntu.com,akpm@linux-foundation.org,allan@archlinux.org,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:32:36 -0700


The patch titled
     Subject: xattr: guard against simultaneous glibc header inclusion
has been removed from the -mm tree.  Its filename was
     xattr-guard-against-simultaneous-glibc-header-inclusion-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: xattr: guard against simultaneous glibc header inclusion

If the glibc xattr.h header is included after the uapi header, compilation
fails due to an enum re-using a #define from the uapi header.  Protect
against this by guarding the define and enum inclusions against each
other.

(See https://lists.debian.org/debian-glibc/2014/03/msg00029.html
and https://sourceware.org/glibc/wiki/Synchronizing_Headers
for more information.)

Signed-off-by: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Allan McRae <allan@archlinux.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/libc-compat.h |    9 +++++++++
 include/uapi/linux/xattr.h       |    7 +++++++
 2 files changed, 16 insertions(+)

diff -puN include/uapi/linux/libc-compat.h~xattr-guard-against-simultaneous-glibc-header-inclusion-v2 include/uapi/linux/libc-compat.h
--- a/include/uapi/linux/libc-compat.h~xattr-guard-against-simultaneous-glibc-header-inclusion-v2
+++ a/include/uapi/linux/libc-compat.h
@@ -85,6 +85,12 @@
 
 #endif /* _NETINET_IN_H */
 
+/* Definitions for xattr.h */
+#if defined(_SYS_XATTR_H)
+#define __UAPI_DEF_XATTR		0
+#else
+#define __UAPI_DEF_XATTR		1
+#endif
 
 /* If we did not see any headers from any supported C libraries,
  * or we are being included in the kernel, then define everything
@@ -98,6 +104,9 @@
 #define __UAPI_DEF_IPV6_MREQ		1
 #define __UAPI_DEF_IPPROTO_V6		1
 
+/* Definitions for xattr.h */
+#define __UAPI_DEF_XATTR		1
+
 #endif /* __GLIBC__ */
 
 #endif /* _UAPI_LIBC_COMPAT_H */
diff -puN include/uapi/linux/xattr.h~xattr-guard-against-simultaneous-glibc-header-inclusion-v2 include/uapi/linux/xattr.h
--- a/include/uapi/linux/xattr.h~xattr-guard-against-simultaneous-glibc-header-inclusion-v2
+++ a/include/uapi/linux/xattr.h
@@ -7,11 +7,18 @@
   Copyright (c) 2001-2002 Silicon Graphics, Inc.  All Rights Reserved.
   Copyright (c) 2004 Red Hat, Inc., James Morris <jmorris@redhat.com>
 */
+
+#include <linux/libc-compat.h>
+
 #ifndef _UAPI_LINUX_XATTR_H
 #define _UAPI_LINUX_XATTR_H
 
+#ifdef __UAPI_DEF_XATTR
+#define __USE_KERNEL_XATTR_DEFS
+
 #define XATTR_CREATE	0x1	/* set value, fail if attr already exists */
 #define XATTR_REPLACE	0x2	/* set value, fail if attr does not exist */
+#endif
 
 /* Namespaces */
 #define XATTR_OS2_PREFIX "os2."
_

Patches currently in -mm which might be from serge.hallyn@ubuntu.com are

origin.patch
linux-next.patch

