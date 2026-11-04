Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793809807;
	b=dBx8ub6MhXIevzSk+cY3pzVv2Y7QPVwFxxLxZuPWBvyWsKbBboTIn4g0PIyu3IYaoKim
	 dCkOU1oCejWImeplK+i+4DsCETmJ+gb5Kf36+suSSGJhoD/DlJ9UcdmSP4o39+d0HRG/h
	 miDqRGKUGxFiMUtv/rGk//qI2PMtatDLQIIWNveavgU+vk5nQccNeJj2VEPLtcz7CIByW
	 JlvwanNCP0z1XI2PRXXa3bOCPf0LfN254XGxVGYWsOUtnPD52HBKh0PwZ8OBMY2XtLVvm
	 PV2p1vKUR9Y6vyLCg88DoT1VzN9fsL6ccxjOs26aChB4peQ/FRquF/xrgT4V2+A49QQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793809807;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=N4kEx3nygLpJ3tAvouUK7K6CBBhYbKvTs7/6xuK0UpQ=;
	b=dbs5REUpPzv6xkZPzA/MTfwxE5bXUWyCL3c1ygRg+9mLirZb/X8POsxdo9fvcby1bwGH
	 OR3FeBKxIq0lGnj4utAALfODNQcJ7tc7XMWAGVBEwDyuJ4UhabOJh94UgpzS2ni4BhIr+
	 +TG4n8OBxpN9FQZYrRuAlg+6rbrcicOriGGWkLRxfxV9gClF5Ig7V62RaC4SkkJHJZ/ir
	 929BFZuJdFZa8dOfhTft7eptLtKvBfrSUXXHFIen1HYVJ2Ai4/DF34pSsJLh2tucWF9aq
	 oim1OV4H8FOAK+QWq7CManzxM5jXfSh4E2UISR16TRUVI8BBigRv6/9dj47k55iiTQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tkMGn1N4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D41C606A31B
	for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2026 16:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tkMGn1N4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2BEF1F000C1;
	Wed,  4 Nov 2026 16:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793809805;
	bh=N4kEx3nygLpJ3tAvouUK7K6CBBhYbKvTs7/6xuK0UpQ=;
	h=Date:To:From:Subject;
	b=tkMGn1N4ngd26yoOMNymDJFGATbJpTalgAgy2s72d3RbPxAgihSEfj7cQJOngD5PF
	 avdimQd3RF77DZCmtZ3QsLsxSWP92dQn/O07VhKDbBzLNUIjgLxI91u9izgVd7DW3p
	 LLWqmM6oKYalLFowa8U1DDf8uaiYaz/eyMeInOFM=
Date: Wed, 04 Nov 2026 08:30:05 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,pjw@kernel.org,
	palmer@dabbelt.com,nao.horiguchi@gmail.com,linmiaohe@huawei.com,
	david@kernel.org,aou@eecs.berkeley.edu,alex@ghiti.fr,leitao@debian.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-add-hwpoison-panic-tool.patch added to mm-new branch
Message-Id: <20261104163005.D2BEF1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: tools/mm: add hwpoison-panic tool
has been added to the -mm mm-new branch.  Its filename is
     tools-mm-add-hwpoison-panic-tool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-add-hwpoison-panic-tool.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: tools/mm: add hwpoison-panic tool
Date: Thu, 13 Aug 2026 04:45:15 -0700

Add a tool that enables the vm.panic_on_unrecoverable_memory_failure
sysctl, picks a kernel-owned PFN and writes its physical address to
hard_offline_page.  Three page kinds are selectable with -k: rodata
(default), slab or pgtable.  In all cases the host should panic.

Example:

        # ./hwpoison-panic -k slab --yes-panic-my-kernel
        injecting hwpoison at phys 0x100032000 (pfn 0x100032, kind=slab)
        expecting kernel panic: 'Memory failure: <pfn>: unrecoverable page'

In dmesg, you will see:

        Memory failure: 0x100032: unhandlable page.
        Memory failure: 0x100032: recovery action for reserved kernel page: Ignored
        Kernel panic - not syncing: Memory failure: 0x100032: unrecoverable page

This lives in tools/mm rather than selftests/mm because every successful
run crashes the machine, which is not something to run from CI.

The --yes-panic-my-kernel argument is required so an accidental invocation
does not take the box down.

Link: https://lore.kernel.org/20260813-memory_failure_rewrite_test-v3-1-f9fb6542cbff@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: AlexandreGhiti <alex@ghiti.fr>
---

 MAINTAINERS                              |    1 
 tools/mm/.gitignore                      |    1 
 tools/mm/Makefile                        |    2 
 tools/mm/memory-failure/hwpoison-panic.c |  359 +++++++++++++++++++++
 4 files changed, 363 insertions(+)

