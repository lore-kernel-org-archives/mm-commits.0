From: akpm@linux-foundation.org
Subject: - cris-correct-syscall-numbers-in-unistdh-for-timerfd_settime-and-timerfd_gettime.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:46:05 -0800
Message-ID: <200803050746.m257k5UP021716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50890 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764023AbYCEHqJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:46:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.nilsson@axis.com, mikael.starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris: correct syscall numbers in unistd.h for timerfd_settime and timerfd_gettime
has been removed from the -mm tree.  Its filename was
     cris-correct-syscall-numbers-in-unistdh-for-timerfd_settime-and-timerfd_gettime.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


