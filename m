Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1BA4D8DA4
	for <mm-commits@vger.kernel.org>; Mon, 11 May 2026 21:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778535281; cv=none; b=NNcXRJpFRcKJUzYQwKhCvzQW2WhiaX+THMsjwYM2gLqpbWgl2RFn0Y3cOyh/RSKOa0qJxadaTmEiJBqUM/+zLzyToXn1TJ17tBR50CtvXAxLVV8kP+ppJfd70f7yocAZ6GvgjAfY1XyhcohPDhoG2PclES3YLRo1JxcNdQrDCdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778535281; c=relaxed/simple;
	bh=O9UHvHA4KSUMBjagEHVn/9hnmiEjqsiHZ/vr88uN7Es=;
	h=Date:To:From:Subject:Message-Id; b=siLMBCJ7a3JdxFM0Fr4Bfmbi8tC0vTMf6ucVVTbwuNXxEBsWWvwU3t1cRVxOHpIEZuuPfCITjw6i6qRt8N4la9D/VmhbVJzOmpTEG7cHSp3C/ygsEaGSO4SnI1aCITgI0hgrgGO3Hgvdz5DDS695WnULhLwJc/NkvGmxGWc+cms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fyi4hVOy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fyi4hVOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B536C2BCB0;
	Mon, 11 May 2026 21:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778535281;
	bh=O9UHvHA4KSUMBjagEHVn/9hnmiEjqsiHZ/vr88uN7Es=;
	h=Date:To:From:Subject:From;
	b=fyi4hVOyaSE0tefwjWWaK9qxP3wUsUIYWHIKeTLwqz/z8AD9WRjKyZ1xg6SIF/j5x
	 LCFV2s/Qc0sE5veTlZmg7KSv0XoE3l2Sj4r1XZA6eWY/J/PQJBcwouFfVyFrzYXtju
	 f3M/6SgYP7f9BtblBxUPYjCLsgtVnKse8eI9/gK4=
Date: Mon, 11 May 2026 14:34:40 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-rename-thp_settings-to-hugepage_settings.patch added to mm-new branch
Message-Id: <20260511213441.4B536C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: rename thp_settings.[ch] to hugepage_settings.[ch]
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-rename-thp_settings-to-hugepage_settings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-rename-thp_settings-to-hugepage_settings.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: rename thp_settings.[ch] to hugepage_settings.[ch]
Date: Mon, 11 May 2026 19:28:07 +0300

...  for upcoming addition of HugeTLB helpers.

Link: https://lore.kernel.org/20260511162840.375890-24-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Li Wang <li.wang@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile                |    4 
 tools/testing/selftests/mm/cow.c                   |    2 
 tools/testing/selftests/mm/folio_split_race_test.c |    2 
 tools/testing/selftests/mm/guard-regions.c         |    2 
 tools/testing/selftests/mm/hugepage_settings.c     |  397 +++++++++++
 tools/testing/selftests/mm/hugepage_settings.h     |   89 ++
 tools/testing/selftests/mm/khugepaged.c            |    2 
 tools/testing/selftests/mm/ksm_tests.c             |    2 
 tools/testing/selftests/mm/migration.c             |    2 
 tools/testing/selftests/mm/prctl_thp_disable.c     |    2 
 tools/testing/selftests/mm/soft-dirty.c            |    2 
 tools/testing/selftests/mm/split_huge_page_test.c  |    2 
 tools/testing/selftests/mm/thp_settings.c          |  397 -----------
 tools/testing/selftests/mm/thp_settings.h          |   89 --
 tools/testing/selftests/mm/transhuge-stress.c      |    2 
 tools/testing/selftests/mm/uffd-wp-mremap.c        |    2 
 16 files changed, 499 insertions(+), 499 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-rename-thp_settings-to-hugepage_settings
+++ a/tools/testing/selftests/mm/cow.c
@@ -29,7 +29,7 @@
 #include "../../../../mm/gup_test.h"
 #include "kselftest.h"
 #include "vm_util.h"
-#include "thp_settings.h"
+#include "hugepage_settings.h"
 
 static size_t pagesize;
 static int pagemap_fd;
--- a/tools/testing/selftests/mm/folio_split_race_test.c~selftests-mm-rename-thp_settings-to-hugepage_settings
+++ a/tools/testing/selftests/mm/folio_split_race_test.c
@@ -25,7 +25,7 @@
 #include <unistd.h>
 #include "vm_util.h"
 #include "kselftest.h"
-#include "thp_settings.h"
+#include "hugepage_settings.h"
 
 uint64_t page_size;
 uint64_t pmd_pagesize;
--- a/tools/testing/selftests/mm/guard-regions.c~selftests-mm-rename-thp_settings-to-hugepage_settings
+++ a/tools/testing/selftests/mm/guard-regions.c
@@ -21,7 +21,7 @@
 #include <sys/uio.h>
 #include <unistd.h>
 #include "vm_util.h"
-#include "thp_settings.h"
+#include "hugepage_settings.h"
 
 #include "../pidfd/pidfd.h"
 
diff --git a/tools/testing/selftests/mm/hugepage_settings.c a/tools/testing/selftests/mm/hugepage_settings.c
new file mode 100664
--- /dev/null
+++ a/tools/testing/selftests/mm/hugepage_settings.c
@@ -0,0 +1,397 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <fcntl.h>
+#include <limits.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+
+#include "vm_util.h"
+#include "hugepage_settings.h"
+
+#define THP_SYSFS "/sys/kernel/mm/transparent_hugepage/"
+#define MAX_SETTINGS_DEPTH 4
+static struct thp_settings settings_stack[MAX_SETTINGS_DEPTH];
+static int settings_index;
+static struct thp_settings saved_settings;
+static char dev_queue_read_ahead_path[PATH_MAX];
+static bool thp_settings_saved;
+
+static const char * const thp_enabled_strings[] = {
+	"never",
+	"always",
+	"inherit",
+	"madvise",
+	NULL
+};
+
+static const char * const thp_defrag_strings[] = {
+	"always",
+	"defer",
+	"defer+madvise",
+	"madvise",
+	"never",
+	NULL
+};
+
+static const char * const shmem_enabled_strings[] = {
+	"never",
+	"always",
+	"within_size",
+	"advise",
+	"inherit",
+	"deny",
+	"force",
+	NULL
+};
+
+int read_file(const char *path, char *buf, size_t buflen)
+{
+	int fd;
+	ssize_t numread;
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1)
+		return 0;
+
+	numread = read(fd, buf, buflen - 1);
+	if (numread < 1) {
+		close(fd);
+		return 0;
+	}
+
+	buf[numread] = '\0';
+	close(fd);
+
+	return (unsigned int) numread;
+}
+
+unsigned long read_num(const char *path)
+{
+	char buf[21];
+
+	if (read_file(path, buf, sizeof(buf)) < 0) {
+		perror("read_file()");
+		exit(EXIT_FAILURE);
+	}
+
+	return strtoul(buf, NULL, 10);
+}
+
+void write_num(const char *path, unsigned long num)
+{
+	char buf[21];
+
+	sprintf(buf, "%ld", num);
+	write_file(path, buf, strlen(buf) + 1);
+}
+
+int thp_read_string(const char *name, const char * const strings[])
+{
+	char path[PATH_MAX];
+	char buf[256];
+	char *c;
+	int ret;
+
+	ret = snprintf(path, PATH_MAX, THP_SYSFS "%s", name);
+	if (ret >= PATH_MAX) {
+		printf("%s: Pathname is too long\n", __func__);
+		exit(EXIT_FAILURE);
+	}
+
+	if (!read_file(path, buf, sizeof(buf))) {
+		perror(path);
+		exit(EXIT_FAILURE);
+	}
+
+	c = strchr(buf, '[');
+	if (!c) {
+		printf("%s: Parse failure\n", __func__);
+		exit(EXIT_FAILURE);
+	}
+
+	c++;
+	memmove(buf, c, sizeof(buf) - (c - buf));
+
+	c = strchr(buf, ']');
+	if (!c) {
+		printf("%s: Parse failure\n", __func__);
+		exit(EXIT_FAILURE);
+	}
+	*c = '\0';
+
+	ret = 0;
+	while (strings[ret]) {
+		if (!strcmp(strings[ret], buf))
+			return ret;
+		ret++;
+	}
+
+	printf("Failed to parse %s\n", name);
+	exit(EXIT_FAILURE);
+}
+
+void thp_write_string(const char *name, const char *val)
+{
+	char path[PATH_MAX];
+	int ret;
+
+	ret = snprintf(path, PATH_MAX, THP_SYSFS "%s", name);
+	if (ret >= PATH_MAX) {
+		printf("%s: Pathname is too long\n", __func__);
+		exit(EXIT_FAILURE);
+	}
+	write_file(path, val, strlen(val) + 1);
+}
+
+unsigned long thp_read_num(const char *name)
+{
+	char path[PATH_MAX];
+	int ret;
+
+	ret = snprintf(path, PATH_MAX, THP_SYSFS "%s", name);
+	if (ret >= PATH_MAX) {
+		printf("%s: Pathname is too long\n", __func__);
+		exit(EXIT_FAILURE);
+	}
+	return read_num(path);
+}
+
+void thp_write_num(const char *name, unsigned long num)
+{
+	char path[PATH_MAX];
+	int ret;
+
+	ret = snprintf(path, PATH_MAX, THP_SYSFS "%s", name);
+	if (ret >= PATH_MAX) {
+		printf("%s: Pathname is too long\n", __func__);
+		exit(EXIT_FAILURE);
+	}
+	write_num(path, num);
+}
+
+void thp_read_settings(struct thp_settings *settings)
+{
+	unsigned long orders = thp_supported_orders();
+	unsigned long shmem_orders = thp_shmem_supported_orders();
+	char path[PATH_MAX];
+	int i;
+
+	*settings = (struct thp_settings) {
+		.thp_enabled = thp_read_string("enabled", thp_enabled_strings),
+		.thp_defrag = thp_read_string("defrag", thp_defrag_strings),
+		.shmem_enabled =
+			thp_read_string("shmem_enabled", shmem_enabled_strings),
+		.use_zero_page = thp_read_num("use_zero_page"),
+	};
+	settings->khugepaged = (struct khugepaged_settings) {
+		.defrag = thp_read_num("khugepaged/defrag"),
+		.alloc_sleep_millisecs =
+			thp_read_num("khugepaged/alloc_sleep_millisecs"),
+		.scan_sleep_millisecs =
+			thp_read_num("khugepaged/scan_sleep_millisecs"),
+		.max_ptes_none = thp_read_num("khugepaged/max_ptes_none"),
+		.max_ptes_swap = thp_read_num("khugepaged/max_ptes_swap"),
+		.max_ptes_shared = thp_read_num("khugepaged/max_ptes_shared"),
+		.pages_to_scan = thp_read_num("khugepaged/pages_to_scan"),
+	};
+	if (dev_queue_read_ahead_path[0])
+		settings->read_ahead_kb = read_num(dev_queue_read_ahead_path);
+
+	for (i = 0; i < NR_ORDERS; i++) {
+		if (!((1 << i) & orders)) {
+			settings->hugepages[i].enabled = THP_NEVER;
+			continue;
+		}
+		snprintf(path, PATH_MAX, "hugepages-%ukB/enabled",
+			(getpagesize() >> 10) << i);
+		settings->hugepages[i].enabled =
+			thp_read_string(path, thp_enabled_strings);
+	}
+
+	for (i = 0; i < NR_ORDERS; i++) {
+		if (!((1 << i) & shmem_orders)) {
+			settings->shmem_hugepages[i].enabled = SHMEM_NEVER;
+			continue;
+		}
+		snprintf(path, PATH_MAX, "hugepages-%ukB/shmem_enabled",
+			(getpagesize() >> 10) << i);
+		settings->shmem_hugepages[i].enabled =
+			thp_read_string(path, shmem_enabled_strings);
+	}
+}
+
+void thp_write_settings(struct thp_settings *settings)
+{
+	struct khugepaged_settings *khugepaged = &settings->khugepaged;
+	unsigned long orders = thp_supported_orders();
+	unsigned long shmem_orders = thp_shmem_supported_orders();
+	char path[PATH_MAX];
+	int enabled;
+	int i;
+
+	thp_write_string("enabled", thp_enabled_strings[settings->thp_enabled]);
+	thp_write_string("defrag", thp_defrag_strings[settings->thp_defrag]);
+	thp_write_string("shmem_enabled",
+			shmem_enabled_strings[settings->shmem_enabled]);
+	thp_write_num("use_zero_page", settings->use_zero_page);
+
+	thp_write_num("khugepaged/defrag", khugepaged->defrag);
+	thp_write_num("khugepaged/alloc_sleep_millisecs",
+			khugepaged->alloc_sleep_millisecs);
+	thp_write_num("khugepaged/scan_sleep_millisecs",
+			khugepaged->scan_sleep_millisecs);
+	thp_write_num("khugepaged/max_ptes_none", khugepaged->max_ptes_none);
+	thp_write_num("khugepaged/max_ptes_swap", khugepaged->max_ptes_swap);
+	thp_write_num("khugepaged/max_ptes_shared", khugepaged->max_ptes_shared);
+	thp_write_num("khugepaged/pages_to_scan", khugepaged->pages_to_scan);
+
+	if (dev_queue_read_ahead_path[0])
+		write_num(dev_queue_read_ahead_path, settings->read_ahead_kb);
+
+	for (i = 0; i < NR_ORDERS; i++) {
+		if (!((1 << i) & orders))
+			continue;
+		snprintf(path, PATH_MAX, "hugepages-%ukB/enabled",
+			(getpagesize() >> 10) << i);
+		enabled = settings->hugepages[i].enabled;
+		thp_write_string(path, thp_enabled_strings[enabled]);
+	}
+
+	for (i = 0; i < NR_ORDERS; i++) {
+		if (!((1 << i) & shmem_orders))
+			continue;
+		snprintf(path, PATH_MAX, "hugepages-%ukB/shmem_enabled",
+			(getpagesize() >> 10) << i);
+		enabled = settings->shmem_hugepages[i].enabled;
+		thp_write_string(path, shmem_enabled_strings[enabled]);
+	}
+}
+
+struct thp_settings *thp_current_settings(void)
+{
+	if (!settings_index) {
+		printf("Fail: No settings set");
+		exit(EXIT_FAILURE);
+	}
+	return settings_stack + settings_index - 1;
+}
+
+void thp_push_settings(struct thp_settings *settings)
+{
+	if (settings_index >= MAX_SETTINGS_DEPTH) {
+		printf("Fail: Settings stack exceeded");
+		exit(EXIT_FAILURE);
+	}
+	settings_stack[settings_index++] = *settings;
+	thp_write_settings(thp_current_settings());
+}
+
+void thp_pop_settings(void)
+{
+	if (settings_index <= 0) {
+		printf("Fail: Settings stack empty");
+		exit(EXIT_FAILURE);
+	}
+	--settings_index;
+	thp_write_settings(thp_current_settings());
+}
+
+void thp_restore_settings(void)
+{
+	if (thp_settings_saved)
+		thp_write_settings(&saved_settings);
+}
+
+static void thp_restore_settings_atexit(void)
+{
+	thp_restore_settings();
+}
+
+static void thp_restore_settings_sighandler(int sig)
+{
+	/* exit() will invoke the thp_restore_settings_atexit handler. */
+	exit(KSFT_FAIL);
+}
+
+void thp_save_settings(void)
+{
+	thp_read_settings(&saved_settings);
+	thp_settings_saved = true;
+
+	/*
+	 * setup exit hooks to make sure THP settings are restored on graceful
+	 * and error exits and signals
+	 */
+	atexit(thp_restore_settings_atexit);
+	signal(SIGTERM, thp_restore_settings_sighandler);
+	signal(SIGINT, thp_restore_settings_sighandler);
+	signal(SIGHUP, thp_restore_settings_sighandler);
+	signal(SIGQUIT, thp_restore_settings_sighandler);
+}
+
+void thp_set_read_ahead_path(char *path)
+{
+	if (!path) {
+		dev_queue_read_ahead_path[0] = '\0';
+		return;
+	}
+
+	strncpy(dev_queue_read_ahead_path, path,
+		sizeof(dev_queue_read_ahead_path));
+	dev_queue_read_ahead_path[sizeof(dev_queue_read_ahead_path) - 1] = '\0';
+}
+
+static unsigned long __thp_supported_orders(bool is_shmem)
+{
+	unsigned long orders = 0;
+	char path[PATH_MAX];
+	char buf[256];
+	int ret, i;
+	char anon_dir[] = "enabled";
+	char shmem_dir[] = "shmem_enabled";
+
+	for (i = 0; i < NR_ORDERS; i++) {
+		ret = snprintf(path, PATH_MAX, THP_SYSFS "hugepages-%ukB/%s",
+			       (getpagesize() >> 10) << i, is_shmem ? shmem_dir : anon_dir);
+		if (ret >= PATH_MAX) {
+			printf("%s: Pathname is too long\n", __func__);
+			exit(EXIT_FAILURE);
+		}
+
+		ret = read_file(path, buf, sizeof(buf));
+		if (ret)
+			orders |= 1UL << i;
+	}
+
+	return orders;
+}
+
+unsigned long thp_supported_orders(void)
+{
+	return __thp_supported_orders(false);
+}
+
+unsigned long thp_shmem_supported_orders(void)
+{
+	return __thp_supported_orders(true);
+}
+
+bool thp_available(void)
+{
+	if (access(THP_SYSFS, F_OK) != 0)
+		return false;
+	return true;
+}
+
+bool thp_is_enabled(void)
+{
+	if (!thp_available())
+		return false;
+
+	int mode = thp_read_string("enabled", thp_enabled_strings);
+
+	/* THP is considered enabled if it's either "always" or "madvise" */
+	return mode == 1 || mode == 3;
+}
diff --git a/tools/testing/selftests/mm/hugepage_settings.h a/tools/testing/selftests/mm/hugepage_settings.h
new file mode 100664
--- /dev/null
+++ a/tools/testing/selftests/mm/hugepage_settings.h
@@ -0,0 +1,89 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __HUGEPAGE_SETTINGS_H__
+#define __HUGEPAGE_SETTINGS_H__
+
+#include <stdbool.h>
+#include <stddef.h>
+#include <stdint.h>
+
+enum thp_enabled {
+	THP_NEVER,
+	THP_ALWAYS,
+	THP_INHERIT,
+	THP_MADVISE,
+};
+
+enum thp_defrag {
+	THP_DEFRAG_ALWAYS,
+	THP_DEFRAG_DEFER,
+	THP_DEFRAG_DEFER_MADVISE,
+	THP_DEFRAG_MADVISE,
+	THP_DEFRAG_NEVER,
+};
+
+enum shmem_enabled {
+	SHMEM_NEVER,
+	SHMEM_ALWAYS,
+	SHMEM_WITHIN_SIZE,
+	SHMEM_ADVISE,
+	SHMEM_INHERIT,
+	SHMEM_DENY,
+	SHMEM_FORCE,
+};
+
+#define NR_ORDERS 20
+
+struct hugepages_settings {
+	enum thp_enabled enabled;
+};
+
+struct khugepaged_settings {
+	bool defrag;
+	unsigned int alloc_sleep_millisecs;
+	unsigned int scan_sleep_millisecs;
+	unsigned int max_ptes_none;
+	unsigned int max_ptes_swap;
+	unsigned int max_ptes_shared;
+	unsigned long pages_to_scan;
+};
+
+struct shmem_hugepages_settings {
+	enum shmem_enabled enabled;
+};
+
+struct thp_settings {
+	enum thp_enabled thp_enabled;
+	enum thp_defrag thp_defrag;
+	enum shmem_enabled shmem_enabled;
+	bool use_zero_page;
+	struct khugepaged_settings khugepaged;
+	unsigned long read_ahead_kb;
+	struct hugepages_settings hugepages[NR_ORDERS];
+	struct shmem_hugepages_settings shmem_hugepages[NR_ORDERS];
+};
+
+int read_file(const char *path, char *buf, size_t buflen);
+unsigned long read_num(const char *path);
+void write_num(const char *path, unsigned long num);
+
+int thp_read_string(const char *name, const char * const strings[]);
+void thp_write_string(const char *name, const char *val);
+unsigned long thp_read_num(const char *name);
+void thp_write_num(const char *name, unsigned long num);
+
+void thp_write_settings(struct thp_settings *settings);
+void thp_read_settings(struct thp_settings *settings);
+struct thp_settings *thp_current_settings(void);
+void thp_push_settings(struct thp_settings *settings);
+void thp_pop_settings(void);
+void thp_restore_settings(void);
+void thp_save_settings(void);
+
+void thp_set_read_ahead_path(char *path);
+unsigned long thp_supported_orders(void);
+unsigned long thp_shmem_supported_orders(void);
+
+bool thp_available(void);
+bool thp_is_enabled(void);
+
+#endif /* __HUGEPAGE_SETTINGS_H__ */
--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-rename-thp_settings-to-hugepage_settings
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -22,7 +22,7 @@
 #include "linux/magic.h"
 
 #include "vm_util.h"
-#include "thp_settings.h"
+#include "hugepage_settings.h"
 
 #define BASE_ADDR ((void *)(1UL << 30))
 static unsigned long hpage_pmd_size;
--- a/tools/testing/selftests/mm/ksm_tests.c~selftests-mm-rename-thp_settings-to-hugepage_settings
+++ a/tools/testing/selftests/mm/ksm_tests.c
@@ -15,7 +15,7 @@
 #include "kselftest.h"
 #include <include/vdso/time64.h>
 #include "vm_util.h"
-#include "thp_settings.h"
+#include "hugepage_settings.h"
 
 #define KSM_SYSFS_PATH "/sys/kernel/mm/ksm/"
 #define KSM_FP(s) (KSM_SYSFS_PATH s)
--- a/tools/testing/selftests/mm/Makefile~selftests-mm-rename-thp_settings-to-hugepage_settings
+++ a/tools/testing/selftests/mm/Makefile
@@ -187,8 +187,8 @@ TEST_FILES += write_hugetlb_memory.sh
 
 include ../lib.mk
 
-$(TEST_GEN_PROGS): vm_util.c thp_settings.c
-$(TEST_GEN_FILES): vm_util.c thp_settings.c
+$(TEST_GEN_PROGS): vm_util.c hugepage_settings.c
+$(TEST_GEN_FILES): vm_util.c hugepage_settings.c
 
 $(OUTPUT)/uffd-stress: uffd-common.c
 $(OUTPUT)/uffd-unit-tests: uffd-common.c
--- a/tools/testing/selftests/mm/migration.c~selftests-mm-rename-thp_settings-to-hugepage_settings
+++ a/tools/testing/selftests/mm/migration.c
@@ -5,7 +5,7 @@
  */
 
 #include "kselftest_harness.h"
-#include "thp_settings.h"
+#include "hugepage_settings.h"
 
 #include <strings.h>
 #include <pthread.h>
--- a/tools/testing/selftests/mm/prctl_thp_disable.c~selftests-mm-rename-thp_settings-to-hugepage_settings
+++ a/tools/testing/selftests/mm/prctl_thp_disable.c
@@ -14,7 +14,7 @@
 #include <sys/wait.h>
 
 #include "kselftest_harness.h"
-#include "thp_settings.h"
+#include "hugepage_settings.h"
 #include "vm_util.h"
 
 #ifndef PR_THP_DISABLE_EXCEPT_ADVISED
--- a/tools/testing/selftests/mm/soft-dirty.c~selftests-mm-rename-thp_settings-to-hugepage_settings
+++ a/tools/testing/selftests/mm/soft-dirty.c
@@ -9,7 +9,7 @@
 
 #include "kselftest.h"
 #include "vm_util.h"
-#include "thp_settings.h"
+#include "hugepage_settings.h"
 
 #define PAGEMAP_FILE_PATH "/proc/self/pagemap"
 #define TEST_ITERATIONS 10000
