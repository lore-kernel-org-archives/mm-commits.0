From: akpm@linux-foundation.org
Subject: - linux-kernel-markers-create-modpost-file.patch removed from -mm tree
Date: Thu, 14 Feb 2008 14:23:21 -0500
Message-ID: <200802150226.m1F2QenM015238@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47701 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759028AbYBOC1d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 21:27:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, dsmith@redhat.com, roland@redhat.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     Linux Kernel Markers: create modpost file
has been removed from the -mm tree.  Its filename was
     linux-kernel-markers-create-modpost-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Linux Kernel Markers: create modpost file
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

This adds some new magic in the MODPOST phase for CONFIG_MARKERS.  Analogous
to the Module.symvers file, the build will now write a Module.markers file
when CONFIG_MARKERS=y is set.  This file lists the name, defining module, and
format string of each marker, separated by \t characters.  This simple text
file can be used by offline build procedures for instrumentation code,
analogous to how System.map and Module.symvers can be useful to have for
kernels other than the one you are running right now.

The strings are made easy to extract by having the __trace_mark macro define
the name and format together in a single array called __mstrtab_* in the
__markers_strings section.  This is straightforward and reliable as long as
the marker structs are always defined by this macro.  It is an unreasonable
amount of hairy work to extract the string pointers from the __markers section
structs, which entails handling a relocation type for every machine under the
sun.

Mathieu :
- Ran through checkpatch.pl

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: David Smith <dsmith@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/marker.h   |    9 --
 scripts/Makefile.modpost |   11 ++
 scripts/mod/modpost.c    |  164 ++++++++++++++++++++++++++++++++++++-
 scripts/mod/modpost.h    |    3 
 4 files changed, 180 insertions(+), 7 deletions(-)

