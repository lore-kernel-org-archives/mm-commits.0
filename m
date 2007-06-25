From: akpm@linux-foundation.org
Subject: + mtrr-cyrix-fix-sections.patch added to -mm tree
Date: Mon, 25 Jun 2007 14:33:12 -0700
Message-ID: <200706252133.l5PLXCS0011282@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43005 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751998AbXFYVdu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 17:33:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, ak@suse.de


The patch titled
     mtrr/cyrix: fix sections
has been added to the -mm tree.  Its filename is
     mtrr-cyrix-fix-sections.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mtrr/cyrix: fix sections
From: Randy Dunlap <randy.dunlap@oracle.com>

Are there peculiarities about Cyrix that mean this isn't needed?

main.c::mtrr_add() or mtrr_del() [exported]
calls main.c::mtrr_add_page() or mtrr_del_page() or mtrr_restore() [resume]
calls main.c::set_mtrr()
calls main.c::ipi_handler()
calls main.c::mtrr_if->set_all() == which can be cyrix_set_all

WARNING: arch/i386/kernel/built-in.o(.text+0x8657): Section mismatch: reference to .init.data: (between 'cyrix_set_all' and 'centaur_get_free_region')
WARNING: arch/i386/kernel/built-in.o(.text+0x866b): Section mismatch: reference to .init.data: (between 'cyrix_set_all' and 'centaur_get_free_region')
WARNING: arch/i386/kernel/built-in.o(.text+0x867e): Section mismatch: reference to .init.data: (between 'cyrix_set_all' and 'centaur_get_free_region')
WARNING: arch/i386/kernel/built-in.o(.text+0x8684): Section mismatch: reference to .init.data: (between 'cyrix_set_all' and 'centaur_get_free_region')
WARNING: arch/i386/kernel/built-in.o(.text+0x868a): Section mismatch: reference to .init.data: (between 'cyrix_set_all' and 'centaur_get_free_region')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/mtrr/cyrix.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/cpu/mtrr/cyrix.c~mtrr-cyrix-fix-sections arch/i386/kernel/cpu/mtrr/cyrix.c
--- a/arch/i386/kernel/cpu/mtrr/cyrix.c~mtrr-cyrix-fix-sections
+++ a/arch/i386/kernel/cpu/mtrr/cyrix.c
@@ -233,12 +233,12 @@ typedef struct {
 	mtrr_type type;
 } arr_state_t;
 
-static arr_state_t arr_state[8] __devinitdata = {
+static arr_state_t arr_state[8] = {
 	{0UL, 0UL, 0UL}, {0UL, 0UL, 0UL}, {0UL, 0UL, 0UL}, {0UL, 0UL, 0UL},
 	{0UL, 0UL, 0UL}, {0UL, 0UL, 0UL}, {0UL, 0UL, 0UL}, {0UL, 0UL, 0UL}
 };
 
-static unsigned char ccr_state[7] __devinitdata = { 0, 0, 0, 0, 0, 0, 0 };
+static unsigned char ccr_state[7] = { 0, 0, 0, 0, 0, 0, 0 };
 
 static void cyrix_set_all(void)
 {
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

eventfd-clean-compile-when-config_eventfd=n.patch
mtrr-cyrix-fix-sections.patch
git-acpi.patch
romfs-printk-format-warnings.patch
mtd-use-null-for-pointer.patch
add-pci_try_set_mwi.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
kconfig-no-strange-misc-devices.patch
afs-drop-explicit-extern.patch
add-printktime-option-deprecate-time.patch
fs-clarify-dummy-member-in-struct.patch
sony-laptop-use-null-for-pointer.patch
hugetlbfs-use-lib-parser-fix-docs.patch
report-that-kernel-is-tainted-if-there-were-an-oops-before.patch
doc-oops-tracing-add-code-decode-info.patch
schedstats-fix-printk-format.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
profile-likely-unlikely-macros.patch
