From: akpm@linux-foundation.org
Subject: + documentation-fix-warnings-from-wmissing-prototypes-in-hostcflags.patch added to -mm tree
Date: Thu, 30 Jul 2009 16:54:25 -0700
Message-ID: <200907302354.n6UNsPre007381@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752477AbZG3Xyj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 19:54:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ladinu.pub@gmail.com, sam@ravnborg.org, tsrk@tsrk.net


The patch titled
     Documentation/: fix warnings from -Wmissing-prototypes in HOSTCFLAGS
has been added to the -mm tree.  Its filename is
     documentation-fix-warnings-from-wmissing-prototypes-in-hostcflags.patch

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
Subject: Documentation/: fix warnings from -Wmissing-prototypes in HOSTCFLAGS
From: Ladinu Chandrasinghe <ladinu.pub@gmail.com>

Fix up -Wmissing-prototypes in compileable userspace code, mainly under
Documentation/.

Signed-off-by: Ladinu Chandrasinghe <ladinu.pub@gmail.com>
Signed-off-by: Trevor Keith <tsrk@tsrk.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/getdelays.c          |   12 +-
 Documentation/auxdisplay/cfag12864b-example.c |   22 ++---
 Documentation/ia64/aliasing-test.c            |    8 -
 Documentation/pcmcia/crc32hash.c              |    2 
 Documentation/spi/spidev_test.c               |    4 
 Documentation/video4linux/v4lgrab.c           |    2 
 Documentation/vm/page-types.c                 |   52 ++++++------
 Documentation/vm/slabinfo.c                   |   68 ++++++++--------
 Documentation/watchdog/src/watchdog-test.c    |    2 
 firmware/ihex2fw.c                            |    2 
 scripts/genksyms/genksyms.c                   |    6 -
 11 files changed, 90 insertions(+), 90 deletions(-)

diff -puN Documentation/accounting/getdelays.c~documentation-fix-warnings-from-wmissing-prototypes-in-hostcflags Documentation/accounting/getdelays.c
--- a/Documentation/accounting/getdelays.c~documentation-fix-warnings-from-wmissing-prototypes-in-hostcflags
+++ a/Documentation/accounting/getdelays.c
@@ -116,7 +116,7 @@ error:
 }
 
 
