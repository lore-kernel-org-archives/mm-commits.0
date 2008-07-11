From: akpm@linux-foundation.org
Subject: + gru-driver-v3-resource-management-unmap-driver-ptes-gru.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:44:27 -0700
Message-ID: <200807111850.m6BIo8qO031239@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755992AbYGKSuO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:50:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com, hugh@veritas.com, nickpiggin@yahoo.com.au


The patch titled
     Unmap driver ptes - GRU
has been added to the -mm tree.  Its filename is
     gru-driver-v3-resource-management-unmap-driver-ptes-gru.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Unmap driver ptes - GRU
From: Jack Steiner <steiner@sgi.com>

Change the GRU driver to use the new zap_vma_ptes() interface.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grumain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/sgi-gru/grumain.c~gru-driver-v3-resource-management-unmap-driver-ptes-gru drivers/misc/sgi-gru/grumain.c
--- a/drivers/misc/sgi-gru/grumain.c~gru-driver-v3-resource-management-unmap-driver-ptes-gru
+++ a/drivers/misc/sgi-gru/grumain.c
@@ -489,7 +489,7 @@ void gru_unload_context(struct gru_threa
 	struct gru_context_configuration_handle *cch;
 	int ctxnum = gts->ts_ctxnum;
 
-	zap_page_range(gts->ts_vma, UGRUADDR(gts), GRU_GSEG_PAGESIZE, NULL);
+	zap_vma_ptes(gts->ts_vma, UGRUADDR(gts), GRU_GSEG_PAGESIZE);
 	cch = get_cch(gru->gs_gru_base_vaddr, ctxnum);
 
 	lock_cch_handle(cch);
_

Patches currently in -mm which might be from steiner@sgi.com are

linux-next.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifiers-add-mm_take_all_locks-operation-checkpatch-fixes.patch
mmu-notifier-core.patch
mmu-notifier-core-fix.patch
mmu-notifier-core-fix-2.patch
mm-add-zap_vma_ptes-a-library-function-to-unmap-driver-ptes.patch
gru-driver-v3-hardware-data-structures.patch
gru-driver-v3-gru-instructions-macros.patch
gru-driver-v3-driver-internal-header-files.patch
gru-driver-v3-kernel-services-header-files.patch
gru-driver-v3-driver-initialization-file-vma-ops.patch
gru-driver-v3-page-faults-exceptions.patch
gru-driver-v3-page-faults-exceptions-gru-virtual-physical-translation.patch
gru-driver-v3-kernel-services-provide-by-driver.patch
gru-driver-v3-resource-management.patch
gru-driver-v3-resource-management-unmap-driver-ptes-gru.patch
gru-driver-v3-proc-interfaces.patch
gru-driver-v3-tlb-flushing-mmuops-callouts.patch
gru-driver-v3-driver-makefile.patch
gru-driver-v3-export-is_uv_system-zap_page_range-follow_page.patch
gru-driver-v3-driver-misc-makefile-kconfig-changes.patch

