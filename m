From: akpm@linux-foundation.org
Subject: - kconfig-reset-generated-values-only-if-kconfig-and-config-agree.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:09:18 -0700
Message-ID: <200707172309.l6HN9IMf012362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46968 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936193AbXGQXPa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zippel@linux-m68k.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kconfig: reset generated values only if Kconfig and .config agree.
has been removed from the -mm tree.  Its filename was
     kconfig-reset-generated-values-only-if-kconfig-and-config-agree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-kbuild.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
hfs-convert-to-new-aops.patch
hfsplus-convert-to-new-aops.patch
fs-affs-convert-to-new-aops.patch
time-make-sure-sys_gettimeofday-and-sys_time-are-in.patch
