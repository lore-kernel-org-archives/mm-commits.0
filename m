Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90271DCB09
	for <mm-commits@vger.kernel.org>; Fri,  6 Jun 2025 04:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749185777; cv=none; b=AK2vYvr7EtIP9EaDCdSUV6GVEhZsYthkRiBMfo5ad/cJy6m0oQYUagrjCIkgDslSTxvvbYUn92lCPRQHYSbz3DxXfWk85QvAe1SclNkJdofOvDJP54xuTeWOUU664DSyP8QYSVAhA+NZrkbW/z5CZ+6pe4KpdOWIz/X2AWPobMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749185777; c=relaxed/simple;
	bh=RWRuLLqNiy9tULad/Q/Rn65vk6gZ3FKpS7UDx3HVn7o=;
	h=Date:To:From:Subject:Message-Id; b=R0kgFHaUu5YypVyhZhdtjYWhKZTu+Ux9oiT9o2kBG/po8x2oqkJ1SZDVXhmg7IT5A56HjYwS6yKG4wjXs78oUv3M58tuEqCXYAeJAWsjet6FsQ47h3SNS3O3iqecwwHroCGUygSy7bQOG3yj2J4+FM6q8wb43v0cj05zYH3jPlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NQsXV6tt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NQsXV6tt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D9FCC4CEEB;
	Fri,  6 Jun 2025 04:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749185775;
	bh=RWRuLLqNiy9tULad/Q/Rn65vk6gZ3FKpS7UDx3HVn7o=;
	h=Date:To:From:Subject:From;
	b=NQsXV6ttTyoL4QEZSpg8gYfsUj7g3QdnMiw8LnNHOHC4OkZzInlmdohxpdDPCbz1l
	 e1XzOqmRH/1O6/ixb3As8uNnGSaCqP6lB58/GKAETVXeZWh9d3vz6KUdWDOSK3SmFV
	 gZ1YZuSUQvJ5H6Gi9hec6h7BpFgJCa2qk5TGLKYE=
Date: Thu, 05 Jun 2025 21:56:14 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,peterz@infradead.org,oleg@redhat.com,mhiramat@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,pulehui@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-extract-read_sysfs-and-write_sysfs-into-vm_util.patch removed from -mm tree
Message-Id: <20250606045615.3D9FCC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: extract read_sysfs and write_sysfs into vm_util
has been removed from the -mm tree.  Its filename was
     selftests-mm-extract-read_sysfs-and-write_sysfs-into-vm_util.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pu Lehui <pulehui@huawei.com>
Subject: selftests/mm: extract read_sysfs and write_sysfs into vm_util
Date: Thu, 29 May 2025 15:56:49 +0000

Extract read_sysfs and write_sysfs into vm_util.  Meanwhile, rename the
function in thuge-gen that has the same name as read_sysfs.

Link: https://lkml.kernel.org/r/20250529155650.4017699-4-pulehui@huaweicloud.com
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
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
@@ -88,6 +88,8 @@ int open_procmap(pid_t pid, struct procm
 int query_procmap(struct procmap_fd *procmap);
 bool find_vma_procmap(struct procmap_fd *procmap, void *address);
 int close_procmap(struct procmap_fd *procmap);
+int write_sysfs(const char *file_path, unsigned long val);
+int read_sysfs(const char *file_path, unsigned long *val);
 
 static inline int open_self_procmap(struct procmap_fd *procmap_out)
 {
_

Patches currently in -mm which might be from pulehui@huawei.com are


