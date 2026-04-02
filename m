Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1676730F95F
	for <mm-commits@vger.kernel.org>; Thu,  2 Apr 2026 03:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775100775; cv=none; b=GiURzEZRbvbTfp4qoFqje/3eMI++CQn1I232n0vbWMfXhUpkfOHnYu2QnQaF7vrY8rK0VJE1WeBHlJbN2BB1xvVmTqTB1Xp1jQzVvN/wCTkrUVxZ00d5pyg8sXyNrvbBC4cDjFPep0+KbjDJFqWNmg/90v1s75cXxlEkQv56r4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775100775; c=relaxed/simple;
	bh=S6376FHPouVMhWk3AXuUqGB5D6mxwnTHdv4vAXzW6J8=;
	h=Date:To:From:Subject:Message-Id; b=FVoxXSX9yuvn7BoVpIWyKJQJ9z9a2LIPzXon17GXKBQ/MwXuNCVIfEGKZ/e2ESdC2kdgPFsnm6yGsE/YvkM1wqv7LvCsQomDlCrVjADPCnv4didHN5sia9s3u0IirkfXPJcp99jDkYBUwCVhx43/UNj3aUGaMf4rMVNdlF/Ckyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q1ijzAYW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q1ijzAYW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD9F7C4CEF7;
	Thu,  2 Apr 2026 03:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775100774;
	bh=S6376FHPouVMhWk3AXuUqGB5D6mxwnTHdv4vAXzW6J8=;
	h=Date:To:From:Subject:From;
	b=Q1ijzAYWKBakcH6guvfrE6/wGVemaAaKOlgnzKgijdMIN/O0A+7JjnPIfbrppsMHq
	 k97hIECwjcGIINPQjaV1nqg1cJfstNRhQsQdnqmGDHUqfmjDyAHBsxciYeltpLPAyi
	 +WhtgSb+wEhpLbZmzOrDAiszqVJDj0oCzYA2MpLs=
Date: Wed, 01 Apr 2026 20:32:54 -0700
To: mm-commits@vger.kernel.org,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-move-write_file-helper-to-vm_util.patch added to mm-unstable branch
Message-Id: <20260402033254.AD9F7C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: move write_file helper to vm_util
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-move-write_file-helper-to-vm_util.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-move-write_file-helper-to-vm_util.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Chunyu Hu <chuhu@redhat.com>
Subject: selftests/mm: move write_file helper to vm_util
Date: Thu, 2 Apr 2026 09:45:40 +0800

thp_settings provides write_file() helper for safely writing to a file and
exit when write failure happens.  It's a very low level helper and many
sub tests need such a helper, not only thp tests.

split_huge_page_test also defines a write_file locally.  The two have
minior differences in return type and used exit api.  And there would be
conflicts if split_huge_page_test wanted to include thp_settings.h because
of different prototype, making it less convenient.

It's possisble to merge the two, although some tests don't use the
kselftest infrastrucutre for testing.  It would also work when using the
ksft_exit_msg() to exit in my test, as the counters are all zero.  Output
will be like:

  TAP version 13
  1..62
  Bail out! /proc/sys/vm/drop_caches1 open failed: No such file or directory
  # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0

So here we just keep the version in split_huge_page_test, and move it into
the vm_util.  This makes it easy to maitain and user could just include
one vm_util.h when they don't need thp setting helpers.  Keep the
prototype of void return as the function will exit on any error, return
value is not necessary, and will simply the callers like write_num() and
write_string().

Link: https://lkml.kernel.org/r/20260402014543.1671131-4-chuhu@redhat.com
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Suggested-by: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |   15 -----
 tools/testing/selftests/mm/thp_settings.c         |   35 +-----------
 tools/testing/selftests/mm/thp_settings.h         |    1 
 tools/testing/selftests/mm/vm_util.c              |   15 +++++
 tools/testing/selftests/mm/vm_util.h              |    2 
 5 files changed, 20 insertions(+), 48 deletions(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-move-write_file-helper-to-vm_util
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -255,21 +255,6 @@ static int check_after_split_folio_order
 	return status;
 }
 
