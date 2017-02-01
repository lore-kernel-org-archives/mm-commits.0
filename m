From: akpm@linux-foundation.org
Subject: + prctl-implement-pr_get_endian-for-all-architectures.patch added to -mm tree
Date: Tue, 31 Jan 2017 16:27:05 -0800
Message-ID: <58912b59.Ays0cJdiclRf+fon%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38302 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750830AbdBAA1G (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2017 19:27:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deller@gmx.de, mtk.manpages@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: prctl: implement PR_GET_ENDIAN for all architectures
has been added to the -mm tree.  Its filename is
     prctl-implement-pr_get_endian-for-all-architectures.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/prctl-implement-pr_get_endian-for-all-architectures.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/prctl-implement-pr_get_endian-for-all-architectures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Helge Deller <deller@gmx.de>
Subject: prctl: implement PR_GET_ENDIAN for all architectures

The prctl(PR_GET_ENDIAN) syscall was added to Kernel 2.6.18, but
implemented for PowerPC only.  This trivial patch adds support for this
syscall for all other architectures.

Link: http://lkml.kernel.org/r/20170128111310.GA13389@ls3530.fritz.box
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN kernel/sys.c~prctl-implement-pr_get_endian-for-all-architectures kernel/sys.c
--- a/kernel/sys.c~prctl-implement-pr_get_endian-for-all-architectures
+++ a/kernel/sys.c
@@ -79,9 +79,6 @@
 #ifndef GET_FPEXC_CTL
 # define GET_FPEXC_CTL(a, b)	(-EINVAL)
 #endif
-#ifndef GET_ENDIAN
-# define GET_ENDIAN(a, b)	(-EINVAL)
-#endif
 #ifndef SET_ENDIAN
 # define SET_ENDIAN(a, b)	(-EINVAL)
 #endif
@@ -2136,7 +2133,13 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 			return -EFAULT;
 		break;
 	case PR_GET_ENDIAN:
+#ifdef GET_ENDIAN
 		error = GET_ENDIAN(me, arg2);
+#elif defined(__BIG_ENDIAN)
+		error = put_user(PR_ENDIAN_BIG, (unsigned int __user *)arg2);
+#else
+		error = put_user(PR_ENDIAN_LITTLE, (unsigned int __user *)arg2);
+#endif
 		break;
 	case PR_SET_ENDIAN:
 		error = SET_ENDIAN(me, arg2);
_

Patches currently in -mm which might be from deller@gmx.de are

prctl-implement-pr_get_endian-for-all-architectures.patch

