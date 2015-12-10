From: akpm@linux-foundation.org
Subject: + sh64-fix-__nr_fgetxattr.patch added to -mm tree
Date: Wed, 09 Dec 2015 16:16:31 -0800
Message-ID: <5668c45f.EVzzuc39ECcx/0KZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45937 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbbLJAQb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Dec 2015 19:16:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ldv@altlinux.org, geert+renesas@glider.be, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sh64: fix __NR_fgetxattr
has been added to the -mm tree.  Its filename is
     sh64-fix-__nr_fgetxattr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh64-fix-__nr_fgetxattr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh64-fix-__nr_fgetxattr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: sh64: fix __NR_fgetxattr

According to arch/sh/kernel/syscalls_64.S and common sense, __NR_fgetxattr
has to be defined to 259, but it doesn't.  Instead, it's defined to 269,
which is of course used by another syscall, __NR_sched_setaffinity in this
case.

This bug was found by strace test suite.

Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/uapi/asm/unistd_64.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sh/include/uapi/asm/unistd_64.h~sh64-fix-__nr_fgetxattr arch/sh/include/uapi/asm/unistd_64.h
--- a/arch/sh/include/uapi/asm/unistd_64.h~sh64-fix-__nr_fgetxattr
+++ a/arch/sh/include/uapi/asm/unistd_64.h
@@ -278,7 +278,7 @@
 #define __NR_fsetxattr		256
 #define __NR_getxattr		257
 #define __NR_lgetxattr		258
-#define __NR_fgetxattr		269
+#define __NR_fgetxattr		259
 #define __NR_listxattr		260
 #define __NR_llistxattr		261
 #define __NR_flistxattr		262
_

Patches currently in -mm which might be from ldv@altlinux.org are

sh64-fix-__nr_fgetxattr.patch

