Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96740285071
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126284; cv=none; b=EQcrd2441/8LqbPtWXzx9/MIgI6mhYDfoxGzXG5k9ShmcotsyiJplidmGf5d45OlVtKrKU4FLd2Litsw8/6SxZUhI+earAt8uLK/9DbbGwxtvlwcVeMvLEJTSbgp/Ifg1iejUgRz7okz6si0F8x25J+OdZU8jOndKQ81ZiXWM1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126284; c=relaxed/simple;
	bh=pMXQRr3nwiOsrnhg5vWw7b/abj00TLEQ+2WL7DmwRLo=;
	h=Date:To:From:Subject:Message-Id; b=usMCR+dqt2tjI54YTuw397ke9V4THb6FLmwXD7gbAeUCeOwMX0CPZHFN01qe+enhOm0Owdau5At52BSTauL2aDxKonWGLS1EU39cByVWH9EzMGUOt+Ha1gRluimsSENmdYwX7D/lMyYAMsS1cjPnFRQmrqjsiOcFOOEWBlG/lX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PJ9WhNZp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PJ9WhNZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B97DC4CEE3;
	Thu, 10 Jul 2025 05:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126284;
	bh=pMXQRr3nwiOsrnhg5vWw7b/abj00TLEQ+2WL7DmwRLo=;
	h=Date:To:From:Subject:From;
	b=PJ9WhNZpZirfgiwbWvjIo/PrBNyuqs//UnmgwIeQblHJserx6mcw2CZPh3Qm5H50p
	 GvfqVxOspWC9FAUrm7+43QZCN5LT/PfhSB/mXfw6vNGvHlvQ5IFwf8phSGS2yOO7zw
	 0GX+T1Q7jCJ9y6t3Nu8SgxzyZ0YqFX5ScHJasmo8=
Date: Wed, 09 Jul 2025 22:44:43 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,lorenzo.stoakes@oracle.com,pulehui@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-use-generic-read_sysfs-in-thuge-gen-test.patch removed from -mm tree
Message-Id: <20250710054444.6B97DC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: use generic read_sysfs in thuge-gen test
has been removed from the -mm tree.  Its filename was
     selftests-mm-use-generic-read_sysfs-in-thuge-gen-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


