From: akpm@linux-foundation.org
Subject: - uml-fix-errno-return.patch removed from -mm tree
Date: Tue, 13 May 2008 14:32:31 -0700
Message-ID: <200805132132.m4DLWV6a000695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760646AbYEMVcv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:32:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, johfel@users.sourceforge.net, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix errno return
has been removed from the -mm tree.  Its filename was
     uml-fix-errno-return.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
asm-alphah8300umv850xtensa-paramh-unbreak-hz-for-userspace.patch
arch-um-kernel-irqc-clean-up-some-functions.patch
arch-um-kernel-memc-remove-arch_validate.patch
uml-make-several-more-things-static.patch

