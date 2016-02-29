From: akpm@linux-foundation.org
Subject: + procfs-add-conditional-compilation-check.patch added to -mm
 tree
Date: Mon, 29 Feb 2016 15:11:32 -0800
Message-ID: <56d4d024.0M4H5G6y0dLsOtTy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47070 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbcB2XLd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Feb 2016 18:11:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.engestrom@imgtec.com, gorcunov@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: add conditional compilation check
has been added to the -mm tree.  Its filename is
     procfs-add-conditional-compilation-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/procfs-add-conditional-compilation-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/procfs-add-conditional-compilation-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Engestrom <eric.engestrom@imgtec.com>
Subject: procfs: add conditional compilation check

`proc_timers_operations` is only used when CONFIG_CHECKPOINT_RESTORE
is enabled.

Signed-off-by: Eric Engestrom <eric.engestrom@imgtec.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/proc/base.c~procfs-add-conditional-compilation-check fs/proc/base.c
--- a/fs/proc/base.c~procfs-add-conditional-compilation-check
+++ a/fs/proc/base.c
@@ -2158,6 +2158,7 @@ static const struct file_operations proc
 	.llseek		= default_llseek,
 };
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
 struct timers_private {
 	struct pid *pid;
 	struct task_struct *task;
@@ -2256,6 +2257,7 @@ static const struct file_operations proc
 	.llseek		= seq_lseek,
 	.release	= seq_release_private,
 };
+#endif
 
 static ssize_t timerslack_ns_write(struct file *file, const char __user *buf,
 					size_t count, loff_t *offset)
_

Patches currently in -mm which might be from eric.engestrom@imgtec.com are

procfs-add-conditional-compilation-check.patch

