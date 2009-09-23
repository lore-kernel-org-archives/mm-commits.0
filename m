From: akpm@linux-foundation.org
Subject: [merged] kbuild-add-static-to-prototypes.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:04:17 -0700
Message-ID: <200909232004.n8NK4HAY020974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753900AbZIWUE5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:04:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tsrk@tsrk.net, sam@ravnborg.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     kbuild: add static to prototypes
has been removed from the -mm tree.  Its filename was
     kbuild-add-static-to-prototypes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kbuild: add static to prototypes
From: Trevor Keith <tsrk@tsrk.net>

Warnings found via gcc -Wmissing-prototypes.

Signed-off-by: Trevor Keith <tsrk@tsrk.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/basic/docproc.c     |   34 +++++++++++++++++-----------------
 scripts/basic/fixdep.c      |   26 +++++++++++++-------------
 scripts/basic/hash.c        |    4 ++--
 scripts/kconfig/conf.c      |    2 +-
 scripts/kconfig/confdata.c  |    2 +-
 scripts/kconfig/expr.c      |    4 ++--
 scripts/kconfig/kxgettext.c |    4 ++--
 scripts/kconfig/menu.c      |    4 ++--
 scripts/kconfig/symbol.c    |    6 +++---
 9 files changed, 43 insertions(+), 43 deletions(-)

diff -puN scripts/basic/docproc.c~kbuild-add-static-to-prototypes scripts/basic/docproc.c
--- a/scripts/basic/docproc.c~kbuild-add-static-to-prototypes
+++ a/scripts/basic/docproc.c
@@ -71,7 +71,7 @@ FILELINE * docsection;
 
 static char *srctree, *kernsrctree;
 
