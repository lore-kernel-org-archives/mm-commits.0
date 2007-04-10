From: akpm@linux-foundation.org
Subject: + slub-add-slabinfo-tool-update-slabinfoc.patch added to -mm tree
Date: Mon, 09 Apr 2007 22:31:57 -0700
Message-ID: <200704100531.l3A5VvYa032326@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44898 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966102AbXDJFb7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 01:31:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     slub: update slabinfo.c
has been added to the -mm tree.  Its filename is
     slub-add-slabinfo-tool-update-slabinfoc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slub: update slabinfo.c
From: Christoph Lameter <clameter@sgi.com>

This adds a lot of new functionality including display of NUMA information,
tracking information, slab verification etc. Some of those will only be
supported in V7.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/slabinfo.c |  223 ++++++++++++++++++++++++++++++----
 1 file changed, 199 insertions(+), 24 deletions(-)

diff -puN Documentation/vm/slabinfo.c~slub-add-slabinfo-tool-update-slabinfoc Documentation/vm/slabinfo.c
--- a/Documentation/vm/slabinfo.c~slub-add-slabinfo-tool-update-slabinfoc
+++ a/Documentation/vm/slabinfo.c
@@ -14,16 +14,23 @@
 #include <string.h>
 #include <unistd.h>
 #include <stdarg.h>
+#include <getopt.h>
+#include <regex.h>
 
-char buffer[200];
+char buffer[4096];
 
 int show_alias = 0;
-int show_slab = 1;
-int show_parameter = 0;
+int show_slab = 0;
+int show_parameters = 0;
 int skip_zero = 1;
+int show_numa = 0;
+int show_track = 0;
+int validate = 0;
 
 int page_size;
 
+regex_t pattern;
+
 void fatal(const char *x, ...)
 {
 	va_list ap;
@@ -34,23 +41,71 @@ void fatal(const char *x, ...)
 	exit(1);
 }
 
+void usage(void)
+{
+	printf("slabinfo [-ahnpvtsz] [slab-regexp]\n"
+		"-a|--aliases           Show aliases\n"
+		"-h|--help              Show usage information\n"
+		"-n|--numa              Show NUMA information\n"
+		"-p|--parameters        Show global parameters\n"
+		"-v|--validate          Validate slabs\n"
+		"-t|--tracking          Show alloc/free information\n"
+		"-s|--slabs             Show slabs\n"
+		"-z|--zero              Include empty slabs\n"
+	);
+}
+
+unsigned long read_obj(char *name)
+{
+	FILE *f = fopen(name, "r");
+
+	if (!f)
+		buffer[0] = 0;
+	else {
+		if (!fgets(buffer,sizeof(buffer), f))
+			buffer[0] = 0;
+		fclose(f);
+		if (buffer[strlen(buffer)] == '\n')
+			buffer[strlen(buffer)] = 0;
+	}
+	return strlen(buffer);
+}
+
+
 /*
  * Get the contents of an attribute
  */
 unsigned long get_obj(char *name)
 {
-	FILE *f = fopen(name, "r");
+	if (!read_obj(name))
+		return 0;
+
+	return atol(buffer);
+}
+
+unsigned long get_obj_and_str(char *name, char **x)
+{
 	unsigned long result = 0;
 
-	if (!f) {
-		getcwd(buffer, sizeof(buffer));
-		fatal("Cannot open file '%s/%s'\n", buffer, name);
+	if (!read_obj(name)) {
+		x = NULL;
+		return 0;
 	}
+	result = strtoul(buffer, x, 10);
+	while (**x == ' ')
+		(*x)++;
+	return result;
+}
+
+void set_obj(char *name, int n)
+{
+	FILE *f = fopen(name, "w");
 
-	if (fgets(buffer,sizeof(buffer), f))
-		result = atol(buffer);
+	if (!f)
+		fatal("Cannot write to %s\n", name);
+
+	fprintf(f, "%d\n", n);
 	fclose(f);
-	return result;
 }
 
 /*
@@ -90,12 +145,29 @@ int store_size(char *buffer, unsigned lo
 
 void alias(const char *name)
 {
-	char *target;
+	int count;
+	char *p;
 
 	if (!show_alias)
 		return;
-	/* Read link target */
-	printf("%20s -> %s", name, target);
+
+	count = readlink(name, buffer, sizeof(buffer));
+
+	if (count < 0)
+		return;
+
+	buffer[count] = 0;
+
+	p = buffer + count;
+
+	while (p > buffer && p[-1] != '/')
+		p--;
+	printf("%-20s -> %s\n", name, p);
+}
+
+void slab_validate(char *name)
+{
+	set_obj("validate", 1);
 }
 
 int line = 0;
@@ -120,9 +192,6 @@ void slab(const char *name)
 	if (!show_slab)
 		return;
 
-	if (chdir(name))
-		fatal("Unable to access slab %s\n", name);
-
 	aliases = get_obj("aliases");
 	align = get_obj("align");
 	cache_dma = get_obj("cache_dma");
@@ -144,7 +213,7 @@ void slab(const char *name)
 	trace = get_obj("trace");
 
 	if (skip_zero && !slabs)
-		goto out;
+		return;
 
 	store_size(size_str, slabs * page_size);
 	sprintf(dist_str,"%lu/%lu/%lu", slabs, partial, cpu_slabs);
@@ -172,41 +241,147 @@ void slab(const char *name)
 		*p++ = 'T';
 
 	*p = 0;
