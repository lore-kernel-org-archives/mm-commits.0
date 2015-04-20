From: akpm@linux-foundation.org
Subject: [merged] mips-switch-to-using-asm-generic-for-seccomph.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:20:33 -0700
Message-ID: <55355181.lIlPh5IBXayKU0om%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40481 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbbDTTOM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:14:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mips: switch to using asm-generic for seccomp.h
has been removed from the -mm tree.  Its filename was
     mips-switch-to-using-asm-generic-for-seccomph.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: mips: switch to using asm-generic for seccomp.h

Switch to using the newly created asm-generic/seccomp.h for the seccomp
strict mode syscall definitions.  COMPAT definitions retain their
overrides and the remaining definitions were identical.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/seccomp.h |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN arch/mips/include/asm/seccomp.h~mips-switch-to-using-asm-generic-for-seccomph arch/mips/include/asm/seccomp.h
--- a/arch/mips/include/asm/seccomp.h~mips-switch-to-using-asm-generic-for-seccomph
+++ a/arch/mips/include/asm/seccomp.h
@@ -2,11 +2,6 @@
 
 #include <linux/unistd.h>
 
-#define __NR_seccomp_read __NR_read
-#define __NR_seccomp_write __NR_write
-#define __NR_seccomp_exit __NR_exit
-#define __NR_seccomp_sigreturn __NR_rt_sigreturn
