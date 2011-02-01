From: akpm@linux-foundation.org
Subject: + include-asm-generic-vmlinuxldsh-fix-__modver-section-warnings.patch added to -mm tree
Date: Tue, 01 Feb 2011 14:36:30 -0800
Message-ID: <201102012236.p11MaWKx002611@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751221Ab1BAWhI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2011 17:37:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dtor@vmware.com, rusty@rustcorp.com.au


The patch titled
     include/asm-generic/vmlinux.lds.h: fix __modver section warnings
has been added to the -mm tree.  Its filename is
     include-asm-generic-vmlinuxldsh-fix-__modver-section-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/asm-generic/vmlinux.lds.h: fix __modver section warnings
From: Dmitry Torokhov <dtor@vmware.com>

current mainline, x86_64 allnoconfig:

ld: .tmp_vmlinux1: warning: allocated section `__modver' not in segment
ld: .tmp_vmlinux2: warning: allocated section `__modver' not in segment
ld: vmlinux: warning: allocated section `__modver' not in segment

Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/vmlinux.lds.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN include/asm-generic/vmlinux.lds.h~include-asm-generic-vmlinuxldsh-fix-__modver-section-warnings include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~include-asm-generic-vmlinuxldsh-fix-__modver-section-warnings
+++ a/include/asm-generic/vmlinux.lds.h
@@ -359,18 +359,18 @@
 		MEM_KEEP(exit.rodata)					\
 	}								\
 									\
-	/* Built-in module parameters. */				\
-	__param : AT(ADDR(__param) - LOAD_OFFSET) {			\
-		VMLINUX_SYMBOL(__start___param) = .;			\
-		*(__param)						\
-		VMLINUX_SYMBOL(__stop___param) = .;			\
-	}								\
-									\
 	/* Built-in module versions. */					\
 	__modver : AT(ADDR(__modver) - LOAD_OFFSET) {			\
 		VMLINUX_SYMBOL(__start___modver) = .;			\
 		*(__modver)						\
 		VMLINUX_SYMBOL(__stop___modver) = .;			\
+	}								\
+									\
+	/* Built-in module parameters. */				\
+	__param : AT(ADDR(__param) - LOAD_OFFSET) {			\
+		VMLINUX_SYMBOL(__start___param) = .;			\
+		*(__param)						\
+		VMLINUX_SYMBOL(__stop___param) = .;			\
 		. = ALIGN((align));					\
 		VMLINUX_SYMBOL(__end_rodata) = .;			\
 	}								\
_

Patches currently in -mm which might be from dtor@vmware.com are

include-asm-generic-vmlinuxldsh-fix-__modver-section-warnings.patch

