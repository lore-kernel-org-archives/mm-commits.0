Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C543264FD
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776499078; cv=none; b=mTdVh/3sHtAsILY00KfsSbGkK+M/SKhaPpm+hHT8jqFIEcZv6mIcz0hG/6BUY0f/D8LclAkgWB7kHJbRXDRAo/93V7nroX4SMWM+BIDdpUorqkQ7iCI31rs5EeTvhwzZ4F2CSHQVs98en3KuUfiQa9xiEBCTaiBwLiI0vvBk2pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776499078; c=relaxed/simple;
	bh=mMQwspG67RqTQLj/5A/oO08Iup8bMn3UZQhDbbvMX8A=;
	h=Date:To:From:Subject:Message-Id; b=BbfV/Ywb9YLoEly89pS0po+tN+u5pjW2NzNOc2AV2b8hDjySho83hfkWFnMIyWg27AhR31XF/kXVEIglVFP4FQZcUlUXeqYCPg0XQdxl0VP7gWi8Vkvi564IOJUlIB+bQFTimKX6XKScdy7EPgw6/1dloQySJkaUdGcitIo8Lug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RasHBSAO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RasHBSAO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E894FC19424;
	Sat, 18 Apr 2026 07:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776499078;
	bh=mMQwspG67RqTQLj/5A/oO08Iup8bMn3UZQhDbbvMX8A=;
	h=Date:To:From:Subject:From;
	b=RasHBSAOCR+DVxzKzJTDps7X64GMEs2bYnJwjunYYnZphyvm3mshDTcFwJj364wru
	 13dU2e6dBfjAK2FghVL0qv7OPNM2Zwq8YSK7ThNJ7iS2yUrJL3Uzesv20T5h2etfdM
	 7fX0Cqw/G6/oTxj8/idtSEIOS2xKDWq189FjA4dY=
Date: Sat, 18 Apr 2026 00:57:53 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,rppt@kernel.org,npache@redhat.com,ljs@kernel.org,david@kernel.org,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-move-write_file-helper-to-vm_util.patch removed from -mm tree
Message-Id: <20260418075757.E894FC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: move write_file helper to vm_util
has been removed from the -mm tree.  Its filename was
     selftests-mm-move-write_file-helper-to-vm_util.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lore.kernel.org/20260402014543.1671131-4-chuhu@redhat.com
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Suggested-by: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
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


