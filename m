From: akpm@linux-foundation.org
Subject: [merged]
 xattr-fix-check-for-simultaneous-glibc-header-inclusion.patch removed from
 -mm tree
Date: Wed, 03 Sep 2014 10:57:39 -0700
Message-ID: <54075693.DuTP60vhDm0trTic%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42874 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877AbaICR5k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2014 13:57:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: filbranden@google.com, allan@archlinux.org, serge.hallyn@ubuntu.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: xattr: fix check for simultaneous glibc header inclusion
has been removed from the -mm tree.  Its filename was
     xattr-fix-check-for-simultaneous-glibc-header-inclusion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Filipe Brandenburger <filbranden@google.com>
Subject: xattr: fix check for simultaneous glibc header inclusion

The guard was introduced in ea1a8217b06b41 ("xattr: guard against
simultaneous glibc header inclusion") but it is using #ifdef to check for
a define that is either set to 1 or 0.  Fix it to use #if instead.

* Without this patch:
  $ { echo "#include <sys/xattr.h>"; echo "#include <linux/xattr.h>"; } | gcc -E -Iinclude/uapi - >/dev/null
  include/uapi/linux/xattr.h:19:0: warning: "XATTR_CREATE" redefined [enabled by default]
   #define XATTR_CREATE 0x1 /* set value, fail if attr already exists */
   ^
  /usr/include/x86_64-linux-gnu/sys/xattr.h:32:0: note: this is the location of the previous definition
   #define XATTR_CREATE XATTR_CREATE
   ^

* With this patch:
  $ { echo "#include <sys/xattr.h>"; echo "#include <linux/xattr.h>"; } | gcc -E -Iinclude/uapi - >/dev/null
  (no warnings)

Signed-off-by: Filipe Brandenburger <filbranden@google.com>
Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
Cc: Allan McRae <allan@archlinux.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/xattr.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/uapi/linux/xattr.h~xattr-fix-check-for-simultaneous-glibc-header-inclusion include/uapi/linux/xattr.h
--- a/include/uapi/linux/xattr.h~xattr-fix-check-for-simultaneous-glibc-header-inclusion
+++ a/include/uapi/linux/xattr.h
@@ -13,7 +13,7 @@
 #ifndef _UAPI_LINUX_XATTR_H
 #define _UAPI_LINUX_XATTR_H
 
-#ifdef __UAPI_DEF_XATTR
+#if __UAPI_DEF_XATTR
 #define __USE_KERNEL_XATTR_DEFS
 
 #define XATTR_CREATE	0x1	/* set value, fail if attr already exists */
_

Patches currently in -mm which might be from filbranden@google.com are


