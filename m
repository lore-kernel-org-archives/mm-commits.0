Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22C21EA7EC;
	Wed, 25 Jun 2025 22:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750892156; cv=none; b=KEC74VERoo1rvFMq41d1djX5aTeYU8mlYpE1pLsB1uo1oCnyD/evq8taA4cQ01D2c2h1QcwpqOGUUipLLflipmMYl39TojzkSIKooFGcDeHVP1j69yOWdmZILX1JfpPldYhCtdwf4m+Wq/PIXPV/MemFOv5sEnSvE9UMywARuHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750892156; c=relaxed/simple;
	bh=4sMeofaq+J37fCmT5OyzfJj5KmtiqBf3NRGyA1isPIs=;
	h=Date:To:From:Subject:Message-Id; b=VqmCWkAMl6dBxBoYuEQE3uNfKD+51gp6aglCYu/nkyNxoRAFwbKZjQfbODduq6Lf3/zpy1Cp7t9trZZFzOlmY/ix/Soz/3jPGWIXkA3F7j5272QG9XuQ997KZ/ZZC94mSkt/TO7h6AjNwZxU/tIMyNsQdChecHC3158rt7iINnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B8G8dYit; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B8G8dYit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B81C4CEEA;
	Wed, 25 Jun 2025 22:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750892155;
	bh=4sMeofaq+J37fCmT5OyzfJj5KmtiqBf3NRGyA1isPIs=;
	h=Date:To:From:Subject:From;
	b=B8G8dYit9LRno2oKRwWmCvwjG7AWJ0pJOloIIzXp/IHq13n4Gw5j/KurDsQ5E19SW
	 GDtTgp5nXIgyqx6RK1dknjO/U3MNxmF3wmCP51ljkbxlieEnBydrc8mSywXR8sqyEt
	 5lB/7sr4yT17ApBBzlOOu+qpwMmYbldbZymwgIv4=
Date: Wed, 25 Jun 2025 15:55:54 -0700
To: mm-commits@vger.kernel.org,yi.zhang@huawei.com,yangerkun@huawei.com,tglx@linutronix.de,stable@vger.kernel.org,ming.lei@redhat.com,john.g.garry@oracle.com,axboe@kernel.dk,yukuai3@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-group_cpus-fix-null-pointer-dereference-from-group_cpus_evenly.patch removed from -mm tree
Message-Id: <20250625225555.56B81C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/group_cpus: fix NULL pointer dereference from group_cpus_evenly()
has been removed from the -mm tree.  Its filename was
     lib-group_cpus-fix-null-pointer-dereference-from-group_cpus_evenly.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yu Kuai <yukuai3@huawei.com>
Subject: lib/group_cpus: fix NULL pointer dereference from group_cpus_evenly()
Date: Thu, 19 Jun 2025 21:26:55 +0800

While testing null_blk with configfs, echo 0 > poll_queues will trigger
following panic:

BUG: kernel NULL pointer dereference, address: 0000000000000010
Oops: Oops: 0000 [#1] SMP NOPTI
CPU: 27 UID: 0 PID: 920 Comm: bash Not tainted 6.15.0-02023-gadbdb95c8696-dirty #1238 PREEMPT(undef)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.1-2.fc37 04/01/2014
RIP: 0010:__bitmap_or+0x48/0x70
Call Trace:
 <TASK>
 __group_cpus_evenly+0x822/0x8c0
 group_cpus_evenly+0x2d9/0x490
 blk_mq_map_queues+0x1e/0x110
 null_map_queues+0xc9/0x170 [null_blk]
 blk_mq_update_queue_map+0xdb/0x160
 blk_mq_update_nr_hw_queues+0x22b/0x560
 nullb_update_nr_hw_queues+0x71/0xf0 [null_blk]
 nullb_device_poll_queues_store+0xa4/0x130 [null_blk]
 configfs_write_iter+0x109/0x1d0
 vfs_write+0x26e/0x6f0
 ksys_write+0x79/0x180
 __x64_sys_write+0x1d/0x30
 x64_sys_call+0x45c4/0x45f0
 do_syscall_64+0xa5/0x240
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Root cause is that numgrps is set to 0, and ZERO_SIZE_PTR is returned from
kcalloc(), and later ZERO_SIZE_PTR will be deferenced.

Fix the problem by checking numgrps first in group_cpus_evenly(), and
return NULL directly if numgrps is zero.

[yukuai3@huawei.com: also fix the non-SMP version]
  Link: https://lkml.kernel.org/r/20250620010958.1265984-1-yukuai1@huaweicloud.com
Link: https://lkml.kernel.org/r/20250619132655.3318883-1-yukuai1@huaweicloud.com
Fixes: 6a6dcae8f486 ("blk-mq: Build default queue map via group_cpus_evenly()")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Cc: ErKun Yang <yangerkun@huawei.com>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/group_cpus.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/lib/group_cpus.c~lib-group_cpus-fix-null-pointer-dereference-from-group_cpus_evenly
+++ a/lib/group_cpus.c
@@ -352,6 +352,9 @@ struct cpumask *group_cpus_evenly(unsign
 	int ret = -ENOMEM;
 	struct cpumask *masks = NULL;
 
+	if (numgrps == 0)
+		return NULL;
+
 	if (!zalloc_cpumask_var(&nmsk, GFP_KERNEL))
 		return NULL;
 
@@ -426,8 +429,12 @@ struct cpumask *group_cpus_evenly(unsign
 #else /* CONFIG_SMP */
 struct cpumask *group_cpus_evenly(unsigned int numgrps)
 {
-	struct cpumask *masks = kcalloc(numgrps, sizeof(*masks), GFP_KERNEL);
+	struct cpumask *masks;
 
+	if (numgrps == 0)
+		return NULL;
+
+	masks = kcalloc(numgrps, sizeof(*masks), GFP_KERNEL);
 	if (!masks)
 		return NULL;
 
_

Patches currently in -mm which might be from yukuai3@huawei.com are


