From: akpm@linux-foundation.org
Subject: - remove-one-useless-extern-declaration.patch removed from -mm tree
Date: Mon, 04 Feb 2008 18:54:08 -0800
Message-ID: <200802050253.m152rnZX031534@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45885 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752831AbYBECy1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 21:54:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pierre.peiffer@bull.net, mm-commits@vger.kernel.org


The patch titled
     Remove one useless extern declaration
has been removed from the -mm tree.  Its filename was
     remove-one-useless-extern-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Remove one useless extern declaration
From: Pierre Peiffer <pierre.peiffer@bull.net>

The file exit.c contains one useless extern declaration of sem_exit().
Moreover, it refers to nothing.

Remove it.

Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/exit.c~remove-one-useless-extern-declaration kernel/exit.c
--- a/kernel/exit.c~remove-one-useless-extern-declaration
+++ a/kernel/exit.c
@@ -50,8 +50,6 @@
 #include <asm/pgtable.h>
 #include <asm/mmu_context.h>
 
-extern void sem_exit (void);
-
 static void exit_mm(struct task_struct * tsk);
 
 static void __unhash_process(struct task_struct *p)
_

Patches currently in -mm which might be from pierre.peiffer@bull.net are

origin.patch
ipc-fix-error-check-in-all-new-xxx_lock-and.patch
ipc-semaphores-consolidate-sem_stat-and.patch
ipc-make-struct-ipc_ids-static-in-ipc_namespace.patch
ipc-consolidate-sem_exit_ns-msg_exit_ns-and-shm_exit_ns.patch
