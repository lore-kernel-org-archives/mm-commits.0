From: akpm@linux-foundation.org
Subject: + proc-hide-kernel-addresses-via-%pk-in-proc-pid-stack.patch added to -mm tree
Date: Wed, 23 Feb 2011 16:36:44 -0800
Message-ID: <201102240036.p1O0aid2001548@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36891 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751834Ab1BXAhT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Feb 2011 19:37:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, adobriyan@gmail.com, kees.cook@canonical.com


The patch titled
     proc: hide kernel addresses via %pK in /proc/<pid>/stack
has been added to the -mm tree.  Its filename is
     proc-hide-kernel-addresses-via-%pk-in-proc-pid-stack.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

proc-hide-kernel-addresses-via-%pk-in-proc-pid-stack.patch

