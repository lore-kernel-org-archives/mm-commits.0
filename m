From: akpm@linux-foundation.org
Subject: [merged] microblaze-use-asm-generic-for-seccomph.patch removed
 from -mm tree
Date: Mon, 20 Apr 2015 12:20:31 -0700
Message-ID: <5535517f.geXQzGw9aQC/u9WB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40477 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbbDTTOK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:14:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, monstr@monstr.eu, mm-commits@vger.kernel.org


The patch titled
     Subject: microblaze: use asm-generic for seccomp.h
has been removed from the -mm tree.  Its filename was
     microblaze-use-asm-generic-for-seccomph.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: microblaze: use asm-generic for seccomp.h

Switch to using the newly created asm-generic/seccomp.h for the seccomp
strict mode syscall definitions. Since microblaze is 32-bit, the COMPAT
seccomp defines are unused and can be dropped. The obsolete sigreturn
for seccomp strict mode is retained as an override. Remaining definitions
are identical.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/include/asm/seccomp.h |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN arch/microblaze/include/asm/seccomp.h~microblaze-use-asm-generic-for-seccomph arch/microblaze/include/asm/seccomp.h
--- a/arch/microblaze/include/asm/seccomp.h~microblaze-use-asm-generic-for-seccomph
+++ a/arch/microblaze/include/asm/seccomp.h
@@ -3,14 +3,8 @@
 
 #include <linux/unistd.h>
 
-#define __NR_seccomp_read		__NR_read
-#define __NR_seccomp_write		__NR_write
-#define __NR_seccomp_exit		__NR_exit
 #define __NR_seccomp_sigreturn		__NR_sigreturn
 
-#define __NR_seccomp_read_32		__NR_read
-#define __NR_seccomp_write_32		__NR_write
-#define __NR_seccomp_exit_32		__NR_exit
-#define __NR_seccomp_sigreturn_32	__NR_sigreturn
+#include <asm-generic/seccomp.h>
 
 #endif	/* _ASM_MICROBLAZE_SECCOMP_H */
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
lib-vsprintf-add-%pt-format-specifier.patch

