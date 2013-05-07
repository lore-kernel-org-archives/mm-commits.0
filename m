From: akpm@linux-foundation.org
Subject: [merged] menuconfig-print-more-info-for-symbol-without-prompts.patch removed from -mm tree
Date: Tue, 07 May 2013 10:51:02 -0700
Message-ID: <20130507175102.8906531C4F8@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:51922 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759509Ab3EGRvE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:51:04 -0400
Received: by mail-ve0-f202.google.com with SMTP id 15so86304vea.5
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:51:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wengmeiling.weng@huawei.com, libo.chen@huawei.com, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: menuconfig: print more info for symbol without prompts
has been removed from the -mm tree.  Its filename was
     menuconfig-print-more-info-for-symbol-without-prompts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wengmeiling <wengmeiling.weng@huawei.com>
Subject: menuconfig: print more info for symbol without prompts

When we search a config symbol, if it has no prompt the position of this
symbol in the Kconfig file and it's dependencies are not printed.  This
can be inconvenient, especially when it's set to n and we want to find out
why.

the following is an example:

before:

Symbol: GENERIC_SMP_IDLE_THREAD [=y]
Type  : boolean
  Selected by: X86 [=y]

after:

Symbol: GENERIC_SMP_IDLE_THREAD [=y]
Type  : boolean
  Defined at arch/Kconfig:213
  Selected by: X86 [=y]

Signed-off-by: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Libo Chen <libo.chen@huawei.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/menu.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff -puN scripts/kconfig/menu.c~menuconfig-print-more-info-for-symbol-without-prompts scripts/kconfig/menu.c
--- a/scripts/kconfig/menu.c~menuconfig-print-more-info-for-symbol-without-prompts
+++ a/scripts/kconfig/menu.c
@@ -515,13 +515,6 @@ static void get_prompt_str(struct gstr *
 	struct jump_key *jump;
 
 	str_printf(r, _("Prompt: %s\n"), _(prop->text));
-	str_printf(r, _("  Defined at %s:%d\n"), prop->menu->file->name,
-		prop->menu->lineno);
-	if (!expr_is_yes(prop->visible.expr)) {
-		str_append(r, _("  Depends on: "));
-		expr_gstr_print(prop->visible.expr, r);
-		str_append(r, "\n");
-	}
 	menu = prop->menu->parent;
 	for (i = 0; menu != &rootmenu && i < 8; menu = menu->parent) {
 		bool accessible = menu_is_visible(menu);
@@ -572,6 +565,18 @@ static void get_prompt_str(struct gstr *
 }
 
 /*
+ * get peoperty of type P_SYMBOL
+ */
+static struct property *get_symbol_prop(struct symbol *sym)
+{
+	struct property *prop = NULL;
+
+	for_all_properties(sym, prop, P_SYMBOL)
+		break;
+	return prop;
+}
+
+/*
  * head is optional and may be NULL
  */
 void get_symbol_str(struct gstr *r, struct symbol *sym,
@@ -595,6 +600,14 @@ void get_symbol_str(struct gstr *r, stru
 	}
 	for_all_prompts(sym, prop)
 		get_prompt_str(r, prop, head);
+	prop = get_symbol_prop(sym);
+	str_printf(r, _("  Defined at %s:%d\n"), prop->menu->file->name,
+		prop->menu->lineno);
+	if (!expr_is_yes(prop->visible.expr)) {
+		str_append(r, _("  Depends on: "));
+		expr_gstr_print(prop->visible.expr, r);
+		str_append(r, "\n");
+	}
 	hit = false;
 	for_all_properties(sym, prop, P_SELECT) {
 		if (!hit) {
_

Patches currently in -mm which might be from wengmeiling.weng@huawei.com are

origin.patch

