From: akpm@linux-foundation.org
Subject: + arc-do-not-export-symbols-in-troubleshootc.patch added to -mm
 tree
Date: Wed, 18 Feb 2015 12:18:54 -0800
Message-ID: <54e4f3ae.G5sjiYVZuWC/kQc5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46698 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbbBRUSz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 15:18:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, vgupta@synopsys.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arc: do not export symbols in troubleshoot.c
has been added to the -mm tree.  Its filename is
     arc-do-not-export-symbols-in-troubleshootc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arc-do-not-export-symbols-in-troubleshootc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arc-do-not-export-symbols-in-troubleshootc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: arc: do not export symbols in troubleshoot.c

print_task_path_n_nm() is local to this file, its only user being
show_regs().  Mark the function static and avoid the EXPORT_SYMBOL.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Vineet Gupta <vgupta@synopsys.com>
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
arc-do-not-export-symbols-in-troubleshootc.patch

