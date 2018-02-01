From: akpm@linux-foundation.org
Subject: [merged]
 tools-vm-new-option-to-specify-kpageflags-file.patch removed from -mm tree
Date: Thu, 01 Feb 2018 11:35:10 -0800
Message-ID: <20180201193510.YKcd8ZNvp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33380 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754606AbeBATfM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:35:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, koct9i@gmail.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, rientjes@google.com, vdavydov.dev@gmail.com


The patch titled
     Subject: tools, vm: new option to specify kpageflags file
has been removed from the -mm tree.  Its filename was
     tools-vm-new-option-to-specify-kpageflags-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: tools, vm: new option to specify kpageflags file

page-types currently hardcodes /proc/kpageflags as the file to parse. 
This works when using the tool to examine the state of pageflags on the
same system, but does not allow storing a snapshot of pageflags at a given
time to debug issues nor on a different system.

This allows the user to specify a saved version of kpageflags with a new
page-types -F option.

[akpm@linux-foundation.org: add "filename" to fix usage() string]
[rientjes@google.com: fix layout]
  Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1801301840050.140969@chino.kir.corp.google.com
Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1801301458180.153857@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page-types.c |   28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff -puN tools/vm/page-types.c~tools-vm-new-option-to-specify-kpageflags-file tools/vm/page-types.c
--- a/tools/vm/page-types.c~tools-vm-new-option-to-specify-kpageflags-file
+++ a/tools/vm/page-types.c
@@ -169,9 +169,10 @@ static int		opt_raw;	/* for kernel devel
 static int		opt_list;	/* list pages (in ranges) */
 static int		opt_no_summary;	/* don't show summary */
 static pid_t		opt_pid;	/* process to walk */
-const char *		opt_file;	/* file or directory path */
+const char		*opt_file;	/* file or directory path */
 static uint64_t		opt_cgroup;	/* cgroup inode */
 static int		opt_list_cgroup;/* list page cgroup */
+static const char	*opt_kpageflags;/* kpageflags file to parse */
 
 #define MAX_ADDR_RANGES	1024
 static int		nr_addr_ranges;
@@ -258,7 +259,7 @@ static int checked_open(const char *path
  * pagemap/kpageflags routines
  */
 
-static unsigned long do_u64_read(int fd, char *name,
+static unsigned long do_u64_read(int fd, const char *name,
 				 uint64_t *buf,
 				 unsigned long index,
 				 unsigned long count)
@@ -283,7 +284,7 @@ static unsigned long kpageflags_read(uin
 				     unsigned long index,
 				     unsigned long pages)
 {
-	return do_u64_read(kpageflags_fd, PROC_KPAGEFLAGS, buf, index, pages);
+	return do_u64_read(kpageflags_fd, opt_kpageflags, buf, index, pages);
 }
 
 static unsigned long kpagecgroup_read(uint64_t *buf,
@@ -293,7 +294,7 @@ static unsigned long kpagecgroup_read(ui
 	if (kpagecgroup_fd < 0)
 		return pages;
 
-	return do_u64_read(kpagecgroup_fd, PROC_KPAGEFLAGS, buf, index, pages);
+	return do_u64_read(kpagecgroup_fd, opt_kpageflags, buf, index, pages);
 }
 
 static unsigned long pagemap_read(uint64_t *buf,
@@ -743,7 +744,7 @@ static void walk_addr_ranges(void)
 {
 	int i;
 
-	kpageflags_fd = checked_open(PROC_KPAGEFLAGS, O_RDONLY);
+	kpageflags_fd = checked_open(opt_kpageflags, O_RDONLY);
 
 	if (!nr_addr_ranges)
 		add_addr_range(0, ULONG_MAX);
@@ -790,6 +791,7 @@ static void usage(void)
 "            -N|--no-summary            Don't show summary info\n"
 "            -X|--hwpoison              hwpoison pages\n"
 "            -x|--unpoison              unpoison pages\n"
+"            -F|--kpageflags filename   kpageflags file to parse\n"
 "            -h|--help                  Show this usage message\n"
 "flags:\n"
 "            0x10                       bitfield format, e.g.\n"
@@ -1013,7 +1015,7 @@ static void walk_page_cache(void)
 {
 	struct stat st;
 
-	kpageflags_fd = checked_open(PROC_KPAGEFLAGS, O_RDONLY);
+	kpageflags_fd = checked_open(opt_kpageflags, O_RDONLY);
 	pagemap_fd = checked_open("/proc/self/pagemap", O_RDONLY);
 	sigaction(SIGBUS, &sigbus_action, NULL);
 
@@ -1164,6 +1166,11 @@ static void parse_bits_mask(const char *
 	add_bits_filter(mask, bits);
 }
 
+static void parse_kpageflags(const char *name)
+{
+	opt_kpageflags = name;
+}
+
 static void describe_flags(const char *optarg)
 {
 	uint64_t flags = parse_flag_names(optarg, 0);
@@ -1188,6 +1195,7 @@ static const struct option opts[] = {
 	{ "no-summary", 0, NULL, 'N' },
 	{ "hwpoison"  , 0, NULL, 'X' },
 	{ "unpoison"  , 0, NULL, 'x' },
+	{ "kpageflags", 0, NULL, 'F' },
 	{ "help"      , 0, NULL, 'h' },
 	{ NULL        , 0, NULL, 0 }
 };
@@ -1199,7 +1207,7 @@ int main(int argc, char *argv[])
 	page_size = getpagesize();
 
 	while ((c = getopt_long(argc, argv,
-				"rp:f:a:b:d:c:ClLNXxh", opts, NULL)) != -1) {
+				"rp:f:a:b:d:c:ClLNXxF:h", opts, NULL)) != -1) {
 		switch (c) {
 		case 'r':
 			opt_raw = 1;
@@ -1242,6 +1250,9 @@ int main(int argc, char *argv[])
 			opt_unpoison = 1;
 			prepare_hwpoison_fd();
 			break;
+		case 'F':
+			parse_kpageflags(optarg);
+			break;
 		case 'h':
 			usage();
 			exit(0);
@@ -1251,6 +1262,9 @@ int main(int argc, char *argv[])
 		}
 	}
 
+	if (!opt_kpageflags)
+		opt_kpageflags = PROC_KPAGEFLAGS;
+
 	if (opt_cgroup || opt_list_cgroup)
 		kpagecgroup_fd = checked_open(PROC_KPAGECGROUP, O_RDONLY);
 
_

Patches currently in -mm which might be from rientjes@google.com are


