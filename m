From: akpm@linux-foundation.org
Subject: [merged] kbuild-generate-modulesbuiltin-fix-2.patch removed from -mm tree
Date: Tue, 08 Dec 2009 13:05:29 -0800
Message-ID: <200912082105.nB8L5TTt009348@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966083AbZLHVGA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2009 16:06:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mmarek@suse.cz, JBeulich@novell.com, anibal@debian.org, rostedt@goodmis.org, rusty@rustcorp.com.au, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kbuild-generate-modulesbuiltin-fix-2
has been removed from the -mm tree.  Its filename was
     kbuild-generate-modulesbuiltin-fix-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kbuild-generate-modulesbuiltin-fix-2
From: Michal Marek <mmarek@suse.cz>

Signed-off-by: Michal Marek <mmarek@suse.cz>
Cc: Jan Beulich <JBeulich@novell.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Anibal Monsalve Salazar <anibal@debian.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kbuild/kbuild.txt  |   14 +++++++
 Documentation/kbuild/kconfig.txt |    5 ++
 Makefile                         |    7 ++-
 scripts/Makefile.lib             |    5 --
 scripts/Makefile.modbuiltin      |   17 +++++----
 scripts/kconfig/confdata.c       |   53 ++++++++++-------------------
 6 files changed, 53 insertions(+), 48 deletions(-)

diff -puN Documentation/kbuild/kbuild.txt~kbuild-generate-modulesbuiltin-fix-2 Documentation/kbuild/kbuild.txt
--- a/Documentation/kbuild/kbuild.txt~kbuild-generate-modulesbuiltin-fix-2
+++ a/Documentation/kbuild/kbuild.txt
@@ -1,3 +1,17 @@
+Output files
+
+modules.order
+--------------------------------------------------
+This file records the order in which modules appear in Makefiles. This
+is used by modprobe to deterministically resolve aliases that match
+multiple modules.
+
+modules.builtin
+--------------------------------------------------
+This file lists all modules that are built into the kernel. This is used
+by modprobe to not fail when trying to load something builtin.
+
+
 Environment variables
 
 KCPPFLAGS
diff -puN Documentation/kbuild/kconfig.txt~kbuild-generate-modulesbuiltin-fix-2 Documentation/kbuild/kconfig.txt
--- a/Documentation/kbuild/kconfig.txt~kbuild-generate-modulesbuiltin-fix-2
+++ a/Documentation/kbuild/kconfig.txt
@@ -103,6 +103,11 @@ KCONFIG_AUTOCONFIG
 This environment variable can be set to specify the path & name of the
 "auto.conf" file.  Its default value is "include/config/auto.conf".
 
+KCONFIG_TRISTATE
+--------------------------------------------------
+This environment variable can be set to specify the path & name of the
+"tristate.conf" file.  Its default value is "include/config/tristate.conf".
+
 KCONFIG_AUTOHEADER
 --------------------------------------------------
 This environment variable can be set to specify the path & name of the
diff -puN Makefile~kbuild-generate-modulesbuiltin-fix-2 Makefile
--- a/Makefile~kbuild-generate-modulesbuiltin-fix-2
+++ a/Makefile
@@ -464,7 +464,7 @@ ifeq ($(KBUILD_EXTMOD),)
 # Carefully list dependencies so we do not try to build scripts twice
 # in parallel
 PHONY += scripts
-scripts: scripts_basic include/config/auto.conf
+scripts: scripts_basic include/config/auto.conf include/config/tristate.conf
 	$(Q)$(MAKE) $(build)=$(@)
 
 # Objects we will link into vmlinux / subdirs we need to visit
@@ -491,7 +491,7 @@ $(KCONFIG_CONFIG) include/config/auto.co
 # with it and forgot to run make oldconfig.
 # if auto.conf.cmd is missing then we are probably in a cleaned tree so
 # we execute the config step to be sure to catch updated Kconfig files
-include/config/auto.conf: $(KCONFIG_CONFIG) include/config/auto.conf.cmd
+include/config/%.conf: $(KCONFIG_CONFIG) include/config/auto.conf.cmd
 	$(Q)$(MAKE) -f $(srctree)/Makefile silentoldconfig
 else
 # external modules needs include/generated/autoconf.h and include/config/auto.conf
@@ -1112,7 +1112,8 @@ _modinst_:
 		rm -f $(MODLIB)/build ; \
 		ln -s $(objtree) $(MODLIB)/build ; \
 	fi
-	@cp -f $(objtree)/modules.{order,builtin} $(MODLIB)/
+	@cp -f $(objtree)/modules.order $(MODLIB)/
+	@cp -f $(objtree)/modules.builtin $(MODLIB)/
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modinst
 
 # This depmod is only for convenience to give the initial
