From: akpm@linux-foundation.org
Subject: - ia64-fix-userspace-compile-error-in-gcc_intrinh.patch removed from -mm tree
Date: Mon, 04 Feb 2008 18:53:51 -0800
Message-ID: <200802050253.m152rWJ3031511@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56406 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752259AbYBECxl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 21:53:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: doug.chapman@hp.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: fix userspace compile error in gcc_intrin.h
has been removed from the -mm tree.  Its filename was
     ia64-fix-userspace-compile-error-in-gcc_intrinh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 register unsigned long ia64_r13 asm ("r13") __used;
+#endif
 
 #define ia64_setreg(regnum, val)						\
 ({										\
_

Patches currently in -mm which might be from doug.chapman@hp.com are

git-ia64.patch
