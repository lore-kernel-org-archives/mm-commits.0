Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDD912D758
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756821; cv=none; b=TzQyExgVG7BrE1vko8S/UuAhR2eUw/y65I0/vITWr8JjDAPH8l8Kjs2hk4z/HlqIKFANQgZSM7//IkVpbH5ankUmnuPG78mjfQNcCscB0A7F7V0dy7v3lQF9AlWWlxuG54bq6TolFYvKzeocT7or1AHwhKTctMwvJZr79QIzx3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756821; c=relaxed/simple;
	bh=I2TfW9F5E/cP9CFV/qb5KSi+HDqrQAmBhdXcb51VLMQ=;
	h=Date:To:From:Subject:Message-Id; b=Psemq6CMAmFAaSn0qdWOQcwS7EfWjKg9l2vNlptT20I8rpL7D/MtdQ8WF5gJnsrgUipRLc7h2FEIrJvlmP4du+UWdkX0Fe+Z5juyMgPCSXM0O21/4G48c2X4IOyuoGt0HRL/Zn5aQr7RwFtFDlQWPGzcM+KmodUc/fWpDLoRpqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h9qFJlPe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h9qFJlPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB801C4CEED;
	Sun,  1 Jun 2025 05:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756821;
	bh=I2TfW9F5E/cP9CFV/qb5KSi+HDqrQAmBhdXcb51VLMQ=;
	h=Date:To:From:Subject:From;
	b=h9qFJlPeM7Wl0bzxMBQva6X22VX8LSB3huZYmhYHwYg/T1IEu+I7nrOkNnM0JKjdN
	 dYj6uKAkFFtdFOMqF2q5vF63IlYEs4Gk5k7qnxPP8R1ClvOPZMhHteHP+BJ8LB3mwL
	 PqiscOZSwF8LWmJn+qCog/CsrACBH3toAFz+8UC0=
Date: Sat, 31 May 2025 22:47:00 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,dev.jain@arm.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-deduplicate-default-page-size-test-results-in-thuge-gen.patch removed from -mm tree
Message-Id: <20250601054700.EB801C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: deduplicate default page size test results in thuge-gen
has been removed from the -mm tree.  Its filename was
     selftests-mm-deduplicate-default-page-size-test-results-in-thuge-gen.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Brown <broonie@kernel.org>
Subject: selftests/mm: deduplicate default page size test results in thuge-gen
Date: Thu, 15 May 2025 11:36:14 +0200

The thuge-gen test program runs mmap() and shmget() tests for both every
available page size and the default page size, resulting in two tests for
the default size.  These tests are distinct since the flags in the default
case do not specify an explicit size, add the flags to the test name that
is logged to deduplicate.

Link: https://lkml.kernel.org/r/20250515-selfests-mm-thuge-gen-dup-v1-1-057d2836553f@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Acked-by: Dev Jain <dev.jain@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/thuge-gen.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/thuge-gen.c~selftests-mm-deduplicate-default-page-size-test-results-in-thuge-gen
+++ a/tools/testing/selftests/mm/thuge-gen.c
@@ -127,7 +127,7 @@ void test_mmap(unsigned long size, unsig
 
 	show(size);
 	ksft_test_result(size == getpagesize() || (before - after) == NUM_PAGES,
-			 "%s mmap %lu\n", __func__, size);
+			 "%s mmap %lu %x\n", __func__, size, flags);
 
 	if (munmap(map, size * NUM_PAGES))
 		ksft_exit_fail_msg("%s: unmap %s\n", __func__, strerror(errno));
@@ -165,7 +165,7 @@ void test_shmget(unsigned long size, uns
 
 	show(size);
 	ksft_test_result(size == getpagesize() || (before - after) == NUM_PAGES,
-			 "%s: mmap %lu\n", __func__, size);
+			 "%s: mmap %lu %x\n", __func__, size, flags);
 	if (shmdt(map))
 		ksft_exit_fail_msg("%s: shmdt: %s\n", __func__, strerror(errno));
 }
_

Patches currently in -mm which might be from broonie@kernel.org are


