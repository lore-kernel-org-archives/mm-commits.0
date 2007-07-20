From: akpm@linux-foundation.org
Subject: + kthread-silence-bogus-section-mismatch-warning.patch added to -mm tree
Date: Thu, 19 Jul 2007 18:08:27 -0700
Message-ID: <200707200108.l6K18R1Z032369@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53136 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756201AbXGTBIx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 21:08:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ssatyam@cse.iitk.ac.in, randy.dunlap@oracle.com


The patch titled
     kthread: silence bogus section mismatch warning
has been added to the -mm tree.  Its filename is
     kthread-silence-bogus-section-mismatch-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kthread: silence bogus section mismatch warning
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>

WARNING: kernel/built-in.o(.text+0x16910): Section mismatch:
reference to .init.text: (between 'kthreadd' and 'init_waitqueue_head')

comes because kernel/kthread.c:kthreadd() is not __init but calls
kthreadd_setup() which is __init. But this is ok, because kthreadd_setup()
is only ever called at init time, and then kthreadd() proceeds into its
"for (;;)" loop. We could mark kthreadd __init_refok, but kthreadd_setup()
with just one callsite and 4 lines in it (it's been that small since
10ab825bdef8df51) doesn't need to be a separate function at all -- so let's
just move those four lines at beginning of kthreadd() itself.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff -puN kernel/kthread.c~kthread-silence-bogus-section-mismatch-warning kernel/kthread.c
--- a/kernel/kthread.c~kthread-silence-bogus-section-mismatch-warning
+++ a/kernel/kthread.c
@@ -214,23 +214,15 @@ int kthread_stop(struct task_struct *k)
 }
 EXPORT_SYMBOL(kthread_stop);
 
-
-static noinline __init_refok void kthreadd_setup(void)
+int kthreadd(void *unused)
 {
 	struct task_struct *tsk = current;
 
+	/* Setup a clean context for our children to inherit. */
 	set_task_comm(tsk, "kthreadd");
-
 	ignore_signals(tsk);
-
 	set_user_nice(tsk, -5);
 	set_cpus_allowed(tsk, CPU_MASK_ALL);
-}
-
-int kthreadd(void *unused)
-{
-	/* Setup a clean context for our children to inherit. */
-	kthreadd_setup();
 
 	current->flags |= PF_NOFREEZE;
 
_

Patches currently in -mm which might be from ssatyam@cse.iitk.ac.in are

origin.patch
kthread-silence-bogus-section-mismatch-warning.patch