--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-rename-thp_settings-to-hugepage_settings
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -21,7 +21,7 @@
 #include <time.h>
 #include "vm_util.h"
 #include "kselftest.h"
-#include "thp_settings.h"
+#include "hugepage_settings.h"
 
 uint64_t pagesize;
 unsigned int pageshift;
diff --git a/tools/testing/selftests/mm/thp_settings.c a/tools/testing/selftests/mm/thp_settings.c
deleted file mode 100644
--- a/tools/testing/selftests/mm/thp_settings.c
+++ /dev/null
@@ -1,397 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <fcntl.h>
-#include <limits.h>
-#include <signal.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <unistd.h>
-
-#include "vm_util.h"
-#include "thp_settings.h"
-
-#define THP_SYSFS "/sys/kernel/mm/transparent_hugepage/"
-#define MAX_SETTINGS_DEPTH 4
-static struct thp_settings settings_stack[MAX_SETTINGS_DEPTH];
-static int settings_index;
-static struct thp_settings saved_settings;
-static char dev_queue_read_ahead_path[PATH_MAX];
-static bool thp_settings_saved;
-
-static const char * const thp_enabled_strings[] = {
-	"never",
-	"always",
-	"inherit",
-	"madvise",
-	NULL
-};
-
-static const char * const thp_defrag_strings[] = {
-	"always",
-	"defer",
-	"defer+madvise",
-	"madvise",
-	"never",
-	NULL
-};
-
-static const char * const shmem_enabled_strings[] = {
-	"never",
-	"always",
-	"within_size",
-	"advise",
-	"inherit",
-	"deny",
-	"force",
-	NULL
-};
-
-int read_file(const char *path, char *buf, size_t buflen)
-{
-	int fd;
-	ssize_t numread;
-
-	fd = open(path, O_RDONLY);
-	if (fd == -1)
-		return 0;
-
-	numread = read(fd, buf, buflen - 1);
-	if (numread < 1) {
-		close(fd);
-		return 0;
-	}
-
-	buf[numread] = '\0';
-	close(fd);
-
-	return (unsigned int) numread;
-}
-
-unsigned long read_num(const char *path)
-{
-	char buf[21];
-
-	if (read_file(path, buf, sizeof(buf)) < 0) {
-		perror("read_file()");
-		exit(EXIT_FAILURE);
-	}
-
-	return strtoul(buf, NULL, 10);
-}
-
-void write_num(const char *path, unsigned long num)
-{
-	char buf[21];
-
-	sprintf(buf, "%ld", num);
-	write_file(path, buf, strlen(buf) + 1);
-}
-
-int thp_read_string(const char *name, const char * const strings[])
-{
-	char path[PATH_MAX];
-	char buf[256];
-	char *c;
-	int ret;
-
-	ret = snprintf(path, PATH_MAX, THP_SYSFS "%s", name);
-	if (ret >= PATH_MAX) {
-		printf("%s: Pathname is too long\n", __func__);
-		exit(EXIT_FAILURE);
-	}
-
-	if (!read_file(path, buf, sizeof(buf))) {
-		perror(path);
-		exit(EXIT_FAILURE);
-	}
-
-	c = strchr(buf, '[');
-	if (!c) {
-		printf("%s: Parse failure\n", __func__);
-		exit(EXIT_FAILURE);
-	}
-
-	c++;
-	memmove(buf, c, sizeof(buf) - (c - buf));
-
-	c = strchr(buf, ']');
-	if (!c) {
-		printf("%s: Parse failure\n", __func__);
-		exit(EXIT_FAILURE);
-	}
-	*c = '\0';
-
-	ret = 0;
-	while (strings[ret]) {
-		if (!strcmp(strings[ret], buf))
-			return ret;
-		ret++;
-	}
-
-	printf("Failed to parse %s\n", name);
-	exit(EXIT_FAILURE);
-}
-
-void thp_write_string(const char *name, const char *val)
-{
-	char path[PATH_MAX];
-	int ret;
-
-	ret = snprintf(path, PATH_MAX, THP_SYSFS "%s", name);
-	if (ret >= PATH_MAX) {
-		printf("%s: Pathname is too long\n", __func__);
-		exit(EXIT_FAILURE);
-	}
-	write_file(path, val, strlen(val) + 1);
-}
-
-unsigned long thp_read_num(const char *name)
-{
-	char path[PATH_MAX];
-	int ret;
-
-	ret = snprintf(path, PATH_MAX, THP_SYSFS "%s", name);
-	if (ret >= PATH_MAX) {
-		printf("%s: Pathname is too long\n", __func__);
-		exit(EXIT_FAILURE);
-	}
-	return read_num(path);
-}
-
-void thp_write_num(const char *name, unsigned long num)
-{
-	char path[PATH_MAX];
-	int ret;
-
-	ret = snprintf(path, PATH_MAX, THP_SYSFS "%s", name);
-	if (ret >= PATH_MAX) {
-		printf("%s: Pathname is too long\n", __func__);
-		exit(EXIT_FAILURE);
-	}
-	write_num(path, num);
-}
-
-void thp_read_settings(struct thp_settings *settings)
-{
-	unsigned long orders = thp_supported_orders();
-	unsigned long shmem_orders = thp_shmem_supported_orders();
-	char path[PATH_MAX];
-	int i;
-
-	*settings = (struct thp_settings) {
-		.thp_enabled = thp_read_string("enabled", thp_enabled_strings),
-		.thp_defrag = thp_read_string("defrag", thp_defrag_strings),
-		.shmem_enabled =
-			thp_read_string("shmem_enabled", shmem_enabled_strings),
-		.use_zero_page = thp_read_num("use_zero_page"),
-	};
-	settings->khugepaged = (struct khugepaged_settings) {
-		.defrag = thp_read_num("khugepaged/defrag"),
-		.alloc_sleep_millisecs =
-			thp_read_num("khugepaged/alloc_sleep_millisecs"),
-		.scan_sleep_millisecs =
-			thp_read_num("khugepaged/scan_sleep_millisecs"),
-		.max_ptes_none = thp_read_num("khugepaged/max_ptes_none"),
-		.max_ptes_swap = thp_read_num("khugepaged/max_ptes_swap"),
-		.max_ptes_shared = thp_read_num("khugepaged/max_ptes_shared"),
-		.pages_to_scan = thp_read_num("khugepaged/pages_to_scan"),
-	};
-	if (dev_queue_read_ahead_path[0])
-		settings->read_ahead_kb = read_num(dev_queue_read_ahead_path);
-
-	for (i = 0; i < NR_ORDERS; i++) {
-		if (!((1 << i) & orders)) {
-			settings->hugepages[i].enabled = THP_NEVER;
-			continue;
-		}
-		snprintf(path, PATH_MAX, "hugepages-%ukB/enabled",
-			(getpagesize() >> 10) << i);
-		settings->hugepages[i].enabled =
-			thp_read_string(path, thp_enabled_strings);
-	}
-
-	for (i = 0; i < NR_ORDERS; i++) {
-		if (!((1 << i) & shmem_orders)) {
-			settings->shmem_hugepages[i].enabled = SHMEM_NEVER;
-			continue;
-		}
-		snprintf(path, PATH_MAX, "hugepages-%ukB/shmem_enabled",
-			(getpagesize() >> 10) << i);
-		settings->shmem_hugepages[i].enabled =
-			thp_read_string(path, shmem_enabled_strings);
-	}
-}
-
-void thp_write_settings(struct thp_settings *settings)
-{
-	struct khugepaged_settings *khugepaged = &settings->khugepaged;
-	unsigned long orders = thp_supported_orders();
-	unsigned long shmem_orders = thp_shmem_supported_orders();
-	char path[PATH_MAX];
-	int enabled;
-	int i;
-
-	thp_write_string("enabled", thp_enabled_strings[settings->thp_enabled]);
-	thp_write_string("defrag", thp_defrag_strings[settings->thp_defrag]);
-	thp_write_string("shmem_enabled",
-			shmem_enabled_strings[settings->shmem_enabled]);
-	thp_write_num("use_zero_page", settings->use_zero_page);
-
-	thp_write_num("khugepaged/defrag", khugepaged->defrag);
-	thp_write_num("khugepaged/alloc_sleep_millisecs",
-			khugepaged->alloc_sleep_millisecs);
-	thp_write_num("khugepaged/scan_sleep_millisecs",
-			khugepaged->scan_sleep_millisecs);
-	thp_write_num("khugepaged/max_ptes_none", khugepaged->max_ptes_none);
-	thp_write_num("khugepaged/max_ptes_swap", khugepaged->max_ptes_swap);
-	thp_write_num("khugepaged/max_ptes_shared", khugepaged->max_ptes_shared);
-	thp_write_num("khugepaged/pages_to_scan", khugepaged->pages_to_scan);
-
-	if (dev_queue_read_ahead_path[0])
-		write_num(dev_queue_read_ahead_path, settings->read_ahead_kb);
-
-	for (i = 0; i < NR_ORDERS; i++) {
-		if (!((1 << i) & orders))
-			continue;
-		snprintf(path, PATH_MAX, "hugepages-%ukB/enabled",
-			(getpagesize() >> 10) << i);
-		enabled = settings->hugepages[i].enabled;
-		thp_write_string(path, thp_enabled_strings[enabled]);
-	}
-
-	for (i = 0; i < NR_ORDERS; i++) {
-		if (!((1 << i) & shmem_orders))
-			continue;
-		snprintf(path, PATH_MAX, "hugepages-%ukB/shmem_enabled",
-			(getpagesize() >> 10) << i);
-		enabled = settings->shmem_hugepages[i].enabled;
-		thp_write_string(path, shmem_enabled_strings[enabled]);
-	}
-}
-
-struct thp_settings *thp_current_settings(void)
-{
-	if (!settings_index) {
-		printf("Fail: No settings set");
-		exit(EXIT_FAILURE);
-	}
-	return settings_stack + settings_index - 1;
-}
-
-void thp_push_settings(struct thp_settings *settings)
-{
-	if (settings_index >= MAX_SETTINGS_DEPTH) {
-		printf("Fail: Settings stack exceeded");
-		exit(EXIT_FAILURE);
-	}
-	settings_stack[settings_index++] = *settings;
-	thp_write_settings(thp_current_settings());
-}
-
-void thp_pop_settings(void)
-{
-	if (settings_index <= 0) {
-		printf("Fail: Settings stack empty");
-		exit(EXIT_FAILURE);
-	}
-	--settings_index;
-	thp_write_settings(thp_current_settings());
-}
-
-void thp_restore_settings(void)
-{
-	if (thp_settings_saved)
-		thp_write_settings(&saved_settings);
-}
-
-static void thp_restore_settings_atexit(void)
-{
-	thp_restore_settings();
-}
-
-static void thp_restore_settings_sighandler(int sig)
-{
-	/* exit() will invoke the thp_restore_settings_atexit handler. */
-	exit(KSFT_FAIL);
-}
-
-void thp_save_settings(void)
-{
-	thp_read_settings(&saved_settings);
-	thp_settings_saved = true;
-
-	/*
-	 * setup exit hooks to make sure THP settings are restored on graceful
-	 * and error exits and signals
-	 */
-	atexit(thp_restore_settings_atexit);
-	signal(SIGTERM, thp_restore_settings_sighandler);
-	signal(SIGINT, thp_restore_settings_sighandler);
-	signal(SIGHUP, thp_restore_settings_sighandler);
-	signal(SIGQUIT, thp_restore_settings_sighandler);
-}
-
-void thp_set_read_ahead_path(char *path)
-{
-	if (!path) {
-		dev_queue_read_ahead_path[0] = '\0';
-		return;
-	}
-
-	strncpy(dev_queue_read_ahead_path, path,
-		sizeof(dev_queue_read_ahead_path));
-	dev_queue_read_ahead_path[sizeof(dev_queue_read_ahead_path) - 1] = '\0';
-}
-
-static unsigned long __thp_supported_orders(bool is_shmem)
-{
-	unsigned long orders = 0;
-	char path[PATH_MAX];
-	char buf[256];
-	int ret, i;
-	char anon_dir[] = "enabled";
-	char shmem_dir[] = "shmem_enabled";
-
-	for (i = 0; i < NR_ORDERS; i++) {
-		ret = snprintf(path, PATH_MAX, THP_SYSFS "hugepages-%ukB/%s",
-			       (getpagesize() >> 10) << i, is_shmem ? shmem_dir : anon_dir);
-		if (ret >= PATH_MAX) {
-			printf("%s: Pathname is too long\n", __func__);
-			exit(EXIT_FAILURE);
-		}
-
-		ret = read_file(path, buf, sizeof(buf));
-		if (ret)
-			orders |= 1UL << i;
-	}
-
-	return orders;
-}
-
-unsigned long thp_supported_orders(void)
-{
-	return __thp_supported_orders(false);
-}
-
-unsigned long thp_shmem_supported_orders(void)
-{
-	return __thp_supported_orders(true);
-}
-
-bool thp_available(void)
-{
-	if (access(THP_SYSFS, F_OK) != 0)
-		return false;
-	return true;
-}
-
-bool thp_is_enabled(void)
-{
-	if (!thp_available())
-		return false;
-
-	int mode = thp_read_string("enabled", thp_enabled_strings);
-
-	/* THP is considered enabled if it's either "always" or "madvise" */
-	return mode == 1 || mode == 3;
-}
diff --git a/tools/testing/selftests/mm/thp_settings.h a/tools/testing/selftests/mm/thp_settings.h
deleted file mode 100644
--- a/tools/testing/selftests/mm/thp_settings.h
+++ /dev/null
@@ -1,89 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __THP_SETTINGS_H__
-#define __THP_SETTINGS_H__
-
-#include <stdbool.h>
-#include <stddef.h>
-#include <stdint.h>
-
-enum thp_enabled {
-	THP_NEVER,
-	THP_ALWAYS,
-	THP_INHERIT,
-	THP_MADVISE,
-};
-
-enum thp_defrag {
-	THP_DEFRAG_ALWAYS,
-	THP_DEFRAG_DEFER,
-	THP_DEFRAG_DEFER_MADVISE,
-	THP_DEFRAG_MADVISE,
-	THP_DEFRAG_NEVER,
-};
-
-enum shmem_enabled {
-	SHMEM_NEVER,
-	SHMEM_ALWAYS,
-	SHMEM_WITHIN_SIZE,
-	SHMEM_ADVISE,
-	SHMEM_INHERIT,
-	SHMEM_DENY,
-	SHMEM_FORCE,
-};
-
-#define NR_ORDERS 20
-
-struct hugepages_settings {
-	enum thp_enabled enabled;
-};
-
-struct khugepaged_settings {
-	bool defrag;
-	unsigned int alloc_sleep_millisecs;
-	unsigned int scan_sleep_millisecs;
-	unsigned int max_ptes_none;
-	unsigned int max_ptes_swap;
-	unsigned int max_ptes_shared;
-	unsigned long pages_to_scan;
-};
-
-struct shmem_hugepages_settings {
-	enum shmem_enabled enabled;
-};
-
-struct thp_settings {
-	enum thp_enabled thp_enabled;
-	enum thp_defrag thp_defrag;
-	enum shmem_enabled shmem_enabled;
-	bool use_zero_page;
-	struct khugepaged_settings khugepaged;
-	unsigned long read_ahead_kb;
-	struct hugepages_settings hugepages[NR_ORDERS];
-	struct shmem_hugepages_settings shmem_hugepages[NR_ORDERS];
-};
-
-int read_file(const char *path, char *buf, size_t buflen);
-unsigned long read_num(const char *path);
-void write_num(const char *path, unsigned long num);
-
-int thp_read_string(const char *name, const char * const strings[]);
-void thp_write_string(const char *name, const char *val);
-unsigned long thp_read_num(const char *name);
-void thp_write_num(const char *name, unsigned long num);
-
-void thp_write_settings(struct thp_settings *settings);
-void thp_read_settings(struct thp_settings *settings);
-struct thp_settings *thp_current_settings(void);
-void thp_push_settings(struct thp_settings *settings);
-void thp_pop_settings(void);
-void thp_restore_settings(void);
-void thp_save_settings(void);
-
-void thp_set_read_ahead_path(char *path);
-unsigned long thp_supported_orders(void);
-unsigned long thp_shmem_supported_orders(void);
-
-bool thp_available(void);
-bool thp_is_enabled(void);
-
-#endif /* __THP_SETTINGS_H__ */
--- a/tools/testing/selftests/mm/transhuge-stress.c~selftests-mm-rename-thp_settings-to-hugepage_settings
+++ a/tools/testing/selftests/mm/transhuge-stress.c
@@ -17,7 +17,7 @@
 #include <sys/mman.h>
 #include "vm_util.h"
 #include "kselftest.h"
