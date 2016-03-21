From: akpm@linux-foundation.org
Subject: [merged]
 tools-vm-page-typesc-add-memory-cgroup-dumping-and-filtering.patch removed
 from -mm tree
Date: Mon, 21 Mar 2016 11:38:39 -0700
Message-ID: <56f03faf.nXRDqOC7dzVVCRyZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53446 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757587AbcCUT4N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koct9i@gmail.com, n-horiguchi@ah.jp.nec.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page-types.c: add memory cgroup dumping and filtering
has been removed from the -mm tree.  Its filename was
     tools-vm-page-typesc-add-memory-cgroup-dumping-and-filtering.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: tools/vm/page-types.c: add memory cgroup dumping and filtering

This adds two command line keys:

 -c|--cgroup path|@inode	Walk only pages owned by this memory cgroup
 -C|--list-cgroup		Show memory cgroup inodes

[vdavydov@virtuozzo.com: opt_cgroup should be uint64_t.  Fix conflicts with "tools/vm/page-types.c: support swap entry"]
Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page-types.c |   99 +++++++++++++++++++++++++++++++++-------
 1 file changed, 84 insertions(+), 15 deletions(-)

diff -puN tools/vm/page-types.c~tools-vm-page-typesc-add-memory-cgroup-dumping-and-filtering tools/vm/page-types.c
--- a/tools/vm/page-types.c~tools-vm-page-typesc-add-memory-cgroup-dumping-and-filtering
+++ a/tools/vm/page-types.c
@@ -75,6 +75,7 @@
 
 #define KPF_BYTES		8
 #define PROC_KPAGEFLAGS		"/proc/kpageflags"
+#define PROC_KPAGECGROUP	"/proc/kpagecgroup"
 
 /* [32-] kernel hacking assistances */
 #define KPF_RESERVED		32
@@ -168,7 +169,9 @@ static int		opt_raw;	/* for kernel devel
 static int		opt_list;	/* list pages (in ranges) */
 static int		opt_no_summary;	/* don't show summary */
 static pid_t		opt_pid;	/* process to walk */
-const char *		opt_file;
+const char *		opt_file;	/* file or directory path */
+static uint64_t		opt_cgroup;	/* cgroup inode */
+static int		opt_list_cgroup;/* list page cgroup */
 
 #define MAX_ADDR_RANGES	1024
 static int		nr_addr_ranges;
@@ -189,6 +192,7 @@ static int		page_size;
 
 static int		pagemap_fd;
 static int		kpageflags_fd;
+static int		kpagecgroup_fd = -1;
 
 static int		opt_hwpoison;
 static int		opt_unpoison;
@@ -282,6 +286,16 @@ static unsigned long kpageflags_read(uin
 	return do_u64_read(kpageflags_fd, PROC_KPAGEFLAGS, buf, index, pages);
 }
 
+static unsigned long kpagecgroup_read(uint64_t *buf,
+				      unsigned long index,
+				      unsigned long pages)
+{
+	if (kpagecgroup_fd < 0)
+		return pages;
+
+	return do_u64_read(kpagecgroup_fd, PROC_KPAGEFLAGS, buf, index, pages);
+}
+
 static unsigned long pagemap_read(uint64_t *buf,
 				  unsigned long index,
 				  unsigned long pages)
