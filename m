From: akpm@linux-foundation.org
Subject: [merged] fix-_ioc_typecheck-sparse-error.patch removed from -mm
 tree
Date: Mon, 09 Jun 2014 12:36:02 -0700
Message-ID: <53960ca2.JAfJZZx9lRQ+XpOi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54165 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaFITgD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:36:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, josh@joshtriplett.org, hans.verkuil@cisco.com, hverkuil@xs4all.nl

Subject: [merged] fix-_ioc_typecheck-sparse-error.patch removed from -mm tree
To: hverkuil@xs4all.nl,hans.verkuil@cisco.com,josh@joshtriplett.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:36:02 -0700


The patch titled
     Subject: include/asm-generic/ioctl.h: fix _IOC_TYPECHECK sparse error
has been removed from the -mm tree.  Its filename was
     fix-_ioc_typecheck-sparse-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: include/asm-generic/ioctl.h: fix _IOC_TYPECHECK sparse error

When running sparse over drivers/media/v4l2-core/v4l2-ioctl.c I get these
errors:

drivers/media/v4l2-core/v4l2-ioctl.c:2043:9: error: bad integer constant expression
drivers/media/v4l2-core/v4l2-ioctl.c:2044:9: error: bad integer constant expression
drivers/media/v4l2-core/v4l2-ioctl.c:2045:9: error: bad integer constant expression
drivers/media/v4l2-core/v4l2-ioctl.c:2046:9: error: bad integer constant expression

etc.

The root cause of that turns out to be in include/asm-generic/ioctl.h:

#include <uapi/asm-generic/ioctl.h>

/* provoke compile error for invalid uses of size argument */
extern unsigned int __invalid_size_argument_for_IOC;
#define _IOC_TYPECHECK(t) \
        ((sizeof(t) == sizeof(t[1]) && \
          sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
          sizeof(t) : __invalid_size_argument_for_IOC)

If it is defined as this (as is already done if __KERNEL__ is not defined):

#define _IOC_TYPECHECK(t) (sizeof(t))

then all is well with the world.

This patch allows sparse to work correctly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/ioctl.h |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN include/asm-generic/ioctl.h~fix-_ioc_typecheck-sparse-error include/asm-generic/ioctl.h
--- a/include/asm-generic/ioctl.h~fix-_ioc_typecheck-sparse-error
+++ a/include/asm-generic/ioctl.h
@@ -3,10 +3,15 @@
 
 #include <uapi/asm-generic/ioctl.h>
 
+#ifdef __CHECKER__
+#define _IOC_TYPECHECK(t) (sizeof(t))
+#else
 /* provoke compile error for invalid uses of size argument */
 extern unsigned int __invalid_size_argument_for_IOC;
 #define _IOC_TYPECHECK(t) \
 	((sizeof(t) == sizeof(t[1]) && \
 	  sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
 	  sizeof(t) : __invalid_size_argument_for_IOC)
+#endif
+
 #endif /* _ASM_GENERIC_IOCTL_H */
_

Patches currently in -mm which might be from hverkuil@xs4all.nl are

origin.patch
linux-next.patch

