From: akpm@linux-foundation.org
Subject: + fix-_ioc_typecheck-sparse-error.patch added to -mm tree
Date: Mon, 12 May 2014 14:37:05 -0700
Message-ID: <53713f01.MGDf826+vXMylmAR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39048 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbaELVhG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 May 2014 17:37:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, josh@joshtriplett.org, hans.verkuil@cisco.com, hverkuil@xs4all.nl

Subject: + fix-_ioc_typecheck-sparse-error.patch added to -mm tree
To: hverkuil@xs4all.nl,hans.verkuil@cisco.com,josh@joshtriplett.org
From: akpm@linux-foundation.org
Date: Mon, 12 May 2014 14:37:05 -0700


The patch titled
     Subject: include/asm-generic/ioctl.h: fix _IOC_TYPECHECK sparse error
has been added to the -mm tree.  Its filename is
     fix-_ioc_typecheck-sparse-error.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fix-_ioc_typecheck-sparse-error.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fix-_ioc_typecheck-sparse-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fix-_ioc_typecheck-sparse-error.patch
linux-next.patch

