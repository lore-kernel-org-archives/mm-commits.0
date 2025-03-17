Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C1210E4
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 04:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742185826; cv=none; b=Kk6iHTu0Sk7c1/LdzE899NcDm7T05g8ontKB2WSxmEdS35Zr0pFtwx70Jdy67CGVx6Ou1XTbwzT8MWJH1/i9sMZqa9behbKyRjCLVq6AViISJ94ysk5KZIEae+Z63STRUaJH1V56yrJlMMKQB0E3hltfF8jU9ePoDpnggcoqd0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742185826; c=relaxed/simple;
	bh=oNvLsZ4JNmG1wiW/8X33qddPBdh3AsJC11auQsbQOBI=;
	h=Date:To:From:Subject:Message-Id; b=T3HID2lKEteZvkpUxtQgAkcLMhWbqHBXPHRJ7ySr77BtAAE2/6wmoFuqIGcdFyeC326/4wPfi8aCByU9Z/JQajKOjN6pu6gYlNHCBO/kj4awFGc8Xc0d2D5bFpZ1Sgz8d3qouPayna66LkNMRpNkKoTF+5V+yVIjQu5mD/qhzPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H0ZnRlxN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H0ZnRlxN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E58C4CEEC;
	Mon, 17 Mar 2025 04:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742185825;
	bh=oNvLsZ4JNmG1wiW/8X33qddPBdh3AsJC11auQsbQOBI=;
	h=Date:To:From:Subject:From;
	b=H0ZnRlxNkVRSmMUATiPn9LQvWQ6WVZWuCIVLETy8b2NmfdPaEAFh95r5mqi4otDvq
	 JLmFP6kOWQCFeA/v04FNG8ldeFtC386Say9rIPAULxFd2YgIGWLs2OnBMqEzPrzi2K
	 VfywgSsieC69KpRnvFhzo+gL+gfDiI4Nn2RICj0g=
Date: Sun, 16 Mar 2025 21:30:25 -0700
To: mm-commits@vger.kernel.org,zhanghao1@kylinos.cn,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix.patch removed from -mm tree
Message-Id: <20250317043025.C8E58C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix
has been removed from the -mm tree.  Its filename was
     mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix.patch

This patch was dropped because it was folded into mm-vmscan-extract-calculated-pressure-balance-as-a-function.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix
Date: Tue Jan 28 08:13:57 PM PST 2025

80-col wrapping

Cc: Hao Zhang <zhanghao1@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix
+++ a/mm/vmscan.c
@@ -2400,8 +2400,8 @@ static void prepare_scan_control(pg_data
 	}
 }
 
-static inline void calculate_pressure_balance(struct scan_control *sc, int swappiness,
-			u64 *fraction, u64 *denominator)
+static inline void calculate_pressure_balance(struct scan_control *sc,
+			int swappiness, u64 *fraction, u64 *denominator)
 {
 	unsigned long anon_cost, file_cost, total_cost;
 	unsigned long ap, fp;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-extract-calculated-pressure-balance-as-a-function.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise-fix-checkpatch-fixes.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix.patch
mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option-fix.patch
mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix.patch
lib-plistc-add-shortcut-for-plist_requeue-fix.patch
scsi-lpfc-convert-timeouts-to-secs_to_jiffies-fix.patch
signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset-fix.patch
hung_task-show-the-blocker-task-if-the-task-is-hung-on-mutex-fix.patch

