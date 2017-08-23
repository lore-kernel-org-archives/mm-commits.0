From: akpm@linux-foundation.org
Subject: + kcov-support-compat-processes.patch added to -mm tree
Date: Wed, 23 Aug 2017 15:15:03 -0700
Message-ID: <599dfe67.6JTZeXo31q0cauEq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45588 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750715AbdHWWPE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Aug 2017 18:15:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, syzkaller@googlegroups.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: support compat processes
has been added to the -mm tree.  Its filename is
     kcov-support-compat-processes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kcov-support-compat-processes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kcov-support-compat-processes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dmitry Vyukov <dvyukov@google.com>
Subject: kcov: support compat processes

Support compat processes in KCOV by providing compat_ioctl callback. 
Compat mode uses the same ioctl callback: we have 2 commands that do not
use the argument and 1 that already checks that the arg does not overflow
INT_MAX.  This allows to use KCOV-guided fuzzing in compat processes.

Link: http://lkml.kernel.org/r/20170823100553.55812-1-dvyukov@google.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Cc: <syzkaller@googlegroups.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/kcov.c~kcov-support-compat-processes kernel/kcov.c
--- a/kernel/kcov.c~kcov-support-compat-processes
+++ a/kernel/kcov.c
@@ -270,6 +270,7 @@ static long kcov_ioctl(struct file *file
 static const struct file_operations kcov_fops = {
 	.open		= kcov_open,
 	.unlocked_ioctl	= kcov_ioctl,
+	.compat_ioctl	= kcov_ioctl,
 	.mmap		= kcov_mmap,
 	.release        = kcov_close,
 };
_

Patches currently in -mm which might be from dvyukov@google.com are

kcov-support-compat-processes.patch

