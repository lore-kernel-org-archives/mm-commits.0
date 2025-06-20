Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE464EC4;
	Fri, 20 Jun 2025 00:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750379154; cv=none; b=ptxtPs7KFNJ+RIeIY2rUJEsZuRz9OqINNY/b7H9aF3D66n44XVgT1Bepyk1QQ2Pl05aGDFAhX6YHLJR2m3qFE8L1CYSVXQmcE5xXDWwN9V4W81gj/mhaXQUMla5a8bDqVh4hAR23TsgVJxd5Gn0KVdMRJqL74cUz/sg8mUbEo38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750379154; c=relaxed/simple;
	bh=8Cbir+MG5T+MiScP4RwETCFou3JHDUzEXbBX752Hfxk=;
	h=Date:To:From:Subject:Message-Id; b=hMcRenNL7148p/DTKdajRIgsL1gz2D7LZDohVJSVOCnWCr9rLvJ0PBOPbbldJ6+NV8I8HxTvSS2kMQJUx+5yTNK7gJxuJLCzhgjo2I7Zlz6VfkLag0A4remYyouajVnR061Dlm4PXrrEYJCGZR0IFiAlg4ogQAoDVzuSzdkWVt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OSHd7sgC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OSHd7sgC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33504C4CEEA;
	Fri, 20 Jun 2025 00:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750379154;
	bh=8Cbir+MG5T+MiScP4RwETCFou3JHDUzEXbBX752Hfxk=;
	h=Date:To:From:Subject:From;
	b=OSHd7sgCJ18Tx5XmVfWIGqrWC0WPqD1EGa7icEkt5KNPgQANXEt3rc7xvpgDkh+8J
	 wHGjzqbD84zqixxBcpRHM+3AWN2AmUOLDT2o2wV0A9l4bvGBlt8kVfgj6nEEzA3FR6
	 u5v49O02yatSrvMX4QqWGDaUQIUTMA6Xfnmj1NwY=
Date: Thu, 19 Jun 2025 17:25:53 -0700
To: mm-commits@vger.kernel.org,yi.zhang@huawei.com,yangerkun@huawei.com,tglx@linutronix.de,stable@vger.kernel.org,ming.lei@redhat.com,john.g.garry@oracle.com,axboe@kernel.dk,yukuai3@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-group_cpus-fix-null-pointer-dereference-from-group_cpus_evenly.patch added to mm-hotfixes-unstable branch
Message-Id: <20250620002554.33504C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/group_cpus: fix NULL pointer dereference from group_cpus_evenly()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     lib-group_cpus-fix-null-pointer-dereference-from-group_cpus_evenly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-group_cpus-fix-null-pointer-dereference-from-group_cpus_evenly.patch

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

Root cause is that numgrps is set to 0, and ZERO_SIZE_PTR is returned
from kcalloc(), then __group_cpus_evenly() will deference the
ZERO_SIZE_PTR.

Fix the problem by checking numgrps first in group_cpus_evenly(), and
return NULL directly if numgrps is zero.

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

 lib/group_cpus.c |    3 +++
 1 file changed, 3 insertions(+)

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
 
_

Patches currently in -mm which might be from yukuai3@huawei.com are

lib-group_cpus-fix-null-pointer-dereference-from-group_cpus_evenly.patch

