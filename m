From: akpm@linux-foundation.org
Subject: + uml-use-__spin_lock_unlocked.patch added to -mm tree
Date: Tue, 06 May 2008 13:49:29 -0700
Message-ID: <200805062049.m46KnTT3026585@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38030 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762935AbYEFUuD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 16:50:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com, rpjday@crashcourse.ca, xiyou.wangcong@gmail.com


The patch titled
     uml: use __SPIN_LOCK_UNLOCKED
has been added to the -mm tree.  Its filename is
     uml-use-__spin_lock_unlocked.patch

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
Subject: uml: use __SPIN_LOCK_UNLOCKED
From: Jeff Dike <jdike@addtoit.com>


Use newer, non-deprecated __SPIN_LOCK_UNLOCKED macro.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/line.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/um/include/line.h~uml-use-__spin_lock_unlocked arch/um/include/line.h
--- a/arch/um/include/line.h~uml-use-__spin_lock_unlocked
+++ a/arch/um/include/line.h
@@ -58,11 +58,11 @@ struct line {
 };
 
 #define LINE_INIT(str, d) \
-	{ .count_lock =	SPIN_LOCK_UNLOCKED, \
+	{ .count_lock =	__SPIN_LOCK_UNLOCKED((str).count_lock), \
 	  .init_str =	str,	\
 	  .init_pri =	INIT_STATIC, \
 	  .valid =	1, \
-	  .lock =	SPIN_LOCK_UNLOCKED, \
+	  .lock =	__SPIN_LOCK_UNLOCKED((str).lock), \
 	  .driver =	d }
 
 extern void line_close(struct tty_struct *tty, struct file * filp);
_

Patches currently in -mm which might be from jdike@addtoit.com are

linux-next.patch
uml-fix-inconsistence-due-to-tty_operation-change.patch
uml-redo-host-capability-detection-and-disabling.patch
uml-tidy-stub-management-code.patch
uml-style-fixes.patch
uml-random-driver-fixes.patch
uml-random-driver-style-fixes.patch
uml-hppfs-fixes.patch
uml-move-hppfs_kernc-to-hppfsc.patch
uml-tidy-ptrace-interface.patch
uml-fix-errno-return.patch
uml-track-and-make-up-lost-ticks.patch
uml-fix-build-when-slob-is-enabled.patch
uml-remove-unused-header.patch
uml-fix-bad-ntp-interaction-with-clock.patch
uml-use-__spin_lock_unlocked.patch
uml-physical-memory-shouldnt-include-initial-stack.patch
arch-um-kernel-irqc-clean-up-some-functions.patch
arch-um-kernel-memc-remove-arch_validate.patch
uml-make-several-more-things-static.patch

