Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02757604D
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104006; cv=none; b=I2w9K5H0lQJn+KVj3jUYuXVAiiPd9wdXUphof8sEeOlzYSOdig0Gnv89ZE5FzbkwQqiY7LKCL+iDTmSLAyOiH70LeiIYX2EKOLR/uiyThc9Jzokrqw/UtnK2P7fw8x6N4XxcYrbAek/l/w9EgwTULEtpUdVbFVQXV4lEeGCsh3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104006; c=relaxed/simple;
	bh=/2hvDmMaVeDYXiefuvooNIW1TSW7LekhyVOPSfTgIvc=;
	h=Date:To:From:Subject:Message-Id; b=tvoftvjTDgbkABXEt+7f0xwPOAJtuWvyCRlZwG7RgOMatvNgDnHtzdUh38tuhMwerX8GUUh//Clio02bJPB54DGHPwJ28nPe5TyxGdh5HgZatRvG/6Vo4ZM15erI70NsvNyLzyNFd6EAU4gsFbkmScZ4ZKZDZZ/lb5btTJlvXC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JVVt2/QP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JVVt2/QP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44EAC113CD;
	Fri, 26 Apr 2024 04:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104005;
	bh=/2hvDmMaVeDYXiefuvooNIW1TSW7LekhyVOPSfTgIvc=;
	h=Date:To:From:Subject:From;
	b=JVVt2/QPax23JdCVNUO6tCoYO0u6HAp9PdS3iSowMJZ9zjoeGPcA8nPQSjESHHikU
	 2Z5mJ6oNypLHEnxUIH5Sza7xAkAnHDHPkbZNkr9IRyHyLntaFF0MzoDBvqzhkVa6w4
	 LYeM/ROz/rb5XnYEHIj64XJ9pcITg9Y+Hp+SWVMY=
Date: Thu, 25 Apr 2024 21:00:05 -0700
To: mm-commits@vger.kernel.org,dennis@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-backing-dev-use-group-allocation-free-of-per-cpu-counters-api.patch removed from -mm tree
Message-Id: <20240426040005.B44EAC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: backing-dev: use group allocation/free of per-cpu counters API
has been removed from the -mm tree.  Its filename was
     mm-backing-dev-use-group-allocation-free-of-per-cpu-counters-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: backing-dev: use group allocation/free of per-cpu counters API
Date: Mon, 25 Mar 2024 11:56:35 +0800

Use group allocation/free of per-cpu counters api to accelerate
wb_init/exit() and simplify code.

Link: https://lkml.kernel.org/r/20240325035635.49342-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Dennis Zhou <dennis@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |   23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

--- a/mm/backing-dev.c~mm-backing-dev-use-group-allocation-free-of-per-cpu-counters-api
+++ a/mm/backing-dev.c
@@ -388,7 +388,7 @@ static void wb_update_bandwidth_workfn(s
 static int wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi,
 		   gfp_t gfp)
 {
-	int i, err;
+	int err;
 
 	memset(wb, 0, sizeof(*wb));
 
@@ -416,18 +416,10 @@ static int wb_init(struct bdi_writeback
 	if (err)
 		return err;
 
-	for (i = 0; i < NR_WB_STAT_ITEMS; i++) {
-		err = percpu_counter_init(&wb->stat[i], 0, gfp);
-		if (err)
-			goto out_destroy_stat;
-	}
-
-	return 0;
+	err = percpu_counter_init_many(wb->stat, 0, gfp, NR_WB_STAT_ITEMS);
+	if (err)
+		fprop_local_destroy_percpu(&wb->completions);
 
-out_destroy_stat:
-	while (i--)
-		percpu_counter_destroy(&wb->stat[i]);
-	fprop_local_destroy_percpu(&wb->completions);
 	return err;
 }
 
@@ -460,13 +452,8 @@ static void wb_shutdown(struct bdi_write
 
 static void wb_exit(struct bdi_writeback *wb)
 {
-	int i;
-
 	WARN_ON(delayed_work_pending(&wb->dwork));
-
-	for (i = 0; i < NR_WB_STAT_ITEMS; i++)
-		percpu_counter_destroy(&wb->stat[i]);
-
+	percpu_counter_destroy_many(wb->stat, NR_WB_STAT_ITEMS);
 	fprop_local_destroy_percpu(&wb->completions);
 }
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

arm64-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch
mm-move-mm-counter-updating-out-of-set_pte_range.patch
mm-filemap-batch-mm-counter-updating-in-filemap_map_pages.patch
mm-swapfile-check-usable-swap-device-in-__folio_throttle_swaprate.patch
mm-memory-check-userfaultfd_wp-in-vmf_orig_pte_uffd_wp.patch

