From: akpm@linux-foundation.org
Subject: - m68knommu-wire-up-new-system-calls.patch removed from -mm tree
Date: Tue, 12 Aug 2008 13:32:42 -0700
Message-ID: <200808122032.m7CKWgha011731@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44384 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751189AbYHLUdZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 16:33:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     m68k{,nommu}: wire up new system calls
has been removed from the -mm tree.  Its filename was
     m68knommu-wire-up-new-system-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68k{,nommu}: wire up new system calls
From: Geert Uytterhoeven <geert@linux-m68k.org>

Wire up for m68k{,nommu} the system calls that were added in the last
merge window:

commit 4006553b06306b34054529477b06b68a1c66249b (flag parameters: inotify_init)
commit ed8cae8ba01348bfd83333f4648dd807b04d7f08 (flag parameters: pipe)
commit 336dd1f70ff62d7dd8655228caed4c5bfc818c56 (flag parameters: dup2)
commit a0998b50c3f0b8fdd265c63e0032f86ebe377dbf (flag parameters: epoll_create)
commit 9fe5ad9c8cef9ad5873d8ee55d1cf00d9b607df0 (flag parameters add-on: remove
						 epoll_create size param)
commit b087498eb5605673b0f260a7620d91818cd72304 (flag parameters: eventfd)
commit 9deb27baedb79759c3ab9435a7d8b841842d56e9 (flag parameters: signalfd)

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/kernel/entry.S             |    6 ++++++
 arch/m68knommu/include/asm/unistd.h  |    8 +++++++-
 arch/m68knommu/kernel/syscalltable.S |    6 ++++++
 include/asm-m68k/unistd.h            |    8 +++++++-
 4 files changed, 26 insertions(+), 2 deletions(-)

diff -puN arch/m68k/kernel/entry.S~m68knommu-wire-up-new-system-calls arch/m68k/kernel/entry.S
--- a/arch/m68k/kernel/entry.S~m68knommu-wire-up-new-system-calls
+++ a/arch/m68k/kernel/entry.S
@@ -747,4 +747,10 @@ sys_call_table:
 	.long sys_fallocate		/* 320 */
 	.long sys_timerfd_settime
 	.long sys_timerfd_gettime
+	.long sys_signalfd4
+	.long sys_eventfd2
+	.long sys_epoll_create1		/* 325 */
+	.long sys_dup3
+	.long sys_pipe2
+	.long sys_inotify_init1
 
diff -puN arch/m68knommu/include/asm/unistd.h~m68knommu-wire-up-new-system-calls arch/m68knommu/include/asm/unistd.h
--- a/arch/m68knommu/include/asm/unistd.h~m68knommu-wire-up-new-system-calls
+++ a/arch/m68knommu/include/asm/unistd.h
@@ -326,10 +326,16 @@
 #define __NR_fallocate		320
 #define __NR_timerfd_settime	321
 #define __NR_timerfd_gettime	322
+#define __NR_signalfd4		323
+#define __NR_eventfd2		324
+#define __NR_epoll_create1	325
+#define __NR_dup3		326
+#define __NR_pipe2		327
+#define __NR_inotify_init1	328
 
 #ifdef __KERNEL__
 
-#define NR_syscalls		323
+#define NR_syscalls		329
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff -puN arch/m68knommu/kernel/syscalltable.S~m68knommu-wire-up-new-system-calls arch/m68knommu/kernel/syscalltable.S
--- a/arch/m68knommu/kernel/syscalltable.S~m68knommu-wire-up-new-system-calls
+++ a/arch/m68knommu/kernel/syscalltable.S
@@ -341,6 +341,12 @@ ENTRY(sys_call_table)
 	.long sys_fallocate		/* 320 */
 	.long sys_timerfd_settime
 	.long sys_timerfd_gettime
+	.long sys_signalfd4
+	.long sys_eventfd2
+	.long sys_epoll_create1		/* 325 */
+	.long sys_dup3
+	.long sys_pipe2
+	.long sys_inotify_init1
 
 	.rept NR_syscalls-(.-sys_call_table)/4
 		.long sys_ni_syscall
diff -puN include/asm-m68k/unistd.h~m68knommu-wire-up-new-system-calls include/asm-m68k/unistd.h
--- a/include/asm-m68k/unistd.h~m68knommu-wire-up-new-system-calls
+++ a/include/asm-m68k/unistd.h
@@ -325,10 +325,16 @@
 #define __NR_fallocate		320
 #define __NR_timerfd_settime	321
 #define __NR_timerfd_gettime	322
+#define __NR_signalfd4		323
+#define __NR_eventfd2		324
+#define __NR_epoll_create1	325
+#define __NR_dup3		326
+#define __NR_pipe2		327
+#define __NR_inotify_init1	328
 
 #ifdef __KERNEL__
 
-#define NR_syscalls		323
+#define NR_syscalls		329
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
fs-eventpollc-fix-sys_epoll_create1-comment.patch
linux-next.patch
arch-m68k-bvme6000-rtcc-remove-duplicated-include.patch
viafb-viafbmodes-viafbtxt.patch
viafb-makefile-kconfig.patch
viafb-accelc-accelh.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-chiph-debugh.patch
viafb-dvic-dvih-globalc-and-globalh.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-ifacec-ifaceh-ioctlc-ioctlh.patch
viafb-lcdc-lcdh-lcdtblh.patch
viafb-makefile-shareh.patch
viafb-tbl1636c-tbl1636h-tbldpasettingc-tbldpasettingh.patch
viafb-viafbdevc-viafbdevh.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
viafb-via_i2cc-via_i2ch-viamodec-viamodeh.patch
viafb-via_utilityc-via_utilityh-vt1636c-vt1636h.patch
fbdev-kconfig-update.patch
fbdev-kconfig-update-fix.patch

