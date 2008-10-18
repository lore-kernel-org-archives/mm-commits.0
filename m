From: akpm@linux-foundation.org
Subject: - sysrq-add-enable_mask-in-sysrq_moom_op.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:11:46 -0700
Message-ID: <200810182311.m9INBk9S027793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751261AbYJRXMU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:12:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nooiwa@miraclelinux.com, mm-commits@vger.kernel.org


The patch titled
     sysrq: add enable_mask in sysrq_moom_op
has been removed from the -mm tree.  Its filename was
     sysrq-add-enable_mask-in-sysrq_moom_op.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysrq: add enable_mask in sysrq_moom_op
From: Naohiro Ooiwa <nooiwa@miraclelinux.com>

It is written in the Documentation/sysrq.txt that oom-killer is enabled
when we set "64" in /proc/sys/kernel/sysrq:

<Documentation/sysrq.txt>

    Here is the list of possible values in /proc/sys/kernel/sysrq:
         64 - enable signalling of processes (term, kill, oom-kill)
                                                          ^^^^^^^^

but enable_mask is not set in sysrq_moom_op.

Signed-off-by: Naohiro Ooiwa <nooiwa@miraclelinux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/sysrq.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/char/sysrq.c~sysrq-add-enable_mask-in-sysrq_moom_op drivers/char/sysrq.c
--- a/drivers/char/sysrq.c~sysrq-add-enable_mask-in-sysrq_moom_op
+++ a/drivers/char/sysrq.c
@@ -326,6 +326,7 @@ static struct sysrq_key_op sysrq_moom_op
 	.handler	= sysrq_handle_moom,
 	.help_msg	= "Full",
 	.action_msg	= "Manual OOM execution",
+	.enable_mask	= SYSRQ_ENABLE_SIGNAL,
 };
 
 static void sysrq_handle_kill(int key, struct tty_struct *tty)
_

Patches currently in -mm which might be from nooiwa@miraclelinux.com are

origin.patch

