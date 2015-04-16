From: akpm@linux-foundation.org
Subject: [folded-merged] mm-rcu-protected-get_mm_exe_file-fix.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 10:44:24 -0700
Message-ID: <552ff4f8.glEpESXEUdMsM2et%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44314 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbbDPRoZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 13:44:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@yandex-team.ru, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix lockdep build in rcu-protected get_mm_exe_file()
has been removed from the -mm tree.  Its filename was
     mm-rcu-protected-get_mm_exe_file-fix.patch

This patch was dropped because it was folded into mm-rcu-protected-get_mm_exe_file.patch

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
@@ -719,7 +719,7 @@ void set_mm_exe_file(struct mm_struct *m
 {
 	struct file *old_exe_file = rcu_dereference_protected(mm->exe_file,
 			!atomic_read(&mm->mm_users) || current->in_execve ||
-			lock_is_held(&mm->mmap_sem));
+			lockdep_is_held(&mm->mmap_sem));
 
 	if (new_exe_file)
 		get_file(new_exe_file);
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

origin.patch
mm-rcu-protected-get_mm_exe_file.patch
mm-rcu-protected-get_mm_exe_file-fix-2.patch

