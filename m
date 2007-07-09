From: akpm@linux-foundation.org
Subject: - lguest-the-documentation-example-launcher-fix-guests-1g.patch removed from -mm tree
Date: Mon, 09 Jul 2007 16:42:36 -0700
Message-ID: <200707092342.l69NgacS020971@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59476 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759316AbXGIXnT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 19:43:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, matias.zabaljauregui@cern.ch, mm-commits@vger.kernel.org


The patch titled
     lguest: fix guests > 1G
has been removed from the -mm tree.  Its filename was
     lguest-the-documentation-example-launcher-fix-guests-1g.patch

This patch was dropped because it was folded into lguest-the-documentation-example-launcher.patch

------------------------------------------------------
Subject: lguest: fix guests > 1G
From: Rusty Russell <rusty@rustcorp.com.au>

Matias Zabaljauregui <matias.zabaljauregui@cern.ch> noticed this bug
in the launcher: we were not capping the page tables at 4G, hence
overwriting the guest's device descriptor page for guests with more
memory than -PAGE_OFFSET.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Matias Zabaljauregui <matias.zabaljauregui@cern.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/lguest/lguest.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/lguest/lguest.c~lguest-the-documentation-example-launcher-fix-guests-1g Documentation/lguest/lguest.c
--- a/Documentation/lguest/lguest.c~lguest-the-documentation-example-launcher-fix-guests-1g
+++ a/Documentation/lguest/lguest.c
@@ -281,7 +281,7 @@ static unsigned long setup_pagetables(un
 	unsigned int ptes_per_page = getpagesize()/sizeof(u32);
 
 	/* If we can map all of memory above page_offset, we do so. */
-	if (mem > -page_offset)
+	if (mem <= -page_offset)
 		mapped_pages = mem/getpagesize();
 	else
 		mapped_pages = -page_offset/getpagesize();
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

git-kbuild.patch
paravirt-helper-to-disable-all-io-space-fix.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
mm-clean-up-and-kernelify-shrinker-registration-vs-git-nfs.patch
use-menuconfig-objects-ii-module-menu.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
modules-remove-modlist_lock.patch
permit-mempool_freenull.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-the-host-code.patch
lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-fix-guests-1g.patch
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