@@ -354,14 +368,15 @@ static char *page_flag_longname(uint64_t
  */
 
 static void show_page_range(unsigned long voffset, unsigned long offset,
-			    unsigned long size, uint64_t flags)
+			    unsigned long size, uint64_t flags, uint64_t cgroup)
 {
 	static uint64_t      flags0;
+	static uint64_t	     cgroup0;
 	static unsigned long voff;
 	static unsigned long index;
 	static unsigned long count;
 
-	if (flags == flags0 && offset == index + count &&
+	if (flags == flags0 && cgroup == cgroup0 && offset == index + count &&
 	    size && voffset == voff + count) {
 		count += size;
 		return;
@@ -372,11 +387,14 @@ static void show_page_range(unsigned lon
 			printf("%lx\t", voff);
 		if (opt_file)
 			printf("%lu\t", voff);
+		if (opt_list_cgroup)
+			printf("@%llu\t", (unsigned long long)cgroup0);
 		printf("%lx\t%lx\t%s\n",
 				index, count, page_flag_name(flags0));
 	}
 
 	flags0 = flags;
+	cgroup0= cgroup;
 	index  = offset;
 	voff   = voffset;
 	count  = size;
@@ -384,16 +402,18 @@ static void show_page_range(unsigned lon
 
 static void flush_page_range(void)
 {
-	show_page_range(0, 0, 0, 0);
+	show_page_range(0, 0, 0, 0, 0);
 }
 
-static void show_page(unsigned long voffset,
-		      unsigned long offset, uint64_t flags)
+static void show_page(unsigned long voffset, unsigned long offset,
+		      uint64_t flags, uint64_t cgroup)
 {
 	if (opt_pid)
 		printf("%lx\t", voffset);
 	if (opt_file)
 		printf("%lu\t", voffset);
+	if (opt_list_cgroup)
+		printf("@%llu\t", (unsigned long long)cgroup);
 	printf("%lx\t%s\n", offset, page_flag_name(flags));
 }
 
@@ -576,23 +596,26 @@ static size_t hash_slot(uint64_t flags)
 	exit(EXIT_FAILURE);
 }
 
-static void add_page(unsigned long voffset,
-		     unsigned long offset, uint64_t flags, uint64_t pme)
+static void add_page(unsigned long voffset, unsigned long offset,
+		     uint64_t flags, uint64_t cgroup, uint64_t pme)
 {
 	flags = kpageflags_flags(flags, pme);
 
 	if (!bit_mask_ok(flags))
 		return;
 
+	if (opt_cgroup && cgroup != (uint64_t)opt_cgroup)
+		return;
+
 	if (opt_hwpoison)
 		hwpoison_page(offset);
 	if (opt_unpoison)
 		unpoison_page(offset);
 
 	if (opt_list == 1)
-		show_page_range(voffset, offset, 1, flags);
+		show_page_range(voffset, offset, 1, flags, cgroup);
 	else if (opt_list == 2)
-		show_page(voffset, offset, flags);
+		show_page(voffset, offset, flags, cgroup);
 
 	nr_pages[hash_slot(flags)]++;
 	total_pages++;
@@ -605,18 +628,24 @@ static void walk_pfn(unsigned long voffs
 		     uint64_t pme)
 {
 	uint64_t buf[KPAGEFLAGS_BATCH];
+	uint64_t cgi[KPAGEFLAGS_BATCH];
 	unsigned long batch;
 	unsigned long pages;
 	unsigned long i;
 
+	memset(cgi, 0, sizeof cgi);
+
 	while (count) {
 		batch = min_t(unsigned long, count, KPAGEFLAGS_BATCH);
 		pages = kpageflags_read(buf, index, batch);
 		if (pages == 0)
 			break;
 
+		if (kpagecgroup_read(cgi, index, pages) != pages)
+			fatal("kpagecgroup returned fewer pages than expected");
+
 		for (i = 0; i < pages; i++)
-			add_page(voffset + i, index + i, buf[i], pme);
+			add_page(voffset + i, index + i, buf[i], cgi[i], pme);
 
 		index += pages;
 		count -= pages;
@@ -630,10 +659,13 @@ static void walk_swap(unsigned long voff
 	if (!bit_mask_ok(flags))
 		return;
 
+	if (opt_cgroup)
+		return;
+
 	if (opt_list == 1)
-		show_page_range(voffset, pagemap_swap_offset(pme), 1, flags);
+		show_page_range(voffset, pagemap_swap_offset(pme), 1, flags, 0);
 	else if (opt_list == 2)
-		show_page(voffset, pagemap_swap_offset(pme), flags);
+		show_page(voffset, pagemap_swap_offset(pme), flags, 0);
 
 	nr_pages[hash_slot(flags)]++;
 	total_pages++;
@@ -741,10 +773,12 @@ static void usage(void)
 "            -d|--describe flags        Describe flags\n"
 "            -a|--addr    addr-spec     Walk a range of pages\n"
 "            -b|--bits    bits-spec     Walk pages with specified bits\n"
+"            -c|--cgroup  path|@inode   Walk pages within memory cgroup\n"
 "            -p|--pid     pid           Walk process address space\n"
 "            -f|--file    filename      Walk file address space\n"
 "            -l|--list                  Show page details in ranges\n"
 "            -L|--list-each             Show page details one by one\n"
+"            -C|--list-cgroup           Show cgroup inode for pages\n"
 "            -N|--no-summary            Don't show summary info\n"
 "            -X|--hwpoison              hwpoison pages\n"
 "            -x|--unpoison              unpoison pages\n"
@@ -879,6 +913,7 @@ static void walk_file(const char *name,
 {
 	uint8_t vec[PAGEMAP_BATCH];
 	uint64_t buf[PAGEMAP_BATCH], flags;
+	uint64_t cgroup = 0;
 	unsigned long nr_pages, pfn, i;
 	off_t off, end = st->st_size;
 	int fd;
@@ -936,12 +971,15 @@ got_sigbus:
 				continue;
 			if (!kpageflags_read(&flags, pfn, 1))
 				continue;
+			if (!kpagecgroup_read(&cgroup, pfn, 1))
+				fatal("kpagecgroup_read failed");
 			if (first && opt_list) {
 				first = 0;
 				flush_page_range();
 				show_file(name, st);
 			}
-			add_page(off / page_size + i, pfn, flags, buf[i]);
+			add_page(off / page_size + i, pfn,
+				 flags, cgroup, buf[i]);
 		}
 	}
 
@@ -993,6 +1031,24 @@ static void parse_file(const char *name)
 	opt_file = name;
 }
 
+static void parse_cgroup(const char *path)
+{
+	if (path[0] == '@') {
+		opt_cgroup = parse_number(path + 1);
+		return;
+	}
+
+	struct stat st;
+
+	if (stat(path, &st))
+		fatal("stat failed: %s: %m\n", path);
+
+	if (!S_ISDIR(st.st_mode))
+		fatal("cgroup supposed to be a directory: %s\n", path);
+
+	opt_cgroup = st.st_ino;
+}
+
 static void parse_addr_range(const char *optarg)
 {
 	unsigned long offset;
@@ -1116,9 +1172,11 @@ static const struct option opts[] = {
 	{ "file"      , 1, NULL, 'f' },
 	{ "addr"      , 1, NULL, 'a' },
 	{ "bits"      , 1, NULL, 'b' },
+	{ "cgroup"    , 1, NULL, 'c' },
 	{ "describe"  , 1, NULL, 'd' },
 	{ "list"      , 0, NULL, 'l' },
 	{ "list-each" , 0, NULL, 'L' },
+	{ "list-cgroup", 0, NULL, 'C' },
 	{ "no-summary", 0, NULL, 'N' },
 	{ "hwpoison"  , 0, NULL, 'X' },
 	{ "unpoison"  , 0, NULL, 'x' },
@@ -1133,7 +1191,7 @@ int main(int argc, char *argv[])
 	page_size = getpagesize();
 
 	while ((c = getopt_long(argc, argv,
-				"rp:f:a:b:d:lLNXxh", opts, NULL)) != -1) {
+				"rp:f:a:b:d:c:ClLNXxh", opts, NULL)) != -1) {
 		switch (c) {
 		case 'r':
 			opt_raw = 1;
@@ -1150,6 +1208,12 @@ int main(int argc, char *argv[])
 		case 'b':
 			parse_bits_mask(optarg);
 			break;
+		case 'c':
+			parse_cgroup(optarg);
+			break;
+		case 'C':
+			opt_list_cgroup = 1;
+			break;
 		case 'd':
 			describe_flags(optarg);
 			exit(0);
@@ -1179,10 +1243,15 @@ int main(int argc, char *argv[])
 		}
 	}
 
+	if (opt_cgroup || opt_list_cgroup)
+		kpagecgroup_fd = checked_open(PROC_KPAGECGROUP, O_RDONLY);
+
 	if (opt_list && opt_pid)
 		printf("voffset\t");
 	if (opt_list && opt_file)
 		printf("foffset\t");
+	if (opt_list && opt_list_cgroup)
+		printf("cgroup\t");
 	if (opt_list == 1)
 		printf("offset\tlen\tflags\n");
 	if (opt_list == 2)
_

Patches currently in -mm which might be from koct9i@gmail.com are


