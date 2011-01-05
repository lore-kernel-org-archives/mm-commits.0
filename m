From: akpm@linux-foundation.org
Subject: + proc-less-lock-unlock-in-remove_proc_entry.patch added to -mm tree
Date: Tue, 04 Jan 2011 16:45:57 -0800
Message-ID: <201101050045.p050jvgD001146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750892Ab1AEAq3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2011 19:46:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     proc: less LOCK/UNLOCK in remove_proc_entry()
has been added to the -mm tree.  Its filename is
     proc-less-lock-unlock-in-remove_proc_entry.patch

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
Subject: proc: less LOCK/UNLOCK in remove_proc_entry()
From: Alexey Dobriyan <adobriyan@gmail.com>

For the common case where a proc entry is being removed and nobody is in
the process of using it, save a LOCK/UNLOCK pair.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN fs/proc/generic.c~proc-less-lock-unlock-in-remove_proc_entry fs/proc/generic.c
--- a/fs/proc/generic.c~proc-less-lock-unlock-in-remove_proc_entry
+++ a/fs/proc/generic.c
@@ -826,12 +826,9 @@ void remove_proc_entry(const char *name,
 
 		wait_for_completion(de->pde_unload_completion);
 
-		goto continue_removing;
+		spin_lock(&de->pde_unload_lock);
 	}
-	spin_unlock(&de->pde_unload_lock);
 
-continue_removing:
-	spin_lock(&de->pde_unload_lock);
 	while (!list_empty(&de->pde_openers)) {
 		struct pde_opener *pdeo;
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
proc-use-unsigned-long-inside-proc-statm.patch
proc-use-seq_puts-seq_putc-where-possible.patch
proc-low_ino-cleanup.patch
proc-use-single_open-correctly.patch
proc-less-lock-unlock-in-remove_proc_entry.patch