-static void write_file(const char *path, const char *buf, size_t buflen)
-{
-	int fd;
-	ssize_t numwritten;
-
-	fd = open(path, O_WRONLY);
-	if (fd == -1)
-		ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));
-
-	numwritten = write(fd, buf, buflen - 1);
-	close(fd);
-	if (numwritten < 1)
-		ksft_exit_fail_msg("Write failed\n");
-}
-
 static void write_debugfs(const char *fmt, ...)
 {
 	char input[INPUT_MAX];
--- a/tools/testing/selftests/mm/thp_settings.c~selftests-mm-move-write_file-helper-to-vm_util
+++ a/tools/testing/selftests/mm/thp_settings.c
@@ -6,6 +6,7 @@
 #include <string.h>
 #include <unistd.h>
 
+#include "vm_util.h"
 #include "thp_settings.h"
 
 #define THP_SYSFS "/sys/kernel/mm/transparent_hugepage/"
@@ -64,29 +65,6 @@ int read_file(const char *path, char *bu
 	return (unsigned int) numread;
 }
 
-int write_file(const char *path, const char *buf, size_t buflen)
-{
-	int fd;
-	ssize_t numwritten;
-
-	fd = open(path, O_WRONLY);
-	if (fd == -1) {
-		printf("open(%s)\n", path);
-		exit(EXIT_FAILURE);
-		return 0;
-	}
-
-	numwritten = write(fd, buf, buflen - 1);
-	close(fd);
-	if (numwritten < 1) {
-		printf("write(%s)\n", buf);
-		exit(EXIT_FAILURE);
-		return 0;
-	}
-
-	return (unsigned int) numwritten;
-}
-
 unsigned long read_num(const char *path)
 {
 	char buf[21];
@@ -104,10 +82,7 @@ void write_num(const char *path, unsigne
 	char buf[21];
 
 	sprintf(buf, "%ld", num);
-	if (!write_file(path, buf, strlen(buf) + 1)) {
-		perror(path);
-		exit(EXIT_FAILURE);
-	}
+	write_file(path, buf, strlen(buf) + 1);
 }
 
 int thp_read_string(const char *name, const char * const strings[])
@@ -165,11 +140,7 @@ void thp_write_string(const char *name,
 		printf("%s: Pathname is too long\n", __func__);
 		exit(EXIT_FAILURE);
 	}
-
-	if (!write_file(path, val, strlen(val) + 1)) {
-		perror(path);
-		exit(EXIT_FAILURE);
-	}
+	write_file(path, val, strlen(val) + 1);
 }
 
 unsigned long thp_read_num(const char *name)
--- a/tools/testing/selftests/mm/thp_settings.h~selftests-mm-move-write_file-helper-to-vm_util
+++ a/tools/testing/selftests/mm/thp_settings.h
@@ -63,7 +63,6 @@ struct thp_settings {
 };
 
 int read_file(const char *path, char *buf, size_t buflen);
-int write_file(const char *path, const char *buf, size_t buflen);
 unsigned long read_num(const char *path);
 void write_num(const char *path, unsigned long num);
 
--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-move-write_file-helper-to-vm_util
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -764,3 +764,18 @@ int unpoison_memory(unsigned long pfn)
 
 	return ret > 0 ? 0 : -errno;
 }
+
+void write_file(const char *path, const char *buf, size_t buflen)
+{
+	int fd;
+	ssize_t numwritten;
+
+	fd = open(path, O_WRONLY);
+	if (fd == -1)
+		ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));
+
+	numwritten = write(fd, buf, buflen - 1);
+	close(fd);
+	if (numwritten < 1)
+		ksft_exit_fail_msg("Write failed\n");
+}
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-move-write_file-helper-to-vm_util
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -166,3 +166,5 @@ int unpoison_memory(unsigned long pfn);
 
 #define PAGEMAP_PRESENT(ent)	(((ent) & (1ull << 63)) != 0)
 #define PAGEMAP_PFN(ent)	((ent) & ((1ull << 55) - 1))
+
+void write_file(const char *path, const char *buf, size_t buflen);
_

Patches currently in -mm which might be from chuhu@redhat.com are

selftests-mm-guard-regions-skip-collapse-test-when-thp-not-enabled.patch
selftests-mm-soft-dirty-skip-two-tests-when-thp-is-not-available.patch
selftests-mm-move-write_file-helper-to-vm_util.patch
selftests-mm-vm_util-robust-write_file.patch
selftests-mm-split_huge_page_test-skip-the-test-when-thp-is-not-available.patch
selftests-mm-transhuge_stress-skip-the-test-when-thp-not-available.patch

