From: akpm@linux-foundation.org
Subject: + m68knommu-wire-up-new-timerfd-syscalls.patch added to -mm tree
Date: Tue, 04 Mar 2008 00:27:01 -0800
Message-ID: <200803040827.m248R3OL031386@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751385AbYCDI1r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 03:27:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, davidel@xmailserver.org, gerg@uclinux.org, zippel@linux-m68k.org


The patch titled
     m68k{,nommu}: Wire up new timerfd syscalls
has been added to the -mm tree.  Its filename is
     m68knommu-wire-up-new-timerfd-syscalls.patch

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
Subject: m68k{,nommu}: Wire up new timerfd syscalls
From: Geert Uytterhoeven <geert@linux-m68k.org>

m68k{,nommu}: Wire up the new timerfd syscalls, which were introduced in
commit 4d672e7ac79b5ec5cdc90e450823441e20464691 ("timerfd: new timerfd API").

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/kernel/entry.S             |    4 +++-
 arch/m68knommu/kernel/syscalltable.S |    4 +++-
 include/asm-m68k/unistd.h            |    6 ++++--
 include/asm-m68knommu/unistd.h       |    6 ++++--
 4 files changed, 14 insertions(+), 6 deletions(-)

diff -puN arch/m68k/kernel/entry.S~m68knommu-wire-up-new-timerfd-syscalls arch/m68k/kernel/entry.S
--- a/arch/m68k/kernel/entry.S~m68knommu-wire-up-new-timerfd-syscalls
+++ a/arch/m68k/kernel/entry.S
@@ -742,7 +742,9 @@ sys_call_table:
 	.long sys_epoll_pwait		/* 315 */
 	.long sys_utimensat
 	.long sys_signalfd
-	.long sys_ni_syscall
+	.long sys_timerfd_create
 	.long sys_eventfd
 	.long sys_fallocate		/* 320 */
+	.long sys_timerfd_settime
+	.long sys_timerfd_gettime
 
diff -puN arch/m68knommu/kernel/syscalltable.S~m68knommu-wire-up-new-timerfd-syscalls arch/m68knommu/kernel/syscalltable.S
--- a/arch/m68knommu/kernel/syscalltable.S~m68knommu-wire-up-new-timerfd-syscalls
+++ a/arch/m68knommu/kernel/syscalltable.S
@@ -336,9 +336,11 @@ ENTRY(sys_call_table)
 	.long sys_epoll_pwait		/* 315 */
 	.long sys_utimensat
 	.long sys_signalfd
-	.long sys_ni_syscall
+	.long sys_timerfd_create
 	.long sys_eventfd
 	.long sys_fallocate		/* 320 */
+	.long sys_timerfd_settime
+	.long sys_timerfd_gettime
 
 	.rept NR_syscalls-(.-sys_call_table)/4
 		.long sys_ni_syscall
diff -puN include/asm-m68knommu/unistd.h~m68knommu-wire-up-new-timerfd-syscalls include/asm-m68knommu/unistd.h
--- a/include/asm-m68knommu/unistd.h~m68knommu-wire-up-new-timerfd-syscalls
+++ a/include/asm-m68knommu/unistd.h
@@ -321,13 +321,15 @@
 #define __NR_epoll_pwait	315
 #define __NR_utimensat		316
 #define __NR_signalfd		317
-#define __NR_timerfd		318
+#define __NR_timerfd_create	318
 #define __NR_eventfd		319
 #define __NR_fallocate		320
+#define __NR_timerfd_settime	321
+#define __NR_timerfd_gettime	322
 
 #ifdef __KERNEL__
 
-#define NR_syscalls		321
+#define NR_syscalls		323
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff -puN include/asm-m68k/unistd.h~m68knommu-wire-up-new-timerfd-syscalls include/asm-m68k/unistd.h
--- a/include/asm-m68k/unistd.h~m68knommu-wire-up-new-timerfd-syscalls
+++ a/include/asm-m68k/unistd.h
@@ -320,13 +320,15 @@
 #define __NR_epoll_pwait	315
 #define __NR_utimensat		316
 #define __NR_signalfd		317
-#define __NR_timerfd		318
+#define __NR_timerfd_create	318
 #define __NR_eventfd		319
 #define __NR_fallocate		320
+#define __NR_timerfd_settime	321
+#define __NR_timerfd_gettime	322
 
 #ifdef __KERNEL__
 
-#define NR_syscalls		321
+#define NR_syscalls		323
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
_

Patches currently in -mm which might be from geert@linux-m68k.org are

m68knommu-wire-up-new-timerfd-syscalls.patch
m68k-replace-remaining-__function__-occurences.patch
fb-add-support-for-foreign-endianness-add-support-for-choice-foreign-endianness.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch

