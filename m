From: akpm@linux-foundation.org
Subject: + make-ioctlh-compatible-with-userland.patch added to -mm tree
Date: Wed, 30 Jul 2008 01:10:57 -0700
Message-ID: <200807300810.m6U8AvRc015471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39711 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758867AbYG3ILG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 04:11:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael@araneidae.co.uk


The patch titled
     Make ioctl.h compatible with userland
has been added to the -mm tree.  Its filename is
     make-ioctlh-compatible-with-userland.patch

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
Subject: Make ioctl.h compatible with userland
From: Michael Abbott <michael@araneidae.co.uk>

The attached patch seems to already exist in a number of branches -- it
keeps popping up on Google for me, and is certainly already in Debian --
but is strangely absent from mainstream.

The problem appears to be that the patched file ends up as part of the
target toolchain, but unfortunately the gcc constant folding doesn't
appear to eliminate the __invalid_size_argument_for_IOC value early
enough.  Certainly compiling C++ programs which use _IO...  macros as
constants fails without this patch.



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/ioctl.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/asm-generic/ioctl.h~make-ioctlh-compatible-with-userland include/asm-generic/ioctl.h
--- a/include/asm-generic/ioctl.h~make-ioctlh-compatible-with-userland
+++ a/include/asm-generic/ioctl.h
@@ -68,12 +68,16 @@
 	 ((nr)   << _IOC_NRSHIFT) | \
 	 ((size) << _IOC_SIZESHIFT))
 
+#ifdef __KERNEL__
 /* provoke compile error for invalid uses of size argument */
 extern unsigned int __invalid_size_argument_for_IOC;
 #define _IOC_TYPECHECK(t) \
 	((sizeof(t) == sizeof(t[1]) && \
 	  sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
 	  sizeof(t) : __invalid_size_argument_for_IOC)
+#else
+#define _IOC_TYPECHECK(t) (sizeof(t))
+#endif
 
 /* used to create numbers */
 #define _IO(type,nr)		_IOC(_IOC_NONE,(type),(nr),0)
_

Patches currently in -mm which might be from michael@araneidae.co.uk are

make-ioctlh-compatible-with-userland.patch

