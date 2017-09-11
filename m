From: akpm@linux-foundation.org
Subject: [merged] kcov-support-compat-processes.patch removed from
 -mm tree
Date: Mon, 11 Sep 2017 12:44:07 -0700
Message-ID: <20170911194407.RU_jEdWes%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50860 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750782AbdIKToI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:44:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, mm-commits@vger.kernel.org, syzkaller@googlegroups.com


The patch titled
     Subject: kcov: support compat processes
has been removed from the -mm tree.  Its filename was
     kcov-support-compat-processes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


