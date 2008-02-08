From: akpm@linux-foundation.org
Subject: + fix-xtensa-timerfd-breakage.patch added to -mm tree
Date: Fri, 08 Feb 2008 12:56:50 -0800
Message-ID: <200802082056.m18KuowR012893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50257 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755049AbYBHVBF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:01:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, chris@zankel.net


The patch titled
     fix xtensa timerfd breakage
has been added to the -mm tree.  Its filename is
     fix-xtensa-timerfd-breakage.patch

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
Subject: fix xtensa timerfd breakage
From: Adrian Bunk <bunk@kernel.org>

In file included from /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/xtensa/kernel/syscall.c:39:
include2/asm/unistd.h:681: error: 'sys_timerfd' undeclared here (not in a function)

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Christian Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-xtensa/unistd.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/asm-xtensa/unistd.h~fix-xtensa-timerfd-breakage include/asm-xtensa/unistd.h
--- a/include/asm-xtensa/unistd.h~fix-xtensa-timerfd-breakage
+++ a/include/asm-xtensa/unistd.h
@@ -677,8 +677,8 @@ __SYSCALL(303, sys_ni_syscall, 0)
 
 #define __NR_signalfd				304
 __SYSCALL(304, sys_signalfd, 3)
-#define __NR_timerfd				305
-__SYSCALL(305, sys_timerfd, 4)
+/*  305 was __NR_timerfd  */
+__SYSCALL(305, sys_ni_syscall, 0)
 #define __NR_eventfd				306
 __SYSCALL(306, sys_eventfd, 1)
 
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
fix-frv-cmpxchg_local.patch
fix-xtensa-timerfd-breakage.patch
powerpc-vdso_do_func_patch3264-must-be-__init.patch
powerpc-free_property-mustnt-be-__init.patch
hvc_rtas_init-must-be-__init.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ocfs2.patch
if-0-pci_cleanup_aer_correct_error_status.patch
scsi-aic94xx-cleanups.patch
scsi-qlogicptic-section-fixes.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
make-b43_mac_enablesuspend-static.patch
git-xtensa.patch
reiser4.patch
