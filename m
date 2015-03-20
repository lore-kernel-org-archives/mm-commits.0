From: akpm@linux-foundation.org
Subject: + mm-rcu-protected-get_mm_exe_file-fix.patch added to -mm tree
Date: Fri, 20 Mar 2015 12:36:08 -0700
Message-ID: <550c76a8.W1PRGEtJt1i45WN+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52152 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbbCTTgJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Mar 2015 15:36:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@yandex-team.ru, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix lockdep build in rcu-protected get_mm_exe_file()
has been added to the -mm tree.  Its filename is
     mm-rcu-protected-get_mm_exe_file-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rcu-protected-get_mm_exe_file-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rcu-protected-get_mm_exe_file-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: mm: fix lockdep build in rcu-protected get_mm_exe_file()

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/fork.c~mm-rcu-protected-get_mm_exe_file-fix kernel/fork.c
--- a/kernel/fork.c~mm-rcu-protected-get_mm_exe_file-fix
+++ a/kernel/fork.c
@@ -696,7 +696,7 @@ void set_mm_exe_file(struct mm_struct *m
 {
 	struct file *old_exe_file = rcu_dereference_protected(mm->exe_file,
 			!atomic_read(&mm->mm_users) || current->in_execve ||
-			lock_is_held(&mm->mmap_sem));
+			lockdep_is_held(&mm->mmap_sem));
 
 	if (new_exe_file)
 		get_file(new_exe_file);
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

page_writeback-cleanup-mess-around-cancel_dirty_page.patch
page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch
mm-hide-per-cpu-lists-in-output-of-show_mem.patch
mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch
mm-rcu-protected-get_mm_exe_file.patch
mm-rcu-protected-get_mm_exe_file-fix.patch
linux-next.patch

