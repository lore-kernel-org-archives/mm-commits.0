From: akpm@linux-foundation.org
Subject: [failures] scripts-mod-modpostc-handle-non-abs-crc-symbols.patch
 removed from -mm tree
Date: Tue, 10 Sep 2013 17:22:54 -0700
Message-ID: <522fb7de.8WMYlx+opwk5EZpP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40729 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab3IKAWz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Sep 2013 20:22:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, geert@linux-m68k.org, ak@linux.intel.com

Subject: [failures] scripts-mod-modpostc-handle-non-abs-crc-symbols.patch removed from -mm tree
To: ak@linux.intel.com,geert@linux-m68k.org,viro@ZenIV.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 10 Sep 2013 17:22:54 -0700


The patch titled
     Subject: scripts/mod/modpost.c: handle non ABS crc symbols
has been removed from the -mm tree.  Its filename was
     scripts-mod-modpostc-handle-non-abs-crc-symbols.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: scripts/mod/modpost.c: handle non ABS crc symbols

For some reason I managed to trick gcc into create CRC symbols that are
not absolute anymore, but weak.

Make modpost handle this case.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/mod/modpost.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN scripts/mod/modpost.c~scripts-mod-modpostc-handle-non-abs-crc-symbols scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~scripts-mod-modpostc-handle-non-abs-crc-symbols
+++ a/scripts/mod/modpost.c
@@ -599,18 +599,17 @@ static void handle_modversions(struct mo
 	else
 		export = export_from_sec(info, get_secindex(info, sym));
 
+	/* CRC'd symbol */
+	if (strncmp(symname, CRC_PFX, strlen(CRC_PFX)) == 0) {
+		crc = (unsigned int) sym->st_value;
+		sym_update_crc(symname + strlen(CRC_PFX), mod, crc,
+				export);
+	}
+
 	switch (sym->st_shndx) {
 	case SHN_COMMON:
 		warn("\"%s\" [%s] is COMMON symbol\n", symname, mod->name);
 		break;
-	case SHN_ABS:
-		/* CRC'd symbol */
-		if (strncmp(symname, CRC_PFX, strlen(CRC_PFX)) == 0) {
-			crc = (unsigned int) sym->st_value;
-			sym_update_crc(symname + strlen(CRC_PFX), mod, crc,
-					export);
-		}
-		break;
 	case SHN_UNDEF:
 		/* undefined symbol */
 		if (ELF_ST_BIND(sym->st_info) != STB_GLOBAL &&
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
mm-migrate-make-core-migration-code-aware-of-hugepage.patch
mm-soft-offline-use-migrate_pages-instead-of-migrate_huge_page.patch
migrate-add-hugepage-migration-code-to-migrate_pages.patch
mm-migrate-add-hugepage-migration-code-to-move_pages.patch
mm-mbind-add-hugepage-migration-code-to-mbind.patch
mm-migrate-remove-vm_hugetlb-from-vma-flag-check-in-vma_migratable.patch
mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage.patch
mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2.patch
mm-mempolicy-rename-check_range-to-queue_pages_range.patch
kernel-modsign_pubkeyc-fix-init-const-for-module-signing-code.patch
lto-watchdog-hpwdtc-make-assembler-label-global.patch
x86-add-1-2-4-8-byte-optimization-to-64bit-__copy_fromto_user_inatomic.patch
thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch
mm-cleanup-add_to_page_cache_locked.patch
thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch
thp-do_huge_pmd_anonymous_page-cleanup.patch
thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch

