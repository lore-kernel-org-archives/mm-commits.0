From: akpm@linux-foundation.org
Subject: +
 mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-4.patch
 added to -mm tree
Date: Tue, 21 Jul 2015 12:53:57 -0700
Message-ID: <55aea355.RgWnIW3Qr4sEdUpc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39998 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbbGUTx6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jul 2015 15:53:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@roeck-us.net, emunson@akamai.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: increase NR_syscalls to match size of syscall table
has been added to the -mm tree.  Its filename is
     mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Guenter Roeck <linux@roeck-us.net>
Subject: ia64: increase NR_syscalls to match size of syscall table

Commit 05aa30a22eff ("mm: mlock: add new mlock, munlock, and munlockall
system calls") added new system calls, but did not increase the size of the
syscall table for the ia64 architecture, resulting in the following build
error.

arch/ia64/kernel/entry.S: Assembler messages:
arch/ia64/kernel/entry.S:1775: Error: attempt to move .org backwards

Fixes: 05aa30a22eff ("mm: mlock: add new mlock, munlock, and munlockall
	system calls")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Cc: Eric B Munson <emunson@akamai.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/unistd.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/ia64/include/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-4 arch/ia64/include/asm/unistd.h
--- a/arch/ia64/include/asm/unistd.h~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-4
+++ a/arch/ia64/include/asm/unistd.h
@@ -11,7 +11,7 @@
 
 
 
-#define NR_syscalls			319 /* length of syscall table */
+#define NR_syscalls			322 /* length of syscall table */
 
 /*
  * The following defines stop scripts/checksyscalls.sh from complaining about
_

Patches currently in -mm which might be from linux@roeck-us.net are

mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-4.patch
linux-next.patch

