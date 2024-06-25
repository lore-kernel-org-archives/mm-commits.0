Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F112C17C7AE
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 19:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719342486; cv=none; b=GjK8TE0N2XJK6GIRbXSFw+c6uz5Gr6TPPYMjf8W3/0RYNsLFvIrtk852pzNAO5ZokYlEKOzCKlZDbBTTW4CP/k7k8zQVA01nEc+jFJkxHHDMoUZ6c3Z2ef/RHAvhi2NnjTV/J6sXOlozIN5zAva6H7p/LBCvZ1KrPOyFITAEdfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719342486; c=relaxed/simple;
	bh=6ltZ4zMaMwjXY5CRyGZhrIfZ/eYKQRbZS7KuS8CW67Q=;
	h=Date:To:From:Subject:Message-Id; b=bqhxgnxYAzrYjWZM+0nvkJKkO0PlFjd+CdjfXA0+mLyRLCdxVCHL324syOAUvFnoJrWiYhGnB+ACDd6OZBqQ+YBpF0OXBTddCfDZFdbVODEa7HUZyVTmXMYkyP+KyAgzv7nJK3K5BhM4z4x9PWjA7xKfyQediOjj9sYXY/uig+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dINy/Yxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dINy/Yxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B883C32781;
	Tue, 25 Jun 2024 19:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719342485;
	bh=6ltZ4zMaMwjXY5CRyGZhrIfZ/eYKQRbZS7KuS8CW67Q=;
	h=Date:To:From:Subject:From;
	b=dINy/Yxdy3Ho8klpZZ57mvNsK+YG+cxHdjMiN7I6Wj+RSDGkKJyy65rT+BGoES4m7
	 YKuR330bZNGh/qJAHg7duC+iZ00Y/7gD4aTNqhegZ/oLZHzTor0A7djfxUiokQzHWk
	 sfKpubMbOXvpLQUY+gl+B1d+s5QV4FYyK6gt1GK4=
Date: Tue, 25 Jun 2024 12:08:04 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-implement-a-program-for-even-numbered-memory-regions-access.patch added to mm-unstable branch
Message-Id: <20240625190805.6B883C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon: implement a program for even-numbered memory regions access
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-implement-a-program-for-even-numbered-memory-regions-access.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-implement-a-program-for-even-numbered-memory-regions-access.patch

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
docs-mm-damon-maintainer-profile-introduce-hackermail.patch
docs-mm-damon-maintainer-profile-document-damon-community-meetups.patch
selftests-damon-access_memory-use-user-defined-region-size.patch
selftests-damon-_damon_sysfs-support-schemes_update_tried_regions.patch
selftests-damon-implement-a-program-for-even-numbered-memory-regions-access.patch
selftests-damon-implement-damos-tried-regions-test.patch
selftests-damon-_damon_sysfs-implement-kdamonds-stop-function.patch
selftests-damon-implement-test-for-min-max_nr_regions.patch
_damon_sysfs-implement-commit-for-online-parameters-update.patch
selftests-damon-damon_nr_regions-test-online-tuned-max_nr_regions.patch

