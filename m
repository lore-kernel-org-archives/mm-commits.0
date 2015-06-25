From: akpm@linux-foundation.org
Subject: [folded-merged]
 proc-fix-page_size-limit-of-proc-pid-cmdline-fix.patch removed from -mm
 tree
Date: Thu, 25 Jun 2015 14:51:00 -0700
Message-ID: <558c77c4.GTNuizND7UXN43H2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40675 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbbFYVvC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Jun 2015 17:51:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adobriyan@gmail.com, jarod@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc-fix-page_size-limit-of-proc-pid-cmdline-fix
has been removed from the -mm tree.  Its filename was
     proc-fix-page_size-limit-of-proc-pid-cmdline-fix.patch

This patch was dropped because it was folded into proc-fix-page_size-limit-of-proc-pid-cmdline.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: proc-fix-page_size-limit-of-proc-pid-cmdline-fix

fix a billion min() warnings

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jarod Wilson <jarod@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/proc/base.c~proc-fix-page_size-limit-of-proc-pid-cmdline-fix fs/proc/base.c
--- a/fs/proc/base.c~proc-fix-page_size-limit-of-proc-pid-cmdline-fix
+++ a/fs/proc/base.c
@@ -197,11 +197,12 @@ static int proc_root_link(struct dentry
 }
 
 static ssize_t proc_pid_cmdline_read(struct file *file, char __user *buf,
-				     size_t count, loff_t *pos)
+				     size_t _count, loff_t *pos)
 {
 	struct task_struct *tsk;
 	struct mm_struct *mm;
 	char *page;
+	unsigned long count = _count;
 	unsigned long arg_start, arg_end, env_start, env_end;
 	unsigned long len1, len2, len;
 	unsigned long p;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
s390-mm-change-hpage_shift-type-to-int.patch
zswap-runtime-enable-disable.patch
prctl-more-prctlpr_set_mm_-checks.patch
proc-fix-page_size-limit-of-proc-pid-cmdline.patch
maintainers-davidlohr-has-moved.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
radix-tree-replace-preallocated-node-array-with-linked-list-fix.patch
checkpatch-emit-an-error-when-theres-a-diff-in-a-changelog.patch
init-do_mounts-add-create_dev-failure-log-fix.patch

