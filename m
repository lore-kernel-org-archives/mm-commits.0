From: akpm@linux-foundation.org
Subject: [obsolete] include-asm-generic-vmlinuxldsh-fix-__modver-section-warnings.patch removed from -mm tree
Date: Wed, 25 May 2011 15:46:23 -0700
Message-ID: <201105252323.p4PNN86D023915@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754028Ab1EYXXN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 19:23:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dtor@vmware.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     include/asm-generic/vmlinux.lds.h: fix __modver section warnings
has been removed from the -mm tree.  Its filename was
     include-asm-generic-vmlinuxldsh-fix-__modver-section-warnings.patch

This patch was dropped because it is obsolete

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

origin.patch

