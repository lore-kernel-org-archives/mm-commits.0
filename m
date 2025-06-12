Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411BABA34
	for <mm-commits@vger.kernel.org>; Thu, 12 Jun 2025 00:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749687708; cv=none; b=LmCuyeHdxYAnyyjoVWJ4wxMLdd907CXs4+JIl66TktOPF6VrTqK6gAFc7IPinjhQa5m0OUIL4vbBgglxu5pATuiDsei6WZRa7vPkdB3/ExQezN5+gowbGwp+aeVz2Uy0CbC0A26eE0SmKA86WLnBo7Y65p3RcHeSk7yL7nvXnQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749687708; c=relaxed/simple;
	bh=q/a1j8He8pjuMz/JwqraWJu9TUdVR7FgtUYbd/6gjOY=;
	h=Date:To:From:Subject:Message-Id; b=o5RkfTCqwGXkAr8MyIxcwu9up+QaPosIw3kjiy2rvbUJzuPgc1L0Clqls1I4mw6gneP4Zd0vCY9NGNjyiBGvqYcxi9GJzTikVPCppLlgWDWpFoa4xtzjl+aDdlGkC2HPUHEmhkoXYwDrAmZZ8q/u5mfQZvh0fYpgZpQKpmhNhAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X8MaIz+z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X8MaIz+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C67C4CEE3;
	Thu, 12 Jun 2025 00:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749687707;
	bh=q/a1j8He8pjuMz/JwqraWJu9TUdVR7FgtUYbd/6gjOY=;
	h=Date:To:From:Subject:From;
	b=X8MaIz+zunz/Xd248KjzWBREpG1PAIalE6pu3HhDF0K6NgCHxhRTpmYOnX0Ijr2GR
	 /oMLgE6P2O0iQLWh6sSS94Oc+6EowEMlLlOwVEC0VNHsXA19F8dioEsR/+K7+vZoXz
	 cjEGs4O7B1VeU072BUEQD5rhCyIoKSWVZZ2/6SvA=
Date: Wed, 11 Jun 2025 17:21:47 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,lorenzo.stoakes@oracle.com,pulehui@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-use-generic-read_sysfs-in-thuge-gen-test.patch added to mm-new branch
Message-Id: <20250612002147.96C67C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: use generic read_sysfs in thuge-gen test
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-use-generic-read_sysfs-in-thuge-gen-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-use-generic-read_sysfs-in-thuge-gen-test.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: selftests/mm: use generic read_sysfs in thuge-gen test
Date: Wed, 11 Jun 2025 10:01:06 +0000

As generic read_sysfs is available in vm_utils, let's use is in thuge-gen
test.

Link: https://lkml.kernel.org/r/20250611100106.1331197-1-pulehui@huaweicloud.com
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/thuge-gen.c |   40 ++++++-----------------
 1 file changed, 11 insertions(+), 29 deletions(-)

--- a/tools/testing/selftests/mm/thuge-gen.c~selftests-mm-use-generic-read_sysfs-in-thuge-gen-test
+++ a/tools/testing/selftests/mm/thuge-gen.c
@@ -77,38 +77,18 @@ void show(unsigned long ps)
 	system(buf);
 }
 
-unsigned long thuge_read_sysfs(int warn, char *fmt, ...)
+unsigned long read_free(unsigned long ps)
 {
-	char *line = NULL;
-	size_t linelen = 0;
-	char buf[100];
-	FILE *f;
-	va_list ap;
 	unsigned long val = 0;
+	char buf[100];
 
-	va_start(ap, fmt);
-	vsnprintf(buf, sizeof buf, fmt, ap);
-	va_end(ap);
-
-	f = fopen(buf, "r");
-	if (!f) {
-		if (warn)
-			ksft_print_msg("missing %s\n", buf);
-		return 0;
-	}
-	if (getline(&line, &linelen, f) > 0) {
-		sscanf(line, "%lu", &val);
-	}
-	fclose(f);
-	free(line);
-	return val;
-}
+	snprintf(buf, sizeof(buf),
+		 "/sys/kernel/mm/hugepages/hugepages-%lukB/free_hugepages",
+		 ps >> 10);
+	if (read_sysfs(buf, &val) && ps != getpagesize())
+		ksft_print_msg("missing %s\n", buf);
 
-unsigned long read_free(unsigned long ps)
-{
-	return thuge_read_sysfs(ps != getpagesize(),
-			  "/sys/kernel/mm/hugepages/hugepages-%lukB/free_hugepages",
-			  ps >> 10);
+	return val;
 }
 
 void test_mmap(unsigned long size, unsigned flags)
@@ -173,6 +153,7 @@ void test_shmget(unsigned long size, uns
 void find_pagesizes(void)
 {
 	unsigned long largest = getpagesize();
+	unsigned long shmmax_val = 0;
 	int i;
 	glob_t g;
 
@@ -195,7 +176,8 @@ void find_pagesizes(void)
 	}
 	globfree(&g);
 
-	if (thuge_read_sysfs(0, "/proc/sys/kernel/shmmax") < NUM_PAGES * largest)
+	read_sysfs("/proc/sys/kernel/shmmax", &shmmax_val);
+	if (shmmax_val < NUM_PAGES * largest)
 		ksft_exit_fail_msg("Please do echo %lu > /proc/sys/kernel/shmmax",
 				   largest * NUM_PAGES);
 
_

Patches currently in -mm which might be from pulehui@huawei.com are

selftests-mm-use-generic-read_sysfs-in-thuge-gen-test.patch

