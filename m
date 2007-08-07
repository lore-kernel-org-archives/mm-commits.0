From: akpm@linux-foundation.org
Subject: + tweak-proc-ipmi-removal.patch added to -mm tree
Date: Tue, 07 Aug 2007 12:29:02 -0700
Message-ID: <200708071929.l77JT3FJ000301@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43375 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752451AbXHGT3t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 15:29:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, minyard@acm.org


The patch titled
     Tweak /proc/ipmi removal
has been added to the -mm tree.  Its filename is
     tweak-proc-ipmi-removal.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Tweak /proc/ipmi removal
From: Alexey Dobriyan <adobriyan@sw.ru>

Driver does
	proc_mkdir("ipmi", NULL);
but
	remove_proc_entry(proc_ipmi_root->name, &proc_root);

This is OK and working if only slightly inconsistent.  Also changing
proc_root to NULL will help OpenVZ which has multiple proc roots and, as we
now know, requires matching parents in such cases.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_msghandler.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/ipmi/ipmi_msghandler.c~tweak-proc-ipmi-removal drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~tweak-proc-ipmi-removal
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -4136,7 +4136,7 @@ static __exit void cleanup_ipmi(void)
 	del_timer_sync(&ipmi_timer);
 
 #ifdef CONFIG_PROC_FS
-	remove_proc_entry(proc_ipmi_root->name, &proc_root);
+	remove_proc_entry(proc_ipmi_root->name, NULL);
 #endif /* CONFIG_PROC_FS */
 
 	driver_unregister(&ipmidriver);
_

Patches currently in -mm which might be from adobriyan@sw.ru are

consolidate-ptrace_detach.patch
use-list_head-in-binfmt-handling-update.patch
make-unregister_binfmt-return-void.patch
slab_panic-more-proc-posix-timers-shmem.patch
add-kernel-notifierc.patch
add-kernel-notifierc-fix.patch
add-kernel-notifierc-fix-2.patch
tweak-proc-ipmi-removal.patch
single_open-seq_release-leak-diagnostics.patch
