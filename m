Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC7F8061B
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104117; cv=none; b=Ypj2xYTq149sxCDOg3bZqfozuvSQMSTLFvr7QrKu6cKPI5U1dsjYK2f3A4sZLCnJ9fmui13KNyKvjfgH+fvdz7QRobqCLRP3KJpQH5f6qUYrnKx218+HfdSEBRMLDBOGdipgLP/orjmOFhfjoDCAUACZ/HuX9edxi6R9/335Qp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104117; c=relaxed/simple;
	bh=yJ+S+7/NhG+/fok3PHBd1DkzZ3pGHnOXVgyyCEB8vII=;
	h=Date:To:From:Subject:Message-Id; b=Rk/1S0kbwQTJIHoO8weYCK5y8accByn8fV7SWh9RJwSrY80T+UruyZm35WWbhK3HSAYSX2PVrNfzk0eK4VLj8hP3zGXBZtcUOoiDN6x3xj1pJ662nAtXzvvHM4WWgEm/36jNTO2xe5oVpNp1DxhGxrbs5KhNoqYLZNprZsS8qKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xI6z9+Bb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xI6z9+Bb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2331C113CD;
	Fri, 26 Apr 2024 04:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104117;
	bh=yJ+S+7/NhG+/fok3PHBd1DkzZ3pGHnOXVgyyCEB8vII=;
	h=Date:To:From:Subject:From;
	b=xI6z9+Bbloxz4wTx4EGrLPIKYHpgAkvpZqVN3ea8aCTsHYQgrqleLRWAJEofcM5wN
	 8BuwpkPIvoYSks6rjc37RqzVNLV4ykjdk0orw9lSaRV8NNyEHA2JrU5I5ZIjN3Dt2H
	 /mUgpFLc9Xy3QJ9fj0xznk+csg5+4g8LbYFtt6/4=
Date: Thu, 25 Apr 2024 21:01:57 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,kaleshsingh@google.com,jhubbard@nvidia.com,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-mremap_test-use-sscanf-to-parse-proc-self-maps.patch removed from -mm tree
Message-Id: <20240426040157.A2331C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: mremap_test: use sscanf to parse /proc/self/maps
has been removed from the -mm tree.  Its filename was
     selftests-mm-mremap_test-use-sscanf-to-parse-proc-self-maps.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: selftests/mm: mremap_test: use sscanf to parse /proc/self/maps
Date: Sat, 30 Mar 2024 23:05:57 +0530

Enforce consistency across files by avoiding two separate functions to
parse /proc/self/maps, replacing them with a simple sscanf().

Link: https://lkml.kernel.org/r/20240330173557.2697684-4-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mremap_test.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/mm/mremap_test.c~selftests-mm-mremap_test-use-sscanf-to-parse-proc-self-maps
+++ a/tools/testing/selftests/mm/mremap_test.c
@@ -148,19 +148,21 @@ static unsigned long long get_mmap_min_a
  * Using /proc/self/maps, assert that the specified address range is contained
  * within a single mapping.
  */
-static bool is_range_mapped(FILE *maps_fp, void *start, void *end)
+static bool is_range_mapped(FILE *maps_fp, unsigned long start,
+			    unsigned long end)
 {
 	char *line = NULL;
 	size_t len = 0;
 	bool success = false;
+	unsigned long first_val, second_val;
 
 	rewind(maps_fp);
 
 	while (getline(&line, &len, maps_fp) != -1) {
-		char *first = strtok(line, "- ");
-		void *first_val = (void *)strtol(first, NULL, 16);
-		char *second = strtok(NULL, "- ");
-		void *second_val = (void *) strtol(second, NULL, 16);
+		if (sscanf(line, "%lx-%lx", &first_val, &second_val) != 2) {
+			ksft_exit_fail_msg("cannot parse /proc/self/maps\n");
+			break;
+		}
 
 		if (first_val <= start && second_val >= end) {
 			success = true;
@@ -255,7 +257,8 @@ static void mremap_expand_merge(FILE *ma
 		goto out;
 	}
 
-	success = is_range_mapped(maps_fp, start, start + 3 * page_size);
+	success = is_range_mapped(maps_fp, (unsigned long)start,
+				  (unsigned long)(start + 3 * page_size));
 	munmap(start, 3 * page_size);
 
 out:
@@ -294,7 +297,8 @@ static void mremap_expand_merge_offset(F
 		goto out;
 	}
 
-	success = is_range_mapped(maps_fp, start, start + 3 * page_size);
+	success = is_range_mapped(maps_fp, (unsigned long)start,
+				  (unsigned long)(start + 3 * page_size));
 	munmap(start, 3 * page_size);
 
 out:
_

Patches currently in -mm which might be from dev.jain@arm.com are