-void usage (void)
+static void usage (void)
 {
 	fprintf(stderr, "Usage: docproc {doc|depend} file\n");
 	fprintf(stderr, "Input is read from file.tmpl. Output is sent to stdout\n");
@@ -84,7 +84,7 @@ void usage (void)
 /*
  * Execute kernel-doc with parameters given in svec
  */
-void exec_kernel_doc(char **svec)
+static void exec_kernel_doc(char **svec)
 {
 	pid_t pid;
 	int ret;
@@ -129,7 +129,7 @@ struct symfile
 struct symfile symfilelist[MAXFILES];
 int symfilecnt = 0;
 
-void add_new_symbol(struct symfile *sym, char * symname)
+static void add_new_symbol(struct symfile *sym, char * symname)
 {
 	sym->symbollist =
           realloc(sym->symbollist, (sym->symbolcnt + 1) * sizeof(char *));
@@ -137,14 +137,14 @@ void add_new_symbol(struct symfile *sym,
 }
 
 /* Add a filename to the list */
-struct symfile * add_new_file(char * filename)
+static struct symfile * add_new_file(char * filename)
 {
 	symfilelist[symfilecnt++].filename = strdup(filename);
 	return &symfilelist[symfilecnt - 1];
 }
 
 /* Check if file already are present in the list */
-struct symfile * filename_exist(char * filename)
+static struct symfile * filename_exist(char * filename)
 {
 	int i;
 	for (i=0; i < symfilecnt; i++)
@@ -157,20 +157,20 @@ struct symfile * filename_exist(char * f
  * List all files referenced within the template file.
  * Files are separated by tabs.
  */
-void adddep(char * file)		   { printf("\t%s", file); }
-void adddep2(char * file, char * line)     { line = line; adddep(file); }
-void noaction(char * line)		   { line = line; }
-void noaction2(char * file, char * line)   { file = file; line = line; }
+static void adddep(char * file)		   { printf("\t%s", file); }
+static void adddep2(char * file, char * line)     { line = line; adddep(file); }
+static void noaction(char * line)		   { line = line; }
+static void noaction2(char * file, char * line)   { file = file; line = line; }
 
 /* Echo the line without further action */
-void printline(char * line)               { printf("%s", line); }
+static void printline(char * line)               { printf("%s", line); }
 
 /*
  * Find all symbols in filename that are exported with EXPORT_SYMBOL &
  * EXPORT_SYMBOL_GPL (& EXPORT_SYMBOL_GPL_FUTURE implicitly).
  * All symbols located are stored in symfilelist.
  */
-void find_export_symbols(char * filename)
+static void find_export_symbols(char * filename)
 {
 	FILE * fp;
 	struct symfile *sym;
@@ -227,7 +227,7 @@ void find_export_symbols(char * filename
  * intfunc uses -nofunction
  * extfunc uses -function
  */
-void docfunctions(char * filename, char * type)
+static void docfunctions(char * filename, char * type)
 {
 	int i,j;
 	int symcnt = 0;
@@ -258,15 +258,15 @@ void docfunctions(char * filename, char 
 	fflush(stdout);
 	free(vec);
 }
-void intfunc(char * filename) {	docfunctions(filename, NOFUNCTION); }
-void extfunc(char * filename) { docfunctions(filename, FUNCTION);   }
+static void intfunc(char * filename) {	docfunctions(filename, NOFUNCTION); }
+static void extfunc(char * filename) { docfunctions(filename, FUNCTION);   }
 
 /*
  * Document specific function(s) in a file.
  * Call kernel-doc with the following parameters:
  * kernel-doc -docbook -function function1 [-function function2]
  */
-void singfunc(char * filename, char * line)
+static void singfunc(char * filename, char * line)
 {
 	char *vec[200]; /* Enough for specific functions */
         int i, idx = 0;
@@ -297,7 +297,7 @@ void singfunc(char * filename, char * li
  * Call kernel-doc with the following parameters:
  * kernel-doc -docbook -function "doc section" filename
  */
-void docsect(char *filename, char *line)
+static void docsect(char *filename, char *line)
 {
 	char *vec[6]; /* kerneldoc -docbook -function "section" file NULL */
 	char *s;
@@ -324,7 +324,7 @@ void docsect(char *filename, char *line)
  * 5) Lines containing !P
  * 6) Default lines - lines not matching the above
  */
-void parse_file(FILE *infile)
+static void parse_file(FILE *infile)
 {
 	char line[MAXLINESZ];
 	char * s;
diff -puN scripts/basic/fixdep.c~kbuild-add-static-to-prototypes scripts/basic/fixdep.c
--- a/scripts/basic/fixdep.c~kbuild-add-static-to-prototypes
+++ a/scripts/basic/fixdep.c
@@ -124,7 +124,7 @@ char *target;
 char *depfile;
 char *cmdline;
 
-void usage(void)
+static void usage(void)
 {
 	fprintf(stderr, "Usage: fixdep <depfile> <target> <cmdline>\n");
 	exit(1);
@@ -133,7 +133,7 @@ void usage(void)
 /*
  * Print out the commandline prefixed with cmd_<target filename> :=
  */
-void print_cmdline(void)
+static void print_cmdline(void)
 {
 	printf("cmd_%s := %s\n\n", target, cmdline);
 }
@@ -146,7 +146,7 @@ int    len_config  = 0;
  * Grow the configuration string to a desired length.
  * Usually the first growth is plenty.
  */
-void grow_config(int len)
+static void grow_config(int len)
 {
 	while (len_config + len > size_config) {
 		if (size_config == 0)
@@ -162,7 +162,7 @@ void grow_config(int len)
 /*
  * Lookup a value in the configuration string.
  */
-int is_defined_config(const char * name, int len)
+static int is_defined_config(const char * name, int len)
 {
 	const char * pconfig;
 	const char * plast = str_config + len_config - len;
@@ -178,7 +178,7 @@ int is_defined_config(const char * name,
 /*
  * Add a new value to the configuration string.
  */
-void define_config(const char * name, int len)
+static void define_config(const char * name, int len)
 {
 	grow_config(len + 1);
 
@@ -190,7 +190,7 @@ void define_config(const char * name, in
 /*
  * Clear the set of configuration strings.
  */
-void clear_config(void)
+static void clear_config(void)
 {
 	len_config = 0;
 	define_config("", 0);
@@ -199,7 +199,7 @@ void clear_config(void)
 /*
  * Record the use of a CONFIG_* word.
  */
-void use_config(char *m, int slen)
+static void use_config(char *m, int slen)
 {
 	char s[PATH_MAX];
 	char *p;
@@ -220,7 +220,7 @@ void use_config(char *m, int slen)
 	printf("    $(wildcard include/config/%s.h) \\\n", s);
 }
 
-void parse_config_file(char *map, size_t len)
+static void parse_config_file(char *map, size_t len)
 {
 	int *end = (int *) (map + len);
 	/* start at +1, so that p can never be < map */
@@ -254,7 +254,7 @@ void parse_config_file(char *map, size_t
 }
 
 /* test is s ends in sub */
-int strrcmp(char *s, char *sub)
+static int strrcmp(char *s, char *sub)
 {
 	int slen = strlen(s);
 	int sublen = strlen(sub);
@@ -265,7 +265,7 @@ int strrcmp(char *s, char *sub)
 	return memcmp(s + slen - sublen, sub, sublen);
 }
 
-void do_config_file(char *filename)
+static void do_config_file(char *filename)
 {
 	struct stat st;
 	int fd;
@@ -296,7 +296,7 @@ void do_config_file(char *filename)
 	close(fd);
 }
 
-void parse_dep_file(void *map, size_t len)
+static void parse_dep_file(void *map, size_t len)
 {
 	char *m = map;
 	char *end = m + len;
@@ -336,7 +336,7 @@ void parse_dep_file(void *map, size_t le
 	printf("$(deps_%s):\n", target);
 }
 
-void print_deps(void)
+static void print_deps(void)
 {
 	struct stat st;
 	int fd;
@@ -368,7 +368,7 @@ void print_deps(void)
 	close(fd);
 }
 
-void traps(void)
+static void traps(void)
 {
 	static char test[] __attribute__((aligned(sizeof(int)))) = "CONF";
 	int *p = (int *)test;
diff -puN scripts/basic/hash.c~kbuild-add-static-to-prototypes scripts/basic/hash.c
--- a/scripts/basic/hash.c~kbuild-add-static-to-prototypes
+++ a/scripts/basic/hash.c
@@ -21,7 +21,7 @@ static void usage(void)
  * http://www.cse.yorku.ca/~oz/hash.html
  */
 
-unsigned int djb2_hash(char *str)
+static unsigned int djb2_hash(char *str)
 {
 	unsigned long hash = 5381;
 	int c;
@@ -34,7 +34,7 @@ unsigned int djb2_hash(char *str)
 	return (unsigned int)(hash & ((1 << DYNAMIC_DEBUG_HASH_BITS) - 1));
 }
 
-unsigned int r5_hash(char *str)
+static unsigned int r5_hash(char *str)
 {
 	unsigned long hash = 0;
 	int c;
diff -puN scripts/kconfig/conf.c~kbuild-add-static-to-prototypes scripts/kconfig/conf.c
--- a/scripts/kconfig/conf.c~kbuild-add-static-to-prototypes
+++ a/scripts/kconfig/conf.c
@@ -121,7 +121,7 @@ static int conf_askvalue(struct symbol *
 	return 1;
 }
 
-int conf_string(struct menu *menu)
+static int conf_string(struct menu *menu)
 {
 	struct symbol *sym = menu->sym;
 	const char *def;
diff -puN scripts/kconfig/confdata.c~kbuild-add-static-to-prototypes scripts/kconfig/confdata.c
--- a/scripts/kconfig/confdata.c~kbuild-add-static-to-prototypes
+++ a/scripts/kconfig/confdata.c
@@ -560,7 +560,7 @@ int conf_write(const char *name)
 	return 0;
 }
 
-int conf_split_config(void)
+static int conf_split_config(void)
 {
 	const char *name;
 	char path[128];
diff -puN scripts/kconfig/expr.c~kbuild-add-static-to-prototypes scripts/kconfig/expr.c
--- a/scripts/kconfig/expr.c~kbuild-add-static-to-prototypes
+++ a/scripts/kconfig/expr.c
@@ -348,7 +348,7 @@ struct expr *expr_trans_bool(struct expr
 /*
  * e1 || e2 -> ?
  */
-struct expr *expr_join_or(struct expr *e1, struct expr *e2)
+static struct expr *expr_join_or(struct expr *e1, struct expr *e2)
 {
 	struct expr *tmp;
 	struct symbol *sym1, *sym2;
@@ -412,7 +412,7 @@ struct expr *expr_join_or(struct expr *e
 	return NULL;
 }
 
-struct expr *expr_join_and(struct expr *e1, struct expr *e2)
+static struct expr *expr_join_and(struct expr *e1, struct expr *e2)
 {
 	struct expr *tmp;
 	struct symbol *sym1, *sym2;
diff -puN scripts/kconfig/kxgettext.c~kbuild-add-static-to-prototypes scripts/kconfig/kxgettext.c
--- a/scripts/kconfig/kxgettext.c~kbuild-add-static-to-prototypes
+++ a/scripts/kconfig/kxgettext.c
@@ -166,7 +166,7 @@ static int message__add(const char *msg,
 	return rc;
 }
 
-void menu_build_message_list(struct menu *menu)
+static void menu_build_message_list(struct menu *menu)
 {
 	struct menu *child;
 
@@ -211,7 +211,7 @@ static void message__print_gettext_msgid
 	       "msgstr \"\"\n", self->msg);
 }
 
-void menu__xgettext(void)
+static void menu__xgettext(void)
 {
 	struct message *m = message__list;
 
diff -puN scripts/kconfig/menu.c~kbuild-add-static-to-prototypes scripts/kconfig/menu.c
--- a/scripts/kconfig/menu.c~kbuild-add-static-to-prototypes
+++ a/scripts/kconfig/menu.c
@@ -77,7 +77,7 @@ void menu_end_menu(void)
 	current_menu = current_menu->parent;
 }
 
-struct expr *menu_check_dep(struct expr *e)
+static struct expr *menu_check_dep(struct expr *e)
 {
 	if (!e)
 		return e;
@@ -187,7 +187,7 @@ static int menu_range_valid_sym(struct s
 	       (sym2->type == S_UNKNOWN && sym_string_valid(sym, sym2->name));
 }
 
-void sym_check_prop(struct symbol *sym)
+static void sym_check_prop(struct symbol *sym)
 {
 	struct property *prop;
 	struct symbol *sym2;
diff -puN scripts/kconfig/symbol.c~kbuild-add-static-to-prototypes scripts/kconfig/symbol.c
--- a/scripts/kconfig/symbol.c~kbuild-add-static-to-prototypes
+++ a/scripts/kconfig/symbol.c
@@ -36,7 +36,7 @@ tristate modules_val;
 
 struct expr *sym_env_list;
 
-void sym_add_default(struct symbol *sym, const char *def)
+static void sym_add_default(struct symbol *sym, const char *def)
 {
 	struct property *prop = prop_alloc(P_DEFAULT, sym);
 
@@ -125,7 +125,7 @@ struct property *sym_get_default_prop(st
 	return NULL;
 }
 
-struct property *sym_get_range_prop(struct symbol *sym)
+static struct property *sym_get_range_prop(struct symbol *sym)
 {
 	struct property *prop;
 
@@ -943,7 +943,7 @@ const char *prop_get_type_name(enum prop
 	return "unknown";
 }
 
-void prop_add_env(const char *env)
+static void prop_add_env(const char *env)
 {
 	struct symbol *sym, *sym2;
 	struct property *prop;
_

Patches currently in -mm which might be from tsrk@tsrk.net are

origin.patch
linux-next.patch

