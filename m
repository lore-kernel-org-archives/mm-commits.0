Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F148638A9A1
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898330; cv=none; b=eFqZRNG+ijawvnSb8KQVsOy/BEnB2ANKGSjSmFvNfwlZCjigIfVsUZN6Vbn+Mtd3GixwToZLRYSnTDcx+S06UAzR9lkcwSDNOYAGGAgBzGGSWJzkWVH0/yGrdid3omVZajCo40SdknImC2XSgakVjZFRwA4KP2bZZl6rP4EjgGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898330; c=relaxed/simple;
	bh=t1xW0uFC09+aPvjrNaJjrwNjeENpXy2FYGFZYIpPQxc=;
	h=Date:To:From:Subject:Message-Id; b=jeCOugW17/Q/QD73nDN+oIaWvIfsYMN2/VgAHr8+Dtr3LGNtf3r3lljPK+tvutg1nJs3FKKajZQZ8S8J8FvMnsTuWCkt2ljmMl/YUtZvMnpCAffrARASbZUL9duAwvVEpgNylQQQQCVEE8Dc+ICNsRN7YzqfbFaAHW6/3oy8L+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=apS5IXmp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="apS5IXmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1939C4CEF1;
	Sat, 31 Jan 2026 22:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898329;
	bh=t1xW0uFC09+aPvjrNaJjrwNjeENpXy2FYGFZYIpPQxc=;
	h=Date:To:From:Subject:From;
	b=apS5IXmp/9Ix5snoK2wzT8I1w380hSCk6tvgxHb7m/jeWXu2DLM6wOFrOIiK3P8HL
	 PQZzeNeF9ei14Ir9SZYStsygF5cH8dTolEk7X82a22n2XsHF3E5uon9005vDEy0WR3
	 CBUjVGHRnBhzSuiW5x923YcLigX66A6re0d5gpI0=
Date: Sat, 31 Jan 2026 14:25:29 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-access_memory-add-repeat-mode.patch removed from -mm tree
Message-Id: <20260131222529.C1939C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/access_memory: add repeat mode
has been removed from the -mm tree.  Its filename was
     selftests-damon-access_memory-add-repeat-mode.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/access_memory: add repeat mode
Date: Fri, 16 Jan 2026 18:07:26 -0800

'access_memory' is an artificial memory access generator program that is
used for a few DAMON selftests.  It accesses a given number of regions one
by one only once, and exits.  Depending on systems, the test workload may
exit faster than expected, making the tests unreliable.  For reliable
control of the artificial memory access pattern, add a mode to make it
repeat running.

Link: https://lkml.kernel.org/r/20260117020731.226785-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/access_memory.c |   29 +++++++++++-----
 1 file changed, 21 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/damon/access_memory.c~selftests-damon-access_memory-add-repeat-mode
+++ a/tools/testing/selftests/damon/access_memory.c
@@ -8,6 +8,11 @@
 #include <string.h>
 #include <time.h>
 
+enum access_mode {
+	ACCESS_MODE_ONCE,
+	ACCESS_MODE_REPEAT,
+};
+
 int main(int argc, char *argv[])
 {
 	char **regions;
@@ -15,10 +20,12 @@ int main(int argc, char *argv[])
 	int nr_regions;
 	int sz_region;
 	int access_time_ms;
+	enum access_mode mode = ACCESS_MODE_ONCE;
+
 	int i;
 
-	if (argc != 4) {
-		printf("Usage: %s <number> <size (bytes)> <time (ms)>\n",
+	if (argc < 4) {
+		printf("Usage: %s <number> <size (bytes)> <time (ms)> [mode]\n",
 				argv[0]);
 		return -1;
 	}
@@ -27,15 +34,21 @@ int main(int argc, char *argv[])
 	sz_region = atoi(argv[2]);
 	access_time_ms = atoi(argv[3]);
 
+	if (argc > 4 && !strcmp(argv[4], "repeat"))
+		mode = ACCESS_MODE_REPEAT;
+
 	regions = malloc(sizeof(*regions) * nr_regions);
 	for (i = 0; i < nr_regions; i++)
 		regions[i] = malloc(sz_region);
 
-	for (i = 0; i < nr_regions; i++) {
-		start_clock = clock();
-		while ((clock() - start_clock) * 1000 / CLOCKS_PER_SEC <
-				access_time_ms)
-			memset(regions[i], i, sz_region);
-	}
+	do {
+		for (i = 0; i < nr_regions; i++) {
+			start_clock = clock();
+			while ((clock() - start_clock) * 1000 / CLOCKS_PER_SEC
+					< access_time_ms)
+				memset(regions[i], i, sz_region);
+		}
+	} while (mode == ACCESS_MODE_REPEAT);
+
 	return 0;
 }
_

Patches currently in -mm which might be from sj@kernel.org are


