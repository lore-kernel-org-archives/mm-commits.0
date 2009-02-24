From: akpm@linux-foundation.org
Subject: - kbuild-check-for-select-dependency-errors-on-config-load.patch removed from -mm tree
Date: Tue, 24 Feb 2009 14:49:31 -0800
Message-ID: <200902242249.n1OMnVmO017927@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753554AbZBXWuf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 17:50:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, randy.dunlap@oracle.com, sam@ravnborg.org, srostedt@redhat.com, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     kbuild: check for select dependency errors on config load
has been removed from the -mm tree.  Its filename was
     kbuild-check-for-select-dependency-errors-on-config-load.patch

This patch was dropped because i got bored of all the noise

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kbuild: check for select dependency errors on config load
From: Steven Rostedt <rostedt@goodmis.org>

There have been a few problems with SELECT and dependencies lately.  I've
been burnt by it a few times myself.  So I look at the kconfig code and
added this patch.  It can use a bit more work but it does what I want.

When the config is loaded, it checks all the symbols that are selected by
an active config and makes sure the visible dependencies are also
activated.  This should probably be moved to the writing of the config
instead, but since I just wanted to see if my current config was OK, I did
it on load.  This is an RFC patch anyway, so fixes/comments are definitely
welcome.

Here's what I get with the attached config running on 2.6.29-rc5.

$ make menuconfig
scripts/kconfig/mconf arch/x86/Kconfig
.config:2561:warning: MICROCODE selects FW_LOADER which fails its dependencies!
.config:2561:warning: MICROCODE_INTEL selects FW_LOADER which fails its dependencies!
.config:2561:warning: PCMCIA_LOAD_CIS selects FW_LOADER which fails its dependencies!
.config:2561:warning: SCSI_SAS_LIBSAS selects SCSI_SAS_ATTRS which fails its dependencies!
.config:2561:warning: SCSI_AIC94XX selects FW_LOADER which fails its dependencies!
.config:2561:warning: KEYBOARD_ATKBD selects SERIO which fails its dependencies!
.config:2561:warning: KEYBOARD_ATKBD selects SERIO_LIBPS2 which fails its dependencies!
.config:2561:warning: KEYBOARD_ATKBD selects SERIO_I8042 which fails its dependencies!
.config:2561:warning: MOUSE_PS2 selects SERIO which fails its dependencies!
.config:2561:warning: MOUSE_PS2 selects SERIO_LIBPS2 which fails its dependencies!
.config:2561:warning: MOUSE_PS2 selects SERIO_I8042 which fails its dependencies!
.config:2561:warning: VT selects INPUT which fails its dependencies!
.config:2561:warning: DRM selects I2C_ALGOBIT which fails its dependencies!
.config:2561:warning: SND_EMU10K1 selects FW_LOADER which fails its dependencies!

<exit out>

*** End of Linux kernel configuration.
*** Execute 'make' to build the kernel or try 'make help'.

This also flags the MARKERS error with KVM_TRACE in linux-tip.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/confdata.c |  104 +++++++++++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)

diff -puN scripts/kconfig/confdata.c~kbuild-check-for-select-dependency-errors-on-config-load scripts/kconfig/confdata.c
--- a/scripts/kconfig/confdata.c~kbuild-check-for-select-dependency-errors-on-config-load
+++ a/scripts/kconfig/confdata.c
@@ -310,6 +310,109 @@ load:
 	return 0;
 }
 
+static int test_deps(struct symbol *sym)
+{
+	struct property *prop;
+	struct expr *expr;
+
+	if (sym->rev_dep.tri == no)
+		return 1;
+
+	for (prop = sym->prop; prop; prop = prop->next) {
+		if (prop->type != P_PROMPT)
+			continue;
+
+		expr = prop->visible.expr;
+		if (!expr)
+			continue;
+
+		if (expr_calc_value(expr) == no)
+			return 0;
+	}
+
+	return 1;
+}
+
+void test_select(struct symbol *sym)
+{
+	struct property *prop;
+	struct expr *expr;
+
+	for (prop = sym->prop; prop; prop = prop->next) {
+		if (prop->type != P_SELECT)
+			continue;
+
+		expr = prop->expr;
+
+		if (!expr || expr->type != E_SYMBOL ||
+		    !expr->left.sym)
+			continue;
+
+		if (test_deps(expr->left.sym))
+			continue;
+
+		conf_warning("%s selects %s which fails its dependencies!",
+			     sym->name, expr->left.sym->name);
+	}
+}
+
+void test_conf(void)
+{
+	struct symbol *sym;
+	struct menu *menu;
+	int type;
+
+	menu = rootmenu.list;
+	while (menu) {
+		sym = menu->sym;
+		if (!sym)
+			goto next;
+
+		if (!(sym->flags & SYMBOL_CHOICE)) {
+			sym_calc_value(sym);
+			if (!(sym->flags & SYMBOL_WRITE))
+				goto next;
+			type = sym->type;
+			if (type == S_TRISTATE) {
+				sym_calc_value(modules_sym);
+				if (modules_sym->curr.tri == no)
+					type = S_BOOLEAN;
+			}
+			switch (type) {
+			case S_BOOLEAN:
+			case S_TRISTATE:
+				switch (sym_get_tristate_value(sym)) {
+				case no:
+					break;
+				case mod:
+				case yes:
+					test_select(sym);
+					break;
+				}
+				break;
+			case S_STRING:
+			case S_HEX:
+			case S_INT:
+				break;
+			}
+		}
+
+	next:
+		if (menu->list) {
+			menu = menu->list;
+			continue;
+		}
+		if (menu->next)
+			menu = menu->next;
+		else while ((menu = menu->parent)) {
+			if (menu->next) {
+				menu = menu->next;
+				break;
+			}
+		}
+	}
+}
+
 int conf_read(const char *name)
 {
 	struct symbol *sym, *choice_sym;
@@ -386,6 +489,7 @@ int conf_read(const char *name)
 
 	sym_add_change_count(conf_warnings || conf_unsaved);
 
+	test_conf();
 	return 0;
 }
 
_

Patches currently in -mm which might be from rostedt@goodmis.org are

linux-next.patch
kbuild-check-for-select-dependency-errors-on-config-load.patch
kbuild-check-for-select-dependency-errors-on-config-load-checkpatch-fixes.patch

