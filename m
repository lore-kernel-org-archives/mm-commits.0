From: akpm@linux-foundation.org
Subject: - lguest-the-host-code-properly-kill-guest-userspace-programs-accessing-kernel-mem.patch removed from -mm tree
Date: Wed, 09 May 2007 02:42:54 -0700
Message-ID: <200705090942.l499gsJT020190@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755887AbXEIJnZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:43:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest: properly kill guest userspace programs accessing kernel mem
has been removed from the -mm tree.  Its filename was
     lguest-the-host-code-properly-kill-guest-userspace-programs-accessing-kernel-mem.patch

This patch was dropped because it was folded into lguest-the-host-code.patch

------------------------------------------------------
Subject: lguest: properly kill guest userspace programs accessing kernel mem
From: Rusty Russell <rusty@rustcorp.com.au>

Kernel pages on x86 are protected by not having the _PAGE_USER bit set. 
When guest userspace accesses a kernel page, we didn't check this, so we'd
think we'd handled the fault and return to the guest, causing the guest
userspace program to loop instead of segfaulting.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/core.c        |    2 +-
 drivers/lguest/lg.h          |    2 +-
 drivers/lguest/page_tables.c |   12 ++++++++----
 3 files changed, 10 insertions(+), 6 deletions(-)

diff -puN drivers/lguest/core.c~lguest-the-host-code-properly-kill-guest-userspace-programs-accessing-kernel-mem drivers/lguest/core.c
--- a/drivers/lguest/core.c~lguest-the-host-code-properly-kill-guest-userspace-programs-accessing-kernel-mem
+++ a/drivers/lguest/core.c
@@ -345,7 +345,7 @@ int run_guest(struct lguest *lg, char *_
 			}
 			break;
 		case 14: /* We've intercepted a page fault. */
-			if (demand_page(lg, cr2, lg->regs->errcode & 2))
+			if (demand_page(lg, cr2, lg->regs->errcode))
 				continue;
 
 			/* If lguest_data is NULL, this won't hurt. */
diff -puN drivers/lguest/lg.h~lguest-the-host-code-properly-kill-guest-userspace-programs-accessing-kernel-mem drivers/lguest/lg.h
--- a/drivers/lguest/lg.h~lguest-the-host-code-properly-kill-guest-userspace-programs-accessing-kernel-mem
+++ a/drivers/lguest/lg.h
@@ -214,7 +214,7 @@ void guest_pagetable_flush_user(struct l
 void guest_set_pte(struct lguest *lg, unsigned long cr3,
 		   unsigned long vaddr, gpte_t val);
 void map_switcher_in_guest(struct lguest *lg, struct lguest_pages *pages);
-int demand_page(struct lguest *info, unsigned long cr2, int write);
+int demand_page(struct lguest *info, unsigned long cr2, int errcode);
 void pin_page(struct lguest *lg, unsigned long vaddr);
 
 /* lguest_user.c: */
diff -puN drivers/lguest/page_tables.c~lguest-the-host-code-properly-kill-guest-userspace-programs-accessing-kernel-mem drivers/lguest/page_tables.c
--- a/drivers/lguest/page_tables.c~lguest-the-host-code-properly-kill-guest-userspace-programs-accessing-kernel-mem
+++ a/drivers/lguest/page_tables.c
@@ -109,7 +109,7 @@ static void check_gpgd(struct lguest *lg
 
 /* We fault pages in, which allows us to update accessed/dirty bits.
  * Return true if we got page. */
-int demand_page(struct lguest *lg, unsigned long vaddr, int write)
+int demand_page(struct lguest *lg, unsigned long vaddr, int errcode)
 {
 	gpgd_t gpgd;
 	spgd_t *spgd;
@@ -142,12 +142,16 @@ int demand_page(struct lguest *lg, unsig
 		return 0;
 
 	/* Write to read-only page? */
-	if (write && !(gpte.flags & _PAGE_RW))
+	if ((errcode & 2) && !(gpte.flags & _PAGE_RW))
+		return 0;
+
+	/* User access to a non-user page? */
+	if ((errcode & 4) && !(gpte.flags & _PAGE_USER))
 		return 0;
 
 	check_gpte(lg, gpte);
 	gpte.flags |= _PAGE_ACCESSED;
-	if (write)
+	if (errcode & 2)
 		gpte.flags |= _PAGE_DIRTY;
 
 	/* We're done with the old pte. */
@@ -185,7 +189,7 @@ static int page_writable(struct lguest *
 
 void pin_page(struct lguest *lg, unsigned long vaddr)
 {
-	if (!page_writable(lg, vaddr) && !demand_page(lg, vaddr, 0))
+	if (!page_writable(lg, vaddr) && !demand_page(lg, vaddr, 2))
 		kill_guest(lg, "bad stack page %#lx", vaddr);
 }
 
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
lguest-the-host-code-properly-kill-guest-userspace-programs-accessing-kernel-mem.patch
lguest-the-host-code-remove-put_user-etc-warnings-add-bloat.patch
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
