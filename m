From: akpm@linux-foundation.org
Subject: - uml-use-__spin_lock_unlocked.patch removed from -mm tree
Date: Tue, 13 May 2008 14:32:39 -0700
Message-ID: <200805132132.m4DLWdCu000727@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35161 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759980AbYEMVcq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:32:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, rpjday@crashcourse.ca, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     uml: use __SPIN_LOCK_UNLOCKED
has been removed from the -mm tree.  Its filename was
     uml-use-__spin_lock_unlocked.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
asm-alphah8300umv850xtensa-paramh-unbreak-hz-for-userspace.patch
arch-um-kernel-irqc-clean-up-some-functions.patch
arch-um-kernel-memc-remove-arch_validate.patch
uml-make-several-more-things-static.patch

