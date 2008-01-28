From: akpm@linux-foundation.org
Subject: + ia64-fix-userspace-compile-error-in-gcc_intrinh.patch added to -mm tree
Date: Sun, 27 Jan 2008 21:15:25 -0800
Message-ID: <200801280516.m0S5GKs9013431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33192 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751986AbYA1FQe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 00:16:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: doug.chapman@hp.com, tony.luck@intel.com


The patch titled
     ia64: fix userspace compile error in gcc_intrin.h
has been added to the -mm tree.  Its filename is
     ia64-fix-userspace-compile-error-in-gcc_intrinh.patch

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
Subject: ia64: fix userspace compile error in gcc_intrin.h
From: Doug Chapman <doug.chapman@hp.com>

Fixes userspace build errors when linux/ipv6.h is included such as in the
dhcpv6 package under fedora.  Likely causes other userspace build errors as
well.  I found this in akpm's tree from 2.6.18 but could not find any case
of anyone proposing it for the main tree.

Signed-off-by: Doug Chapman <doug.chapman@hp.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-ia64/gcc_intrin.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/asm-ia64/gcc_intrin.h~ia64-fix-userspace-compile-error-in-gcc_intrinh include/asm-ia64/gcc_intrin.h
--- a/include/asm-ia64/gcc_intrin.h~ia64-fix-userspace-compile-error-in-gcc_intrinh
+++ a/include/asm-ia64/gcc_intrin.h
@@ -24,7 +24,9 @@
 extern void ia64_bad_param_for_setreg (void);
 extern void ia64_bad_param_for_getreg (void);
 
+#ifdef __KERNEL__
 register unsigned long ia64_r13 asm ("r13") __attribute_used__;
+#endif
 
 #define ia64_setreg(regnum, val)						\
 ({										\
_

Patches currently in -mm which might be from doug.chapman@hp.com are

ia64-fix-userspace-compile-error-in-gcc_intrinh.patch
