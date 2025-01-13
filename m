Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B18A8248C;
	Mon, 13 Jan 2025 03:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736737463; cv=none; b=ukblS5+P3Sf1URioGchw1qRMeyKuS2ziIxzDrC/hCvWiUKL0nlxC5KXQl19zCK+6Zxw1DOBmQs8nH18dq/VeEBRIGCqlp1bZUABPZ4oG19WlhyOi4Wq2najAc5E4cCqHxEl0Ome6EPkTnGUXAbd2WvsS6D6+N2HxrBqkLPuTs1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736737463; c=relaxed/simple;
	bh=j+D+FUZxzTKS3YBNJ0qvQWNpgcidHeJJNRv72yIgmmM=;
	h=Date:To:From:Subject:Message-Id; b=pwDyJtyKYGBFk2M9rGqvQ+KH2AvTmk+v7CPbB16Ez5YQuOc7kQ8bSTExCTuIMoJgPjxFOT0gzFzEk1+urL4/aNplTIPmvB+me5W35xJuPTAkRB6xTzyeS/kEUX8AvK1J1qvqLIHv8QJLb+N/qOxFc7+Xf3g/7hduqqll55L4drU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lFCMh17t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lFCMh17t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF24C4CEE0;
	Mon, 13 Jan 2025 03:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736737463;
	bh=j+D+FUZxzTKS3YBNJ0qvQWNpgcidHeJJNRv72yIgmmM=;
	h=Date:To:From:Subject:From;
	b=lFCMh17tho0RL1HBi5dtIjFsZLrFBqPbmgt6y87rLrnGmaSWPGDpI41AeMaPWfvt7
	 EJaSr0a6tcE44EyugbSFO6cbHEh6O5qfxGF7tv981JgK+B7DMLB1oxpXjausCG01P8
	 7GFfm9RRZnELjehUW0SuLSKdo0dJtn/J/c+2oCrk=
Date: Sun, 12 Jan 2025 19:04:22 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,senozhatsky@chromium.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] zram-fix-potential-uaf-of-zram-table.patch removed from -mm tree
Message-Id: <20250113030423.0FF24C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: fix potential UAF of zram table
has been removed from the -mm tree.  Its filename was
     zram-fix-potential-uaf-of-zram-table.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: zram: fix potential UAF of zram table
Date: Tue, 7 Jan 2025 14:54:46 +0800

If zram_meta_alloc failed early, it frees allocated zram->table without
setting it NULL.  Which will potentially cause zram_meta_free to access
the table if user reset an failed and uninitialized device.

Link: https://lkml.kernel.org/r/20250107065446.86928-1-ryncsn@gmail.com
Fixes: 74363ec674cb ("zram: fix uninitialized ZRAM not releasing backing device")
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by:  Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/zram/zram_drv.c~zram-fix-potential-uaf-of-zram-table
+++ a/drivers/block/zram/zram_drv.c
@@ -1468,6 +1468,7 @@ static bool zram_meta_alloc(struct zram
 	zram->mem_pool = zs_create_pool(zram->disk->disk_name);
 	if (!zram->mem_pool) {
 		vfree(zram->table);
+		zram->table = NULL;
 		return false;
 	}
 
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-memcontrol-avoid-duplicated-memcg-enable-check.patch
mm-swap_cgroup-remove-swap_cgroup_cmpxchg.patch
mm-swap_cgroup-remove-global-swap-cgroup-lock.patch
mm-swap_cgroup-decouple-swap-cgroup-recording-and-clearing.patch
mm-swap-minor-clean-up-for-swap-entry-allocation.patch
mm-swap-fold-swap_info_get_cont-in-the-only-caller.patch
mm-swap-remove-old-allocation-path-for-hdd.patch
mm-swap-use-cluster-lock-for-hdd.patch
mm-swap-clean-up-device-availability-check.patch
mm-swap-clean-up-plist-removal-and-adding.patch
mm-swap-hold-a-reference-during-scan-and-cleanup-flag-usage.patch
mm-swap-use-an-enum-to-define-all-cluster-flags-and-wrap-flags-changes.patch
mm-swap-reduce-contention-on-device-lock.patch
mm-swap-simplify-percpu-cluster-updating.patch
mm-swap-introduce-a-helper-for-retrieving-cluster-from-offset.patch
mm-swap-use-a-global-swap-cluster-for-non-rotation-devices.patch
mm-swap_slots-remove-slot-cache-for-freeing-path.patch

