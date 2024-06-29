Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A3A1862A
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628307; cv=none; b=o8r1kt2vx4szmUaTfNUu9ixKEkNSF6zRBIZqkGrA8MtGuIXofvQu4RrFsHehQC9kelfOnKOYXYIu/mJBDvz8wy08CEoOBGsvv/ofUqLTGiXzVy5afe9bdngSxIX4LH6pQBwLw4ntKnbxZhLaj34eDR4pbDm7tUWEIJjCQLvB838=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628307; c=relaxed/simple;
	bh=vSL24Cyu8y8VMrV14vcOyntl7R2ZdwsMJ5CTNhUOeA8=;
	h=Date:To:From:Subject:Message-Id; b=j25EQy00h9n61EwSsTwi+y0q3/sWhSA+KGBy3OkgUNqfAz/pWmJjoz0XUFPoyJUDwSTZJRARNCm9inx4JwIV9trvMRyxCDXzpsRytZ85aQ68eDSvlx2KJtf5N+dPt3D8O0B3Fy6perSC4zxbZ1vfh8svzrEizKCkd84TxxpFYww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ltKXaOKt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ltKXaOKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04896C32781;
	Sat, 29 Jun 2024 02:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628307;
	bh=vSL24Cyu8y8VMrV14vcOyntl7R2ZdwsMJ5CTNhUOeA8=;
	h=Date:To:From:Subject:From;
	b=ltKXaOKtSBt6qKJAtrdaBv3jRDSUz+5rLBLmqSDPuWIntc+/HVl4/VGjW8fat6YGF
	 CEJJ13Oa4/mbbxPBpK3L+1Fiw1FJSBGYCSY712qtoU4fvKHD4sU+zoMgoy+jgqMmmN
	 /5+kKtVD1aZkRfGrFFh2b3+3fS3rlkKXKMjGyQSE=
Date: Fri, 28 Jun 2024 19:31:46 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-implement-a-program-for-even-numbered-memory-regions-access.patch removed from -mm tree
Message-Id: <20240629023147.04896C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon: implement a program for even-numbered memory regions access
has been removed from the -mm tree.  Its filename was
     selftests-damon-implement-a-program-for-even-numbered-memory-regions-access.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon: implement a program for even-numbered memory regions access
Date: Tue, 25 Jun 2024 11:05:33 -0700

To test schemes_tried_regions feature, we need to have a program having
specific number of regions that having different access pattern.  Existing
artificial access pattern generator, 'access_memory', cannot be used for
the purpose, since it accesses only one region at a given time.  Extending
it could be an option, but since the purpose and the implementation are
pretty simple, implementing another one from the scratch is better.

Implement such another artificial memory access program that allocates
user-defined number/size regions and accesses even-numbered regions.

Link: https://lkml.kernel.org/r/20240625180538.73134-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/Makefile             |    2 
 tools/testing/selftests/damon/access_memory_even.c |   42 +++++++++++
 2 files changed, 43 insertions(+), 1 deletion(-)

--- /dev/null
+++ a/tools/testing/selftests/damon/access_memory_even.c
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Artificial memory access program for testing DAMON.
+ *
+ * Receives number of regions and size of each region from user.  Allocate the
+ * regions and repeatedly access even numbered (starting from zero) regions.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <time.h>
+
+int main(int argc, char *argv[])
+{
+	char **regions;
+	clock_t start_clock;
+	int nr_regions;
+	int sz_region;
+	int access_time_ms;
+	int i;
+
+	if (argc != 3) {
+		printf("Usage: %s <number> <size (bytes)>\n", argv[0]);
+		return -1;
+	}
+
+	nr_regions = atoi(argv[1]);
+	sz_region = atoi(argv[2]);
+
+	regions = malloc(sizeof(*regions) * nr_regions);
+	for (i = 0; i < nr_regions; i++)
+		regions[i] = malloc(sz_region);
+
+	while (1) {
+		for (i = 0; i < nr_regions; i++) {
+			if (i % 2 == 0)
+				memset(regions[i], i, sz_region);
+		}
+	}
+	return 0;
+}
--- a/tools/testing/selftests/damon/Makefile~selftests-damon-implement-a-program-for-even-numbered-memory-regions-access
+++ a/tools/testing/selftests/damon/Makefile
@@ -4,7 +4,7 @@
 TEST_GEN_FILES += huge_count_read_write
 TEST_GEN_FILES += debugfs_target_ids_read_before_terminate_race
 TEST_GEN_FILES += debugfs_target_ids_pid_leak
-TEST_GEN_FILES += access_memory
+TEST_GEN_FILES += access_memory access_memory_even
 
 TEST_FILES = _chk_dependency.sh _debugfs_common.sh
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch
mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix.patch
mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix-2.patch

