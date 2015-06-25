From: akpm@linux-foundation.org
Subject: [folded-merged]
 proc-fix-page_size-limit-of-proc-pid-cmdline-update.patch removed from -mm
 tree
Date: Thu, 25 Jun 2015 14:51:03 -0700
Message-ID: <558c77c7.xIIxSAfhWFhUPSRm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40679 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbbFYVvE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Jun 2015 17:51:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, gorcunov@openvz.org, jarod@redhat.com, jstancek@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc-fix-page_size-limit-of-proc-pid-cmdline-update
has been removed from the -mm tree.  Its filename was
     proc-fix-page_size-limit-of-proc-pid-cmdline-update.patch

This patch was dropped because it was folded into proc-fix-page_size-limit-of-proc-pid-cmdline.patch

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc-fix-page_size-limit-of-proc-pid-cmdline-update

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Tested-by: Jarod Wilson <jarod@redhat.com>
Acked-by: Jarod Wilson <jarod@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/proc/base.c~proc-fix-page_size-limit-of-proc-pid-cmdline-update fs/proc/base.c
--- a/fs/proc/base.c~proc-fix-page_size-limit-of-proc-pid-cmdline-update
+++ a/fs/proc/base.c
@@ -218,7 +218,8 @@ static ssize_t proc_pid_cmdline_read(str
 	put_task_struct(tsk);
 	if (!mm)
 		return 0;
-	if (!mm->arg_end) {
+	/* Check if process spawned far enough to have cmdline. */
+	if (!mm->env_end) {
 		rv = 0;
 		goto out_mmput;
 	}
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
prctl-more-prctlpr_set_mm_-checks.patch
proc-fix-page_size-limit-of-proc-pid-cmdline.patch

