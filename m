From: akpm@linux-foundation.org
Subject: + tristate-choices-with-mixed-tristate-and-boolean.patch added to -mm tree
Date: Sat, 15 Sep 2007 01:31:48 -0700
Message-ID: <200709150831.l8F8Vmv1025453@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35350 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752335AbXIOIdD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 15 Sep 2007 04:33:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, sam@ravnborg.org, zippel@linux-m68k.org


The patch titled
     tristate choices with mixed tristate and boolean values
has been added to the -mm tree.  Its filename is
     tristate-choices-with-mixed-tristate-and-boolean.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tristate choices with mixed tristate and boolean values
From: "Jan Beulich" <jbeulich@novell.com>

Change kconfig behavior so that mixing bool and tristate config settings in
a choice is possible and has the desired effect of offering just the
tristate options individually if the choice gets set to M, and a normal
boolean selection if the choice gets set to Y.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/menu.c |   35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff -puN scripts/kconfig/menu.c~tristate-choices-with-mixed-tristate-and-boolean scripts/kconfig/menu.c
--- a/scripts/kconfig/menu.c~tristate-choices-with-mixed-tristate-and-boolean
+++ a/scripts/kconfig/menu.c
@@ -235,16 +235,23 @@ void menu_finalize(struct menu *parent)
 	sym = parent->sym;
 	if (parent->list) {
 		if (sym && sym_is_choice(sym)) {
-			/* find the first choice value and find out choice type */
+			/* find out choice type */
+			enum symbol_type type = S_UNKNOWN;
+
 			for (menu = parent->list; menu; menu = menu->next) {
-				if (menu->sym) {
-					current_entry = parent;
-					menu_set_type(menu->sym->type);
-					current_entry = menu;
-					menu_set_type(sym->type);
-					break;
+				if (menu->sym && menu->sym->type != S_UNKNOWN) {
+					if (type == S_UNKNOWN)
+						type = menu->sym->type;
+					if (type != S_BOOLEAN)
+						break;
+					if (menu->sym->type == S_TRISTATE) {
+						type = S_TRISTATE;
+						break;
+					}
 				}
 			}
+			current_entry = parent;
+			menu_set_type(type);
 			parentdep = expr_alloc_symbol(sym);
 		} else if (parent->prompt)
 			parentdep = parent->prompt->visible.expr;
@@ -253,7 +260,16 @@ void menu_finalize(struct menu *parent)
 
 		for (menu = parent->list; menu; menu = menu->next) {
 			basedep = expr_transform(menu->dep);
-			basedep = expr_alloc_and(expr_copy(parentdep), basedep);
+			dep = parentdep;
+			if (sym && sym_is_choice(sym) && menu->sym) {
+				enum symbol_type type = menu->sym->type;
+
+				if (type == S_UNKNOWN)
+					type = sym->type;
+			     if (type != S_TRISTATE)
+					dep = expr_alloc_comp(E_EQUAL, sym, &symbol_yes);
+			}
+			basedep = expr_alloc_and(expr_copy(dep), basedep);
 			basedep = expr_eliminate_dups(basedep);
 			menu->dep = basedep;
 			if (menu->sym)
@@ -326,7 +342,8 @@ void menu_finalize(struct menu *parent)
 					    "values not supported");
 			}
 			current_entry = menu;
-			menu_set_type(sym->type);
+			if (menu->sym->type == S_UNKNOWN)
+				menu_set_type(sym->type);
 			menu_add_symbol(P_CHOICE, sym, NULL);
 			prop = sym_get_choice_prop(sym);
 			for (ep = &prop->expr; *ep; ep = &(*ep)->left.expr)
_

Patches currently in -mm which might be from jbeulich@novell.com are

intel_cacheinfo-adjustmentspatch.patch
tristate-choices-with-mixed-tristate-and-boolean.patch
fix-x86_64-mm-unwinder.patch
floppy-tolerate-dma-channel-unavailability.patch
cleanup-floppyh.patch
handle-recursive-calls-to-bust_spinlocks.patch
store-__setup_str_-in-a-more-compact-way.patch
constify-string-array-kparam-tracking-structures.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-cpuid-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
pnp-dont-fail-device-init-if-no-dma-channel.patch
