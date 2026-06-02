Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F0F3B961E
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439040; cv=none; b=mOk6sNL1Ii5ChCvbvJ8W8jQX54j0ztZreGAD02kZ8ungym3d8aDg4GcSyGk/GcIVGrEM7HmV2F6VE1SUfIbaAtQXNgl7O3WqLjBOKHfp10tMYgKZpRspX/NM6Dc9/cdJ45HFG/mYWQZsnJcDbrAe0c9CDV26QoRIIceF/shAPns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439040; c=relaxed/simple;
	bh=eQfieqLLq3Xwd+VmPSDUlhhKF4cgbfLoiT0KX1rbziA=;
	h=Date:To:From:Subject:Message-Id; b=JfuEM+MfvGfgnCVT1KJCR9Egj2EgmWbxlqpQCTAXxYxLQ8Wi6WdpDhm+yjNnHXsqBr+SqLa05PdUMJ/KNfbusAOS0e4mKnsrh1a27JyS+ZXH/BGJyY4oKZ9i1aFVfIHzRcvr8k/+S/Qb57oACpyHbYD3xVsHO1mXbxe2L8VX+FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oQlVxzom; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oQlVxzom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD6F1F00898;
	Tue,  2 Jun 2026 22:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439038;
	bh=/dNr3qeuQu5XZu76RIc4cWl4wvmRZlnD1YAYv2wKmPM=;
	h=Date:To:From:Subject;
	b=oQlVxzomuTrmQhjAXxzHctS8pGLakZ2hICUM33KXS3LKZg7X1z3zPIRYnObvRWwZX
	 namvK23GFOZl78OyIyIajq3H0oRv2W22ZCib7qtnjpJy475cEU0SxPDm6qTi0LRh1N
	 WVPxh28zCtWjMJ+i8EeN10Ou184OxWILqTc8hbMs=
Date: Tue, 02 Jun 2026 15:23:58 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,agarwal.vineet2006@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-ksm-functional-tests-fix-partial-write-handling.patch removed from -mm tree
Message-Id: <20260602222358.CAD6F1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: ksm-functional-tests: fix partial write handling
has been removed from the -mm tree.  Its filename was
     selftests-mm-ksm-functional-tests-fix-partial-write-handling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Subject: selftests/mm: ksm-functional-tests: fix partial write handling
Date: Mon, 4 May 2026 13:43:13 +0530

Update write() checks to properly detect and handle partial writes.

Previously, the write() calls used <= 0 to detect failure.  This condition
is never true for partial writes (ret > 0 but ret < len), so partial
writes were silently treated as success.

Fix this by verifying that write() returns the full expected length and
treating any mismatch as failure.

Link: https://lore.kernel.org/20260504081638.683223-1-agarwal.vineet2006@gmail.com
Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_functional_tests.c |   21 ++++++------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/tools/testing/selftests/mm/ksm_functional_tests.c~selftests-mm-ksm-functional-tests-fix-partial-write-handling
+++ a/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -498,6 +498,7 @@ static void test_prctl_fork(void)
 static int start_ksmd_and_set_frequency(char *pages_to_scan, char *sleep_ms)
 {
 	int ksm_fd;
+	size_t len;
 
 	ksm_fd = open("/sys/kernel/mm/ksm/run", O_RDWR);
 	if (ksm_fd < 0)
@@ -506,11 +507,13 @@ static int start_ksmd_and_set_frequency(
 	if (write(ksm_fd, "1", 1) != 1)
 		return -errno;
 
-	if (write(pages_to_scan_fd, pages_to_scan, strlen(pages_to_scan)) <= 0)
-		return -errno;
-
-	if (write(sleep_millisecs_fd, sleep_ms, strlen(sleep_ms)) <= 0)
-		return -errno;
+	len = strlen(pages_to_scan);
+	if (write(pages_to_scan_fd, pages_to_scan, len) != len)
+		return -1;
+
+	len = strlen(sleep_ms);
+	if (write(sleep_millisecs_fd, sleep_ms, len) != len)
+		return -1;
 
 	return 0;
 }
@@ -526,11 +529,11 @@ static int stop_ksmd_and_restore_frequen
 	if (write(ksm_fd, "2", 1) != 1)
 		return -errno;
 
-	if (write(pages_to_scan_fd, "100", 3) <= 0)
-		return -errno;
+	if (write(pages_to_scan_fd, "100", 3) != 3)
+		return -1;
 
-	if (write(sleep_millisecs_fd, "20", 2) <= 0)
-		return -errno;
+	if (write(sleep_millisecs_fd, "20", 2) != 2)
+		return -1;
 
 	return 0;
 }
_

Patches currently in -mm which might be from agarwal.vineet2006@gmail.com are


