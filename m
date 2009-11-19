From: akpm@linux-foundation.org
Subject: + kbuild-clear-marker-out-of-modpost.patch added to -mm tree
Date: Thu, 19 Nov 2009 15:10:43 -0800
Message-ID: <200911192310.nAJNAhqQ026456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757392AbZKSXKs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Nov 2009 18:10:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wenji.huang@oracle.com, rusty@rustcorp.com.au, sam@ravnborg.org


The patch titled
     kbuild: clear marker out of modpost
has been added to the -mm tree.  Its filename is
     kbuild-clear-marker-out-of-modpost.patch

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
Subject: kbuild: clear marker out of modpost
From: Wenji Huang <wenji.huang@oracle.com>

Remove the unnecessary functions and variables.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/mod/modpost.c |  164 ----------------------------------------
 scripts/mod/modpost.h |    3 
 2 files changed, 167 deletions(-)

diff -puN scripts/mod/modpost.c~kbuild-clear-marker-out-of-modpost scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~kbuild-clear-marker-out-of-modpost
+++ a/scripts/mod/modpost.c
@@ -462,8 +462,6 @@ static int parse_elf(struct elf_info *in
 			info->export_unused_gpl_sec = i;
 		else if (strcmp(secname, "__ksymtab_gpl_future") == 0)
 			info->export_gpl_future_sec = i;
-		else if (strcmp(secname, "__markers_strings") == 0)
-			info->markers_strings_sec = i;
 
 		if (sechdrs[i].sh_type != SHT_SYMTAB)
 			continue;
@@ -1533,62 +1531,6 @@ static void check_sec_ref(struct module 
 	}
 }
 
