From: akpm@linux-foundation.org
Subject: - i386-during-vm-oom-condition.patch removed from -mm tree
Date: Mon, 23 Jul 2007 14:12:28 -0700
Message-ID: <200707232112.l6NLCSFW012018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39492 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760988AbXGWVMi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 17:12:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: will_schmidt@vnet.ibm.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     i386: During VM oom condition, kill all threads in process group
has been removed from the -mm tree.  Its filename was
     i386-during-vm-oom-condition.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: i386: During VM oom condition, kill all threads in process group
From: Will Schmidt <will_schmidt@vnet.ibm.com>

During a VM oom condition, kill all threads in the process group.

We have had complaints where a threaded application is left in a bad state
after one of it's threads is killed when we hit a VM: out_of_memory condition.

Killing just one of the process threads can leave the application in a bad
state, whereas killing the entire process group would allow for the
application to restart, or otherwise handled, and makes it very obvious that
something has gone wrong.

This change allows the entire process group to be taken down, rather than just
the one thread.

tested lightly on i386.

Signed-off-by: Will Schmidt <will_schmidt@vnet.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mm/fault.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/mm/fault.c~i386-during-vm-oom-condition arch/i386/mm/fault.c
--- a/arch/i386/mm/fault.c~i386-during-vm-oom-condition
+++ a/arch/i386/mm/fault.c
@@ -587,7 +587,7 @@ out_of_memory:
 	}
 	printk("VM: killing process %s\n", tsk->comm);
 	if (error_code & 4)
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	goto no_context;
 
 do_sigbus:
_

Patches currently in -mm which might be from will_schmidt@vnet.ibm.com are

i386-during-vm-oom-condition.patch