--- a/MAINTAINERS~tools-mm-add-hwpoison-panic-tool
+++ a/MAINTAINERS
@@ -12415,6 +12415,7 @@ F:	include/linux/memory-failure.h
 F:	include/trace/events/memory-failure.h
 F:	mm/hwpoison-inject.c
 F:	mm/memory-failure.c
+F:	tools/mm/memory-failure/
 F:	tools/testing/selftests/mm/memory-failure.c
 
 HYCON HY46XX TOUCHSCREEN SUPPORT
--- a/tools/mm/.gitignore~tools-mm-add-hwpoison-panic-tool
+++ a/tools/mm/.gitignore
@@ -4,3 +4,4 @@ page-types
 page_owner_sort
 thp_swap_allocator_test
 gup_bench
+memory-failure/hwpoison-panic
--- a/tools/mm/Makefile~tools-mm-add-hwpoison-panic-tool
+++ a/tools/mm/Makefile
@@ -5,6 +5,7 @@ include ../scripts/Makefile.include
 
 BUILD_TARGETS=page-types slabinfo page_owner_sort page_owner_filter
 BUILD_TARGETS += thp_swap_allocator_test gup_bench
+BUILD_TARGETS+=memory-failure/hwpoison-panic
 INSTALL_TARGETS = $(BUILD_TARGETS) thpmaps
 
 LIB_DIR = ../lib/api
@@ -29,6 +30,7 @@ gup_bench: $(GUP_BENCH_OBJS) $(LIBS)
 
 clean:
 	$(RM) page-types slabinfo page_owner_sort page_owner_filter thp_swap_allocator_test gup_bench
+	$(RM) memory-failure/hwpoison-panic
 	make -C $(LIB_DIR) clean
 
 sbindir ?= /usr/sbin
