From: akpm@linux-foundation.org
Subject: + kbuild-generate-modulesbuiltin.patch added to -mm tree
Date: Fri, 04 Sep 2009 16:19:08 -0700
Message-ID: <200909042319.n84NJ8rC026550@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934442AbZIDXTa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2009 19:19:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mmarek@suse.cz, JBeulich@novell.com, sam@ravnborg.org


The patch titled
     kbuild: generate modules.builtin
has been added to the -mm tree.  Its filename is
     kbuild-generate-modulesbuiltin.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kbuild: generate modules.builtin
From: Michal Marek <mmarek@suse.cz>

To make it easier for tools like mkinitrd to detect whether a needed
module is missing or whether it is compiled into the kernel, install a
modules.builtin file listing all modules built into the kernel.  This is
done by generating an alternate config file with all tristate =y options
set to =Y and reading the makefiles with this config included.  The built
in modules then appear in obj-Y.

Signed-off-by: Michal Marek <mmarek@suse.cz>
Cc: Jan Beulich <JBeulich@novell.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .gitignore                  |    1 
 Makefile                    |   14 +++++++--
 scripts/Kbuild.include      |    6 ++++
 scripts/Makefile.lib        |    5 ++-
 scripts/Makefile.modbuiltin |   48 ++++++++++++++++++++++++++++++++++
 scripts/kconfig/confdata.c  |   48 +++++++++++++++++++++++++++++-----
 6 files changed, 110 insertions(+), 12 deletions(-)

diff -puN .gitignore~kbuild-generate-modulesbuiltin .gitignore
--- a/.gitignore~kbuild-generate-modulesbuiltin
+++ a/.gitignore
@@ -22,6 +22,7 @@
 *.lst
 *.symtypes
 *.order
+modules.builtin
 *.elf
 *.bin
 *.gz
diff -puN Makefile~kbuild-generate-modulesbuiltin Makefile
--- a/Makefile~kbuild-generate-modulesbuiltin
+++ a/Makefile
@@ -871,6 +871,9 @@ $(sort $(vmlinux-init) $(vmlinux-main)) 
 PHONY += $(vmlinux-dirs)
 $(vmlinux-dirs): prepare scripts
 	$(Q)$(MAKE) $(build)=$@
+ifdef CONFIG_MODULES
+	$(Q)$(MAKE) $(modbuiltin)=$@
+endif
 
 # Build the kernel release string
 #
@@ -1126,6 +1129,7 @@ all: modules
 PHONY += modules
 modules: $(vmlinux-dirs) $(if $(KBUILD_BUILTIN),vmlinux)
 	$(Q)$(AWK) '!x[$$0]++' $(vmlinux-dirs:%=$(objtree)/%/modules.order) > $(objtree)/modules.order
+	$(Q)$(AWK) '!x[$$0]++' $(vmlinux-dirs:%=$(objtree)/%/modules.builtin) > $(objtree)/modules.builtin
 	@$(kecho) '  Building modules, stage 2.';
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.fwinst obj=firmware __fw_modbuild
@@ -1154,7 +1158,7 @@ _modinst_:
 		rm -f $(MODLIB)/build ; \
 		ln -s $(objtree) $(MODLIB)/build ; \
 	fi
-	@cp -f $(objtree)/modules.order $(MODLIB)/
+	@cp -f $(objtree)/modules.{order,builtin} $(MODLIB)/
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modinst
 
 # This depmod is only for convenience to give the initial
@@ -1217,8 +1221,9 @@ clean: archclean $(clean-dirs)
 		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
 		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
 		-o -name '*.symtypes' -o -name 'modules.order' \
-		-o -name 'Module.markers' -o -name '.tmp_*.o.*' \
-		-o -name '*.gcno' \) -type f -print | xargs rm -f
+		-o -name 'modules.builtin' -o -name 'Module.markers' \
+		-o -name '.tmp_*.o.*' -o -name '*.gcno' \) \
+		-type f -print | xargs rm -f
 
 # mrproper - Delete all generated files, including .config
 #
@@ -1416,7 +1421,8 @@ $(clean-dirs):
 clean:	rm-dirs := $(MODVERDIR)
 clean: rm-files := $(KBUILD_EXTMOD)/Module.symvers \
                    $(KBUILD_EXTMOD)/Module.markers \
-                   $(KBUILD_EXTMOD)/modules.order
+                   $(KBUILD_EXTMOD)/modules.order \
+                   $(KBUILD_EXTMOD)/modules.builtin
 clean: $(clean-dirs)
 	$(call cmd,rmdirs)
 	$(call cmd,rmfiles)
