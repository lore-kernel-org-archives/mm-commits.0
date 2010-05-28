From: akpm@linux-foundation.org
Subject: + m32r-invoke-oom-killer-from-page-fault.patch added to -mm tree
Date: Fri, 28 May 2010 16:19:05 -0700
Message-ID: <201005282319.o4SNJ5no020078@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754097Ab0E1XW5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 May 2010 19:22:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, rientjes@google.com, takata@linux-m32r.org


The patch titled
     m32r: invoke oom-killer from page fault
has been added to the -mm tree.  Its filename is
     m32r-invoke-oom-killer-from-page-fault.patch

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
Subject: m32r: invoke oom-killer from page fault
From: Nick Piggin <npiggin@suse.de>

As explained in commit 1c0fe6e3bd ("mm: invoke oom-killer from page
fault") , we want to call the architecture independent oom killer when
getting an unexplained OOM from handle_mm_fault, rather than simply
killing current.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/mm/fault.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff -puN arch/m32r/mm/fault.c~m32r-invoke-oom-killer-from-page-fault arch/m32r/mm/fault.c
--- a/arch/m32r/mm/fault.c~m32r-invoke-oom-killer-from-page-fault
+++ a/arch/m32r/mm/fault.c
@@ -188,7 +188,6 @@ good_area:
 	if ((error_code & ACE_INSTRUCTION) && !(vma->vm_flags & VM_EXEC))
 	  goto bad_area;
 
-survive:
 	/*
 	 * If for any reason at all we couldn't handle the fault,
 	 * make sure we exit gracefully rather than endlessly redo
@@ -271,15 +270,10 @@ no_context:
  */
 out_of_memory:
 	up_read(&mm->mmap_sem);
-	if (is_global_init(tsk)) {
-		yield();
-		down_read(&mm->mmap_sem);
-		goto survive;
-	}
-	printk("VM: killing process %s\n", tsk->comm);
-	if (error_code & ACE_USERMODE)
-		do_group_exit(SIGKILL);
-	goto no_context;
+	if (!(error_code & ACE_USERMODE))
+		goto no_context;
+	pagefault_out_of_memory();
+	return;
 
 do_sigbus:
 	up_read(&mm->mmap_sem);
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
fb_defio-redo-fix-for-non-dirty-ptes.patch
block-bd_start_claiming-fix-module-refcount.patch
block-bd_start_claiming-cleanup.patch
fs-splicec-fix-mapping_gfp_mask-usage.patch
reiser4.patch
avr32-invoke-oom-killer-from-page-fault.patch
frv-invoke-oom-killer-from-page-fault.patch
m32r-invoke-oom-killer-from-page-fault.patch
mn10300-invoke-oom-killer-from-page-fault.patch
xtensa-invoke-oom-killer-from-page-fault.patch

