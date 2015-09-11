From: akpm@linux-foundation.org
Subject: [merged]
 kmod-remove-unecessary-explicit-wide-cpu-affinity-setting.patch removed
 from -mm tree
Date: Fri, 11 Sep 2015 11:12:47 -0700
Message-ID: <55f3199f./JZt4kf5WzpqhcGd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbbIKSMs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:12:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fweisbec@gmail.com, cl@linux.com, oleg@redhat.com, riel@redhat.com, rusty@rustcorp.com.au, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kmod: remove unecessary explicit wide CPU affinity setting
has been removed from the -mm tree.  Its filename was
     kmod-remove-unecessary-explicit-wide-cpu-affinity-setting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: kmod: remove unecessary explicit wide CPU affinity setting

Khelper is affine to all CPUs.  Now since it creates the
call_usermodehelper_exec_[a]sync() kernel threads, those inherit the wide
affinity.

As such explicitly forcing a wide affinity from those kernel threads
is like a no-op.

Just remove it. It's needless and it breaks CPU isolation users who
rely on workqueue affinity tuning.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN kernel/kmod.c~kmod-remove-unecessary-explicit-wide-cpu-affinity-setting kernel/kmod.c
--- a/kernel/kmod.c~kmod-remove-unecessary-explicit-wide-cpu-affinity-setting
+++ a/kernel/kmod.c
@@ -224,9 +224,6 @@ static int call_usermodehelper_exec_asyn
 	flush_signal_handlers(current, 1);
 	spin_unlock_irq(&current->sighand->siglock);
 
-	/* We can run anywhere, unlike our parent keventd(). */
-	set_cpus_allowed_ptr(current, cpu_all_mask);
