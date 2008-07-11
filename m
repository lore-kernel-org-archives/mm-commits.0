From: akpm@linux-foundation.org
Subject: + drm-remove-defines-for-non-linux-systems.patch added to -mm tree
Date: Fri, 11 Jul 2008 16:29:40 -0700
Message-ID: <200807112329.m6BNTeT1010201@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753295AbYGKX3m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 19:29:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: crmafra2@gmail.com, crmafra@gmail.com


The patch titled
     drm: remove #define's for non-linux systems
has been added to the -mm tree.  Its filename is
     drm-remove-defines-for-non-linux-systems.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm: remove #define's for non-linux systems
From: "Carlos R. Mafra" <crmafra2@gmail.com>

There is no point in considering FreeBSD et al.  in the linux kernel
source code.

Signed-off-by: Carlos R. Mafra <crmafra@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/drm/drm.h |   17 -----------------
 1 file changed, 17 deletions(-)

diff -puN include/drm/drm.h~drm-remove-defines-for-non-linux-systems include/drm/drm.h
--- a/include/drm/drm.h~drm-remove-defines-for-non-linux-systems
+++ a/include/drm/drm.h
@@ -36,7 +36,6 @@
 #ifndef _DRM_H_
 #define _DRM_H_
 
-#if defined(__linux__)
 #if defined(__KERNEL__)
 #endif
 #include <asm/ioctl.h>		/* For _IO* macros */
@@ -46,22 +45,6 @@
 #define DRM_IOC_WRITE		_IOC_WRITE
 #define DRM_IOC_READWRITE	_IOC_READ|_IOC_WRITE
 #define DRM_IOC(dir, group, nr, size) _IOC(dir, group, nr, size)
-#elif defined(__FreeBSD__) || defined(__NetBSD__) || defined(__OpenBSD__)
-#if defined(__FreeBSD__) && defined(IN_MODULE)
-/* Prevent name collision when including sys/ioccom.h */
-#undef ioctl
-#include <sys/ioccom.h>
-#define ioctl(a,b,c)		xf86ioctl(a,b,c)
-#else
-#include <sys/ioccom.h>
-#endif				/* __FreeBSD__ && xf86ioctl */
-#define DRM_IOCTL_NR(n)		((n) & 0xff)
-#define DRM_IOC_VOID		IOC_VOID
-#define DRM_IOC_READ		IOC_OUT
-#define DRM_IOC_WRITE		IOC_IN
-#define DRM_IOC_READWRITE	IOC_INOUT
-#define DRM_IOC(dir, group, nr, size) _IOC(dir, group, nr, size)
-#endif
 
 #define DRM_MAJOR       226
 #define DRM_MAX_MINOR   15
_

Patches currently in -mm which might be from crmafra2@gmail.com are

linux-next.patch
drm-remove-defines-for-non-linux-systems.patch

