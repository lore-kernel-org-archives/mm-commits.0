From: akpm@linux-foundation.org
Subject: + freezer-prevent-new-tasks-from-inheriting-tif_freeze-set.patch added to -mm tree
Date: Mon, 23 Jul 2007 16:48:15 -0700
Message-ID: <200707232348.l6NNmFR7018375@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48800 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761281AbXGWXsb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 19:48:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, nigel@nigel.suspend2.net, pavel@ucw.cz


The patch titled
     freezer: prevent new tasks from inheriting TIF_FREEZE set
has been added to the -mm tree.  Its filename is
     freezer-prevent-new-tasks-from-inheriting-tif_freeze-set.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: freezer: prevent new tasks from inheriting TIF_FREEZE set
From: Rafael J. Wysocki <rjw@sisk.pl>

Tasks should go to the refrigerator only if explicitly requested to do that by
the freezer and not as a result of inheriting the TIF_FREEZE flag set from the
parent.  Make it happen.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Nigel Cunningham <nigel@nigel.suspend2.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN kernel/fork.c~freezer-prevent-new-tasks-from-inheriting-tif_freeze-set kernel/fork.c
--- a/kernel/fork.c~freezer-prevent-new-tasks-from-inheriting-tif_freeze-set
+++ a/kernel/fork.c
@@ -930,6 +930,7 @@ static inline void copy_flags(unsigned l
 	if (!(clone_flags & CLONE_PTRACE))
 		p->ptrace = 0;
 	p->flags = new_flags;
+	clear_freeze_flag(p);
 }
 
 asmlinkage long sys_set_tid_address(int __user *tidptr)
_

Patches currently in -mm which might be from rjw@sisk.pl are

git-acpi.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-fix-compilation-of-suspend-code-if-config_pm-is-unset.patch
pm-make-suspend_ops-static.patch
pm-rework-struct-hibernation_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
freezer-document-relationship-with-memory-shrinking.patch
freezer-do-not-sync-filesystems-from-freeze_processes.patch
freezer-prevent-new-tasks-from-inheriting-tif_freeze-set.patch
freezer-introduce-freezer-firendly-waiting-macros.patch
freezer-do-not-send-signals-to-kernel-threads.patch
shrink_slab-handle-bad-shrinkers.patch