-#include "thp_settings.h"
+#include "hugepage_settings.h"
 
 int backing_fd = -1;
 int mmap_flags = MAP_ANONYMOUS | MAP_NORESERVE | MAP_PRIVATE;
--- a/tools/testing/selftests/mm/uffd-wp-mremap.c~selftests-mm-rename-thp_settings-to-hugepage_settings
+++ a/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -8,7 +8,7 @@
 #include <linux/mman.h>
 #include <sys/mman.h>
 #include "kselftest.h"
-#include "thp_settings.h"
+#include "hugepage_settings.h"
 #include "uffd-common.h"
 
 static int pagemap_fd;
_

Patches currently in -mm which might be from rppt@kernel.org are

maintainers-add-tree-for-kdump-and-kexec.patch
maintainers-add-kexec-list-to-live-update-entry.patch
sh-fix-fallout-from-zero_page-consolidation.patch
selftests-mm-hugetlb-read-hwpoison-add-sigbus-handler.patch
selftests-mm-migration-dont-assume-huge-page-is-twomeg.patch
selftests-mm-migration-make-nthreads-represent-number-of-working-threads.patch
selftests-mm-migration-properly-cleanup-forked-processes.patch
selftests-mm-run_vmtestssh-dont-gate-thp-and-ksm-tests-on-have_hugepages.patch
selftests-mm-merge-map_hugetlb-into-hugepage-mmap.patch
selftests-mm-rename-hugepage-tests-to-hugetlb.patch
selftests-mm-hugetlb-shm-use-kselftest-framework.patch
selftests-mm-hugetlb-vmemmap-use-kselftest-framework.patch
selftests-mm-hugetlb-madvise-use-kselftest-framework.patch
selftests-mm-hugetlb_madv_vs_map-use-kselftest-framework.patch
selftests-mm-hugetlb-read-hwpoison-use-kselftest-framework.patch
selftests-mm-khugepaged-group-tests-in-an-array.patch
selftests-mm-khugepaged-use-ksefltest-framework.patch
selftests-mm-ksm_tests-use-kselftest-framework.patch
selftests-mm-protection_keys-use-descriptive-test-names-in-the-output.patch
selftests-mm-protection_keys-use-kselftest-framework.patch
selftests-mm-uffd-common-use-kselftest-framework.patch
selftests-mm-uffd-stress-use-kselftest-framework.patch
selftests-mm-uffd-unit-tests-use-kselftest-framework.patch
selftests-mm-va_high_addr_switch-use-kselftest-framework.patch
selftests-mm-add-atexit-and-signal-handlers-to-thp_settings.patch
selftests-mm-rename-thp_settings-to-hugepage_settings.patch
selftests-mm-move-hugetlb-helpers-to-hugepage_settings.patch
selftests-mm-hugepage_settings-use-unsigned-long-in-detect_hugetlb_page_size.patch
selftests-mm-hugepage_settings-add-apis-to-get-and-set-nr_hugepages.patch
selftests-mm-hugepage_settings-rename-and-rework-get_free_hugepages.patch
selftests-mm-hugepage_settings-add-apis-for-hugetlb-setup-and-teardown.patch
selftests-mm-move-read_file-read_num-and-write_num-to-vm_util.patch
selftests-mm-vm_util-add-helpers-to-set-and-restore-shm-limits.patch
selftests-mm-compaction_test-use-hugetlb-helpers.patch
selftests-mm-cow-add-setup-of-hugetlb-pages.patch
selftests-mm-gup_longterm-add-setup-of-hugetlb-pages.patch
selftests-mm-gup_test-add-setup-of-hugetlb-pages.patch
selftests-mm-hmm-tests-add-setup-of-hugetlb-pages.patch
selftests-mm-hugepage_dio-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb_fault_after_madv-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-madvise-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb_madv_vs_map-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-mmap-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-mremap-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-shm-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-soft-offline-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-vmemmap-add-setup-of-hugetlb-pages.patch
selftests-mm-migration-add-setup-of-hugetlb-pages.patch
selftests-mm-pagemap_ioctl-add-setup-of-hugetlb-pages.patch
selftests-mm-protection_keys-use-library-code-for-hugetlb-setup.patch
selftests-mm-thuge-gen-add-setup-of-hugetlb-pages.patch
selftests-mm-uffd-stress-use-hugetlb_save-and-alloc-huge-pages.patch
selftests-mm-uffd-unit-tests-add-setup-of-hugetlb-pages.patch
selftests-mm-uffd-wp-mremap-add-setup-of-hugetlb-pages.patch
selftests-mm-va_high_addr_switch-add-setup-of-hugetlb-pages.patch
selftests-mm-va_high_addr_switchsh-drop-huge-pages-setup.patch
selftests-mm-run_vmtestssh-free-memory-if-available-memory-is-low.patch
selftests-mm-run_vmtestssh-drop-detection-and-setup-of-hugetlb.patch

