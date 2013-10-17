From: akpm@linux-foundation.org
Subject: [merged]
 kernel-kmodc-check-for-null-in-call_usermodehelper_exec.patch removed from
 -mm tree
Date: Thu, 17 Oct 2013 11:12:19 -0700
Message-ID: <52602883.CVUhmy6toEphxESS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44194 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758270Ab3JQSMU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Oct 2013 14:12:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp

Subject: [merged] kernel-kmodc-check-for-null-in-call_usermodehelper_exec.patch removed from -mm tree
To: penguin-kernel@I-love.SAKURA.ne.jp,oleg@redhat.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 17 Oct 2013 11:12:19 -0700


The patch titled
     Subject: kernel/kmod.c: check for NULL in call_usermodehelper_exec()
has been removed from the -mm tree.  Its filename was
     kernel-kmodc-check-for-null-in-call_usermodehelper_exec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: kernel/kmod.c: check for NULL in call_usermodehelper_exec()

If /proc/sys/kernel/core_pattern contains only "|", NULL pointer
dereference happens upon core dump because argv_split("") returns argv[0]
== NULL.

This bug was once fixed by commit 264b83c0 ("usermodehelper: check
subprocess_info->path != NULL") but was by error reintroduced by commit
7f57cfa4 ("usermodehelper: kill the sub_info->path[0] check").

This bug seems to exist since 2.6.19 (the version which core dump to pipe
was added).  Depending on kernel version and config, some side effect
might happen immediately after this oops (e.g.  kernel panic with
2.6.32-358.18.1.el6).

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/kmod.c~kernel-kmodc-check-for-null-in-call_usermodehelper_exec kernel/kmod.c
--- a/kernel/kmod.c~kernel-kmodc-check-for-null-in-call_usermodehelper_exec
+++ a/kernel/kmod.c
@@ -571,6 +571,10 @@ int call_usermodehelper_exec(struct subp
 	DECLARE_COMPLETION_ONSTACK(done);
 	int retval = 0;
 
+	if (!sub_info->path) {
+		call_usermodehelper_freeinfo(sub_info);
+		return -EINVAL;
+	}
 	helper_lock();
 	if (!khelper_wq || usermodehelper_disabled) {
 		retval = -EBUSY;
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

kthread-make-kthread_create-killable.patch
seq_file-introduce-seq_setwidth-and-seq_pad.patch
seq_file-remove-%n-usage-from-seq_file-users.patch
vsprintf-ignore-%n-again.patch

