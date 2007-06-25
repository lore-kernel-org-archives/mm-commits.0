From: akpm@linux-foundation.org
Subject: + i386-during-vm-oom-condition.patch added to -mm tree
Date: Mon, 25 Jun 2007 11:22:29 -0700
Message-ID: <200706251822.l5PIMTBU007756@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34024 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752566AbXFYSWl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 14:22:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: will_schmidt@vnet.ibm.com, ak@suse.de


The patch titled
     i386: During VM oom condition, kill all threads in process group
has been added to the -mm tree.  Its filename is
     i386-during-vm-oom-condition.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/mm/fault.c~i386-during-vm-oom-condition arch/i386/mm/fault.c
--- a/arch/i386/mm/fault.c~i386-during-vm-oom-condition
+++ a/arch/i386/mm/fault.c
@@ -598,7 +598,7 @@ out_of_memory:
 	}
 	printk("VM: killing process %s\n", tsk->comm);
 	if (error_code & 4)
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	goto no_context;
 
 do_sigbus:
_

Patches currently in -mm which might be from will_schmidt@vnet.ibm.com are

git-powerpc.patch
x86_64-during-vm-oom-condition.patch
i386-during-vm-oom-condition.patch