diff --git a/tools/mm/memory-failure/hwpoison-panic.c a/tools/mm/memory-failure/hwpoison-panic.c
new file mode 100644
--- /dev/null
+++ a/tools/mm/memory-failure/hwpoison-panic.c
@@ -0,0 +1,359 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * hwpoison-panic: trigger an intentional kernel panic by injecting a
+ * hwpoison error on a kernel-owned page, to check that
+ * vm.panic_on_unrecoverable_memory_failure fires.
+ *
+ * Three kinds of kernel-owned page can be targeted, selected with -k
+ * (default: rodata):
+ *
+ *   rodata  - a PG_reserved page in the kernel rodata range, from
+ *             /proc/iomem "Kernel rodata".  x86 and riscv only.
+ *   slab    - a slab page found via /proc/kpageflags (KPF_SLAB).
+ *   pgtable - a page-table page found via /proc/kpageflags (KPF_PGTABLE).
+ *
+ * slab and pgtable work everywhere; rodata needs an architecture that
+ * publishes the rodata resource in /proc/iomem.
+ *
+ * The slab and pgtable variants exercise memory_failure() -> get_any_page()
+ * on a non PG_reserved kernel-owned page, catching regressions where
+ * get_any_page() collapses such pages into a transient -EIO instead of
+ * -ENOTRECOVERABLE.
+ *
+ * A successful run crashes the kernel, so --yes-panic-my-kernel is required
+ * and the tool is meant for a disposable VM (e.g. virtme-ng) with the serial
+ * console captured.  The result is observed externally: the kernel panics with
+ *   "Memory failure: <pfn>: unrecoverable page"
+ * Returning at all means no panic fired, so every exit status is non-zero:
+ * either a failure, or an inconclusive run where the target PFN raced to
+ * another page type before injection.
+ *
+ * Author: Breno Leitao <leitao@debian.org>
+ */
+#define _GNU_SOURCE
+#define _FILE_OFFSET_BITS 64
+#include <fcntl.h>
+#include <getopt.h>
+#include <limits.h>
+#include <stdarg.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+
+#include "../../../include/uapi/linux/kernel-page-flags.h"
+#include "../../include/linux/sizes.h"
+#include <api/fs/fs.h>
+
+#define SYSCTL_PATH	"/proc/sys/vm/panic_on_unrecoverable_memory_failure"
+#define INJECT_PATH	"/sys/devices/system/memory/hard_offline_page"
+#define PROC_KPAGEFLAGS	"/proc/kpageflags"
+
+/* Not exported by the uapi header, see tools/mm/page-types.c. */
+#define KPF_RESERVED	32
+
+#define BIT(name)	(1ULL << KPF_##name)
+#define ARRAY_SIZE(x)	(sizeof(x) / sizeof((x)[0]))
+
+/* The kpageflags bit identifying each kernel-owned page kind we target. */
+static const struct page_kind {
+	const char *name;
+	uint64_t bit;
+} page_kinds[] = {
+	{ "rodata",  BIT(RESERVED) },
+	{ "slab",    BIT(SLAB)     },
+	{ "pgtable", BIT(PGTABLE)  },
+};
+
+static unsigned long page_size;
+
+static void fatal(const char *x, ...)
+{
+	va_list ap;
+
+	va_start(ap, x);
+	vfprintf(stderr, x, ap);
+	va_end(ap);
+	exit(EXIT_FAILURE);
+}
+
+static int kpageflags_read(int fd, uint64_t pfn, uint64_t *flags)
+{
+	ssize_t bytes;
+
+	bytes = pread(fd, flags, sizeof(*flags), (off_t)pfn * sizeof(*flags));
+
+	return bytes == sizeof(*flags) ? 0 : -1;
+}
+
+static int pick_rodata_phys_addr(uint64_t *phys_addr)
+{
+	unsigned long long start, end;
+	char line[256], label[64];
+	int ret = -1;
+	FILE *f;
+
+	f = fopen("/proc/iomem", "r");
+	if (!f)
+		return -1;
+
+	/* Sub-resources are indented: "  02500000-02ffffff : Kernel rodata" */
+	while (fgets(line, sizeof(line), f)) {
+		if (sscanf(line, " %llx-%llx : %63[^\n]", &start, &end,
+			   label) != 3)
+			continue;
+		if (strcmp(label, "Kernel rodata") || end <= start)
+			continue;
+		/* Page-align up and return the first byte of that page. */
+		*phys_addr = ((start + page_size - 1) / page_size) * page_size;
+		ret = 0;
+		break;
+	}
+
+	fclose(f);
+	return ret;
+}
+
+static int pick_kpageflags_phys_addr(uint64_t want, uint64_t *phys_addr)
+{
+	uint64_t pfn = SZ_16M / page_size;
+	uint64_t flags;
+	int ret = -1;
+	int fd;
+
+	fd = open(PROC_KPAGEFLAGS, O_RDONLY);
+	if (fd < 0)
+		return -1;
+
+	for (; kpageflags_read(fd, pfn, &flags) == 0; pfn++) {
+		if ((flags & want) && !(flags & BIT(HWPOISON)) &&
+		    !(flags & BIT(NOPAGE)) && !(flags & BIT(COMPOUND_TAIL))) {
+			*phys_addr = pfn * page_size;
+			ret = 0;
+			break;
+		}
+	}
+
+	close(fd);
+	return ret;
+}
+
+static int read_sysctl(unsigned long *val)
+{
+	FILE *f = fopen(SYSCTL_PATH, "r");
+	int ret;
+
+	if (!f)
+		return -1;
+	ret = fscanf(f, "%lu", val) == 1 ? 0 : -1;
+	fclose(f);
+
+	return ret;
+}
+
+static int write_sysctl(unsigned long val)
+{
+	FILE *f = fopen(SYSCTL_PATH, "w");
+	int ret;
+
+	if (!f)
+		return -1;
+	ret = fprintf(f, "%lu", val) < 0 ? -1 : 0;
+	fclose(f);
+
+	return ret;
+}
+
+/* hard_offline_page() injects with MF_SW_SIMULATED, so unpoison is allowed. */
+static void unpoison_pfn(uint64_t pfn)
+{
+	char path[PATH_MAX], buf[32];
+	const char *debugfs;
+	int fd, len;
+
+	debugfs = debugfs__mount();
+	if (!debugfs)
+		return;
+
+	snprintf(path, sizeof(path), "%s/hwpoison/unpoison-pfn", debugfs);
+	fd = open(path, O_WRONLY);
+	if (fd < 0)
+		return;
+
+	len = snprintf(buf, sizeof(buf), "0x%llx\n", (unsigned long long)pfn);
+	if (write(fd, buf, len) < 0)
+		perror("unpoison-pfn");
+	close(fd);
+}
+
+static const char *inject_hwpoison(const struct page_kind *kind,
+				   uint64_t phys_addr, uint64_t pfn)
+{
+	char buf[32];
+	int fd, len;
+	ssize_t ret;
+
+	printf("injecting hwpoison at phys 0x%llx (pfn 0x%llx, kind=%s)\n",
+	       (unsigned long long)phys_addr, (unsigned long long)pfn,
+	       kind->name);
+	printf("expecting kernel panic: 'Memory failure: <pfn>: unrecoverable page'\n");
+	fflush(stdout);
+
+	fd = open(INJECT_PATH, O_WRONLY);
+	if (fd < 0)
+		return "cannot open " INJECT_PATH;
+
+	len = snprintf(buf, sizeof(buf), "0x%llx", (unsigned long long)phys_addr);
+	ret = write(fd, buf, len);
+	close(fd);
+
+	if (ret != len)
+		return "inject failed before reaching the panic path";
+
+	return "inject returned without panic; sysctl ineffective";
+}
+
+static const struct page_kind *lookup_kind(const char *name)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(page_kinds); i++)
+		if (!strcmp(page_kinds[i].name, name))
+			return &page_kinds[i];
+
+	return NULL;
+}
+
+static void usage(void)
+{
+	printf("hwpoison-panic [options]\n"
+	       "            -k|--kind <kind>       rodata (default, x86 and riscv only),\n"
+	       "                                   slab or pgtable\n"
+	       "            --yes-panic-my-kernel  really run it: the machine panics\n"
+	       "                                   and every unsaved write is lost\n"
+	       "            -h|--help              show this\n");
+}
+
+static const struct option opts[] = {
+	{ "kind",                 1, NULL, 'k' },
+	{ "yes-panic-my-kernel",  0, NULL, 'y' },
+	{ "help",                 0, NULL, 'h' },
+	{ NULL,                   0, NULL, 0 },
+};
+
+static const struct page_kind *parse_args(int argc, char **argv, int *armed)
+{
+	const struct page_kind *kind;
+	const char *name = "rodata";
+	int c;
+
+	while ((c = getopt_long(argc, argv, "k:h", opts, NULL)) != -1) {
+		switch (c) {
+		case 'k':
+			name = optarg;
+			break;
+		case 'y':
+			*armed = 1;
+			break;
+		case 'h':
+			usage();
+			exit(EXIT_SUCCESS);
+		default:
+			usage();
+			exit(EXIT_FAILURE);
+		}
+	}
+
+	kind = lookup_kind(name);
+	if (!kind)
+		fatal("unknown kind '%s' (expected: rodata|slab|pgtable)\n",
+		      name);
+
+	return kind;
+}
+
+static void check_prereqs(int armed)
+{
+	if (geteuid())
+		fatal("must run as root\n");
+	if (access(SYSCTL_PATH, W_OK))
+		fatal("%s not present (kernel without the sysctl?)\n",
+		      SYSCTL_PATH);
+	if (access(INJECT_PATH, W_OK))
+		fatal("%s not present (no MEMORY_FAILURE?)\n", INJECT_PATH);
+	if (!armed)
+		fatal("this panics the kernel; pass --yes-panic-my-kernel\n");
+}
+
+static uint64_t pick_phys_addr(const struct page_kind *kind)
+{
+	uint64_t addr;
+
+	if (kind->bit == BIT(RESERVED)) {
+		if (pick_rodata_phys_addr(&addr))
+			fatal("no \"Kernel rodata\" in /proc/iomem; try -k slab or -k pgtable\n");
+	} else {
+		if (pick_kpageflags_phys_addr(kind->bit, &addr))
+			fatal("no usable %s PFN in %s\n", kind->name,
+			      PROC_KPAGEFLAGS);
+	}
+
+	return addr;
+}
+
+static void arm_sysctl(unsigned long *prior)
+{
+	if (read_sysctl(prior))
+		fatal("failed to read %s\n", SYSCTL_PATH);
+	if (write_sysctl(1))
+		fatal("failed to enable %s\n", SYSCTL_PATH);
+}
+
+static void recheck_kind(const struct page_kind *kind, uint64_t pfn,
+			 const char *verdict)
+{
+	uint64_t flags;
+	int fd, ret;
+
+	fd = open(PROC_KPAGEFLAGS, O_RDONLY);
+	if (fd < 0)
+		fatal("%s (could not open %s)\n", verdict, PROC_KPAGEFLAGS);
+	ret = kpageflags_read(fd, pfn, &flags);
+	close(fd);
+
+	if (ret)
+		fatal("%s (could not reconfirm page type via %s)\n", verdict,
+		      PROC_KPAGEFLAGS);
+	if (flags & kind->bit)
+		fatal("%s (page still %s)\n", verdict, kind->name);
+
+	fprintf(stderr, "target PFN no longer %s; raced before inject, inconclusive\n",
+		kind->name);
+}
+
+int main(int argc, char **argv)
+{
+	uint64_t phys_addr, pfn;
+	const struct page_kind *kind;
+	const char *verdict;
+	unsigned long prior;
+	int armed = 0;
+
+	kind = parse_args(argc, argv, &armed);
+	check_prereqs(armed);
+	page_size = getpagesize();
+
+	phys_addr = pick_phys_addr(kind);
+	pfn = phys_addr / page_size;
+	arm_sysctl(&prior);
+
+	verdict = inject_hwpoison(kind, phys_addr, pfn);
+
+	/* No panic fired.  Put the machine back, then report. */
+	write_sysctl(prior);
+	unpoison_pfn(pfn);
+	recheck_kind(kind, pfn, verdict);
+
+	return EXIT_FAILURE;
+}
_

Patches currently in -mm which might be from leitao@debian.org are

mm-kmemleak-scan-modified-objects-as-soon-as-they-are-grayed.patch
tools-mm-add-hwpoison-panic-tool.patch

