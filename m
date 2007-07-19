From: akpm@linux-foundation.org
Subject: - x86_64-during-vm-oom-condition.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:10:08 -0700
Message-ID: <200707192010.l6JKA8r1020644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45786 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759768AbXGSUPV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: will_schmidt@vnet.ibm.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86_64: During VM oom condition, kill all threads in process group
has been removed from the -mm tree.  Its filename was
     x86_64-during-vm-oom-condition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: During VM oom condition, kill all threads in process group
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

Signed-off-by: Will <will_schmidt@vnet.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/fault.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86_64/mm/fault.c~x86_64-during-vm-oom-condition arch/x86_64/mm/fault.c
--- a/arch/x86_64/mm/fault.c~x86_64-during-vm-oom-condition
+++ a/arch/x86_64/mm/fault.c
@@ -568,7 +568,7 @@ out_of_memory:
 	}
 	printk("VM: killing process %s\n", tsk->comm);
 	if (error_code & 4)
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	goto no_context;
 
 do_sigbus:
_

Patches currently in -mm which might be from will_schmidt@vnet.ibm.com are

origin.patch
i386-during-vm-oom-condition.patch
