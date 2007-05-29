From: akpm@linux-foundation.org
Subject: + mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix.patch added to -mm tree
Date: Tue, 29 May 2007 13:11:27 -0700
Message-ID: <200705292011.l4TKBRT9010370@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765677AbXE2ULu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 16:11:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     mm: fix fault vs invalidate race for linear mappings fix
has been added to the -mm tree.  Its filename is
     mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: fix fault vs invalidate race for linear mappings fix
From: Nick Piggin <npiggin@suse.de>

Don't miss unlocking a locked page in GFS2.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/ops_vm.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN fs/gfs2/ops_vm.c~mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix fs/gfs2/ops_vm.c
--- a/fs/gfs2/ops_vm.c~mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix
+++ a/fs/gfs2/ops_vm.c
@@ -138,6 +138,8 @@ static struct page *gfs2_sharewrite_nopa
 	if (alloc_required) {
 		error = alloc_page_backing(ip, result);
 		if (error) {
+			if (area->vm_flags & VM_CAN_INVALIDATE)
+				unlock_page(result);
 			page_cache_release(result);
 			result = NULL;
 			goto out;
_

Patches currently in -mm which might be from npiggin@suse.de are

mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
mm-remove-legacy-cruft.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
git-arm-master.patch
slob-rework-freelist-handling.patch
slob-remove-bigblock-tracking.patch
slob-improved-alignment-handling.patch
mm-document-fault_data-and-flags.patch
fs-introduce-some-page-buffer-invariants.patch
