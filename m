From: akpm@linux-foundation.org
Subject: [merged] procfs-add-conditional-compilation-check.patch removed
 from -mm tree
Date: Mon, 21 Mar 2016 11:40:54 -0700
Message-ID: <56f04036.yL1aFUW6XlKdf8HB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53456 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932429AbcCUT4Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.engestrom@imgtec.com, gorcunov@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: add conditional compilation check
has been removed from the -mm tree.  Its filename was
     procfs-add-conditional-compilation-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


