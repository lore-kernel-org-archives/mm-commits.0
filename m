From: akpm@linux-foundation.org
Subject: + cris-correct-syscall-numbers-in-unistdh-for-timerfd_settime-and-timerfd_gettime.patch added to -mm tree
Date: Thu, 28 Feb 2008 12:42:53 -0800
Message-ID: <200802282042.m1SKgrn0019455@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755037AbYB1Un0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 15:43:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.nilsson@axis.com, mikael.starvik@axis.com


The patch titled
     cris: correct syscall numbers in unistd.h for timerfd_settime and timerfd_gettime
has been added to the -mm tree.  Its filename is
     cris-correct-syscall-numbers-in-unistdh-for-timerfd_settime-and-timerfd_gettime.patch

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
Subject: cris: correct syscall numbers in unistd.h for timerfd_settime and timerfd_gettime
From: Jesper Nilsson <jesper.nilsson@axis.com>

Last commit for unistd was not correct, it only had a partial update of
syscall numbers for __NR_timerfd_settime and __NR_timerfd_gettime.  Also,
NR_syscalls was not incremented for the new syscalls.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-cris/unistd.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/asm-cris/unistd.h~cris-correct-syscall-numbers-in-unistdh-for-timerfd_settime-and-timerfd_gettime include/asm-cris/unistd.h
--- a/include/asm-cris/unistd.h~cris-correct-syscall-numbers-in-unistdh-for-timerfd_settime-and-timerfd_gettime
+++ a/include/asm-cris/unistd.h
@@ -329,12 +329,12 @@
 #define __NR_timerfd_create	322
 #define __NR_eventfd		323
 #define __NR_fallocate		324
-#define __NR_timerfd_settime    315
-#define __NR_timerfd_gettime    316
+#define __NR_timerfd_settime	325
+#define __NR_timerfd_gettime	326
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 325
+#define NR_syscalls 327
 
 #include <asm/arch/unistd.h>
 
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

cris-v10-include-mmh-instead-of-vmstath-in-kernel-timec.patch
cris-import-stringc-memcpy-from-newlib-fixes-compile-error-with-gcc-4.patch
cris-correct-usage-of-__user-for-copy-to-and-from-user-space-in-lib-usercopy-and-uaccessh-try-2.patch
cris-correct-syscall-numbers-in-unistdh-for-timerfd_settime-and-timerfd_gettime.patch

