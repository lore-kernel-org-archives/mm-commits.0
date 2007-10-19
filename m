From: akpm@linux-foundation.org
Subject: - freezer-prevent-new-tasks-from-inheriting-tif_freeze-set.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:40:59 -0700
Message-ID: <200710190340.l9J3exQr012754@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49232 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966525AbXJSD4N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, nigel@nigel.suspend2.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     freezer: prevent new tasks from inheriting TIF_FREEZE set
has been removed from the -mm tree.  Its filename was
     freezer-prevent-new-tasks-from-inheriting-tif_freeze-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 1 insertion(+)

diff -puN kernel/fork.c~freezer-prevent-new-tasks-from-inheriting-tif_freeze-set kernel/fork.c
--- a/kernel/fork.c~freezer-prevent-new-tasks-from-inheriting-tif_freeze-set
+++ a/kernel/fork.c
@@ -942,6 +942,7 @@ static inline void copy_flags(unsigned l
 	if (!(clone_flags & CLONE_PTRACE))
 		p->ptrace = 0;
 	p->flags = new_flags;
+	clear_freeze_flag(p);
 }
 
 asmlinkage long sys_set_tid_address(int __user *tidptr)
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
revert-x86_64-mm-cpa-einval.patch
shrink_slab-handle-bad-shrinkers.patch
