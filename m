From: akpm@linux-foundation.org
Subject: - lguest-the-host-code-disable-sysenter-for-guests.patch removed from -mm tree
Date: Wed, 18 Jul 2007 22:54:17 -0700
Message-ID: <200707190554.l6J5sHJM016577@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49331 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753796AbXGSFy0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 01:54:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest: disable SYSENTER for guests
has been removed from the -mm tree.  Its filename was
     lguest-the-host-code-disable-sysenter-for-guests.patch

This patch was dropped because it was folded into lguest-the-host-code.patch

------------------------------------------------------
Subject: lguest: disable SYSENTER for guests
From: Rusty Russell <rusty@rustcorp.com.au>

The SYSENTER instruction jumps to a pre-programmed address at privilege
level 0.  We must not allow execution of guest code at that privilege
level, so disable sysenter when we enter the guest (and re-enable it on
return).  This fixes current case where guest userspace can crash host.

This save/restore adds 3% to guest context switch times.  (If only there
were some kind of scheduler hook or something which would tell us when we
were being preempted so we could fix this up lazily.  But what kind of
daredevil coder would propose such a thing?)

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/core.c |    7 +++++++
 1 files changed, 7 insertions(+)

diff -puN drivers/lguest/core.c~lguest-the-host-code-disable-sysenter-for-guests drivers/lguest/core.c
--- a/drivers/lguest/core.c~lguest-the-host-code-disable-sysenter-for-guests
+++ a/drivers/lguest/core.c
@@ -338,6 +338,10 @@ int run_guest(struct lguest *lg, unsigne
 		if (lg->ts)
 			set_ts();
 
+		/* Don't let Guest do SYSENTER: we can't handle it. */
+		if (boot_cpu_has(X86_FEATURE_SEP))
+			wrmsr(MSR_IA32_SYSENTER_CS, 0, 0);
+
 		run_guest_once(lg, lguest_pages(raw_smp_processor_id()));
 
 		/* Save cr2 now if we page-faulted. */
@@ -345,6 +349,9 @@ int run_guest(struct lguest *lg, unsigne
 			cr2 = read_cr2();
 		else if (lg->regs->trapnum == 7)
 			math_state_restore();
+
+		if (boot_cpu_has(X86_FEATURE_SEP))
+			wrmsr(MSR_IA32_SYSENTER_CS, __KERNEL_CS, 0);
 		local_irq_enable();
 
 		switch (lg->regs->trapnum) {
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
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
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-the-host-code.patch
lguest-the-host-code-disable-sysenter-for-guests.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