-	printf("%-20s %8ld %7d %8s %14s %3ld %1ld %3d %3d %s\n",
+	printf("%-20s %8ld %7ld %8s %14s %3ld %1ld %3ld %3ld %s\n",
 			name, objects, object_size, size_str, dist_str,
 			objs_per_slab, order,
 			slabs ? (partial * 100) / slabs : 100,
-			slabs ? (objects * object_size * 100) / (slabs * (page_size << order)) : 100,
+			slabs ? (objects * object_size * 100) /
+				(slabs * (page_size << order)) : 100,
 			flags);
-out:
-	chdir("..");
+}
+
+void slab_numa(const char *name)
+{
+	unsigned long slabs;
+	char *numainfo;
+
+	slabs = get_obj_and_str("slabs", &numainfo);
+
+	if (skip_zero && !slabs)
+		return;
+
+	printf("%-20s %s", name, numainfo);
 }
 
 void parameter(const char *name)
 {
-	if (!show_parameter)
+	if (!show_parameters)
 		return;
 }
 
+void show_tracking(const char *name)
+{
+	printf("\n%s: Calls to allocate a slab object\n", name);
+	printf("---------------------------------------------------\n");
+	if (read_obj("alloc_calls"))
+		printf(buffer);
+
+	printf("%s: Calls to free a slab object\n", name);
+	printf("-----------------------------------------------\n");
+	if (read_obj("free_calls"))
+		printf(buffer);
+
+}
+
+int slab_mismatch(char *slab)
+{
+	return regexec(&pattern, slab, 0, NULL, 0);
+}
+
+struct option opts[] = {
+	{ "aliases", 0, NULL, 'a' },
+	{ "slabs", 0, NULL, 's' },
+	{ "numa", 0, NULL, 'n' },
+	{ "parameters", 0, NULL, 'p' },
+	{ "zero", 0, NULL, 'z' },
+	{ "help", 0, NULL, 'h' },
+	{ "validate", 0, NULL, 'v' },
+	{ "track", 0, NULL, 't'},
+	{ NULL, 0, NULL, 0 }
+};
+
 int main(int argc, char *argv[])
 {
 	DIR *dir;
 	struct dirent *de;
+	int c;
+	int err;
+	char *pattern_source;
 
 	page_size = getpagesize();
 	if (chdir("/sys/slab"))
 		fatal("This kernel does not have SLUB support.\n");
 
+	while ((c = getopt_long(argc, argv, "ahtvnpsz", opts, NULL)) != -1)
+	switch(c) {
+		case 's':
+			show_slab = 1;
+			break;
+		case 'a':
+			show_alias = 1;
+			break;
+		case 'n':
+			show_numa = 1;
+			break;
+		case 'p':
+			show_parameters = 1;
+			break;
+		case 'z':
+			skip_zero = 0;
+			break;
+		case 't':
+			show_track = 1;
+			break;
+		case 'v':
+			validate = 1;
+			break;
+		case 'h':
+			usage();
+			return 0;
+
+		default:
+			fatal("%s: Invalid option '%c'\n", argv[0], optopt);
+
+	}
+
+	if (!show_slab && !show_alias && !show_parameters && !show_track
+		&& !validate)
+			show_slab = 1;
+
+	if (argc > optind)
+		pattern_source = argv[optind];
+	else
+		pattern_source = ".*";
+
+	err = regcomp(&pattern, pattern_source, REG_ICASE|REG_NOSUB);
+	if (err)
+		fatal("%s: Invalid pattern '%s' code %d\n",
+			argv[0], pattern_source, err);
+
 	dir = opendir(".");
 	while ((de = readdir(dir))) {
-		if (de->d_name[0] == '.')
+		if (de->d_name[0] == '.' ||
+				slab_mismatch(de->d_name))
 			continue;
 		switch (de->d_type) {
 		   case DT_LNK:
 			alias(de->d_name);
 			break;
 		   case DT_DIR:
-			slab(de->d_name);
+			if (chdir(de->d_name))
+				fatal("Unable to access slab %s\n", de->d_name);
+
+		   	if (show_numa)
+				slab_numa(de->d_name);
+			else
+			if (show_track)
+				show_tracking(de->d_name);
+			else
+		   	if (validate)
+				slab_validate(de->d_name);
+			else
+				slab(de->d_name);
+			chdir("..");
 			break;
 		   case DT_REG:
 			parameter(de->d_name);
_

Patches currently in -mm which might be from clameter@sgi.com are

slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
i386-use-page-allocator-to-allocate-thread_info-structure.patch
slub-core.patch
slub-fix-numa-bootstrap.patch
slub-use-correct-flags-to-check-for-dma-cache.patch
slub-treat-slab_hwcache_align-as-a-mininum-and-not-as-the-alignment.patch
slub-core-minor-fixes.patch
slub-core-use-enum-for-tracking-modes-instead-of-integers.patch
slub-core-fix-another-numa-bootstrap-issue.patch
slub-add-slabinfo-tool.patch
slub-add-slabinfo-tool-update-slabinfoc.patch
make-page-private-usable-in-compound-pages-v1.patch
make-page-private-usable-in-compound-pages-v1-hugetlb-fix.patch
optimize-compound_head-by-avoiding-a-shared-page.patch
add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
slub-fix-object-tracking.patch
quicklists-for-page-table-pages.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
quicklist-support-for-sparc64.patch
extend-print_symbol-capability-fix.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
readahead-state-based-method-aging-accounting.patch
