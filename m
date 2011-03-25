From: akpm@linux-foundation.org
Subject: [merged] proc-hide-kernel-addresses-via-%pk-in-proc-pid-stack.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:25:35 -0700
Message-ID: <201103250725.p2P7PT7K026028@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933869Ab1CYHZs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:25:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, adobriyan@gmail.com, kees.cook@canonical.com, mm-commits@vger.kernel.org


The patch titled
     proc: hide kernel addresses via %pK in /proc/<pid>/stack
has been removed from the -mm tree.  Its filename was
     proc-hide-kernel-addresses-via-%pk-in-proc-pid-stack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: hide kernel addresses via %pK in /proc/<pid>/stack
From: Konstantin Khlebnikov <khlebnikov@openvz.org>

This file is readable for the task owner.  Hide kernel addresses from
unprivileged users, leave them function names and offsets.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Acked-by: Kees Cook <kees.cook@canonical.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/base.c~proc-hide-kernel-addresses-via-%pk-in-proc-pid-stack fs/proc/base.c
--- a/fs/proc/base.c~proc-hide-kernel-addresses-via-%pk-in-proc-pid-stack
+++ a/fs/proc/base.c
@@ -340,7 +340,7 @@ static int proc_pid_stack(struct seq_fil
 	save_stack_trace_tsk(task, &trace);
 
 	for (i = 0; i < trace.nr_entries; i++) {
-		seq_printf(m, "[<%p>] %pS\n",
+		seq_printf(m, "[<%pK>] %pS\n",
 			   (void *)entries[i], (void *)entries[i]);
 	}
 	kfree(entries);
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch

