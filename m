From: akpm@linux-foundation.org
Subject: [patch 87/94] mm: add infrastructure for
 get_user_pages_fast() benchmarking
Date: Fri, 17 Nov 2017 15:31:22 -0800
Message-ID: <20171117233122.8_ec1iRbX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56188 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966975AbdKQXbY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:31:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, corbet@lwn.net, kirill.shutemov@linux.intel.com, mingo@kernel.org, mm-commits@vger.kernel.org, regressions@leemhuis.info, shuah@kernel.org, torvalds@linux-foundation.org, ying.huang@intel.com

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: add infrastructure for get_user_pages_fast() benchmarking

Performance of get_user_pages_fast() is critical for some workloads, but
it's tricky to test it directly.

This patch provides /sys/kernel/debug/gup_benchmark that helps with
testing performance of it.

See tools/testing/selftests/vm/gup_benchmark.c for userspace
counterpart.

Link: http://lkml.kernel.org/r/20170908215603.9189-2-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig                                 |    9 +
 mm/Makefile                                |    1 
 mm/gup_benchmark.c                         |  100 +++++++++++++++++++
 tools/testing/selftests/vm/Makefile        |    1 
 tools/testing/selftests/vm/gup_benchmark.c |   91 +++++++++++++++++
 5 files changed, 202 insertions(+)

diff -puN /dev/null mm/gup_benchmark.c
--- /dev/null
+++ a/mm/gup_benchmark.c
@@ -0,0 +1,100 @@
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/ktime.h>
+#include <linux/debugfs.h>
+
+#define GUP_FAST_BENCHMARK	_IOWR('g', 1, struct gup_benchmark)
+
+struct gup_benchmark {
+	__u64 delta_usec;
+	__u64 addr;
+	__u64 size;
+	__u32 nr_pages_per_call;
+	__u32 flags;
+};
+
+static int __gup_benchmark_ioctl(unsigned int cmd,
+		struct gup_benchmark *gup)
+{
+	ktime_t start_time, end_time;
+	unsigned long i, nr, nr_pages, addr, next;
+	struct page **pages;
+
+	nr_pages = gup->size / PAGE_SIZE;
+	pages = kvmalloc(sizeof(void *) * nr_pages, GFP_KERNEL);
+	if (!pages)
+		return -ENOMEM;
+
+	i = 0;
+	nr = gup->nr_pages_per_call;
+	start_time = ktime_get();
+	for (addr = gup->addr; addr < gup->addr + gup->size; addr = next) {
+		if (nr != gup->nr_pages_per_call)
+			break;
+
+		next = addr + nr * PAGE_SIZE;
+		if (next > gup->addr + gup->size) {
+			next = gup->addr + gup->size;
+			nr = (next - addr) / PAGE_SIZE;
+		}
+
+		nr = get_user_pages_fast(addr, nr, gup->flags & 1, pages + i);
+		i += nr;
+	}
+	end_time = ktime_get();
+
+	gup->delta_usec = ktime_us_delta(end_time, start_time);
+	gup->size = addr - gup->addr;
+
+	for (i = 0; i < nr_pages; i++) {
+		if (!pages[i])
+			break;
+		put_page(pages[i]);
+	}
+
+	kvfree(pages);
+	return 0;
+}
+
+static long gup_benchmark_ioctl(struct file *filep, unsigned int cmd,
+		unsigned long arg)
+{
+	struct gup_benchmark gup;
+	int ret;
+
+	if (cmd != GUP_FAST_BENCHMARK)
+		return -EINVAL;
+
+	if (copy_from_user(&gup, (void __user *)arg, sizeof(gup)))
+		return -EFAULT;
+
+	ret = __gup_benchmark_ioctl(cmd, &gup);
+	if (ret)
+		return ret;
+
+	if (copy_to_user((void __user *)arg, &gup, sizeof(gup)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static const struct file_operations gup_benchmark_fops = {
+	.open = nonseekable_open,
+	.unlocked_ioctl = gup_benchmark_ioctl,
+};
+
+static int gup_benchmark_init(void)
+{
+	void *ret;
+
+	ret = debugfs_create_file_unsafe("gup_benchmark", 0600, NULL, NULL,
+			&gup_benchmark_fops);
+	if (!ret)
+		pr_warn("Failed to create gup_benchmark in debugfs");
+
+	return 0;
+}
+
+late_initcall(gup_benchmark_init);
diff -puN mm/Kconfig~mm-add-infrastructure-for-get_user_pages_fast-benchmarking mm/Kconfig
--- a/mm/Kconfig~mm-add-infrastructure-for-get_user_pages_fast-benchmarking
+++ a/mm/Kconfig
@@ -756,3 +756,12 @@ config PERCPU_STATS
 	  This feature collects and exposes statistics via debugfs. The
 	  information includes global and per chunk statistics, which can
 	  be used to help understand percpu memory usage.
+
+config GUP_BENCHMARK
+	bool "Enable infrastructure for get_user_pages_fast() benchmarking"
+	default n
+	help
+	  Provides /sys/kernel/debug/gup_benchmark that helps with testing
+	  performance of get_user_pages_fast().
+
+	  See tools/testing/selftests/vm/gup_benchmark.c
diff -puN mm/Makefile~mm-add-infrastructure-for-get_user_pages_fast-benchmarking mm/Makefile
--- a/mm/Makefile~mm-add-infrastructure-for-get_user_pages_fast-benchmarking
+++ a/mm/Makefile
@@ -80,6 +80,7 @@ obj-$(CONFIG_PAGE_COUNTER) += page_count
 obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
 obj-$(CONFIG_MEMCG_SWAP) += swap_cgroup.o
 obj-$(CONFIG_CGROUP_HUGETLB) += hugetlb_cgroup.o
+obj-$(CONFIG_GUP_BENCHMARK) += gup_benchmark.o
 obj-$(CONFIG_MEMORY_FAILURE) += memory-failure.o
 obj-$(CONFIG_HWPOISON_INJECT) += hwpoison-inject.o
 obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak.o
diff -puN /dev/null tools/testing/selftests/vm/gup_benchmark.c
--- /dev/null
+++ a/tools/testing/selftests/vm/gup_benchmark.c
@@ -0,0 +1,91 @@
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/prctl.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+
+#include <linux/types.h>
+
+#define MB (1UL << 20)
+#define PAGE_SIZE sysconf(_SC_PAGESIZE)
+
+#define GUP_FAST_BENCHMARK	_IOWR('g', 1, struct gup_benchmark)
+
+struct gup_benchmark {
+	__u64 delta_usec;
+	__u64 addr;
+	__u64 size;
+	__u32 nr_pages_per_call;
+	__u32 flags;
+};
+
+int main(int argc, char **argv)
+{
+	struct gup_benchmark gup;
+	unsigned long size = 128 * MB;
+	int i, fd, opt, nr_pages = 1, thp = -1, repeats = 1, write = 0;
+	char *p;
+
+	while ((opt = getopt(argc, argv, "m:r:n:tT")) != -1) {
+		switch (opt) {
+		case 'm':
+			size = atoi(optarg) * MB;
+			break;
+		case 'r':
+			repeats = atoi(optarg);
+			break;
+		case 'n':
+			nr_pages = atoi(optarg);
+			break;
+		case 't':
+			thp = 1;
+			break;
+		case 'T':
+			thp = 0;
+			break;
+		case 'w':
+			write = 1;
+		default:
+			return -1;
+		}
+	}
+
+	gup.nr_pages_per_call = nr_pages;
+	gup.flags = write;
+
+	fd = open("/sys/kernel/debug/gup_benchmark", O_RDWR);
+	if (fd == -1)
+		perror("open"), exit(1);
+
+	p = mmap(NULL, size, PROT_READ | PROT_WRITE,
+			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (p == MAP_FAILED)
+		perror("mmap"), exit(1);
+	gup.addr = (unsigned long)p;
+
+	if (thp == 1)
+		madvise(p, size, MADV_HUGEPAGE);
+	else if (thp == 0)
+		madvise(p, size, MADV_NOHUGEPAGE);
+
+	for (; (unsigned long)p < gup.addr + size; p += PAGE_SIZE)
+		p[0] = 0;
+
+	for (i = 0; i < repeats; i++) {
+		gup.size = size;
+		if (ioctl(fd, GUP_FAST_BENCHMARK, &gup))
+			perror("ioctl"), exit(1);
+
+		printf("Time: %lld us", gup.delta_usec);
+		if (gup.size != size)
+			printf(", truncated (size: %lld)", gup.size);
+		printf("\n");
+	}
+
+	return 0;
+}
diff -puN tools/testing/selftests/vm/Makefile~mm-add-infrastructure-for-get_user_pages_fast-benchmarking tools/testing/selftests/vm/Makefile
--- a/tools/testing/selftests/vm/Makefile~mm-add-infrastructure-for-get_user_pages_fast-benchmarking
+++ a/tools/testing/selftests/vm/Makefile
@@ -18,6 +18,7 @@ TEST_GEN_FILES += transhuge-stress
 TEST_GEN_FILES += userfaultfd
 TEST_GEN_FILES += mlock-random-test
 TEST_GEN_FILES += virtual_address_range
+TEST_GEN_FILES += gup_benchmark
 
 TEST_PROGS := run_vmtests
 
_
