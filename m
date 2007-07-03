From: akpm@linux-foundation.org
Subject: + kconfig-reset-generated-values-only-if-kconfig-and-config-agree.patch added to -mm tree
Date: Tue, 03 Jul 2007 11:08:07 -0700
Message-ID: <200707031808.l63I876O006838@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43623 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752176AbXGCSI1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2007 14:08:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zippel@linux-m68k.org, sam@ravnborg.org


The patch titled
     kconfig: reset generated values only if Kconfig and .config agree.
has been added to the -mm tree.  Its filename is
     kconfig-reset-generated-values-only-if-kconfig-and-config-agree.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kconfig: reset generated values only if Kconfig and .config agree.
From: Roman Zippel <zippel@linux-m68k.org>

Normally generated values (Kconfig entries without a prompt) are cleared as
they are regenerated anyway and so they appear as new should they become
visible and defaults work as expected (once a value is set defaults aren't
used anymore).

The detection whether a value is generated or not is only based on its
visibility status, which can quickly change for a lot of symbols by just
removing a single line from .config or adding a dependency to Kconfig as you
noticed.

The patch now suppresses this logic when .config and Kconfig aren't in sync
and .config needs to be updated, so that you can remove now a random value
from .config and oldconfig won't reask for many other values.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/confdata.c |   37 ++++++++++++++++++++++++-----------
 1 files changed, 26 insertions(+), 11 deletions(-)

diff -puN scripts/kconfig/confdata.c~kconfig-reset-generated-values-only-if-kconfig-and-config-agree scripts/kconfig/confdata.c
--- a/scripts/kconfig/confdata.c~kconfig-reset-generated-values-only-if-kconfig-and-config-agree
+++ a/scripts/kconfig/confdata.c
@@ -341,27 +341,42 @@ int conf_read(const char *name)
 		conf_unsaved++;
 		/* maybe print value in verbose mode... */
 	sym_ok:
+		if (!sym_is_choice(sym))
+			continue;
+		/* The choice symbol only has a set value (and thus is not new)
+		 * if all its visible childs have values.
+		 */
+		prop = sym_get_choice_prop(sym);
+		flags = sym->flags;
+		for (e = prop->expr; e; e = e->left.expr)
+			if (e->right.sym->visible != no)
+				flags &= e->right.sym->flags;
+		sym->flags &= flags | ~SYMBOL_DEF_USER;
+	}
+
+	for_all_symbols(i, sym) {
 		if (sym_has_value(sym) && !sym_is_choice_value(sym)) {
-			if (sym->visible == no)
+			/* Reset values of generates values, so they'll appear
+			 * as new, if they should become visible, but that
+			 * doesn't quite work if the Kconfig and the saved
+			 * configuration disagree.
+			 */
+			if (sym->visible == no && !conf_unsaved)
 				sym->flags &= ~SYMBOL_DEF_USER;
 			switch (sym->type) {
 			case S_STRING:
 			case S_INT:
 			case S_HEX:
-				if (!sym_string_within_range(sym, sym->def[S_DEF_USER].val))
-					sym->flags &= ~(SYMBOL_VALID|SYMBOL_DEF_USER);
+				/* Reset a string value if it's out of range */
+				if (sym_string_within_range(sym, sym->def[S_DEF_USER].val))
+					break;
+				sym->flags &= ~(SYMBOL_VALID|SYMBOL_DEF_USER);
+				conf_unsaved++;
+				break;
 			default:
 				break;
 			}
 		}
-		if (!sym_is_choice(sym))
-			continue;
-		prop = sym_get_choice_prop(sym);
-		flags = sym->flags;
-		for (e = prop->expr; e; e = e->left.expr)
-			if (e->right.sym->visible != no)
-				flags &= e->right.sym->flags;
-		sym->flags &= flags | ~SYMBOL_DEF_USER;
 	}
 
 	sym_add_change_count(conf_warnings || conf_unsaved);
_

Patches currently in -mm which might be from zippel@linux-m68k.org are

lots-of-architectures-enable-arbitary-speed-tty-support.patch
kconfig-reset-generated-values-only-if-kconfig-and-config-agree.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
ntp-move-the-cmos-update-code-into-ntpc-fix.patch
ntp-move-the-cmos-update-code-into-ntpc-fix-fix.patch
hfs-convert-to-new-aops.patch
hfsplus-convert-to-new-aops.patch
fs-affs-convert-to-new-aops.patch
char-genrtc-use-wait_event_interruptible.patch
dma-mapping-prevent-dma-dependent-code-from-linking-on.patch
hfsplus-change-kmalloc-memset-to-kzalloc.patch
sys_time-speedup.patch
sys_time-speedup-build-fixes.patch
hfs-refactor-ascii-to-unicode-conversion-routine.patch
hfs-refactor-ascii-to-unicode-conversion-routine-fix.patch
hfs-add-custom-dentry-hash-and-comparison-operations.patch