diff -puN scripts/Kbuild.include~kbuild-generate-modulesbuiltin scripts/Kbuild.include
--- a/scripts/Kbuild.include~kbuild-generate-modulesbuiltin
+++ a/scripts/Kbuild.include
@@ -143,6 +143,12 @@ ld-option = $(call try-run,\
 # $(Q)$(MAKE) $(build)=dir
 build := -f $(if $(KBUILD_SRC),$(srctree)/)scripts/Makefile.build obj
 
+###
+# Shorthand for $(Q)$(MAKE) -f scripts/Makefile.modbuiltin obj=
+# Usage:
+# $(Q)$(MAKE) $(modbuiltin)=dir
+modbuiltin := -f $(if $(KBUILD_SRC),$(srctree)/)scripts/Makefile.modbuiltin obj
+
 # Prefix -I with $(srctree) if it is not an absolute path.
 # skip if -I has no parameter
 addtree = $(if $(patsubst -I%,%,$(1)), \
diff -puN scripts/Makefile.lib~kbuild-generate-modulesbuiltin scripts/Makefile.lib
--- a/scripts/Makefile.lib~kbuild-generate-modulesbuiltin
+++ a/scripts/Makefile.lib
@@ -37,6 +37,8 @@ modorder	:= $(patsubst %/,%/modules.orde
 
 __subdir-y	:= $(patsubst %/,%,$(filter %/, $(obj-y)))
 subdir-y	+= $(__subdir-y)
+__subdir-Y	:= $(patsubst %/,%,$(filter %/, $(obj-Y)))
+subdir-Y	+= $(__subdir-Y)
 __subdir-m	:= $(patsubst %/,%,$(filter %/, $(obj-m)))
 subdir-m	+= $(__subdir-m)
 obj-y		:= $(patsubst %/, %/built-in.o, $(obj-y))
@@ -44,7 +46,7 @@ obj-m		:= $(filter-out %/, $(obj-m))
 
 # Subdirectories we need to descend into
 
-subdir-ym	:= $(sort $(subdir-y) $(subdir-m))
+subdir-ym	:= $(sort $(subdir-y) $(subdir-Y) $(subdir-m))
 
 # if $(foo-objs) exists, foo.o is a composite object 
 multi-used-y := $(sort $(foreach m,$(obj-y), $(if $(strip $($(m:.o=-objs)) $($(m:.o=-y))), $(m))))
@@ -76,6 +78,7 @@ always		:= $(addprefix $(obj)/,$(always)
 targets		:= $(addprefix $(obj)/,$(targets))
 modorder	:= $(addprefix $(obj)/,$(modorder))
 obj-y		:= $(addprefix $(obj)/,$(obj-y))
+obj-Y		:= $(addprefix $(obj)/,$(obj-Y))
 obj-m		:= $(addprefix $(obj)/,$(obj-m))
 lib-y		:= $(addprefix $(obj)/,$(lib-y))
 subdir-obj-y	:= $(addprefix $(obj)/,$(subdir-obj-y))
diff -puN /dev/null scripts/Makefile.modbuiltin
--- /dev/null
+++ a/scripts/Makefile.modbuiltin
@@ -0,0 +1,48 @@
+# ==========================================================================
+# Generating modules.builtin
+# ==========================================================================
+
+src := $(obj)
+
+PHONY := __modbuiltin
+__modbuiltin:
+
+# Read auto2.conf which sets tristate variables to 'Y' instead of 'y'
+# That way, we get the list of built-in modules in obj-Y
+-include include/config/auto2.conf
+
+include scripts/Kbuild.include
+
+# The filename Kbuild has precedence over Makefile
+kbuild-dir := $(if $(filter /%,$(src)),$(src),$(srctree)/$(src))
+kbuild-file := $(if $(wildcard $(kbuild-dir)/Kbuild),$(kbuild-dir)/Kbuild,$(kbuild-dir)/Makefile)
+include $(kbuild-file)
+
+include scripts/Makefile.lib
+
+modbuiltin-subdirs := $(patsubst %,%/modules.builtin, $(subdir-ym))
+modbuiltin-mods    := $(filter %.ko, $(obj-Y:.o=.ko))
+modbuiltin-target  := $(obj)/modules.builtin
+
+__modbuiltin: $(modbuiltin-target) $(subdir-ym)
+	@:
+
+modbuiltin-cmds =						\
+	for m in $(modbuiltin-mods); do echo kernel/$$m; done;	\
+	cat /dev/null $(modbuiltin-subdirs);
+
+$(modbuiltin-target): $(subdir-ym)
+	$(Q)($(modbuiltin-cmds)) > $@
+
+# Descending
+# ---------------------------------------------------------------------------
+
+PHONY += $(subdir-ym)
+$(subdir-ym):
+	$(Q)$(MAKE) $(modbuiltin)=$@
+
+
+# Declare the contents of the .PHONY variable as phony.  We keep that
+# information in a variable se we can use it in if_changed and friends.
+
+.PHONY: $(PHONY)
diff -puN scripts/kconfig/confdata.c~kbuild-generate-modulesbuiltin scripts/kconfig/confdata.c
--- a/scripts/kconfig/confdata.c~kbuild-generate-modulesbuiltin
+++ a/scripts/kconfig/confdata.c
@@ -672,12 +672,27 @@ out:
 	return res;
 }
 
+int fprintf2(FILE *f1, FILE *f2, const char *fmt, ...)
+{
+	va_list ap;
+	int res;
+
+	va_start(ap, fmt);
+	vfprintf(f1, fmt, ap);
+	va_end(ap);
+	va_start(ap, fmt);
+	res = vfprintf(f2, fmt, ap);
+	va_end(ap);
+
+	return res;
+}
+
 int conf_write_autoconf(void)
 {
 	struct symbol *sym;
 	const char *str;
 	const char *name;
-	FILE *out, *out_h;
+	FILE *out, *out2, *out_h;
 	time_t now;
 	int i, l;
 
@@ -692,16 +707,23 @@ int conf_write_autoconf(void)
 	if (!out)
 		return 1;
 
+	out2 = fopen(".tmpconfig2", "w");
+	if (!out2) {
+		fclose(out);
+		return 1;
+	}
+
 	out_h = fopen(".tmpconfig.h", "w");
 	if (!out_h) {
 		fclose(out);
+		fclose(out2);
 		return 1;
 	}
 
 	sym = sym_lookup("KERNELVERSION", 0);
 	sym_calc_value(sym);
 	time(&now);
-	fprintf(out, "#\n"
+	fprintf2(out, out2, "#\n"
 		     "# Automatically generated make config: don't edit\n"
 		     "# Linux kernel version: %s\n"
 		     "# %s"
@@ -726,45 +748,51 @@ int conf_write_autoconf(void)
 			case no:
 				break;
 			case mod:
-				fprintf(out, "CONFIG_%s=m\n", sym->name);
+				fprintf2(out, out2, "CONFIG_%s=m\n",
+						sym->name);
 				fprintf(out_h, "#define CONFIG_%s_MODULE 1\n", sym->name);
 				break;
 			case yes:
 				fprintf(out, "CONFIG_%s=y\n", sym->name);
+				fprintf(out2, "CONFIG_%s=%c\n", sym->name,
+					sym->type == S_BOOLEAN ? 'y' : 'Y');
 				fprintf(out_h, "#define CONFIG_%s 1\n", sym->name);
 				break;
 			}
 			break;
 		case S_STRING:
 			str = sym_get_string_value(sym);
-			fprintf(out, "CONFIG_%s=\"", sym->name);
+			fprintf2(out, out2, "CONFIG_%s=\"", sym->name);
 			fprintf(out_h, "#define CONFIG_%s \"", sym->name);
 			while (1) {
 				l = strcspn(str, "\"\\");
 				if (l) {
 					fwrite(str, l, 1, out);
+					fwrite(str, l, 1, out2);
 					fwrite(str, l, 1, out_h);
 					str += l;
 				}
 				if (!*str)
 					break;
-				fprintf(out, "\\%c", *str);
+				fprintf2(out, out2, "\\%c", *str);
 				fprintf(out_h, "\\%c", *str);
 				str++;
 			}
 			fputs("\"\n", out);
+			fputs("\"\n", out2);
 			fputs("\"\n", out_h);
 			break;
 		case S_HEX:
 			str = sym_get_string_value(sym);
 			if (str[0] != '0' || (str[1] != 'x' && str[1] != 'X')) {
-				fprintf(out, "CONFIG_%s=%s\n", sym->name, str);
+				fprintf2(out, out2, "CONFIG_%s=%s\n",
+						sym->name, str);
 				fprintf(out_h, "#define CONFIG_%s 0x%s\n", sym->name, str);
 				break;
 			}
 		case S_INT:
 			str = sym_get_string_value(sym);
-			fprintf(out, "CONFIG_%s=%s\n", sym->name, str);
+			fprintf2(out, out2, "CONFIG_%s=%s\n", sym->name, str);
 			fprintf(out_h, "#define CONFIG_%s %s\n", sym->name, str);
 			break;
 		default:
@@ -772,6 +800,7 @@ int conf_write_autoconf(void)
 		}
 	}
 	fclose(out);
+	fclose(out2);
 	fclose(out_h);
 
 	name = getenv("KCONFIG_AUTOHEADER");
@@ -779,6 +808,11 @@ int conf_write_autoconf(void)
 		name = "include/linux/autoconf.h";
 	if (rename(".tmpconfig.h", name))
 		return 1;
+	name = getenv("KCONFIG_AUTOCONFIG2");
+	if (!name)
+		name = "include/config/auto2.conf";
+	if (rename(".tmpconfig2", name))
+		return 1;
 	name = conf_get_autoconfig_name();
 	/*
 	 * This must be the last step, kbuild has a dependency on auto.conf
_

Patches currently in -mm which might be from mmarek@suse.cz are

kbuild-generate-modulesbuiltin.patch
kbuild-rebuild-fix-for-makefilemodbuiltin.patch

