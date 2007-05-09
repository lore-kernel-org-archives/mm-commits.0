From: akpm@linux-foundation.org
Subject: - lguest-the-host-code-fix-obscure-but-nasty-cow-bug.patch removed from -mm tree
Date: Wed, 09 May 2007 02:42:58 -0700
Message-ID: <200705090942.l499gwEx020196@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754348AbXEIJnr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:43:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest: fix obscure but nasty cow bug
has been removed from the -mm tree.  Its filename was
     lguest-the-host-code-fix-obscure-but-nasty-cow-bug.patch

This patch was dropped because it was folded into lguest-the-host-code.patch

------------------------------------------------------
Subject: lguest: fix obscure but nasty cow bug
From: Rusty Russell <rusty@rustcorp.com.au>

Nasty bug where the host is the first to write a MAP_PRIVATE page: the
guest still references the old one and won't see the write.  This can
happen with just the wrong data layouts for the initial setup hypercall
(the other places in the code are always written guest-first).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/hypercalls.c |    6 ++++++
 1 files changed, 6 insertions(+)

diff -puN drivers/lguest/hypercalls.c~lguest-the-host-code-fix-obscure-but-nasty-cow-bug drivers/lguest/hypercalls.c
--- a/drivers/lguest/hypercalls.c~lguest-the-host-code-fix-obscure-but-nasty-cow-bug
+++ a/drivers/lguest/hypercalls.c
@@ -155,6 +155,12 @@ static void initialize(struct lguest *lg
 	    || put_user(4U*1024*1024, &lg->lguest_data->reserve_mem)
 	    || put_user(lg->guestid, &lg->lguest_data->guestid))
 		kill_guest(lg, "bad guest page %p", lg->lguest_data);
+
+	/* This is the one case where the above accesses might have
+	 * been the first write to a Guest page.  This may have caused
+	 * a copy-on-write fault, but the Guest might be referring to
+	 * the old (read-only) page. */
+	guest_pagetable_clear_all(lg);
 }
 
 /* Even if we go out to userspace and come back, we don't want to do
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
____call_usermodehelper-dont-flush_signals.patch
wait_for_helper-remove-unneeded-do_sigaction.patch
futex-new-private-futexes.patch
compiler-introduce-__used-and-__maybe_unused.patch
xfs-clean-up-shrinker-games.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-the-host-code.patch
lguest-the-host-code-fix-obscure-but-nasty-cow-bug.patch
lguest-the-host-code-lguest-use-standard-bootloader-format-fix-badly-sized.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-net-driver-lguest-2621-mm1-update-lguest-net-stats-inlinepatch.patch
lguest-the-net-driver-two-net-bugfixes.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-fix-lguest-documentation-error.patch
lguest-documentation-and-example-updates.patch
lguest-the-documentation-example-launcher-dont-use-paravirt_probe-its-dying-doc.patch
lguest-use-standard-bootloader-format-fix-badly-sized-doc.patch
lguest-two-net-bugfixes-doc.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
