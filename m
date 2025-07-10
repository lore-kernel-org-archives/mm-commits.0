Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A2D2036FF;
	Thu, 10 Jul 2025 05:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126279; cv=none; b=hdG8u1NNbsUc8Eo1G1+cP8JNZep/xBeVqSIGObzt568QstFLrSg9FYbxfqjq+1B3J55fhlDUkQf61GV2Ga64EkMYj6kEI901BF/riy0dWoJfPXf4B58hMyCfOt2RFaAgoBjU9IaiGh1Rr7ydikVtnvmfKZw4wybBOq5MEoq9Ink=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126279; c=relaxed/simple;
	bh=mt0EcNc5B0EZnX+qVsFJ8OVNyStC3s9WRLhg90waipQ=;
	h=Date:To:From:Subject:Message-Id; b=mPcKsFtTiRqDnuJLvuVuFMMykL1v5cdMwhARxOQTfVSgD9zJfC8JTqj1vS7Z4uzm8xoFimxgZPUti9ch9ruig8XWMD/6K6Tnhe+3f/p8igB11zfzIzfXgZA5563aluaWkpl1kjQ5XP75ZfaTK7ZampzwT+yF4rdmRQZCK1innHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BJK7fs5p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BJK7fs5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8D8C4CEE3;
	Thu, 10 Jul 2025 05:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126278;
	bh=mt0EcNc5B0EZnX+qVsFJ8OVNyStC3s9WRLhg90waipQ=;
	h=Date:To:From:Subject:From;
	b=BJK7fs5p/yDWdWFCkRV5CZ9Ka9uetCEIdwGxoSl6Rsl69eKHKfN4wfzSmOyZd2JhS
	 APVmV95+IEgJwTRnnTmJUCiMUNXdodoChufCDHAq+XvlQZm0dbI4Zit2Bsmt4uIB4u
	 DUskaKxLRLapQfCcA5dAGrBg2B5GrV7qY5m/eJLI=
Date: Wed, 09 Jul 2025 22:44:38 -0700
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,stable@vger.kernel.org,osalvador@suse.de,donettom@linux.ibm.com,balbirs@nvidia.com,lizhijian@fujitsu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-tier-fix-abstract-distance-calculation-overflow.patch removed from -mm tree
Message-Id: <20250710054438.BC8D8C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-tier: fix abstract distance calculation overflow
has been removed from the -mm tree.  Its filename was
     mm-memory-tier-fix-abstract-distance-calculation-overflow.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Zhijian <lizhijian@fujitsu.com>
Subject: mm/memory-tier: fix abstract distance calculation overflow
Date: Tue, 10 Jun 2025 14:27:51 +0800

In mt_perf_to_adistance(), the calculation of abstract distance (adist)
involves multiplying several int values including
MEMTIER_ADISTANCE_DRAM.

*adist = MEMTIER_ADISTANCE_DRAM *
		(perf->read_latency + perf->write_latency) /
		(default_dram_perf.read_latency + default_dram_perf.write_latency) *
		(default_dram_perf.read_bandwidth + default_dram_perf.write_bandwidth) /
		(perf->read_bandwidth + perf->write_bandwidth);

Since these values can be large, the multiplication may exceed the
maximum value of an int (INT_MAX) and overflow (Our platform did),
leading to an incorrect adist.

User-visible impact:
The memory tiering subsystem will misinterpret slow memory (like CXL)
as faster than DRAM, causing inappropriate demotion of pages from
CXL (slow memory) to DRAM (fast memory).

For example, we will see the following demotion chains from the dmesg, where
Node0,1 are DRAM, and Node2,3 are CXL node:
 Demotion targets for Node 0: null
 Demotion targets for Node 1: null
 Demotion targets for Node 2: preferred: 0-1, fallback: 0-1
 Demotion targets for Node 3: preferred: 0-1, fallback: 0-1

Change MEMTIER_ADISTANCE_DRAM to be a long constant by writing it with
the 'L' suffix.  This prevents the overflow because the multiplication
will then be done in the long type which has a larger range.

Link: https://lkml.kernel.org/r/20250611023439.2845785-1-lizhijian@fujitsu.com
Link: https://lkml.kernel.org/r/20250610062751.2365436-1-lizhijian@fujitsu.com
Fixes: 3718c02dbd4c ("acpi, hmat: calculate abstract distance with HMAT")
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory-tiers.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/memory-tiers.h~mm-memory-tier-fix-abstract-distance-calculation-overflow
+++ a/include/linux/memory-tiers.h
@@ -18,7 +18,7 @@
  * adistance value (slightly faster) than default DRAM adistance to be part of
  * the same memory tier.
  */
-#define MEMTIER_ADISTANCE_DRAM	((4 * MEMTIER_CHUNK_SIZE) + (MEMTIER_CHUNK_SIZE >> 1))
+#define MEMTIER_ADISTANCE_DRAM	((4L * MEMTIER_CHUNK_SIZE) + (MEMTIER_CHUNK_SIZE >> 1))
 
 struct memory_tier;
 struct memory_dev_type {
_

Patches currently in -mm which might be from lizhijian@fujitsu.com are


