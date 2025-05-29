Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E59A4685
	for <mm-commits@vger.kernel.org>; Thu, 29 May 2025 19:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748546811; cv=none; b=DO5Wi8CplPu0mBQKEb3tjFSd7BPZWl+LH3xTOU3nJmTBnKXCq/wHkU+L4K+qcmaeVGSNuvpy2cnWiCCGjsWLXjlzcSV+ITHIdyrgcEEAYbYlzJilpmaRiQZy2xBrWbC9YHoVPT+bU9XXJcPpe6MaZGWtlE/8WjOqWkY1Xl9uKWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748546811; c=relaxed/simple;
	bh=+IARCaVqV8Yq9p3f1LpkoBMr8PEQft113HCfWDjJh2E=;
	h=Date:To:From:Subject:Message-Id; b=tFfsNNgvSduumISLUAVE/eKUn32rUxMDkj65wNw+ZynBgQp3R4KkOVCfspWbLgVud8y/RnkON9//KntUlEdiSWRFElSLs9S7KJINl5+7nbq26mUcDWIp5vpW1cJvI9E4zQKuSDNFxZp0PoK+uQST9TnrQrs5/OJ7v8wGjMp09oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g0D+rmNO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g0D+rmNO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5E4C4CEE7;
	Thu, 29 May 2025 19:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748546811;
	bh=+IARCaVqV8Yq9p3f1LpkoBMr8PEQft113HCfWDjJh2E=;
	h=Date:To:From:Subject:From;
	b=g0D+rmNOEvewqSBn+GBiNM25qeHl+29Zt9BPBujf7FtJeoZFfaA27KZJl3bwi8mJd
	 t6B5NsxBGVwWnMeCJhxOUKj9QYbIRGAklaxvFp/m3uJtd7VYxP+QTzmPp7Zdi2Z/7P
	 KJzU0bZlAN/cc9JeW+KQEXvMrJVBvuGTorMfCVpY=
Date: Thu, 29 May 2025 12:26:50 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,peterz@infradead.org,oleg@redhat.com,mhiramat@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,pulehui@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-extract-read_sysfs-and-write_sysfs-into-vm_util.patch added to mm-unstable branch
Message-Id: <20250529192650.DD5E4C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: extract read_sysfs and write_sysfs into vm_util
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-extract-read_sysfs-and-write_sysfs-into-vm_util.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-extract-read_sysfs-and-write_sysfs-into-vm_util.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Pu Lehui <pulehui@huawei.com>
Subject: selftests/mm: extract read_sysfs and write_sysfs into vm_util
Date: Thu, 29 May 2025 15:56:49 +0000

Extract read_sysfs and write_sysfs into vm_util.  Meanwhile, rename the
function in thuge-gen that has the same name as read_sysfs.

Link: https://lkml.kernel.org/r/20250529155650.4017699-4-pulehui@huaweicloud.com
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_tests.c |   32 +------------------
 tools/testing/selftests/mm/thuge-gen.c |    6 +--
 tools/testing/selftests/mm/vm_util.c   |   38 +++++++++++++++++++++++
 tools/testing/selftests/mm/vm_util.h   |    2 +
 4 files changed, 45 insertions(+), 33 deletions(-)

--- a/tools/testing/selftests/mm/ksm_tests.c~selftests-mm-extract-read_sysfs-and-write_sysfs-into-vm_util
+++ a/tools/testing/selftests/mm/ksm_tests.c
@@ -58,40 +58,12 @@ int debug;
 
 static int ksm_write_sysfs(const char *file_path, unsigned long val)
 {
-	FILE *f = fopen(file_path, "w");
-
-	if (!f) {
-		fprintf(stderr, "f %s\n", file_path);
-		perror("fopen");
-		return 1;
-	}
-	if (fprintf(f, "%lu", val) < 0) {
-		perror("fprintf");
-		fclose(f);
-		return 1;
-	}
-	fclose(f);
-
-	return 0;
+	return write_sysfs(file_path, val);
 }
 
 static int ksm_read_sysfs(const char *file_path, unsigned long *val)
 {
-	FILE *f = fopen(file_path, "r");
-
-	if (!f) {
-		fprintf(stderr, "f %s\n", file_path);
-		perror("fopen");
-		return 1;
-	}
-	if (fscanf(f, "%lu", val) != 1) {
-		perror("fscanf");
-		fclose(f);
-		return 1;
-	}
-	fclose(f);
-
-	return 0;
+	return read_sysfs(file_path, val);
 }
 
 static void ksm_print_sysfs(void)
--- a/tools/testing/selftests/mm/thuge-gen.c~selftests-mm-extract-read_sysfs-and-write_sysfs-into-vm_util
+++ a/tools/testing/selftests/mm/thuge-gen.c
@@ -77,7 +77,7 @@ void show(unsigned long ps)
 	system(buf);
 }
 
-unsigned long read_sysfs(int warn, char *fmt, ...)
+unsigned long thuge_read_sysfs(int warn, char *fmt, ...)
 {
 	char *line = NULL;
 	size_t linelen = 0;
@@ -106,7 +106,7 @@ unsigned long read_sysfs(int warn, char
 
 unsigned long read_free(unsigned long ps)
 {
-	return read_sysfs(ps != getpagesize(),
+	return thuge_read_sysfs(ps != getpagesize(),
 			  "/sys/kernel/mm/hugepages/hugepages-%lukB/free_hugepages",
 			  ps >> 10);
 }
@@ -195,7 +195,7 @@ void find_pagesizes(void)
 	}
 	globfree(&g);
 
-	if (read_sysfs(0, "/proc/sys/kernel/shmmax") < NUM_PAGES * largest)
+	if (thuge_read_sysfs(0, "/proc/sys/kernel/shmmax") < NUM_PAGES * largest)
 		ksft_exit_fail_msg("Please do echo %lu > /proc/sys/kernel/shmmax",
 				   largest * NUM_PAGES);
 
--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-extract-read_sysfs-and-write_sysfs-into-vm_util
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -486,3 +486,41 @@ int close_procmap(struct procmap_fd *pro
 {
 	return close(procmap->fd);
 }
+
+int write_sysfs(const char *file_path, unsigned long val)
+{
+	FILE *f = fopen(file_path, "w");
+
+	if (!f) {
+		fprintf(stderr, "f %s\n", file_path);
+		perror("fopen");
+		return 1;
+	}
+	if (fprintf(f, "%lu", val) < 0) {
+		perror("fprintf");
+		fclose(f);
+		return 1;
+	}
+	fclose(f);
+
+	return 0;
+}
+
+int read_sysfs(const char *file_path, unsigned long *val)
+{
+	FILE *f = fopen(file_path, "r");
+
+	if (!f) {
+		fprintf(stderr, "f %s\n", file_path);
+		perror("fopen");
+		return 1;
+	}
+	if (fscanf(f, "%lu", val) != 1) {
+		perror("fscanf");
+		fclose(f);
+		return 1;
+	}
+	fclose(f);
+
+	return 0;
+}
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-extract-read_sysfs-and-write_sysfs-into-vm_util
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -87,6 +87,8 @@ int open_procmap(pid_t pid, struct procm
 int query_procmap(struct procmap_fd *procmap);
 bool find_vma_procmap(struct procmap_fd *procmap, void *address);
 int close_procmap(struct procmap_fd *procmap);
+int write_sysfs(const char *file_path, unsigned long val);
+int read_sysfs(const char *file_path, unsigned long *val);
 
 static inline int open_self_procmap(struct procmap_fd *procmap_out)
 {
_

Patches currently in -mm which might be from pulehui@huawei.com are

mm-fix-uprobe-pte-be-overwritten-when-expanding-vma.patch
mm-expose-abnormal-new_pte-during-move_ptes.patch
selftests-mm-extract-read_sysfs-and-write_sysfs-into-vm_util.patch
selftests-mm-add-test-about-uprobe-pte-be-orphan-during-vma-merge.patch

