Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DA38473
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714101420; cv=none; b=WzUvM2zWZdW4SqvhQzlP6xCVekgultFVTUrvBrgKFGstMHGNBouiIEHI98OGbGDbEiVxgAj8Y0e/PDnM/yaiLNY4B7L6wcGS9bWsd7qGOtLSIOOCqi7AszNvdYD/AZJN3xRi/38DzvbkTSYcdWylu9KvUywqsz5omNeXH9NMPrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714101420; c=relaxed/simple;
	bh=119Ev8PempCHPJAe6Zo0fEv89/dSHi5ymcEZKLhlRZw=;
	h=Date:To:From:Subject:Message-Id; b=k8dy1etbHQQzkN2lcf/fL6yybj22igjMtF4Y7T7/3AzFMSGDdqVLBR6yXnKZLB34ff4ip88TjfeSRO6WG6HXb+GjXGbTXkYUxUhfv4fql5pRgJpYUMtAlwjmPInO8XypiYRgQjpietkacL1xM0h0X0aH7QcxdKP6zSzdf9v1i5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0P46S8pl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0P46S8pl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B826C113CD;
	Fri, 26 Apr 2024 03:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714101420;
	bh=119Ev8PempCHPJAe6Zo0fEv89/dSHi5ymcEZKLhlRZw=;
	h=Date:To:From:Subject:From;
	b=0P46S8plt+dZCJptADX7FOh8eJZxbT+raPxxrkIbrTK3YNrzURmeF/YECd2GZU1KF
	 ay4cr8+VEzjbv4l3Lp1ZpS1YoskZFsdLDr4JN3rLb95UMOJUGzgzQyKURP6kjZ24Va
	 TBTbX5MZvr0BHkPKff8SE0Lc/LwIClTL6PL9hrYg=
Date: Thu, 25 Apr 2024 20:16:59 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-confirm-va-exhaustion-without-reliance-on-correctness-of-mmap-v2.patch removed from -mm tree
Message-Id: <20240426031700.1B826C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests-mm-confirm-va-exhaustion-without-reliance-on-correctness-of-mmap-v2
has been removed from the -mm tree.  Its filename was
     selftests-mm-confirm-va-exhaustion-without-reliance-on-correctness-of-mmap-v2.patch

This patch was dropped because it was folded into selftests-mm-confirm-va-exhaustion-without-reliance-on-correctness-of-mmap.patch

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: selftests-mm-confirm-va-exhaustion-without-reliance-on-correctness-of-mmap-v2
Date: Mon, 25 Mar 2024 09:56:53 +0530

replace SZ_1GB with MAP_CHUNK_SIZE, tidy-up

Link: https://lkml.kernel.org/r/20240325042653.867055-1-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/virtual_address_range.c |   15 ++++-------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/tools/testing/selftests/mm/virtual_address_range.c~selftests-mm-confirm-va-exhaustion-without-reliance-on-correctness-of-mmap-v2
+++ a/tools/testing/selftests/mm/virtual_address_range.c
@@ -117,19 +117,17 @@ static int validate_complete_va_space(vo
 	prev_end_addr = 0;
 	while (fgets(line, sizeof(line), file)) {
 		unsigned long hop;
-		int ret;
 
-		ret = sscanf(line, "%lx-%lx %s[rwxp-]",
-			     &start_addr, &end_addr, prot);
-		if (ret != 3)
-			ksft_exit_fail_msg("sscanf failed, cannot parse\n");
+		if (sscanf(line, "%lx-%lx %s[rwxp-]",
+			   &start_addr, &end_addr, prot) != 3)
+			ksft_exit_fail_msg("cannot parse /proc/self/maps\n");
 
 		/* end of userspace mappings; ignore vsyscall mapping */
 		if (start_addr & (1UL << 63))
 			return 0;
 
-		/* /proc/self/maps must have gaps less than 1GB only */
-		if (start_addr - prev_end_addr >= SZ_1GB)
+		/* /proc/self/maps must have gaps less than MAP_CHUNK_SIZE */
+		if (start_addr - prev_end_addr >= MAP_CHUNK_SIZE)
 			return 1;
 
 		prev_end_addr = end_addr;
@@ -149,8 +147,7 @@ static int validate_complete_va_space(vo
 		while (start_addr + hop < end_addr) {
 			if (write(fd, (void *)(start_addr + hop), 1) != 1)
 				return 1;
-			else
-				lseek(fd, 0, SEEK_SET);
+			lseek(fd, 0, SEEK_SET);
 
 			hop += MAP_CHUNK_SIZE;
 		}
_

Patches currently in -mm which might be from dev.jain@arm.com are

selftests-mm-virtual_address_range-switch-to-ksft_exit_fail_msg.patch
selftests-mm-confirm-va-exhaustion-without-reliance-on-correctness-of-mmap.patch
selftests-mm-parse-vma-range-in-one-go.patch
selftests-mm-mremap_test-optimize-using-pre-filled-random-array-and-memcpy.patch
selftests-mm-mremap_test-optimize-execution-time-from-minutes-to-seconds-using-chunkwise-memcmp.patch
selftests-mm-mremap_test-use-sscanf-to-parse-proc-self-maps.patch

