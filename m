Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F9436F8EF
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 23:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783379887; cv=none; b=EgUYmiXhrGWSUh+PV+XtBsQiv1TJHaRSmMXDNEli61gZph+jkfKSBwgd5lwZvSnejnI3NecCEw8ohRM3rddMtuRYJ+1IA833cO27GvyvMheKSKoNgJV7eVl4abwIIc5HoPeIXbDXM8kHS2By8D2/Vz5xElNopU2vr1KT7rakzY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783379887; c=relaxed/simple;
	bh=LYDXFPR727Dt49OcwFhSAeNUkrn/dQMqNM5BVz1hErY=;
	h=Date:To:From:Subject:Message-Id; b=toOF0QZEAnD8mu/lIwXpEz6kYkmKDCY7sA7p/6iJYhzuMES42SitqPq6q0s4BYonvMnGpVF9kcsYZZ7+hOkOI8xvxQZcdmlNBrzbgA3NAd+N6nRsTHspKbsvjxz6sGbUmQ3qqGDsWOfV1rx/NHPod94IdTRxvN3lkJIlQ1WMcbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ORJSL+sn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ORJSL+sn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D4D1F000E9;
	Mon,  6 Jul 2026 23:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783379885;
	bh=1E3E2Mghdq5DOB0cmkfoZOW5ESmPQYy/RkNrUarvhTI=;
	h=Date:To:From:Subject;
	b=ORJSL+sn6+7zJrbXZ8VNpnVFj80MmzM10JxOEDWZYkkDANfDCktvJGyQfBZ/EB2gq
	 NbktDpyAaPdQsEFlbzE5+FAlFJiWqG69A9Wcr3joHXM3gI8hxpY0xoKsyTjLUNHILn
	 P/J/tRd/kaTuD4nWJtvIb5yHM8jokIEEGC9LeJWE=
Date: Mon, 06 Jul 2026 16:18:05 -0700
To: mm-commits@vger.kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-move-pkey-selftest-helpers-to-pkey_utilc.patch removed from -mm tree
Message-Id: <20260706231805.B6D4D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: move pkey selftest helpers to pkey_util.c
has been removed from the -mm tree.  Its filename was
     selftests-mm-move-pkey-selftest-helpers-to-pkey_utilc.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: selftests/mm: move pkey selftest helpers to pkey_util.c
Date: Thu, 2 Jul 2026 14:23:28 +0800

Patch series "selftests/mm: refactor pkey helpers and fix mmap error
handling", v9.

The main changes in this series are to refactor shared tracing and
assertion helpers into a common file, unify both pkey selftests on
pkey_assert() and per-test tracing for consistent diagnostics, and add
missing mmap() return checks with MAP_FAILED used throughout for
readability and consistency.


This patch (of 5):

Move pkey selftest debugging helpers into shared code so both pkey
selftests can use the same tracing and abort-hook logic.  Also fix
cat_into_file() to print file, not str, in the open() failure message.

Link: https://lore.kernel.org/20260702062332.911786-1-lihongfu@kylinos.cn
Link: https://lore.kernel.org/20260702062332.911786-2-lihongfu@kylinos.cn
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Tested-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Keith Lucas <keith.lucas@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Ross Zwisler <zwisler@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Yury Khrustalev <yury.khrustalev@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pkey-helpers.h    |    4 
 tools/testing/selftests/mm/pkey_util.c       |   90 +++++++++++++++++
 tools/testing/selftests/mm/protection_keys.c |   87 ----------------
 3 files changed, 93 insertions(+), 88 deletions(-)

--- a/tools/testing/selftests/mm/pkey-helpers.h~selftests-mm-move-pkey-selftest-helpers-to-pkey_utilc
+++ a/tools/testing/selftests/mm/pkey-helpers.h
@@ -68,7 +68,9 @@ static inline void sigsafe_printf(const
 #define dprintf3(args...) dprintf_level(3, args)
 #define dprintf4(args...) dprintf_level(4, args)
 
-extern void abort_hooks(void);
+void tracing_on(void);
+void tracing_off(void);
+void abort_hooks(void);
 #define pkey_assert(condition) do {		\
 	if (!(condition)) {			\
 		dprintf0("# assert() at %s::%d test_nr: %d iteration: %d\n", \
--- a/tools/testing/selftests/mm/pkey_util.c~selftests-mm-move-pkey-selftest-helpers-to-pkey_utilc
+++ a/tools/testing/selftests/mm/pkey_util.c
@@ -2,9 +2,99 @@
 #define __SANE_USERSPACE_TYPES__
 #include <sys/syscall.h>
 #include <unistd.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <string.h>
 
 #include "pkey-helpers.h"
 
+int iteration_nr = 1;
+int test_nr;
+int dprint_in_signal;
+
+#if CONTROL_TRACING > 0
+static void cat_into_file(char *str, char *file)
+{
+	int fd = open(file, O_RDWR);
+	int ret;
+
+	dprintf2("%s(): writing '%s' to '%s'\n", __func__, str, file);
+	/*
+	 * these need to be raw because they are called under
+	 * pkey_assert()
+	 */
+	if (fd < 0) {
+		fprintf(stderr, "error opening '%s'\n", file);
+		perror("error: ");
+		exit(__LINE__);
+	}
+
+	ret = write(fd, str, strlen(str));
+	if (ret != strlen(str)) {
+		perror("write to file failed");
+		fprintf(stderr, "filename: '%s' str: '%s'\n", file, str);
+		exit(__LINE__);
+	}
+	close(fd);
+}
+
+static int warned_tracing;
+static int tracing_root_ok(void)
+{
+	if (geteuid() != 0) {
+		if (!warned_tracing)
+			fprintf(stderr, "WARNING: not run as root, "
+					"can not do tracing control\n");
+		warned_tracing = 1;
+		return 0;
+	}
+	return 1;
+}
+#endif
+
+void tracing_on(void)
+{
+#if CONTROL_TRACING > 0
+#define TRACEDIR "/sys/kernel/tracing"
+	char pidstr[32];
+
+	if (!tracing_root_ok())
+		return;
+
+	sprintf(pidstr, "%d", getpid());
+	cat_into_file("0", TRACEDIR "/tracing_on");
+	cat_into_file("\n", TRACEDIR "/trace");
+	if (1) {
+		cat_into_file("function_graph", TRACEDIR "/current_tracer");
+		cat_into_file("1", TRACEDIR "/options/funcgraph-proc");
+	} else {
+		cat_into_file("nop", TRACEDIR "/current_tracer");
+	}
+	cat_into_file(pidstr, TRACEDIR "/set_ftrace_pid");
+	cat_into_file("1", TRACEDIR "/tracing_on");
+	dprintf1("enabled tracing\n");
+#endif
+}
+
+void tracing_off(void)
+{
+#if CONTROL_TRACING > 0
+	if (!tracing_root_ok())
+		return;
+	cat_into_file("0", "/sys/kernel/tracing/tracing_on");
+#endif
+}
+
+void abort_hooks(void)
+{
+	fflush(stdout);
+	fprintf(stderr, "running %s()...\n", __func__);
+	tracing_off();
+#ifdef SLEEP_ON_ABORT
+	sleep(SLEEP_ON_ABORT);
+#endif
+}
+
 int sys_pkey_alloc(unsigned long flags, unsigned long init_val)
 {
 	int ret = syscall(SYS_pkey_alloc, flags, init_val);
--- a/tools/testing/selftests/mm/protection_keys.c~selftests-mm-move-pkey-selftest-helpers-to-pkey_utilc
+++ a/tools/testing/selftests/mm/protection_keys.c
@@ -49,11 +49,7 @@
 #include "hugepage_settings.h"
 #include "pkey-helpers.h"
 
-int iteration_nr = 1;
-int test_nr;
-
 u64 shadow_pkey_reg;
-int dprint_in_signal;
 
 noinline int read_ptr(int *ptr)
 {
@@ -62,89 +58,6 @@ noinline int read_ptr(int *ptr)
 	return *ptr;
 }
 
-#if CONTROL_TRACING > 0
-static void cat_into_file(char *str, char *file)
-{
-	int fd = open(file, O_RDWR);
-	int ret;
-
-	dprintf2("%s(): writing '%s' to '%s'\n", __func__, str, file);
-	/*
-	 * these need to be raw because they are called under
-	 * pkey_assert()
-	 */
-	if (fd < 0) {
-		fprintf(stderr, "error opening '%s'\n", str);
-		perror("error: ");
-		exit(__LINE__);
-	}
-
-	ret = write(fd, str, strlen(str));
-	if (ret != strlen(str)) {
-		perror("write to file failed");
-		fprintf(stderr, "filename: '%s' str: '%s'\n", file, str);
-		exit(__LINE__);
-	}
-	close(fd);
-}
-
-static int warned_tracing;
-static int tracing_root_ok(void)
-{
-	if (geteuid() != 0) {
-		if (!warned_tracing)
-			fprintf(stderr, "WARNING: not run as root, "
-					"can not do tracing control\n");
-		warned_tracing = 1;
-		return 0;
-	}
-	return 1;
-}
-#endif
-
-static void tracing_on(void)
-{
-#if CONTROL_TRACING > 0
-#define TRACEDIR "/sys/kernel/tracing"
-	char pidstr[32];
-
-	if (!tracing_root_ok())
-		return;
-
-	sprintf(pidstr, "%d", getpid());
-	cat_into_file("0", TRACEDIR "/tracing_on");
-	cat_into_file("\n", TRACEDIR "/trace");
-	if (1) {
-		cat_into_file("function_graph", TRACEDIR "/current_tracer");
-		cat_into_file("1", TRACEDIR "/options/funcgraph-proc");
-	} else {
-		cat_into_file("nop", TRACEDIR "/current_tracer");
-	}
-	cat_into_file(pidstr, TRACEDIR "/set_ftrace_pid");
-	cat_into_file("1", TRACEDIR "/tracing_on");
-	dprintf1("enabled tracing\n");
-#endif
-}
-
-static void tracing_off(void)
-{
-#if CONTROL_TRACING > 0
-	if (!tracing_root_ok())
-		return;
-	cat_into_file("0", "/sys/kernel/tracing/tracing_on");
-#endif
-}
-
-void abort_hooks(void)
-{
-	fflush(stdout);
-	fprintf(stderr, "running %s()...\n", __func__);
-	tracing_off();
-#ifdef SLEEP_ON_ABORT
-	sleep(SLEEP_ON_ABORT);
-#endif
-}
-
 /*
  * This attempts to have roughly a page of instructions followed by a few
  * instructions that do a write, and another page of instructions.  That
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

selftests-mm-unify-pkey-sighandler-selftest-assertions-and-tracing.patch
selftests-mm-use-pkey_assert-on-clone_raw-failure-in-pkey-test.patch
selftests-mm-add-missing-mmap-return-checks-in-pkey-tests.patch
selftests-mm-add-missing-pthread_create-return-checks-in-pkey-tests.patch

