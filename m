Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9899450285;
	Thu, 19 Dec 2024 03:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734577531; cv=none; b=QDEh04F+mtL31Pxpr7pUqmQESKB+u62y3q7lRfLIi7im/6fe4YQir/RTNQjCsftixdXvT2QA8c+tr0wFAiEh7hlAfQk1cdAJa4RHEtGGOW6Cw8jY3BWaCPly25o8Zf6Pxa8ouUWjlEKaTkyzjcEDiLYzlxdWfkGSZ/gxeUMlNxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734577531; c=relaxed/simple;
	bh=NFfsnhLVdWek0LfKv5tO2uZPN1YC5Z3YnxrKSlGKCW4=;
	h=Date:To:From:Subject:Message-Id; b=mbvpIxi0K/N5zVqev8bXU+BU1VGnujW0UaWh8QCUeY8XCBfyDWn7/Ygs2x5/oxEh3KRVeV9vKzMkDEmtDhtePO+9xP7Q9nqIeZaL0fEZMajk6yUmjzZoe2mQIqvD9nxYKU9wSa1tJphxW4qbyzjTpJzTup6C7cuPQEtzy0fgEzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H4QH6OTg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H4QH6OTg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B303C4CECD;
	Thu, 19 Dec 2024 03:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734577531;
	bh=NFfsnhLVdWek0LfKv5tO2uZPN1YC5Z3YnxrKSlGKCW4=;
	h=Date:To:From:Subject:From;
	b=H4QH6OTgTV66Uy8hEbDbTbS/lPiCXEQXDfzCL9dW83SZurha8sZe6UeRfLHjnj/bO
	 b008qUl9z3PkDxrTSz1YLXCY8vVx4AiB6UaTjaa8YZFZR3r3KF1K0b4lMefQwPj0ki
	 vtG0SyITXzkNZsB+OcPoVmtPrawngVJfYL9BwD1Q=
Date: Wed, 18 Dec 2024 19:05:30 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,senozhatsky@chromium.org,deshengwu@tencent.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] zram-fix-uninitialized-zram-not-releasing-backing-device.patch removed from -mm tree
Message-Id: <20241219030531.3B303C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: fix uninitialized ZRAM not releasing backing device
has been removed from the -mm tree.  Its filename was
     zram-fix-uninitialized-zram-not-releasing-backing-device.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: zram: fix uninitialized ZRAM not releasing backing device
Date: Tue, 10 Dec 2024 00:57:16 +0800

Setting backing device is done before ZRAM initialization.  If we set the
backing device, then remove the ZRAM module without initializing the
device, the backing device reference will be leaked and the device will be
hold forever.

Fix this by always reset the ZRAM fully on rmmod or reset store.

Link: https://lkml.kernel.org/r/20241209165717.94215-3-ryncsn@gmail.com
Fixes: 013bf95a83ec ("zram: add interface to specif backing device")
Signed-off-by: Kairui Song <kasong@tencent.com>
Reported-by: Desheng Wu <deshengwu@tencent.com>
Suggested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-fix-uninitialized-zram-not-releasing-backing-device
+++ a/drivers/block/zram/zram_drv.c
@@ -1444,12 +1444,16 @@ static void zram_meta_free(struct zram *
 	size_t num_pages = disksize >> PAGE_SHIFT;
 	size_t index;
 
+	if (!zram->table)
+		return;
+
 	/* Free all pages that are still in this zram device */
 	for (index = 0; index < num_pages; index++)
 		zram_free_page(zram, index);
 
 	zs_destroy_pool(zram->mem_pool);
 	vfree(zram->table);
+	zram->table = NULL;
 }
 
 static bool zram_meta_alloc(struct zram *zram, u64 disksize)
@@ -2326,11 +2330,6 @@ static void zram_reset_device(struct zra
 
 	zram->limit_pages = 0;
 
-	if (!init_done(zram)) {
-		up_write(&zram->init_lock);
-		return;
-	}
-
 	set_capacity_and_notify(zram->disk, 0);
 	part_stat_set_all(zram->disk->part0, 0);
 
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-memcontrol-avoid-duplicated-memcg-enable-check.patch
mm-swap_cgroup-remove-swap_cgroup_cmpxchg.patch
mm-swap_cgroup-remove-global-swap-cgroup-lock.patch
mm-swap_cgroup-decouple-swap-cgroup-recording-and-clearing.patch

