Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441BD70838;
	Wed,  8 Jan 2025 05:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736313877; cv=none; b=LPsDmd4D8uOiMHgP/UJNq2sjEtwloyOYW0caBITziPLHHEQdUqZjkDCS+0iXXfLu6lEQPPUx32de6kVe0SB+n/4VgmVyXy1e/TlMvToi7sV2RcdchiZ/Bg85yj8+TXxmfiUUytJJUo1lge72DLmZipMKdtZpH3yHTWymbDcV5NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736313877; c=relaxed/simple;
	bh=dm3qBIDM4Acckz8WHGNCf8+Eya4HDH2HENfz2bKN6sw=;
	h=Date:To:From:Subject:Message-Id; b=XlPlyNeTnFtj8SW8j1kYC9ZxV65sWMCqliloFUrBFAJHa5C+WDSPbCObyqvWfyXGsDaSVOqOYEeUND+AkoUOvxSJZEkjseSJMrTH7LbmlJNavckVBTDcYGRqBg0YKMTMQkF7xCERTx8fSQI7x/q9wEsTrexxz1r2bD4HMq7gOAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DZ3ZbaPP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DZ3ZbaPP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77DEC4CED0;
	Wed,  8 Jan 2025 05:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736313876;
	bh=dm3qBIDM4Acckz8WHGNCf8+Eya4HDH2HENfz2bKN6sw=;
	h=Date:To:From:Subject:From;
	b=DZ3ZbaPPY73Ma6UrCmDnEESIIzix7u4eEl6AA9qh9bjMbuizz5f7t5bZseitrYzpA
	 yXrLThg93DjCU1+Yxxmez9BsTMO1EViYM0Zme2vHyqTq2cAnR0NFoEysneMZe0FP0x
	 OqewdYaEdeCwdl8VsuxuAhzKAc+wYMk9op5R8rzw=
Date: Tue, 07 Jan 2025 21:24:36 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,senozhatsky@chromium.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-fix-potential-uaf-of-zram-table.patch added to mm-hotfixes-unstable branch
Message-Id: <20250108052436.A77DEC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: fix potential UAF of zram table
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     zram-fix-potential-uaf-of-zram-table.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-fix-potential-uaf-of-zram-table.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

zram-fix-potential-uaf-of-zram-table.patch
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

