From: akpm@linux-foundation.org
Subject: + fs-execc-acct_arg_size-ptl-is-no-longer-needed-for-add_mm_counter.patch added to -mm tree
Date: Wed, 13 Jul 2011 16:23:26 -0700
Message-ID: <201107132323.p6DNNQav009912@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752530Ab1GMXYQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jul 2011 19:24:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, dave@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, matt.fleming@linux.intel.com


The patch titled
     fs/exec.c:acct_arg_size(): ptl is no longer needed for add_mm_counter()
has been added to the -mm tree.  Its filename is
     fs-execc-acct_arg_size-ptl-is-no-longer-needed-for-add_mm_counter.patch

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
Subject: fs/exec.c:acct_arg_size(): ptl is no longer needed for add_mm_counter()
From: Oleg Nesterov <oleg@redhat.com>

acct_arg_size() takes ->page_table_lock around add_mm_counter() if
!SPLIT_RSS_COUNTING.  This is not needed after 172703b0 ("mm: delete
non-atomic mm counter implementation").

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Matt Fleming <matt.fleming@linux.intel.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN fs/exec.c~fs-execc-acct_arg_size-ptl-is-no-longer-needed-for-add_mm_counter fs/exec.c
--- a/fs/exec.c~fs-execc-acct_arg_size-ptl-is-no-longer-needed-for-add_mm_counter
+++ a/fs/exec.c
@@ -181,14 +181,7 @@ static void acct_arg_size(struct linux_b
 		return;
 
 	bprm->vma_pages = pages;
-
-#ifdef SPLIT_RSS_COUNTING
-	add_mm_counter(mm, MM_ANONPAGES, diff);
-#else
-	spin_lock(&mm->page_table_lock);
 	add_mm_counter(mm, MM_ANONPAGES, diff);
-	spin_unlock(&mm->page_table_lock);
-#endif
 }
 
 static struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
_

Patches currently in -mm which might be from oleg@redhat.com are

xtensa-prevent-arbitrary-read-in-ptrace.patch
xtensa-prevent-arbitrary-read-in-ptrace-fix.patch
linux-next.patch
x86-do_signal-simplify-the-ts_restore_sigmask-logic.patch
ptrace-unify-show_regs-prototype.patch
ptrace-unify-show_regs-prototype-fix.patch
signals-convert-the-ia32_emulation-code-to-use-set_current_blocked.patch
signals-convert-the-x86_32-code-to-use-set_current_blocked.patch
signals-sys_ssetmask-sys_rt_sigsuspend-should-use-set_current_blocked.patch
coredump-use-task-comm-instead-of-unknown.patch
do_coredump-fix-the-ispipe-error-check.patch
fs-execc-acct_arg_size-ptl-is-no-longer-needed-for-add_mm_counter.patch
ipc-introduce-shm_rmid_forced-sysctl.patch
ipc-introduce-shm_rmid_forced-sysctl-fix-2.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch

