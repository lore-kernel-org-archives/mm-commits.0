From: akpm@linux-foundation.org
Subject: - gru-driver-v3-resource-management-unmap-driver-ptes-gru.patch removed from -mm tree
Date: Tue, 29 Jul 2008 22:27:53 -0700
Message-ID: <200807300527.m6U5Rsq7009170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52295 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752050AbYG3F2B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 01:28:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, hugh@veritas.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     Unmap driver ptes - GRU
has been removed from the -mm tree.  Its filename was
     gru-driver-v3-resource-management-unmap-driver-ptes-gru.patch

This patch was dropped because it was folded into gru-driver-v3-resource-management.patch

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

mm-add-zap_vma_ptes-a-library-function-to-unmap-driver-ptes.patch
gru-driver-v3-hardware-data-structures.patch
gru-driver-v3-gru-instructions-macros.patch
gru-driver-v3-driver-internal-header-files.patch
gru-driver-v3-kernel-services-header-files.patch
gru-driver-v3-driver-initialization-file-vma-ops.patch
gru-driver-v3-page-faults-exceptions.patch
gru-driver-v3-kernel-services-provide-by-driver.patch
gru-driver-v3-resource-management.patch
gru-driver-v3-resource-management-unmap-driver-ptes-gru.patch
gru-driver-v3-proc-interfaces.patch
gru-driver-v3-tlb-flushing-mmuops-callouts.patch
gru-driver-v3-driver-makefile.patch
gru-driver-v3-export-is_uv_system-zap_page_range-follow_page.patch
gru-driver-v3-driver-misc-makefile-kconfig-changes.patch
gru-driver-v3-fixes-to-resolve-code-review-comments.patch
gru-driver-v3-fixes-to-resolve-code-review-comments-checkpatch-fixes.patch
sgi-xp-enable-building-of-xpc-xpnet-on-x86_64.patch
sgi-xp-add-usage-of-gru-driver-by-xpc_remote_memcpy.patch
sgi-xp-move-xpc_check_remote_hb-to-support-both-sn2-and-uv.patch
sgi-xp-cleanup-naming-of-partition-defines.patch
sgi-xp-setup-the-activate-gru-message-queue.patch
sgi-xp-setup-the-notify-gru-message-queue.patch
linux-next.patch

