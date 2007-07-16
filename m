From: akpm@linux-foundation.org
Subject: - permit-mempool_freenull.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:59:47 -0700
Message-ID: <200707162059.l6GKxlp5002454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43737 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759029AbXGPVPR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:15:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, borntraeger@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     permit mempool_free(NULL)
has been removed from the -mm tree.  Its filename was
     permit-mempool_freenull.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: permit mempool_free(NULL)
From: Rusty Russell <rusty@rustcorp.com.au>

Christian Borntraeger points out that mempool_free() doesn't noop when
handed NULL.  This is inconsistent with the other free-like functions
in the kernel.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/mempool.c~permit-mempool_freenull mm/mempool.c
--- a/mm/mempool.c~permit-mempool_freenull
+++ a/mm/mempool.c
@@ -263,6 +263,9 @@ void mempool_free(void *element, mempool
 {
 	unsigned long flags;
 
+	if (unlikely(element == NULL))
+		return;
+
 	smp_mb();
 	if (pool->curr_nr < pool->min_nr) {
 		spin_lock_irqsave(&pool->lock, flags);
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
git-kbuild.patch
paravirt-helper-to-disable-all-io-space-fix.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
mm-clean-up-and-kernelify-shrinker-registration-vs-git-nfs.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-the-host-code.patch
lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch
lguest-the-host-code-remove-usage-and-export-of-__put_task_struct.patch
lguest-the-host-code-disable-sysenter-for-guests.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
readahead-introduce-pg_readahead.patch
readahead-add-look-ahead-support-to-__do_page_cache_readahead.patch
readahead-min_ra_pages-max_ra_pages-macros.patch
readahead-data-structure-and-routines.patch
readahead-on-demand-readahead-logic.patch
readahead-convert-filemap-invocations.patch
readahead-convert-splice-invocations.patch
readahead-convert-ext3-ext4-invocations.patch
readahead-remove-the-old-algorithm.patch
readahead-move-synchronous-readahead-call-out-of-splice-loop.patch
readahead-pass-real-splice-size.patch
mm-share-pg_readahead-and-pg_reclaim.patch
readahead-split-ondemand-readahead-interface-into-two-functions.patch
readahead-sanify-file_ra_state-names.patch
define-new-percpu-interface-for-shared-data-version-4.patch
use-the-new-percpu-interface-for-shared-data-version-4.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
