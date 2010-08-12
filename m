From: akpm@linux-foundation.org
Subject: + asm-generic-unistdh-add-fanotify-syscalls.patch added to -mm tree
Date: Thu, 12 Aug 2010 12:55:02 -0700
Message-ID: <201008121955.o7CJt2gB009519@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754398Ab0HLTz6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Aug 2010 15:55:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cmetcalf@tilera.com, arnd@arndb.de, eparis@redhat.com


The patch titled
     asm-generic/unistd.h: add fanotify syscalls
has been added to the -mm tree.  Its filename is
     asm-generic-unistdh-add-fanotify-syscalls.patch

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
Subject: asm-generic/unistd.h: add fanotify syscalls
From: Chris Metcalf <cmetcalf@tilera.com>

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/unistd.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN include/asm-generic/unistd.h~asm-generic-unistdh-add-fanotify-syscalls include/asm-generic/unistd.h
--- a/include/asm-generic/unistd.h~asm-generic-unistdh-add-fanotify-syscalls
+++ a/include/asm-generic/unistd.h
@@ -642,9 +642,13 @@ __SYSCALL(__NR_recvmmsg, sys_recvmmsg)
 __SYSCALL(__NR_wait4, sys_wait4)
 #define __NR_prlimit64 261
 __SYSCALL(__NR_prlimit64, sys_prlimit64)
+#define __NR_fanotify_init 262
+__SYSCALL(__NR_fanotify_init, sys_fanotify_init)
+#define __NR_fanotify_mark 263
+__SYSCALL(__NR_fanotify_mark, sys_fanotify_mark)
 
 #undef __NR_syscalls
-#define __NR_syscalls 262
+#define __NR_syscalls 264
 
 /*
  * All syscalls below here should go away really,
_

Patches currently in -mm which might be from cmetcalf@tilera.com are

origin.patch
asm-generic-unistdh-add-fanotify-syscalls.patch

