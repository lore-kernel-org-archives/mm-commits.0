From: akpm@linux-foundation.org
Subject: + m68knommu-use-trhead_size-instead-of-hard-constant.patch added to -mm tree
Date: Mon, 04 Jun 2007 13:05:09 -0700
Message-ID: <200706042005.l54K5Al3015930@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48076 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760146AbXFDUF6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 16:05:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerg@snapgear.com, gerg@uclinux.org, phdm@macqel.be


The patch titled
     m68knommu: use TRHEAD_SIZE instead of hard constant
has been added to the -mm tree.  Its filename is
     m68knommu-use-trhead_size-instead-of-hard-constant.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m68knommu: use TRHEAD_SIZE instead of hard constant
From: Greg Ungerer <gerg@snapgear.com>

Use THREAD_SIZE instead of a hard constant.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/kernel/process.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

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

drivers-mtd-maps-nettelc-possible-cleanups.patch
m68knommu-fix-coldfire-timer-off-by-1.patch
nommu-stub-expand_stack-for-nommu-case.patch
m68knommu-use-trhead_size-instead-of-hard-constant.patch
m68knommu-remove-cruft-from-setup-code.patch
m68knommu-remove-old-cache-management-cruft-from-mm-code.patch
nommu-report-correct-errno-in-message.patch
