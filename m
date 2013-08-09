From: akpm@linux-foundation.org
Subject: + scripts-mod-modpostc-handle-non-abs-crc-symbols.patch added to
 -mm tree
Date: Fri, 09 Aug 2013 12:52:00 -0700
Message-ID: <52054860.KbIQ8KnHnbs3ftwX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030969Ab3HITwB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Aug 2013 15:52:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, geert@linux-m68k.org, ak@linux.intel.com

Subject: + scripts-mod-modpostc-handle-non-abs-crc-symbols.patch added to -mm tree
To: ak@linux.intel.com,geert@linux-m68k.org,viro@ZenIV.linux.org.uk
From: akpm@linux-foundation.org
Date: Fri, 09 Aug 2013 12:52:00 -0700


The patch titled
     Subject: scripts/mod/modpost.c: handle non ABS crc symbols
has been added to the -mm tree.  Its filename is
     scripts-mod-modpostc-handle-non-abs-crc-symbols.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-mod-modpostc-handle-non-abs-crc-symbols.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-mod-modpostc-handle-non-abs-crc-symbols.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch
mm-cleanup-add_to_page_cache_locked.patch
thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch
thp-do_huge_pmd_anonymous_page-cleanup.patch
thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch
kernel-modsign_pubkeyc-fix-init-const-for-module-signing-code.patch
lto-watchdog-hpwdtc-make-assembler-label-global.patch
syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls.patch
scripts-mod-modpostc-handle-non-abs-crc-symbols.patch
linux-next.patch

