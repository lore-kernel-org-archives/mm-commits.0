From: akpm@linux-foundation.org
Subject: - m68knommu-use-trhead_size-instead-of-hard-constant.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:50:18 -0700
Message-ID: <200707162050.l6GKoI6G001302@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60012 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760499AbXGPVa7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:30:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerg@snapgear.com, gerg@uclinux.org, phdm@macqel.be, mm-commits@vger.kernel.org


The patch titled
     m68knommu: use TRHEAD_SIZE instead of hard constant
has been removed from the -mm tree.  Its filename was
     m68knommu-use-trhead_size-instead-of-hard-constant.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: m68knommu: use TRHEAD_SIZE instead of hard constant
From: Greg Ungerer <gerg@snapgear.com>

Use THREAD_SIZE instead of a hard constant.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/kernel/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/m68knommu/kernel/process.c~m68knommu-use-trhead_size-instead-of-hard-constant arch/m68knommu/kernel/process.c
--- a/arch/m68knommu/kernel/process.c~m68knommu-use-trhead_size-instead-of-hard-constant
+++ a/arch/m68knommu/kernel/process.c
@@ -377,7 +377,7 @@ unsigned long get_wchan(struct task_stru
 	fp = ((struct switch_stack *)p->thread.ksp)->a6;
 	do {
 		if (fp < stack_page+sizeof(struct thread_info) ||
-		    fp >= 8184+stack_page)
+		    fp >= THREAD_SIZE-8+stack_page)
 			return 0;
 		pc = ((unsigned long *)fp)[1];
 		if (!in_sched_functions(pc))
_

Patches currently in -mm which might be from gerg@snapgear.com are

origin.patch
git-mtd.patch