diff -puN include/linux/marker.h~linux-kernel-markers-create-modpost-file include/linux/marker.h
--- a/include/linux/marker.h~linux-kernel-markers-create-modpost-file
+++ a/include/linux/marker.h
@@ -61,15 +61,12 @@ struct marker {
  */
 #define __trace_mark(name, call_private, format, args...)		\
 	do {								\
-		static const char __mstrtab_name_##name[]		\
+		static const char __mstrtab_##name[]			\
 		__attribute__((section("__markers_strings")))		\
-		= #name;						\
-		static const char __mstrtab_format_##name[]		\
-		__attribute__((section("__markers_strings")))		\
-		= format;						\
+		= #name "\0" format;					\
 		static struct marker __mark_##name			\
 		__attribute__((section("__markers"), aligned(8))) =	\
-		{ __mstrtab_name_##name, __mstrtab_format_##name,	\
+		{ __mstrtab_##name, &__mstrtab_##name[sizeof(#name)],	\
 		0, 0, marker_probe_cb,					\
 		{ __mark_empty_function, NULL}, NULL };			\
 		__mark_check_format(format, ## args);			\
diff -puN scripts/Makefile.modpost~linux-kernel-markers-create-modpost-file scripts/Makefile.modpost
--- a/scripts/Makefile.modpost~linux-kernel-markers-create-modpost-file
+++ a/scripts/Makefile.modpost
@@ -13,6 +13,7 @@
 # 2) modpost is then used to
 # 3)  create one <module>.mod.c file pr. module
 # 4)  create one Module.symvers file with CRC for all exported symbols
+# 4a) [CONFIG_MARKERS] create one Module.markers file listing defined markers
 # 5) compile all <module>.mod.c files
 # 6) final link of the module to a <module.ko> file
 
@@ -45,6 +46,10 @@ include scripts/Makefile.lib
 
 kernelsymfile := $(objtree)/Module.symvers
 modulesymfile := $(firstword $(KBUILD_EXTMOD))/Module.symvers
+kernelmarkersfile := $(objtree)/Module.markers
+modulemarkersfile := $(firstword $(KBUILD_EXTMOD))/Module.markers
+
+markersfile = $(if $(KBUILD_EXTMOD),$(modulemarkersfile),$(kernelmarkersfile))
 
 # Step 1), find all modules listed in $(MODVERDIR)/
 __modules := $(sort $(shell grep -h '\.ko' /dev/null $(wildcard $(MODVERDIR)/*.mod)))
@@ -63,6 +68,8 @@ modpost = scripts/mod/modpost           
  $(if $(KBUILD_EXTMOD),-I $(modulesymfile))      \
  $(if $(KBUILD_EXTMOD),-o $(modulesymfile))      \
  $(if $(CONFIG_DEBUG_SECTION_MISMATCH),,-S)      \
+ $(if $(CONFIG_MARKERS),-K $(kernelmarkersfile)) \
+ $(if $(CONFIG_MARKERS),-M $(markersfile))	 \
  $(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w)
 
 quiet_cmd_modpost = MODPOST $(words $(filter-out vmlinux FORCE, $^)) modules
@@ -82,6 +89,10 @@ vmlinux.o: FORCE
 $(symverfile):         __modpost ;
 $(modules:.ko=.mod.c): __modpost ;
 
+ifdef CONFIG_MARKERS
+$(markersfile):	       __modpost ;
+endif
+
 
 # Step 5), compile all *.mod.c files
 
diff -puN scripts/mod/modpost.c~linux-kernel-markers-create-modpost-file scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~linux-kernel-markers-create-modpost-file
+++ a/scripts/mod/modpost.c
@@ -11,6 +11,8 @@
  * Usage: modpost vmlinux module1.o module2.o ...
  */
 
+#define _GNU_SOURCE
+#include <stdio.h>
 #include <ctype.h>
 #include "modpost.h"
 #include "../../include/linux/license.h"
@@ -435,6 +437,8 @@ static int parse_elf(struct elf_info *in
 			info->export_unused_gpl_sec = i;
 		else if (strcmp(secname, "__ksymtab_gpl_future") == 0)
 			info->export_gpl_future_sec = i;
+		else if (strcmp(secname, "__markers_strings") == 0)
+			info->markers_strings_sec = i;
 
 		if (sechdrs[i].sh_type != SHT_SYMTAB)
 			continue;
@@ -1470,6 +1474,62 @@ static void check_sec_ref(struct module 
 	}
 }
 
+static void get_markers(struct elf_info *info, struct module *mod)
+{
+	const Elf_Shdr *sh = &info->sechdrs[info->markers_strings_sec];
+	const char *strings = (const char *) info->hdr + sh->sh_offset;
+	const Elf_Sym *sym, *first_sym, *last_sym;
+	size_t n;
+
+	if (!info->markers_strings_sec)
+		return;
+
+	/*
+	 * First count the strings.  We look for all the symbols defined
+	 * in the __markers_strings section named __mstrtab_*.  For
+	 * these local names, the compiler puts a random .NNN suffix on,
+	 * so the names don't correspond exactly.
+	 */
+	first_sym = last_sym = NULL;
+	n = 0;
+	for (sym = info->symtab_start; sym < info->symtab_stop; sym++)
+		if (ELF_ST_TYPE(sym->st_info) == STT_OBJECT &&
+		    sym->st_shndx == info->markers_strings_sec &&
+		    !strncmp(info->strtab + sym->st_name,
+			     "__mstrtab_", sizeof "__mstrtab_" - 1)) {
+			if (first_sym == NULL)
+				first_sym = sym;
+			last_sym = sym;
+			++n;
+		}
+
+	if (n == 0)
+		return;
+
+	/*
+	 * Now collect each name and format into a line for the output.
+	 * Lines look like:
+	 *	marker_name	vmlinux	marker %s format %d
+	 * The format string after the second \t can use whitespace.
+	 */
+	mod->markers = NOFAIL(malloc(sizeof mod->markers[0] * n));
+	mod->nmarkers = n;
+
+	n = 0;
+	for (sym = first_sym; sym <= last_sym; sym++)
+		if (ELF_ST_TYPE(sym->st_info) == STT_OBJECT &&
+		    sym->st_shndx == info->markers_strings_sec &&
+		    !strncmp(info->strtab + sym->st_name,
+			     "__mstrtab_", sizeof "__mstrtab_" - 1)) {
+			const char *name = strings + sym->st_value;
+			const char *fmt = strchr(name, '\0') + 1;
+			char *line = NULL;
+			asprintf(&line, "%s\t%s\t%s\n", name, mod->name, fmt);
+			NOFAIL(line);
+			mod->markers[n++] = line;
+		}
+}
+
 static void read_symbols(char *modname)
 {
 	const char *symname;
@@ -1521,6 +1581,8 @@ static void read_symbols(char *modname)
 		get_src_version(modname, mod->srcversion,
 				sizeof(mod->srcversion)-1);
 
+	get_markers(&info, mod);
+
 	parse_elf_finish(&info);
 
 	/* Our trick to get versioning for struct_module - it's
@@ -1867,16 +1929,104 @@ static void write_dump(const char *fname
 	write_if_changed(&buf, fname);
 }
 
+static void add_marker(struct module *mod, const char *name, const char *fmt)
+{
+	char *line = NULL;
+	asprintf(&line, "%s\t%s\t%s\n", name, mod->name, fmt);
+	NOFAIL(line);
+
+	mod->markers = NOFAIL(realloc(mod->markers, ((mod->nmarkers + 1) *
+						     sizeof mod->markers[0])));
+	mod->markers[mod->nmarkers++] = line;
+}
+
+static void read_markers(const char *fname)
+{
+	unsigned long size, pos = 0;
+	void *file = grab_file(fname, &size);
+	char *line;
+
+	if (!file)		/* No old markers, silently ignore */
+		return;
+
+	while ((line = get_next_line(&pos, file, size))) {
+		char *marker, *modname, *fmt;
+		struct module *mod;
+
+		marker = line;
+		modname = strchr(marker, '\t');
+		if (!modname)
+			goto fail;
+		*modname++ = '\0';
+		fmt = strchr(modname, '\t');
+		if (!fmt)
+			goto fail;
+		*fmt++ = '\0';
+		if (*marker == '\0' || *modname == '\0')
+			goto fail;
+
+		mod = find_module(modname);
+		if (!mod) {
+			if (is_vmlinux(modname))
+				have_vmlinux = 1;
+			mod = new_module(NOFAIL(strdup(modname)));
+			mod->skip = 1;
+		}
+
+		add_marker(mod, marker, fmt);
+	}
+	return;
+fail:
+	fatal("parse error in markers list file\n");
+}
+
+static int compare_strings(const void *a, const void *b)
+{
+	return strcmp(*(const char **) a, *(const char **) b);
+}
+
+static void write_markers(const char *fname)
+{
+	struct buffer buf = { };
+	struct module *mod;
+	size_t i;
+
+	for (mod = modules; mod; mod = mod->next)
+		if ((!external_module || !mod->skip) && mod->markers != NULL) {
+			/*
+			 * Sort the strings so we can skip duplicates when
+			 * we write them out.
+			 */
+			qsort(mod->markers, mod->nmarkers,
+			      sizeof mod->markers[0], &compare_strings);
+			for (i = 0; i < mod->nmarkers; ++i) {
+				char *line = mod->markers[i];
+				buf_write(&buf, line, strlen(line));
+				while (i + 1 < mod->nmarkers &&
+				       !strcmp(mod->markers[i],
+					       mod->markers[i + 1]))
+					free(mod->markers[i++]);
+				free(mod->markers[i]);
+			}
+			free(mod->markers);
+			mod->markers = NULL;
+		}
+
+	write_if_changed(&buf, fname);
+}
+
 int main(int argc, char **argv)
 {
 	struct module *mod;
 	struct buffer buf = { };
 	char *kernel_read = NULL, *module_read = NULL;
 	char *dump_write = NULL;
+	char *markers_read = NULL;
+	char *markers_write = NULL;
 	int opt;
 	int err;
 
-	while ((opt = getopt(argc, argv, "i:I:msSo:aw")) != -1) {
+	while ((opt = getopt(argc, argv, "i:I:msSo:awM:K:")) != -1) {
 		switch (opt) {
 		case 'i':
 			kernel_read = optarg;
@@ -1903,6 +2053,12 @@ int main(int argc, char **argv)
 		case 'w':
 			warn_unresolved = 1;
 			break;
+			case 'M':
+				markers_write = optarg;
+				break;
+			case 'K':
+				markers_read = optarg;
+				break;
 		default:
 			exit(1);
 		}
@@ -1950,5 +2106,11 @@ int main(int argc, char **argv)
 		     "'make CONFIG_DEBUG_SECTION_MISMATCH=y'\n",
 		     sec_mismatch_count);
 
+	if (markers_read)
+		read_markers(markers_read);
+
+	if (markers_write)
+		write_markers(markers_write);
+
 	return err;
 }
diff -puN scripts/mod/modpost.h~linux-kernel-markers-create-modpost-file scripts/mod/modpost.h
--- a/scripts/mod/modpost.h~linux-kernel-markers-create-modpost-file
+++ a/scripts/mod/modpost.h
@@ -112,6 +112,8 @@ struct module {
 	int has_init;
 	int has_cleanup;
 	struct buffer dev_table_buf;
+	char **markers;
+	size_t nmarkers;
 	char	     srcversion[25];
 };
 
@@ -126,6 +128,7 @@ struct elf_info {
 	Elf_Section  export_gpl_sec;
 	Elf_Section  export_unused_gpl_sec;
 	Elf_Section  export_gpl_future_sec;
+	Elf_Section  markers_strings_sec;
 	const char   *strtab;
 	char	     *modinfo;
 	unsigned int modinfo_len;
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
fix-module_update_markers-compile-error.patch
git-sched.patch
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
