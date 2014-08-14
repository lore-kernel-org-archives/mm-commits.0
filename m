From: akpm@linux-foundation.org
Subject: + xattr-fix-check-for-simultaneous-glibc-header-inclusion.patch
 added to -mm tree
Date: Thu, 14 Aug 2014 14:29:15 -0700
Message-ID: <53ed2a2b.cm1AM6IhZkwapegH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:53786 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169AbaHNV3Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Aug 2014 17:29:16 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so479347pab.4
        for <mm-commits@vger.kernel.org>; Thu, 14 Aug 2014 14:29:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: filbranden@google.com, allan@archlinux.org, serge.hallyn@ubuntu.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: xattr: fix check for simultaneous glibc header inclusion
has been added to the -mm tree.  Its filename is
     xattr-fix-check-for-simultaneous-glibc-header-inclusion.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/xattr-fix-check-for-simultaneous-glibc-header-inclusion.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/xattr-fix-check-for-simultaneous-glibc-header-inclusion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>
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

xattr-fix-check-for-simultaneous-glibc-header-inclusion.patch

