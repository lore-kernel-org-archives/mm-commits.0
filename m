From: akpm@linux-foundation.org
Subject: +
 fs-signalfdc-fix-inconsistent-return-codes-for-signalfd4.patch added to -mm
 tree
Date: Wed, 17 Jun 2020 18:54:48 -0700
Message-ID: <20200618015448.T6xrL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733127AbgFRByt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 21:54:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, laurent@vivier.eu, deller@gmx.de


The patch titled
     Subject: fs/signalfd.c: fix inconsistent return codes for signalfd4
has been added to the -mm tree.  Its filename is
     fs-signalfdc-fix-inconsistent-return-codes-for-signalfd4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-signalfdc-fix-inconsistent-return-codes-for-signalfd4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-signalfdc-fix-inconsistent-return-codes-for-signalfd4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Helge Deller <deller@gmx.de>
Subject: fs/signalfd.c: fix inconsistent return codes for signalfd4

The kernel signalfd4() syscall returns different error codes when called
either in compat or native mode.  This behaviour makes correct emulation
in qemu and testing programs like LTP more complicated.

Fix the code to always return -in both modes- EFAULT for unaccessible user
memory, and EINVAL when called with an invalid signal mask.

Link: http://lkml.kernel.org/r/20200530100707.GA10159@ls3530.fritz.box
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Laurent Vivier <laurent@vivier.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/signalfd.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/fs/signalfd.c~fs-signalfdc-fix-inconsistent-return-codes-for-signalfd4
+++ a/fs/signalfd.c
@@ -314,9 +314,10 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sig
 {
 	sigset_t mask;
 
-	if (sizemask != sizeof(sigset_t) ||
-	    copy_from_user(&mask, user_mask, sizeof(mask)))
+	if (sizemask != sizeof(sigset_t))
 		return -EINVAL;
+	if (copy_from_user(&mask, user_mask, sizeof(mask)))
+		return -EFAULT;
 	return do_signalfd4(ufd, &mask, flags);
 }
 
@@ -325,9 +326,10 @@ SYSCALL_DEFINE3(signalfd, int, ufd, sigs
 {
 	sigset_t mask;
 
-	if (sizemask != sizeof(sigset_t) ||
-	    copy_from_user(&mask, user_mask, sizeof(mask)))
+	if (sizemask != sizeof(sigset_t))
 		return -EINVAL;
+	if (copy_from_user(&mask, user_mask, sizeof(mask)))
+		return -EFAULT;
 	return do_signalfd4(ufd, &mask, 0);
 }
 
_

Patches currently in -mm which might be from deller@gmx.de are

fs-signalfdc-fix-inconsistent-return-codes-for-signalfd4.patch