-int send_cmd(int sd, __u16 nlmsg_type, __u32 nlmsg_pid,
+static int send_cmd(int sd, __u16 nlmsg_type, __u32 nlmsg_pid,
 	     __u8 genl_cmd, __u16 nla_type,
 	     void *nla_data, int nla_len)
 {
@@ -160,7 +160,7 @@ int send_cmd(int sd, __u16 nlmsg_type, _
  * Probe the controller in genetlink to find the family id
  * for the TASKSTATS family
  */
-int get_family_id(int sd)
+static int get_family_id(int sd)
 {
 	struct {
 		struct nlmsghdr n;
@@ -190,7 +190,7 @@ int get_family_id(int sd)
 	return id;
 }
 
-void print_delayacct(struct taskstats *t)
+static void print_delayacct(struct taskstats *t)
 {
 	printf("\n\nCPU   %15s%15s%15s%15s\n"
 	       "      %15llu%15llu%15llu%15llu\n"
@@ -216,7 +216,7 @@ void print_delayacct(struct taskstats *t
 	       (unsigned long long)t->freepages_delay_total);
 }
 
-void task_context_switch_counts(struct taskstats *t)
+static void task_context_switch_counts(struct taskstats *t)
 {
 	printf("\n\nTask   %15s%15s\n"
 	       "       %15llu%15llu\n",
@@ -224,7 +224,7 @@ void task_context_switch_counts(struct t
 	       (unsigned long long)t->nvcsw, (unsigned long long)t->nivcsw);
 }
 
-void print_cgroupstats(struct cgroupstats *c)
+static void print_cgroupstats(struct cgroupstats *c)
 {
 	printf("sleeping %llu, blocked %llu, running %llu, stopped %llu, "
 		"uninterruptible %llu\n", (unsigned long long)c->nr_sleeping,
@@ -235,7 +235,7 @@ void print_cgroupstats(struct cgroupstat
 }
 
 
-void print_ioacct(struct taskstats *t)
+static void print_ioacct(struct taskstats *t)
 {
 	printf("%s: read=%llu, write=%llu, cancelled_write=%llu\n",
 		t->ac_comm,
diff -puN Documentation/auxdisplay/cfag12864b-example.c~documentation-fix-warnings-from-wmissing-prototypes-in-hostcflags Documentation/auxdisplay/cfag12864b-example.c
--- a/Documentation/auxdisplay/cfag12864b-example.c~documentation-fix-warnings-from-wmissing-prototypes-in-hostcflags
+++ a/Documentation/auxdisplay/cfag12864b-example.c
@@ -62,7 +62,7 @@ unsigned char cfag12864b_buffer[CFAG1286
  * Unable to open: return = -1
  * Unable to mmap: return = -2
  */
-int cfag12864b_init(char *path)
+static int cfag12864b_init(char *path)
 {
 	cfag12864b_fd = open(path, O_RDWR);
 	if (cfag12864b_fd == -1)
@@ -81,7 +81,7 @@ int cfag12864b_init(char *path)
 /*
  * exit a cfag12864b framebuffer device
  */
-void cfag12864b_exit(void)
+static void cfag12864b_exit(void)
 {
 	munmap(cfag12864b_mem, CFAG12864B_SIZE);
 	close(cfag12864b_fd);
@@ -90,7 +90,7 @@ void cfag12864b_exit(void)
 /*
  * set (x, y) pixel
  */
-void cfag12864b_set(unsigned char x, unsigned char y)
+static void cfag12864b_set(unsigned char x, unsigned char y)
 {
 	if (CFAG12864B_CHECK(x, y))
 		cfag12864b_buffer[CFAG12864B_ADDRESS(x, y)] |=
@@ -100,7 +100,7 @@ void cfag12864b_set(unsigned char x, uns
 /*
  * unset (x, y) pixel
  */
-void cfag12864b_unset(unsigned char x, unsigned char y)
+static void cfag12864b_unset(unsigned char x, unsigned char y)
 {
 	if (CFAG12864B_CHECK(x, y))
 		cfag12864b_buffer[CFAG12864B_ADDRESS(x, y)] &=
@@ -113,7 +113,7 @@ void cfag12864b_unset(unsigned char x, u
  * Pixel off: return = 0
  * Pixel on:  return = 1
  */
-unsigned char cfag12864b_isset(unsigned char x, unsigned char y)
+static unsigned char cfag12864b_isset(unsigned char x, unsigned char y)
 {
 	if (CFAG12864B_CHECK(x, y))
 		if (cfag12864b_buffer[CFAG12864B_ADDRESS(x, y)] &
@@ -126,7 +126,7 @@ unsigned char cfag12864b_isset(unsigned 
 /*
  * not (x, y) pixel
  */
-void cfag12864b_not(unsigned char x, unsigned char y)
+static void cfag12864b_not(unsigned char x, unsigned char y)
 {
 	if (cfag12864b_isset(x, y))
 		cfag12864b_unset(x, y);
@@ -137,7 +137,7 @@ void cfag12864b_not(unsigned char x, uns
 /*
  * fill (set all pixels)
  */
-void cfag12864b_fill(void)
+static void cfag12864b_fill(void)
 {
 	unsigned short i;
 
@@ -148,7 +148,7 @@ void cfag12864b_fill(void)
 /*
  * clear (unset all pixels)
  */
-void cfag12864b_clear(void)
+static void cfag12864b_clear(void)
 {
 	unsigned short i;
 
@@ -162,7 +162,7 @@ void cfag12864b_clear(void)
  * Pixel off: src[i] = 0
  * Pixel on:  src[i] > 0
  */
-void cfag12864b_format(unsigned char * matrix)
+static void cfag12864b_format(unsigned char * matrix)
 {
 	unsigned char i, j, n;
 
@@ -182,7 +182,7 @@ void cfag12864b_format(unsigned char * m
 /*
  * blit buffer to lcd
  */
-void cfag12864b_blit(void)
+static void cfag12864b_blit(void)
 {
 	memcpy(cfag12864b_mem, cfag12864b_buffer, CFAG12864B_SIZE);
 }
@@ -198,7 +198,7 @@ void cfag12864b_blit(void)
 
 #define EXAMPLES	6
 
-void example(unsigned char n)
+static void example(unsigned char n)
 {
 	unsigned short i, j;
 	unsigned char matrix[CFAG12864B_WIDTH * CFAG12864B_HEIGHT];
diff -puN Documentation/ia64/aliasing-test.c~documentation-fix-warnings-from-wmissing-prototypes-in-hostcflags Documentation/ia64/aliasing-test.c
--- a/Documentation/ia64/aliasing-test.c~documentation-fix-warnings-from-wmissing-prototypes-in-hostcflags
+++ a/Documentation/ia64/aliasing-test.c
@@ -24,7 +24,7 @@
 
 int sum;
 
-int map_mem(char *path, off_t offset, size_t length, int touch)
+static int map_mem(char *path, off_t offset, size_t length, int touch)
 {
 	int fd, rc;
 	void *addr;
@@ -62,7 +62,7 @@ int map_mem(char *path, off_t offset, si
 	return 0;
 }
 
-int scan_tree(char *path, char *file, off_t offset, size_t length, int touch)
+static int scan_tree(char *path, char *file, off_t offset, size_t length, int touch)
 {
 	struct dirent **namelist;
 	char *name, *path2;
@@ -119,7 +119,7 @@ skip:
 
 char buf[1024];
 
-int read_rom(char *path)
+static int read_rom(char *path)
 {
 	int fd, rc;
 	size_t size = 0;
@@ -146,7 +146,7 @@ int read_rom(char *path)
 	return size;
 }
 
-int scan_rom(char *path, char *file)
+static int scan_rom(char *path, char *file)
 {
 	struct dirent **namelist;
 	char *name, *path2;
diff -puN Documentation/pcmcia/crc32hash.c~documentation-fix-warnings-from-wmissing-prototypes-in-hostcflags Documentation/pcmcia/crc32hash.c
--- a/Documentation/pcmcia/crc32hash.c~documentation-fix-warnings-from-wmissing-prototypes-in-hostcflags
+++ a/Documentation/pcmcia/crc32hash.c
@@ -8,7 +8,7 @@ $ ./crc32hash "Dual Speed"
 #include <ctype.h>
 #include <stdlib.h>
 
-unsigned int crc32(unsigned char const *p, unsigned int len)
+static unsigned int crc32(unsigned char const *p, unsigned int len)
 {
 	int i;
 	unsigned int crc = 0;
diff -puN Documentation/spi/spidev_test.c~documentation-fix-warnings-from-wmissing-prototypes-in-hostcflags Documentation/spi/spidev_test.c
--- a/Documentation/spi/spidev_test.c~documentation-fix-warnings-from-wmissing-prototypes-in-hostcflags
+++ a/Documentation/spi/spidev_test.c
@@ -69,7 +69,7 @@ static void transfer(int fd)
 	puts("");
 }
 
-void print_usage(const char *prog)
+static void print_usage(const char *prog)
 {
 	printf("Usage: %s [-DsbdlHOLC3]\n", prog);
 	puts("  -D --device   device to use (default /dev/spidev1.1)\n"
@@ -85,7 +85,7 @@ void print_usage(const char *prog)
 	exit(1);
 }
 
-void parse_opts(int argc, char *argv[])
+static void parse_opts(int argc, char *argv[])
 {
 	while (1) {
 		static const struct option lopts[] = {
diff -puN Documentation/video4linux/v4lgrab.c~documentation-fix-warnings-from-wmissing-prototypes-in-hostcflags Documentation/video4linux/v4lgrab.c
--- a/Documentation/video4linux/v4lgrab.c~documentation-fix-warnings-from-wmissing-prototypes-in-hostcflags
+++ a/Documentation/video4linux/v4lgrab.c
@@ -89,7 +89,7 @@
 	}                                                               \
 }
 
-int get_brightness_adj(unsigned char *image, long size, int *brightness) {
+static int get_brightness_adj(unsigned char *image, long size, int *brightness) {
   long i, tot = 0;
   for (i=0;i<size*3;i++)
     tot += image[i];
diff -puN Documentation/vm/page-types.c~documentation-fix-warnings-from-wmissing-prototypes-in-hostcflags Documentation/vm/page-types.c
--- a/Documentation/vm/page-types.c~documentation-fix-warnings-from-wmissing-prototypes-in-hostcflags
+++ a/Documentation/vm/page-types.c
@@ -158,12 +158,12 @@ static uint64_t 	page_flags[HASH_SIZE];
 	type __min2 = (y);			\
 	__min1 < __min2 ? __min1 : __min2; })
 
-unsigned long pages2mb(unsigned long pages)
+static unsigned long pages2mb(unsigned long pages)
 {
 	return (pages * page_size) >> 20;
 }
 
-void fatal(const char *x, ...)
+static void fatal(const char *x, ...)
 {
 	va_list ap;
 
@@ -178,7 +178,7 @@ void fatal(const char *x, ...)
  * page flag names
  */
 
-char *page_flag_name(uint64_t flags)
+static char *page_flag_name(uint64_t flags)
 {
 	static char buf[65];
 	int present;
@@ -197,7 +197,7 @@ char *page_flag_name(uint64_t flags)
 	return buf;
 }
 
-char *page_flag_longname(uint64_t flags)
+static char *page_flag_longname(uint64_t flags)
 {
 	static char buf[1024];
 	int i, n;
@@ -221,7 +221,7 @@ char *page_flag_longname(uint64_t flags)
  * page list and summary
  */
 
-void show_page_range(unsigned long offset, uint64_t flags)
+static void show_page_range(unsigned long offset, uint64_t flags)
 {
 	static uint64_t      flags0;
 	static unsigned long index;
@@ -241,12 +241,12 @@ void show_page_range(unsigned long offse
 	count  = 1;
 }
 
-void show_page(unsigned long offset, uint64_t flags)
+static void show_page(unsigned long offset, uint64_t flags)
 {
 	printf("%lu\t%s\n", offset, page_flag_name(flags));
 }
 
-void show_summary(void)
+static void show_summary(void)
 {
 	int i;
 
@@ -272,7 +272,7 @@ void show_summary(void)
  * page flag filters
  */
 
-int bit_mask_ok(uint64_t flags)
+static int bit_mask_ok(uint64_t flags)
 {
 	int i;
 
@@ -289,7 +289,7 @@ int bit_mask_ok(uint64_t flags)
 	return 1;
 }
 
-uint64_t expand_overloaded_flags(uint64_t flags)
+static uint64_t expand_overloaded_flags(uint64_t flags)
 {
 	/* SLOB/SLUB overload several page flags */
 	if (flags & BIT(SLAB)) {
@@ -308,7 +308,7 @@ uint64_t expand_overloaded_flags(uint64_
 	return flags;
 }
 
-uint64_t well_known_flags(uint64_t flags)
+static uint64_t well_known_flags(uint64_t flags)
 {
 	/* hide flags intended only for kernel hacker */
 	flags &= ~KPF_HACKERS_BITS;
@@ -325,7 +325,7 @@ uint64_t well_known_flags(uint64_t flags
  * page frame walker
  */
 
-int hash_slot(uint64_t flags)
+static int hash_slot(uint64_t flags)
 {
 	int k = HASH_KEY(flags);
 	int i;
@@ -352,7 +352,7 @@ int hash_slot(uint64_t flags)
 	exit(EXIT_FAILURE);
 }
 
-void add_page(unsigned long offset, uint64_t flags)
+static void add_page(unsigned long offset, uint64_t flags)
 {
 	flags = expand_overloaded_flags(flags);
 
@@ -371,7 +371,7 @@ void add_page(unsigned long offset, uint
 	total_pages++;
 }
 
-void walk_pfn(unsigned long index, unsigned long count)
+static void walk_pfn(unsigned long index, unsigned long count)
 {
 	unsigned long batch;
 	unsigned long n;
@@ -404,7 +404,7 @@ void walk_pfn(unsigned long index, unsig
 	}
 }
 
-void walk_addr_ranges(void)
+static void walk_addr_ranges(void)
 {
 	int i;
 
@@ -428,7 +428,7 @@ void walk_addr_ranges(void)
  * user interface
  */
 
-const char *page_flag_type(uint64_t flag)
+static const char *page_flag_type(uint64_t flag)
 {
 	if (flag & KPF_HACKERS_BITS)
 		return "(r)";
@@ -437,7 +437,7 @@ const char *page_flag_type(uint64_t flag
 	return "   ";
 }
 
-void usage(void)
+static void usage(void)
 {
 	int i, j;
 
@@ -482,7 +482,7 @@ void usage(void)
 		"(r) raw mode bits  (o) overloaded bits\n");
 }
 
-unsigned long long parse_number(const char *str)
+static unsigned long long parse_number(const char *str)
 {
 	unsigned long long n;
 
@@ -494,16 +494,16 @@ unsigned long long parse_number(const ch
 	return n;
 }
 
-void parse_pid(const char *str)
+static void parse_pid(const char *str)
 {
 	opt_pid = parse_number(str);
 }
 
-void parse_file(const char *name)
+static void parse_file(const char *name)
 {
 }
 
-void add_addr_range(unsigned long offset, unsigned long size)
+static void add_addr_range(unsigned long offset, unsigned long size)
 {
 	if (nr_addr_ranges >= MAX_ADDR_RANGES)
 		fatal("too much addr ranges\n");
@@ -513,7 +513,7 @@ void add_addr_range(unsigned long offset
 	nr_addr_ranges++;
 }
 
-void parse_addr_range(const char *optarg)
+static void parse_addr_range(const char *optarg)
 {
 	unsigned long offset;
 	unsigned long size;
@@ -547,7 +547,7 @@ void parse_addr_range(const char *optarg
 	add_addr_range(offset, size);
 }
 
-void add_bits_filter(uint64_t mask, uint64_t bits)
+static void add_bits_filter(uint64_t mask, uint64_t bits)
 {
 	if (nr_bit_filters >= MAX_BIT_FILTERS)
 		fatal("too much bit filters\n");
@@ -557,7 +557,7 @@ void add_bits_filter(uint64_t mask, uint
 	nr_bit_filters++;
 }
 
-uint64_t parse_flag_name(const char *str, int len)
+static uint64_t parse_flag_name(const char *str, int len)
 {
 	int i;
 
@@ -577,7 +577,7 @@ uint64_t parse_flag_name(const char *str
 	return parse_number(str);
 }
 
-uint64_t parse_flag_names(const char *str, int all)
+static uint64_t parse_flag_names(const char *str, int all)
 {
 	const char *p    = str;
 	uint64_t   flags = 0;
@@ -596,7 +596,7 @@ uint64_t parse_flag_names(const char *st
 	return flags;
 }
 
-void parse_bits_mask(const char *optarg)
+static void parse_bits_mask(const char *optarg)
 {
 	uint64_t mask;
 	uint64_t bits;
@@ -621,7 +621,7 @@ void parse_bits_mask(const char *optarg)
 }
 
 
-struct option opts[] = {
+static struct option opts[] = {
 	{ "raw"       , 0, NULL, 'r' },
 	{ "pid"       , 1, NULL, 'p' },
 	{ "file"      , 1, NULL, 'f' },
diff -puN Documentation/vm/slabinfo.c~documentation-fix-warnings-from-wmissing-prototypes-in-hostcflags Documentation/vm/slabinfo.c
--- a/Documentation/vm/slabinfo.c~documentation-fix-warnings-from-wmissing-prototypes-in-hostcflags
+++ a/Documentation/vm/slabinfo.c
@@ -87,7 +87,7 @@ int page_size;
 
 regex_t pattern;
 
-void fatal(const char *x, ...)
+static void fatal(const char *x, ...)
 {
 	va_list ap;
 
@@ -97,7 +97,7 @@ void fatal(const char *x, ...)
 	exit(EXIT_FAILURE);
 }
 
-void usage(void)
+static void usage(void)
 {
 	printf("slabinfo 5/7/2007. (c) 2007 sgi.\n\n"
 		"slabinfo [-ahnpvtsz] [-d debugopts] [slab-regexp]\n"
@@ -131,7 +131,7 @@ void usage(void)
 	);
 }
 
-unsigned long read_obj(const char *name)
+static unsigned long read_obj(const char *name)
 {
 	FILE *f = fopen(name, "r");
 
@@ -151,7 +151,7 @@ unsigned long read_obj(const char *name)
 /*
  * Get the contents of an attribute
  */
-unsigned long get_obj(const char *name)
+static unsigned long get_obj(const char *name)
 {
 	if (!read_obj(name))
 		return 0;
@@ -159,7 +159,7 @@ unsigned long get_obj(const char *name)
 	return atol(buffer);
 }
 
-unsigned long get_obj_and_str(const char *name, char **x)
+static unsigned long get_obj_and_str(const char *name, char **x)
 {
 	unsigned long result = 0;
 	char *p;
@@ -178,7 +178,7 @@ unsigned long get_obj_and_str(const char
 	return result;
 }
 
-void set_obj(struct slabinfo *s, const char *name, int n)
+static void set_obj(struct slabinfo *s, const char *name, int n)
 {
 	char x[100];
 	FILE *f;
@@ -192,7 +192,7 @@ void set_obj(struct slabinfo *s, const c
 	fclose(f);
 }
 
-unsigned long read_slab_obj(struct slabinfo *s, const char *name)
+static unsigned long read_slab_obj(struct slabinfo *s, const char *name)
 {
 	char x[100];
 	FILE *f;
@@ -215,7 +215,7 @@ unsigned long read_slab_obj(struct slabi
 /*
  * Put a size string together
  */
-int store_size(char *buffer, unsigned long value)
+static int store_size(char *buffer, unsigned long value)
 {
 	unsigned long divisor = 1;
 	char trailer = 0;
@@ -247,7 +247,7 @@ int store_size(char *buffer, unsigned lo
 	return n;
 }
 
-void decode_numa_list(int *numa, char *t)
+static void decode_numa_list(int *numa, char *t)
 {
 	int node;
 	int nr;
@@ -272,7 +272,7 @@ void decode_numa_list(int *numa, char *t
 	}
 }
 
-void slab_validate(struct slabinfo *s)
+static void slab_validate(struct slabinfo *s)
 {
 	if (strcmp(s->name, "*") == 0)
 		return;
@@ -280,7 +280,7 @@ void slab_validate(struct slabinfo *s)
 	set_obj(s, "validate", 1);
 }
 
-void slab_shrink(struct slabinfo *s)
+static void slab_shrink(struct slabinfo *s)
 {
 	if (strcmp(s->name, "*") == 0)
 		return;
@@ -290,7 +290,7 @@ void slab_shrink(struct slabinfo *s)
 
 int line = 0;
 
-void first_line(void)
+static void first_line(void)
 {
 	if (show_activity)
 		printf("Name                   Objects      Alloc       Free   %%Fast Fallb O\n");
@@ -302,7 +302,7 @@ void first_line(void)
 /*
  * Find the shortest alias of a slab
  */
-struct aliasinfo *find_one_alias(struct slabinfo *find)
+static struct aliasinfo *find_one_alias(struct slabinfo *find)
 {
 	struct aliasinfo *a;
 	struct aliasinfo *best = NULL;
@@ -318,18 +318,18 @@ struct aliasinfo *find_one_alias(struct 
 	return best;
 }
 
-unsigned long slab_size(struct slabinfo *s)
+static unsigned long slab_size(struct slabinfo *s)
 {
 	return 	s->slabs * (page_size << s->order);
 }
 
-unsigned long slab_activity(struct slabinfo *s)
+static unsigned long slab_activity(struct slabinfo *s)
 {
 	return 	s->alloc_fastpath + s->free_fastpath +
 		s->alloc_slowpath + s->free_slowpath;
 }
 
-void slab_numa(struct slabinfo *s, int mode)
+static void slab_numa(struct slabinfo *s, int mode)
 {
 	int node;
 
@@ -374,7 +374,7 @@ void slab_numa(struct slabinfo *s, int m
 	line++;
 }
 
-void show_tracking(struct slabinfo *s)
+static void show_tracking(struct slabinfo *s)
 {
 	printf("\n%s: Kernel object allocation\n", s->name);
 	printf("-----------------------------------------------------------------------\n");
@@ -392,7 +392,7 @@ void show_tracking(struct slabinfo *s)
 
 }
 
-void ops(struct slabinfo *s)
+static void ops(struct slabinfo *s)
 {
 	if (strcmp(s->name, "*") == 0)
 		return;
@@ -405,14 +405,14 @@ void ops(struct slabinfo *s)
 		printf("\n%s has no kmem_cache operations\n", s->name);
 }
 
-const char *onoff(int x)
+static const char *onoff(int x)
 {
 	if (x)
 		return "On ";
 	return "Off";
 }
 
-void slab_stats(struct slabinfo *s)
+static void slab_stats(struct slabinfo *s)
 {
 	unsigned long total_alloc;
 	unsigned long total_free;
@@ -477,7 +477,7 @@ void slab_stats(struct slabinfo *s)
 			s->deactivate_to_tail, (s->deactivate_to_tail * 100) / total);
 }
 
-void report(struct slabinfo *s)
+static void report(struct slabinfo *s)
 {
 	if (strcmp(s->name, "*") == 0)
 		return;
@@ -518,7 +518,7 @@ void report(struct slabinfo *s)
 	slab_stats(s);
 }
 
-void slabcache(struct slabinfo *s)
+static void slabcache(struct slabinfo *s)
 {
 	char size_str[20];
 	char dist_str[40];
@@ -593,7 +593,7 @@ void slabcache(struct slabinfo *s)
 /*
  * Analyze debug options. Return false if something is amiss.
  */
-int debug_opt_scan(char *opt)
+static int debug_opt_scan(char *opt)
 {
 	if (!opt || !opt[0] || strcmp(opt, "-") == 0)
 		return 1;
@@ -642,7 +642,7 @@ int debug_opt_scan(char *opt)
 	return 1;
 }
 
-int slab_empty(struct slabinfo *s)
+static int slab_empty(struct slabinfo *s)
 {
 	if (s->objects > 0)
 		return 0;
@@ -657,7 +657,7 @@ int slab_empty(struct slabinfo *s)
 	return 1;
 }
 
-void slab_debug(struct slabinfo *s)
+static void slab_debug(struct slabinfo *s)
 {
 	if (strcmp(s->name, "*") == 0)
 		return;
@@ -717,7 +717,7 @@ void slab_debug(struct slabinfo *s)
 		set_obj(s, "trace", 1);
 }
 
-void totals(void)
+static void totals(void)
 {
 	struct slabinfo *s;
 
@@ -976,7 +976,7 @@ void totals(void)
 			b1,	b2,	b3);
 }
 
-void sort_slabs(void)
+static void sort_slabs(void)
 {
 	struct slabinfo *s1,*s2;
 
@@ -1005,7 +1005,7 @@ void sort_slabs(void)
 	}
 }
 
-void sort_aliases(void)
+static void sort_aliases(void)
 {
 	struct aliasinfo *a1,*a2;
 
@@ -1030,7 +1030,7 @@ void sort_aliases(void)
 	}
 }
 
-void link_slabs(void)
+static void link_slabs(void)
 {
 	struct aliasinfo *a;
 	struct slabinfo *s;
@@ -1048,7 +1048,7 @@ void link_slabs(void)
 	}
 }
 
-void alias(void)
+static void alias(void)
 {
 	struct aliasinfo *a;
 	char *active = NULL;
@@ -1079,7 +1079,7 @@ void alias(void)
 }
 
 
-void rename_slabs(void)
+static void rename_slabs(void)
 {
 	struct slabinfo *s;
 	struct aliasinfo *a;
@@ -1102,12 +1102,12 @@ void rename_slabs(void)
 	}
 }
 
-int slab_mismatch(char *slab)
+static int slab_mismatch(char *slab)
 {
 	return regexec(&pattern, slab, 0, NULL, 0);
 }
 
-void read_slab_dir(void)
+static void read_slab_dir(void)
 {
 	DIR *dir;
 	struct dirent *de;
@@ -1209,7 +1209,7 @@ void read_slab_dir(void)
 		fatal("Too many aliases\n");
 }
 
-void output_slabs(void)
+static void output_slabs(void)
 {
 	struct slabinfo *slab;
 
diff -puN Documentation/watchdog/src/watchdog-test.c~documentation-fix-warnings-from-wmissing-prototypes-in-hostcflags Documentation/watchdog/src/watchdog-test.c
--- a/Documentation/watchdog/src/watchdog-test.c~documentation-fix-warnings-from-wmissing-prototypes-in-hostcflags
+++ a/Documentation/watchdog/src/watchdog-test.c
@@ -18,7 +18,7 @@ int fd;
  * the PC Watchdog card to reset its internal timer so it doesn't trigger
  * a computer reset.
  */
-void keep_alive(void)
+static void keep_alive(void)
 {
     int dummy;
 
diff -puN firmware/ihex2fw.c~documentation-fix-warnings-from-wmissing-prototypes-in-hostcflags firmware/ihex2fw.c
--- a/firmware/ihex2fw.c~documentation-fix-warnings-from-wmissing-prototypes-in-hostcflags
+++ a/firmware/ihex2fw.c
@@ -56,7 +56,7 @@ static int output_records(int outfd);
 static int sort_records = 0;
 static int wide_records = 0;
 
-int usage(void)
+static int usage(void)
 {
 	fprintf(stderr, "ihex2fw: Convert ihex files into binary "
 		"representation for use by Linux kernel\n");
diff -puN scripts/genksyms/genksyms.c~documentation-fix-warnings-from-wmissing-prototypes-in-hostcflags scripts/genksyms/genksyms.c
--- a/scripts/genksyms/genksyms.c~documentation-fix-warnings-from-wmissing-prototypes-in-hostcflags
+++ a/scripts/genksyms/genksyms.c
@@ -176,7 +176,7 @@ static int is_unknown_symbol(struct symb
 			strcmp(defn->string, "{") == 0);
 }
 
-struct symbol *__add_symbol(const char *name, enum symbol_type type,
+static struct symbol *__add_symbol(const char *name, enum symbol_type type,
 			    struct string_list *defn, int is_extern,
 			    int is_reference)
 {
@@ -265,7 +265,7 @@ struct symbol *add_symbol(const char *na
 	return __add_symbol(name, type, defn, is_extern, 0);
 }
 
-struct symbol *add_reference_symbol(const char *name, enum symbol_type type,
+static struct symbol *add_reference_symbol(const char *name, enum symbol_type type,
 				    struct string_list *defn, int is_extern)
 {
 	return __add_symbol(name, type, defn, is_extern, 1);
@@ -313,7 +313,7 @@ static int equal_list(struct string_list
 
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
 
-struct string_list *read_node(FILE *f)
+static struct string_list *read_node(FILE *f)
 {
 	char buffer[256];
 	struct string_list node = {
_

Patches currently in -mm which might be from ladinu.pub@gmail.com are

documentation-fix-warnings-from-wmissing-prototypes-in-hostcflags.patch