-static void get_markers(struct elf_info *info, struct module *mod)
-{
-	const Elf_Shdr *sh = &info->sechdrs[info->markers_strings_sec];
-	const char *strings = (const char *) info->hdr + sh->sh_offset;
-	const Elf_Sym *sym, *first_sym, *last_sym;
-	size_t n;
-
-	if (!info->markers_strings_sec)
-		return;
-
-	/*
-	 * First count the strings.  We look for all the symbols defined
-	 * in the __markers_strings section named __mstrtab_*.  For
-	 * these local names, the compiler puts a random .NNN suffix on,
-	 * so the names don't correspond exactly.
-	 */
-	first_sym = last_sym = NULL;
-	n = 0;
-	for (sym = info->symtab_start; sym < info->symtab_stop; sym++)
-		if (ELF_ST_TYPE(sym->st_info) == STT_OBJECT &&
-		    sym->st_shndx == info->markers_strings_sec &&
-		    !strncmp(info->strtab + sym->st_name,
-			     "__mstrtab_", sizeof "__mstrtab_" - 1)) {
-			if (first_sym == NULL)
-				first_sym = sym;
-			last_sym = sym;
-			++n;
-		}
-
-	if (n == 0)
-		return;
-
-	/*
-	 * Now collect each name and format into a line for the output.
-	 * Lines look like:
-	 *	marker_name	vmlinux	marker %s format %d
-	 * The format string after the second \t can use whitespace.
-	 */
-	mod->markers = NOFAIL(malloc(sizeof mod->markers[0] * n));
-	mod->nmarkers = n;
-
-	n = 0;
-	for (sym = first_sym; sym <= last_sym; sym++)
-		if (ELF_ST_TYPE(sym->st_info) == STT_OBJECT &&
-		    sym->st_shndx == info->markers_strings_sec &&
-		    !strncmp(info->strtab + sym->st_name,
-			     "__mstrtab_", sizeof "__mstrtab_" - 1)) {
-			const char *name = strings + sym->st_value;
-			const char *fmt = strchr(name, '\0') + 1;
-			char *line = NULL;
-			asprintf(&line, "%s\t%s\t%s\n", name, mod->name, fmt);
-			NOFAIL(line);
-			mod->markers[n++] = line;
-		}
-}
-
 static void read_symbols(char *modname)
 {
 	const char *symname;
@@ -1644,8 +1586,6 @@ static void read_symbols(char *modname)
 		get_src_version(modname, mod->srcversion,
 				sizeof(mod->srcversion)-1);
 
-	get_markers(&info, mod);
-
 	parse_elf_finish(&info);
 
 	/* Our trick to get versioning for module struct etc. - it's
@@ -2052,96 +1992,6 @@ static void write_exports(const char *fn
 	write_if_changed(&buf, fname);
 }
 
-static void add_marker(struct module *mod, const char *name, const char *fmt)
-{
-	char *line = NULL;
-	asprintf(&line, "%s\t%s\t%s\n", name, mod->name, fmt);
-	NOFAIL(line);
-
-	mod->markers = NOFAIL(realloc(mod->markers, ((mod->nmarkers + 1) *
-						     sizeof mod->markers[0])));
-	mod->markers[mod->nmarkers++] = line;
-}
-
-static void read_markers(const char *fname)
-{
-	unsigned long size, pos = 0;
-	void *file = grab_file(fname, &size);
-	char *line;
-
-	if (!file)		/* No old markers, silently ignore */
-		return;
-
-	while ((line = get_next_line(&pos, file, size))) {
-		char *marker, *modname, *fmt;
-		struct module *mod;
-
-		marker = line;
-		modname = strchr(marker, '\t');
-		if (!modname)
-			goto fail;
-		*modname++ = '\0';
-		fmt = strchr(modname, '\t');
-		if (!fmt)
-			goto fail;
-		*fmt++ = '\0';
-		if (*marker == '\0' || *modname == '\0')
-			goto fail;
-
-		mod = find_module(modname);
-		if (!mod) {
-			mod = new_module(modname);
-			mod->skip = 1;
-		}
-		if (is_vmlinux(modname)) {
-			have_vmlinux = 1;
-			mod->skip = 0;
-		}
-
-		if (!mod->skip)
-			add_marker(mod, marker, fmt);
-	}
-	release_file(file, size);
-	return;
-fail:
-	fatal("parse error in markers list file\n");
-}
-
-static int compare_strings(const void *a, const void *b)
-{
-	return strcmp(*(const char **) a, *(const char **) b);
-}
-
-static void write_markers(const char *fname)
-{
-	struct buffer buf = { };
-	struct module *mod;
-	size_t i;
-
-	for (mod = modules; mod; mod = mod->next)
-		if ((!external_module || !mod->skip) && mod->markers != NULL) {
-			/*
-			 * Sort the strings so we can skip duplicates when
-			 * we write them out.
-			 */
-			qsort(mod->markers, mod->nmarkers,
-			      sizeof mod->markers[0], &compare_strings);
-			for (i = 0; i < mod->nmarkers; ++i) {
-				char *line = mod->markers[i];
-				buf_write(&buf, line, strlen(line));
-				while (i + 1 < mod->nmarkers &&
-				       !strcmp(mod->markers[i],
-					       mod->markers[i + 1]))
-					free(mod->markers[i++]);
-				free(mod->markers[i]);
-			}
-			free(mod->markers);
-			mod->markers = NULL;
-		}
-
-	write_if_changed(&buf, fname);
-}
-
 struct ext_sym_list {
 	struct ext_sym_list *next;
 	const char *file;
@@ -2154,8 +2004,6 @@ int main(int argc, char **argv)
 	char *kernel_read = NULL, *module_read = NULL;
 	char *dump_write = NULL;
 	char *exports_write = NULL;
-	char *markers_read = NULL;
-	char *markers_write = NULL;
 	int opt;
 	int err;
 	struct ext_sym_list *extsym_iter;
@@ -2202,12 +2050,6 @@ int main(int argc, char **argv)
 		case 'x':
 			exports_write = optarg;
 			break;
-			case 'M':
-				markers_write = optarg;
-				break;
-			case 'K':
-				markers_read = optarg;
-				break;
 		default:
 			exit(1);
 		}
@@ -2265,11 +2107,5 @@ int main(int argc, char **argv)
 	if (exports_write)
 		write_exports(exports_write);
 
-	if (markers_read)
-		read_markers(markers_read);
-
-	if (markers_write)
-		write_markers(markers_write);
-
 	return err;
 }
diff -puN scripts/mod/modpost.h~kbuild-clear-marker-out-of-modpost scripts/mod/modpost.h
--- a/scripts/mod/modpost.h~kbuild-clear-marker-out-of-modpost
+++ a/scripts/mod/modpost.h
@@ -112,8 +112,6 @@ struct module {
 	int has_init;
 	int has_cleanup;
 	struct buffer dev_table_buf;
-	char **markers;
-	size_t nmarkers;
 	char	     srcversion[25];
 };
 
@@ -128,7 +126,6 @@ struct elf_info {
 	Elf_Section  export_gpl_sec;
 	Elf_Section  export_unused_gpl_sec;
 	Elf_Section  export_gpl_future_sec;
-	Elf_Section  markers_strings_sec;
 	const char   *strtab;
 	char	     *modinfo;
 	unsigned int modinfo_len;
_

Patches currently in -mm which might be from wenji.huang@oracle.com are

kbuild-clean-up-marker.patch
kbuild-clear-marker-out-of-modpost.patch

