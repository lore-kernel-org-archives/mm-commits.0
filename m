Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1826BC2BBCA
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:16:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFAC022D2B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:16:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731055AbgLOXQh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:16:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:56708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730422AbgLOXQb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:16:31 -0500
Date:   Tue, 15 Dec 2020 15:15:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074145;
        bh=FABl8xivaehN+lUbLb1XfOubWq7RI0psw4cXTa+Bef8=;
        h=From:To:Subject:From;
        b=jfaccvMnnHoSS21xaXiMCbqBw7Oe2ie6OtdR75yRF5q+BH/DAfpq+cQD6XMveOT6y
         s0BEp9bfIKVx5jWkCfHp4Q9eJqDlfnhm+ARwPdeaKX5p+lkOwCDVd7anpF/xW45dZG
         juT+Eu92eiNeRTmG5T/HkAFJe3o9ST/xP01hYSU0=
From:   akpm@linux-foundation.org
To:     baruch@tkos.co.il, dalias@aerifal.cx, dalias@libc.org,
        fweimer@redhat.com, mm-commits@vger.kernel.org,
        peter@korsgaard.com, petr.vorel@gmail.com
Subject:  [merged]
 uapi-move-constants-from-linux-kernelh-to-linux-consth.patch removed from
 -mm tree
Message-ID: <20201215231544.ftXPAP8EC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: uapi: move constants from <linux/kernel.h> to <linux/const.h>
has been removed from the -mm tree.  Its filename was
     uapi-move-constants-from-linux-kernelh-to-linux-consth.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Petr Vorel <petr.vorel@gmail.com>
Subject: uapi: move constants from <linux/kernel.h> to <linux/const.h>

and include <linux/const.h> in UAPI headers instead of <linux/kernel.h>.

The reason is to avoid indirect <linux/sysinfo.h> include when using
some network headers: <linux/netlink.h> or others -> <linux/kernel.h>
-> <linux/sysinfo.h>.

This indirect include causes on MUSL redefinition of struct sysinfo when
included both <sys/sysinfo.h> and some of UAPI headers:

In file included from x86_64-buildroot-linux-musl/sysroot/usr/include/linux/kernel.h:5,
                 from x86_64-buildroot-linux-musl/sysroot/usr/include/linux/netlink.h:5,
                 from ../include/tst_netlink.h:14,
                 from tst_crypto.c:13:
x86_64-buildroot-linux-musl/sysroot/usr/include/linux/sysinfo.h:8:8: error: redefinition of `struct sysinfo'
 struct sysinfo {
        ^~~~~~~
In file included from ../include/tst_safe_macros.h:15,
                 from ../include/tst_test.h:93,
                 from tst_crypto.c:11:
x86_64-buildroot-linux-musl/sysroot/usr/include/sys/sysinfo.h:10:8: note: originally defined here

Link: https://lkml.kernel.org/r/20201015190013.8901-1-petr.vorel@gmail.com
Signed-off-by: Petr Vorel <petr.vorel@gmail.com>
Suggested-by: Rich Felker <dalias@aerifal.cx>
Acked-by: Rich Felker <dalias@libc.org>
Cc: Peter Korsgaard <peter@korsgaard.com>
Cc: Baruch Siach <baruch@tkos.co.il>
Cc: Florian Weimer <fweimer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/const.h              |    5 +++++
 include/uapi/linux/ethtool.h            |    2 +-
 include/uapi/linux/kernel.h             |    9 +--------
 include/uapi/linux/lightnvm.h           |    2 +-
 include/uapi/linux/mroute6.h            |    2 +-
 include/uapi/linux/netfilter/x_tables.h |    2 +-
 include/uapi/linux/netlink.h            |    2 +-
 include/uapi/linux/sysctl.h             |    2 +-
 8 files changed, 12 insertions(+), 14 deletions(-)

--- a/include/uapi/linux/const.h~uapi-move-constants-from-linux-kernelh-to-linux-consth
+++ a/include/uapi/linux/const.h
@@ -28,4 +28,9 @@
 #define _BITUL(x)	(_UL(1) << (x))
 #define _BITULL(x)	(_ULL(1) << (x))
 
+#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (typeof(x))(a) - 1)
+#define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
+
+#define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
+
 #endif /* _UAPI_LINUX_CONST_H */
--- a/include/uapi/linux/ethtool.h~uapi-move-constants-from-linux-kernelh-to-linux-consth
+++ a/include/uapi/linux/ethtool.h
@@ -14,7 +14,7 @@
 #ifndef _UAPI_LINUX_ETHTOOL_H
 #define _UAPI_LINUX_ETHTOOL_H
 
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/types.h>
 #include <linux/if_ether.h>
 
--- a/include/uapi/linux/kernel.h~uapi-move-constants-from-linux-kernelh-to-linux-consth
+++ a/include/uapi/linux/kernel.h
@@ -3,13 +3,6 @@
 #define _UAPI_LINUX_KERNEL_H
 
 #include <linux/sysinfo.h>
-
-/*
- * 'kernel.h' contains some often-used function prototypes etc
- */
-#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (typeof(x))(a) - 1)
-#define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
-
-#define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
+#include <linux/const.h>
 
 #endif /* _UAPI_LINUX_KERNEL_H */
--- a/include/uapi/linux/lightnvm.h~uapi-move-constants-from-linux-kernelh-to-linux-consth
+++ a/include/uapi/linux/lightnvm.h
@@ -21,7 +21,7 @@
 #define _UAPI_LINUX_LIGHTNVM_H
 
 #ifdef __KERNEL__
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/ioctl.h>
 #else /* __KERNEL__ */
 #include <stdio.h>
--- a/include/uapi/linux/mroute6.h~uapi-move-constants-from-linux-kernelh-to-linux-consth
+++ a/include/uapi/linux/mroute6.h
@@ -2,7 +2,7 @@
 #ifndef _UAPI__LINUX_MROUTE6_H
 #define _UAPI__LINUX_MROUTE6_H
 
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/types.h>
 #include <linux/sockios.h>
 #include <linux/in6.h>		/* For struct sockaddr_in6. */
--- a/include/uapi/linux/netfilter/x_tables.h~uapi-move-constants-from-linux-kernelh-to-linux-consth
+++ a/include/uapi/linux/netfilter/x_tables.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 #ifndef _UAPI_X_TABLES_H
 #define _UAPI_X_TABLES_H
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/types.h>
 
 #define XT_FUNCTION_MAXNAMELEN 30
--- a/include/uapi/linux/netlink.h~uapi-move-constants-from-linux-kernelh-to-linux-consth
+++ a/include/uapi/linux/netlink.h
@@ -2,7 +2,7 @@
 #ifndef _UAPI__LINUX_NETLINK_H
 #define _UAPI__LINUX_NETLINK_H
 
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/socket.h> /* for __kernel_sa_family_t */
 #include <linux/types.h>
 
--- a/include/uapi/linux/sysctl.h~uapi-move-constants-from-linux-kernelh-to-linux-consth
+++ a/include/uapi/linux/sysctl.h
@@ -23,7 +23,7 @@
 #ifndef _UAPI_LINUX_SYSCTL_H
 #define _UAPI_LINUX_SYSCTL_H
 
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/types.h>
 #include <linux/compiler.h>
 
_

Patches currently in -mm which might be from petr.vorel@gmail.com are


