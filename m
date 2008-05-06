From: akpm@linux-foundation.org
Subject: + uml-fix-errno-return.patch added to -mm tree
Date: Tue, 06 May 2008 13:49:19 -0700
Message-ID: <200805062049.m46KnJo2026568@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764700AbYEFUte (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 16:49:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com, johfel@users.sourceforge.net, xiyou.wangcong@gmail.com


The patch titled
     uml: fix errno return
has been added to the -mm tree.  Its filename is
     uml-fix-errno-return.patch

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
Subject: uml: fix errno return
From: Jeff Dike <jdike@addtoit.com>


Error returns are negative.

Signed-off-by: Johann Felix Soden <johfel@users.sourceforge.net>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/hostaudio_kern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/drivers/hostaudio_kern.c~uml-fix-errno-return arch/um/drivers/hostaudio_kern.c
--- a/arch/um/drivers/hostaudio_kern.c~uml-fix-errno-return
+++ a/arch/um/drivers/hostaudio_kern.c
@@ -154,7 +154,7 @@ static int hostaudio_ioctl(struct inode 
 	case SNDCTL_DSP_SUBDIVIDE:
 	case SNDCTL_DSP_SETFRAGMENT:
 		if (get_user(data, (int __user *) arg))
-			return EFAULT;
+			return -EFAULT;
 		break;
 	default:
 		break;
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

