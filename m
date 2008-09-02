From: akpm@linux-foundation.org
Subject: + x86-pgd_cdtor-cleanup.patch added to -mm tree
Date: Tue, 02 Sep 2008 15:08:53 -0700
Message-ID: <200809022208.m82M8rmv015251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47833 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751771AbYIBWJw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 18:09:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, hpa@zytor.com, jeremy@goop.org, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: pgd_{c,d}tor() cleanup
has been added to the -mm tree.  Its filename is
     x86-pgd_cdtor-cleanup.patch

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
Subject: x86: pgd_{c,d}tor() cleanup
From: Jan Beulich <jbeulich@novell.com>

Giving pgd_ctor() a properly typed parameter allows eliminating a local
variable.  Adjust pgd_dtor() to match.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pgtable.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN arch/x86/mm/pgtable.c~x86-pgd_cdtor-cleanup arch/x86/mm/pgtable.c
--- a/arch/x86/mm/pgtable.c~x86-pgd_cdtor-cleanup
+++ a/arch/x86/mm/pgtable.c
@@ -63,10 +63,8 @@ static inline void pgd_list_del(pgd_t *p
 #define UNSHARED_PTRS_PER_PGD				\
 	(SHARED_KERNEL_PMD ? KERNEL_PGD_BOUNDARY : PTRS_PER_PGD)
 
-static void pgd_ctor(void *p)
+static void pgd_ctor(pgd_t *pgd)
 {
-	pgd_t *pgd = p;
-
 	/* If the pgd points to a shared pagetable level (either the
 	   ptes in non-PAE, or shared PMD in PAE), then just copy the
 	   references from swapper_pg_dir. */
@@ -87,7 +85,7 @@ static void pgd_ctor(void *p)
 		pgd_list_add(pgd);
 }
 
-static void pgd_dtor(void *pgd)
+static void pgd_dtor(pgd_t *pgd)
 {
 	unsigned long flags; /* can be called from interrupt context */
 
_

Patches currently in -mm which might be from jbeulich@novell.com are

linux-next.patch
x86-init-annotations-in-early_printk-setup.patch
x86-adjust-dependencies-for-config_x86_cmov.patch
x86-pgd_cdtor-cleanup.patch
x86-x86_physvirt_bits-field-also-for-i386.patch
x86-adjust-vmalloc_sync_all-for-xen-2nd-try.patch
x86-fix-ticket-spin-lock-asm-constraints.patch
x86-64-reduce-boot-fixmap-space.patch
x86-64-add-two-__cpuinit-annotations.patch
x86-64-eliminate-dead-code.patch
x86-64-slightly-streamline-32-bit-syscall-entry-code.patch
adjust-init-section-definitions.patch
kconfig-eliminate-def_bool-n-constructs.patch

