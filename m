From: akpm@linux-foundation.org
Subject: [merged] scripts-mod-modpostc-handle-non-abs-crc-symbols.patch
 removed from -mm tree
Date: Wed, 13 Nov 2013 12:39:52 -0800
Message-ID: <5283e398.wmzoHgFgaQ/w4oEC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42861 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab3KMUjx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:39:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, penguin-kernel@i-love.sakura.ne.jp, geert@linux-m68k.org, ak@linux.intel.com

Subject: [merged] scripts-mod-modpostc-handle-non-abs-crc-symbols.patch removed from -mm tree
To: ak@linux.intel.com,geert@linux-m68k.org,penguin-kernel@i-love.sakura.ne.jp,viro@ZenIV.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:39:52 -0800


The patch titled
     Subject: scripts/mod/modpost.c: handle non ABS crc symbols
has been removed from the -mm tree.  Its filename was
     scripts-mod-modpostc-handle-non-abs-crc-symbols.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: scripts/mod/modpost.c: handle non ABS crc symbols

For some reason I managed to trick gcc into create CRC symbols that are
not absolute anymore, but weak.

Make modpost handle this case.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
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
linux-next.patch
mm-avoid-increase-sizeofstruct-page-due-to-split-page-table-lock.patch
mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks.patch
mm-convert-mm-nr_ptes-to-atomic_long_t.patch
mm-introduce-api-for-split-page-table-lock-for-pmd-level.patch
mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock.patch
mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch
mm-thp-do-not-access-mm-pmd_huge_pte-directly.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
mm-convert-the-rest-to-new-page-table-lock-api.patch
mm-implement-split-page-table-lock-for-pmd-level.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch

