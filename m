Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB3736A37A
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067156; cv=none; b=JLNnIwTnXrU0zMWCR9vCDKFAxz9BRW9qieanN3KmaokYRklzCMZlDZ8/rAzWPYtyn/lUk6d0Wsk4d8ZlAS+0DfzvoetSIU8F6M5qd157Tqg4y8ARTeNvkzLJhkSWYrX16fpWatc1Jz3AiEwqnklMXQj1fIMKFqy64sEoGUIbAKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067156; c=relaxed/simple;
	bh=ZAE6pTRnrhad7Q/E1cVsLGxB5NkB0uUI4I9qMPkPfic=;
	h=Date:To:From:Subject:Message-Id; b=LcFpsIZCZLEwVrOrRCWT6MwWvWjJGkOQi22T97DffiafnBfbHhMI17Lf1VvoshBCC32qiVRCJReiodH0YbDulfH5WrzU8aeye50nTYc8QQaG8s4wdkcrU11qX3HL2NZC2CZdnZJ6h+PewPepTFoP0KWumVWs77gh/m2Q8Ehx27A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lnmCBgKP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lnmCBgKP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C901F00A3A;
	Sun, 21 Jun 2026 18:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067155;
	bh=M3GtBkBxSsZlCyJfanBDVFi7MI0JmHnpdrZFhluzhbI=;
	h=Date:To:From:Subject;
	b=lnmCBgKPdCol4MeLjNnvIB2Y7YwDs2H8AgmoWZOqY94sPyd4B/847QyT2z08J2I/v
	 mkMxg7k2xWpASg+Mr2AnwxXXaWDIPwcbj6FeuyAtiGZd9jq6ipIUJPU8EORYGcRFfM
	 Fuc3akM7EPfLrkEtLP+H2GssR+tTbScImBvBFnHI=
Date: Sun, 21 Jun 2026 11:39:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,li.wang@linux.dev,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,donettom@linux.ibm.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-move-read_file-read_num-and-write_num-to-vm_util.patch removed from -mm tree
Message-Id: <20260621183915.05C901F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: move read_file(), read_num() and write_num() to vm_util
has been removed from the -mm tree.  Its filename was
     selftests-mm-move-read_file-read_num-and-write_num-to-vm_util.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: move read_file(), read_num() and write_num() to vm_util
Date: Mon, 11 May 2026 19:28:13 +0300

These are useful helpers for writing and reading sysfs and proc files.

Make them available to the tests that don't use thp_settings.

While on it make write_num() use "%lu" instead of "%ld" to match 'unsigned
long num' argument type.

Link: https://lore.kernel.org/20260511162840.375890-30-rppt@kernel.org
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

 tools/testing/selftests/mm/hugepage_settings.c |   41 ---------------
 tools/testing/selftests/mm/hugepage_settings.h |    4 -
 tools/testing/selftests/mm/vm_util.c           |   39 ++++++++++++++
 tools/testing/selftests/mm/vm_util.h           |    3 +
 4 files changed, 42 insertions(+), 45 deletions(-)

--- a/tools/testing/selftests/mm/hugepage_settings.c~selftests-mm-move-read_file-read_num-and-write_num-to-vm_util
+++ a/tools/testing/selftests/mm/hugepage_settings.c
@@ -48,47 +48,6 @@ static const char * const shmem_enabled_
 	NULL
 };
 
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
 int thp_read_string(const char *name, const char * const strings[])
 {
 	char path[PATH_MAX];
--- a/tools/testing/selftests/mm/hugepage_settings.h~selftests-mm-move-read_file-read_num-and-write_num-to-vm_util
+++ a/tools/testing/selftests/mm/hugepage_settings.h
@@ -66,10 +66,6 @@ struct thp_settings {
 	struct shmem_hugepages_settings shmem_hugepages[NR_ORDERS];
 };
 
-int read_file(const char *path, char *buf, size_t buflen);
-unsigned long read_num(const char *path);
-void write_num(const char *path, unsigned long num);
-
 int thp_read_string(const char *name, const char * const strings[]);
 void thp_write_string(const char *name, const char *val);
 unsigned long thp_read_num(const char *name);
--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-move-read_file-read_num-and-write_num-to-vm_util
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -698,6 +698,27 @@ int unpoison_memory(unsigned long pfn)
 	return ret > 0 ? 0 : -errno;
 }
 
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
 void write_file(const char *path, const char *buf, size_t buflen)
 {
 	int fd, saved_errno;
@@ -721,3 +742,21 @@ void write_file(const char *path, const
 		ksft_exit_fail_msg("%s write(%.*s) is truncated, expected %zu bytes, got %zd bytes\n",
 				path, (int)(buflen - 1), buf, buflen - 1, numwritten);
 }
+
+unsigned long read_num(const char *path)
+{
+	char buf[21];
+
+	if (read_file(path, buf, sizeof(buf)) < 0)
+		ksft_exit_fail_perror("read_file()");
+
+	return strtoul(buf, NULL, 10);
+}
+
+void write_num(const char *path, unsigned long num)
+{
+	char buf[21];
+
+	sprintf(buf, "%lu", num);
+	write_file(path, buf, strlen(buf) + 1);
+}
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-move-read_file-read_num-and-write_num-to-vm_util
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -165,3 +165,6 @@ int unpoison_memory(unsigned long pfn);
 #define PAGEMAP_PFN(ent)	((ent) & ((1ull << 55) - 1))
 
 void write_file(const char *path, const char *buf, size_t buflen);
+int read_file(const char *path, char *buf, size_t buflen);
+unsigned long read_num(const char *path);
+void write_num(const char *path, unsigned long num);
_

Patches currently in -mm which might be from rppt@kernel.org are


