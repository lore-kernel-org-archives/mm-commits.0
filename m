Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724551BC07A
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 21:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731359518; cv=none; b=Rwj5g/lkzO+cW7Eib8zTQ5bMId7lXPIYVIG8auxPdmDzgdB+hdaav61X1yiDBjdTZ8VlImCNeyQOi6CgaNkc7iRzqY6YdQW2RvkRasRFG36MkcHobz2tfinQI6YpHFTOCe+90V2EK0aYHtMjb9vFWuQhZdq/7Gw7ntpwGT7yogU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731359518; c=relaxed/simple;
	bh=pqi1BG+URpyLmEzzGTaEt17hGGz9vqiqu2DapbtDxAo=;
	h=Date:To:From:Subject:Message-Id; b=eJwulEQWNN6MFi0TTGYIDCwJ6argsNbf/FDkfnMeYbhZk6ijxS0m5SGs+u0CIkR920p41ohUMXBiiYxLINFjwwQAQBtG4Oj+eXn+E6fxhIFZdF8ifO3W8EI6o6Pf/N/Aj6+dFwXE/8JjfmA3IZ84ZxfuHdyAoyAa8usizxwFUZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dKlGlGi/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dKlGlGi/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9515C4CECF;
	Mon, 11 Nov 2024 21:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731359518;
	bh=pqi1BG+URpyLmEzzGTaEt17hGGz9vqiqu2DapbtDxAo=;
	h=Date:To:From:Subject:From;
	b=dKlGlGi/6cgndVnYEX9AwoUimu5jTv5tOGRLxvLE+40HkH3tbjDl/zRt5cnwJul6+
	 QZHGsD2x+6ugcNjYJ6SLWmgr0usgFhAl6K45TYp8HMl0i07JzU6B8MvYCFdguI3nl9
	 nCfqZAeqsXDJSq7amQrdHHXZ4Nm7PPnziujNyFkM=
Date: Mon, 11 Nov 2024 13:11:57 -0800
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,axboe@kernel.dk,liushixin2@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-fix-null-pointer-in-comp_algorithm_show.patch added to mm-unstable branch
Message-Id: <20241111211157.E9515C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: fix NULL pointer in comp_algorithm_show()
has been added to the -mm mm-unstable branch.  Its filename is
     zram-fix-null-pointer-in-comp_algorithm_show.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-fix-null-pointer-in-comp_algorithm_show.patch

This patch will later appear in the mm-unstable branch at
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
From: Liu Shixin <liushixin2@huawei.com>
Subject: zram: fix NULL pointer in comp_algorithm_show()
Date: Fri, 8 Nov 2024 18:01:47 +0800

LTP reported a NULL pointer dereference as followed:

 CPU: 7 UID: 0 PID: 5995 Comm: cat Kdump: loaded Not tainted 6.12.0-rc6+ #3
 Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
 pstate: 40400005 (nZcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
 pc : __pi_strcmp+0x24/0x140
 lr : zcomp_available_show+0x60/0x100 [zram]
 sp : ffff800088b93b90
 x29: ffff800088b93b90 x28: 0000000000000001 x27: 0000000000400cc0
 x26: 0000000000000ffe x25: ffff80007b3e2388 x24: 0000000000000000
 x23: ffff80007b3e2390 x22: ffff0004041a9000 x21: ffff80007b3e2900
 x20: 0000000000000000 x19: 0000000000000000 x18: 0000000000000000
 x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
 x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
 x11: 0000000000000000 x10: ffff80007b3e2900 x9 : ffff80007b3cb280
 x8 : 0101010101010101 x7 : 0000000000000000 x6 : 0000000000000000
 x5 : 0000000000000040 x4 : 0000000000000000 x3 : 00656c722d6f7a6c
 x2 : 0000000000000000 x1 : ffff80007b3e2900 x0 : 0000000000000000
 Call trace:
  __pi_strcmp+0x24/0x140
  comp_algorithm_show+0x40/0x70 [zram]
  dev_attr_show+0x28/0x80
  sysfs_kf_seq_show+0x90/0x140
  kernfs_seq_show+0x34/0x48
  seq_read_iter+0x1d4/0x4e8
  kernfs_fop_read_iter+0x40/0x58
  new_sync_read+0x9c/0x168
  vfs_read+0x1a8/0x1f8
  ksys_read+0x74/0x108
  __arm64_sys_read+0x24/0x38
  invoke_syscall+0x50/0x120
  el0_svc_common.constprop.0+0xc8/0xf0
  do_el0_svc+0x24/0x38
  el0_svc+0x38/0x138
  el0t_64_sync_handler+0xc0/0xc8
  el0t_64_sync+0x188/0x190

The zram->comp_algs[ZRAM_PRIMARY_COMP] can be NULL in zram_add() if
comp_algorithm_set() has not been called.  User can access the zram device
by sysfs after device_add_disk(), so there is a time window to trigger the
NULL pointer dereference.  Move it ahead device_add_disk() to make sure
when user can access the zram device, it is ready.  comp_algorithm_set()
is protected by zram->init_lock in other places and no such problem.

Link: https://lkml.kernel.org/r/20241108100147.3776123-1-liushixin2@huawei.com
Fixes: 7ac07a26dea7 ("zram: preparation for multi-zcomp support")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-fix-null-pointer-in-comp_algorithm_show
+++ a/drivers/block/zram/zram_drv.c
@@ -2572,6 +2572,8 @@ static int zram_add(void)
 	zram->disk->private_data = zram;
 	snprintf(zram->disk->disk_name, 16, "zram%d", device_id);
 	atomic_set(&zram->pp_in_progress, 0);
+	zram_comp_params_reset(zram);
+	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
 
 	/* Actual capacity set using sysfs (/sys/block/zram<id>/disksize */
 	set_capacity(zram->disk, 0);
@@ -2579,9 +2581,6 @@ static int zram_add(void)
 	if (ret)
 		goto out_cleanup_disk;
 
-	zram_comp_params_reset(zram);
-	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
-
 	zram_debugfs_register(zram);
 	pr_info("Added device: %s\n", zram->disk->disk_name);
 	return device_id;
_

Patches currently in -mm which might be from liushixin2@huawei.com are

zram-fix-null-pointer-in-comp_algorithm_show.patch