diff -puN scripts/Makefile.lib~kbuild-generate-modulesbuiltin-fix-2 scripts/Makefile.lib
--- a/scripts/Makefile.lib~kbuild-generate-modulesbuiltin-fix-2
+++ a/scripts/Makefile.lib
@@ -37,8 +37,6 @@ modorder	:= $(patsubst %/,%/modules.orde
 
 __subdir-y	:= $(patsubst %/,%,$(filter %/, $(obj-y)))
 subdir-y	+= $(__subdir-y)
-__subdir-Y	:= $(patsubst %/,%,$(filter %/, $(obj-Y)))
-subdir-Y	+= $(__subdir-Y)
 __subdir-m	:= $(patsubst %/,%,$(filter %/, $(obj-m)))
 subdir-m	+= $(__subdir-m)
 obj-y		:= $(patsubst %/, %/built-in.o, $(obj-y))
@@ -46,7 +44,7 @@ obj-m		:= $(filter-out %/, $(obj-m))
 
 # Subdirectories we need to descend into
 
-subdir-ym	:= $(sort $(subdir-y) $(subdir-Y) $(subdir-m))
+subdir-ym	:= $(sort $(subdir-y) $(subdir-m))
 
 # if $(foo-objs) exists, foo.o is a composite object 
 multi-used-y := $(sort $(foreach m,$(obj-y), $(if $(strip $($(m:.o=-objs)) $($(m:.o=-y))), $(m))))
@@ -78,7 +76,6 @@ always		:= $(addprefix $(obj)/,$(always)
 targets		:= $(addprefix $(obj)/,$(targets))
 modorder	:= $(addprefix $(obj)/,$(modorder))
 obj-y		:= $(addprefix $(obj)/,$(obj-y))
-obj-Y		:= $(addprefix $(obj)/,$(obj-Y))
 obj-m		:= $(addprefix $(obj)/,$(obj-m))
 lib-y		:= $(addprefix $(obj)/,$(lib-y))
 subdir-obj-y	:= $(addprefix $(obj)/,$(subdir-obj-y))
diff -puN scripts/Makefile.modbuiltin~kbuild-generate-modulesbuiltin-fix-2 scripts/Makefile.modbuiltin
--- a/scripts/Makefile.modbuiltin~kbuild-generate-modulesbuiltin-fix-2
+++ a/scripts/Makefile.modbuiltin
@@ -7,9 +7,10 @@ src := $(obj)
 PHONY := __modbuiltin
 __modbuiltin:
 
-# Read auto2.conf which sets tristate variables to 'Y' instead of 'y'
+-include include/config/auto.conf
+# tristate.conf sets tristate variables to uppercase 'Y' or 'M'
 # That way, we get the list of built-in modules in obj-Y
--include include/config/auto2.conf
+-include include/config/tristate.conf
 
 include scripts/Kbuild.include
 
@@ -19,6 +20,11 @@ kbuild-file := $(if $(wildcard $(kbuild-
 include $(kbuild-file)
 
 include scripts/Makefile.lib
+__subdir-Y     := $(patsubst %/,%,$(filter %/, $(obj-Y)))
+subdir-Y       += $(__subdir-Y)
+subdir-ym      := $(sort $(subdir-y) $(subdir-Y) $(subdir-m))
+subdir-ym      := $(addprefix $(obj)/,$(subdir-ym))
+obj-Y          := $(addprefix $(obj)/,$(obj-Y))
 
 modbuiltin-subdirs := $(patsubst %,%/modules.builtin, $(subdir-ym))
 modbuiltin-mods    := $(filter %.ko, $(obj-Y:.o=.ko))
@@ -27,12 +33,9 @@ modbuiltin-target  := $(obj)/modules.bui
 __modbuiltin: $(modbuiltin-target) $(subdir-ym)
 	@:
 
-modbuiltin-cmds =						\
-	for m in $(modbuiltin-mods); do echo kernel/$$m; done;	\
-	cat /dev/null $(modbuiltin-subdirs);
-
 $(modbuiltin-target): $(subdir-ym) FORCE
-	$(Q)($(modbuiltin-cmds)) > $@
+	$(Q)(for m in $(modbuiltin-mods); do echo kernel/$$m; done;	\
+	cat /dev/null $(modbuiltin-subdirs)) > $@
 
 PHONY += FORCE
 
diff -puN scripts/kconfig/confdata.c~kbuild-generate-modulesbuiltin-fix-2 scripts/kconfig/confdata.c
--- a/scripts/kconfig/confdata.c~kbuild-generate-modulesbuiltin-fix-2
+++ a/scripts/kconfig/confdata.c
@@ -672,27 +672,12 @@ out:
 	return res;
 }
 
-int fprintf2(FILE *f1, FILE *f2, const char *fmt, ...)
-{
-	va_list ap;
-	int res;
-
-	va_start(ap, fmt);
-	vfprintf(f1, fmt, ap);
-	va_end(ap);
-	va_start(ap, fmt);
-	res = vfprintf(f2, fmt, ap);
-	va_end(ap);
-
-	return res;
-}
-
 int conf_write_autoconf(void)
 {
 	struct symbol *sym;
 	const char *str;
 	const char *name;
-	FILE *out, *out2, *out_h;
+	FILE *out, *tristate, *out_h;
 	time_t now;
 	int i, l;
 
@@ -707,8 +692,8 @@ int conf_write_autoconf(void)
 	if (!out)
 		return 1;
 
-	out2 = fopen(".tmpconfig2", "w");
-	if (!out2) {
+	tristate = fopen(".tmpconfig_tristate", "w");
+	if (!tristate) {
 		fclose(out);
 		return 1;
 	}
@@ -716,19 +701,22 @@ int conf_write_autoconf(void)
 	out_h = fopen(".tmpconfig.h", "w");
 	if (!out_h) {
 		fclose(out);
-		fclose(out2);
+		fclose(tristate);
 		return 1;
 	}
 
 	sym = sym_lookup("KERNELVERSION", 0);
 	sym_calc_value(sym);
 	time(&now);
-	fprintf2(out, out2, "#\n"
+	fprintf(out, "#\n"
 		     "# Automatically generated make config: don't edit\n"
 		     "# Linux kernel version: %s\n"
 		     "# %s"
 		     "#\n",
 		     sym_get_string_value(sym), ctime(&now));
+	fprintf(tristate, "#\n"
+	                  "# Automatically generated - do not edit\n"
+	                  "\n");
 	fprintf(out_h, "/*\n"
 		       " * Automatically generated C config: don't edit\n"
 		       " * Linux kernel version: %s\n"
@@ -748,13 +736,13 @@ int conf_write_autoconf(void)
 			case no:
 				break;
 			case mod:
-				fprintf2(out, out2, "CONFIG_%s=m\n",
-						sym->name);
+				fprintf(out, "CONFIG_%s=m\n", sym->name);
+				fprintf(tristate, "CONFIG_%s=M\n", sym->name);
 				fprintf(out_h, "#define CONFIG_%s_MODULE 1\n", sym->name);
 				break;
 			case yes:
 				fprintf(out, "CONFIG_%s=y\n", sym->name);
-				fprintf(out2, "CONFIG_%s=%c\n", sym->name,
+				fprintf(tristate, "CONFIG_%s=%c\n", sym->name,
 					sym->type == S_BOOLEAN ? 'y' : 'Y');
 				fprintf(out_h, "#define CONFIG_%s 1\n", sym->name);
 				break;
@@ -762,37 +750,34 @@ int conf_write_autoconf(void)
 			break;
 		case S_STRING:
 			str = sym_get_string_value(sym);
-			fprintf2(out, out2, "CONFIG_%s=\"", sym->name);
+			fprintf(out, "CONFIG_%s=\"", sym->name);
 			fprintf(out_h, "#define CONFIG_%s \"", sym->name);
 			while (1) {
 				l = strcspn(str, "\"\\");
 				if (l) {
 					fwrite(str, l, 1, out);
-					fwrite(str, l, 1, out2);
 					fwrite(str, l, 1, out_h);
 					str += l;
 				}
 				if (!*str)
 					break;
-				fprintf2(out, out2, "\\%c", *str);
+				fprintf(out, "\\%c", *str);
 				fprintf(out_h, "\\%c", *str);
 				str++;
 			}
 			fputs("\"\n", out);
-			fputs("\"\n", out2);
 			fputs("\"\n", out_h);
 			break;
 		case S_HEX:
 			str = sym_get_string_value(sym);
 			if (str[0] != '0' || (str[1] != 'x' && str[1] != 'X')) {
-				fprintf2(out, out2, "CONFIG_%s=%s\n",
-						sym->name, str);
+				fprintf(out, "CONFIG_%s=%s\n", sym->name, str);
 				fprintf(out_h, "#define CONFIG_%s 0x%s\n", sym->name, str);
 				break;
 			}
 		case S_INT:
 			str = sym_get_string_value(sym);
-			fprintf2(out, out2, "CONFIG_%s=%s\n", sym->name, str);
+			fprintf(out, "CONFIG_%s=%s\n", sym->name, str);
 			fprintf(out_h, "#define CONFIG_%s %s\n", sym->name, str);
 			break;
 		default:
@@ -800,7 +785,7 @@ int conf_write_autoconf(void)
 		}
 	}
 	fclose(out);
-	fclose(out2);
+	fclose(tristate);
 	fclose(out_h);
 
 	name = getenv("KCONFIG_AUTOHEADER");
@@ -808,10 +793,10 @@ int conf_write_autoconf(void)
 		name = "include/generated/autoconf.h";
 	if (rename(".tmpconfig.h", name))
 		return 1;
-	name = getenv("KCONFIG_AUTOCONFIG2");
+	name = getenv("KCONFIG_TRISTATE");
 	if (!name)
-		name = "include/config/auto2.conf";
-	if (rename(".tmpconfig2", name))
+		name = "include/config/tristate.conf";
+	if (rename(".tmpconfig_tristate", name))
 		return 1;
 	name = conf_get_autoconfig_name();
 	/*
_

Patches currently in -mm which might be from mmarek@suse.cz are

linux-next.patch
kconfig-cross_compile-option.patch

