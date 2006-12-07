From: akpm@osdl.org
Subject: - mm-pagefault_disableenable-s390-fix.patch removed from -mm tree
Date: Wed, 06 Dec 2006 19:12:50 -0800
Message-ID: <200612070312.kB73Co36026917@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41435 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967785AbWLGDNA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 22:13:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, a.p.zijlstra@chello.nl, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     s390: pagefault_disable/enable build fix
has been removed from the -mm tree.  Its filename was
     mm-pagefault_disableenable-s390-fix.patch

This patch was dropped because it was folded into mm-pagefault_disableenable.patch

------------------------------------------------------
Subject: s390: pagefault_disable/enable build fix
From: Heiko Carstens <heiko.carstens@de.ibm.com>

arch/s390/lib/lib.a(uaccess_std.o)(.text+0x282): In function `futex_atomic_op':
: undefined reference to `pagefault_disable'

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/s390/lib/uaccess_std.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/s390/lib/uaccess_std.c~mm-pagefault_disableenable-s390-fix arch/s390/lib/uaccess_std.c
--- a/arch/s390/lib/uaccess_std.c~mm-pagefault_disableenable-s390-fix
+++ a/arch/s390/lib/uaccess_std.c
@@ -11,7 +11,7 @@
 
 #include <linux/errno.h>
 #include <linux/mm.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <asm/futex.h>
 
 #ifndef __s390x__
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
mm-pagefault_disableenable.patch
mm-pagefault_disableenable-s390-fix.patch
binfmt-fix-uaccess-handling.patch
compat-fix-uaccess-handling.patch
profile-fix-uaccess-handling.patch

