From: akpm@linux-foundation.org
Subject: [merged] arc-do-not-export-symbols-in-troubleshootc.patch removed from -mm tree
Date: Mon, 20 Apr 2015 12:20:24 -0700
Message-ID: <55355178.0YO2nGNhaGViM/07%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40451 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbbDTTOD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:14:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, vgupta@synoipsys.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arc: do not export symbols in troubleshoot.c
has been removed from the -mm tree.  Its filename was
     arc-do-not-export-symbols-in-troubleshootc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: arc: do not export symbols in troubleshoot.c

print_task_path_n_nm() is local to this file, its only user being
show_regs().  Mark the function static and avoid the EXPORT_SYMBOL.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Vineet Gupta <vgupta@synoipsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/kernel/troubleshoot.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/arc/kernel/troubleshoot.c~arc-do-not-export-symbols-in-troubleshootc arch/arc/kernel/troubleshoot.c
--- a/arch/arc/kernel/troubleshoot.c~arc-do-not-export-symbols-in-troubleshootc
+++ a/arch/arc/kernel/troubleshoot.c
@@ -52,7 +52,7 @@ static void show_callee_regs(struct call
 	print_reg_file(&(cregs->r13), 13);
 }
 
-void print_task_path_n_nm(struct task_struct *tsk, char *buf)
+static void print_task_path_n_nm(struct task_struct *tsk, char *buf)
 {
 	struct path path;
 	char *path_nm = NULL;
@@ -77,7 +77,6 @@ void print_task_path_n_nm(struct task_st
 done:
 	pr_info("Path: %s\n", path_nm);
 }
-EXPORT_SYMBOL(print_task_path_n_nm);
 
 static void show_faulting_vma(unsigned long address, char *buf)
 {
_

Patches currently in -mm which might be from dave@stgolabs.net are

origin.patch
linux-next.patch

