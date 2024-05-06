Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C30822089
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957120; cv=none; b=trvqlhLJB/zrWGyDCnu+XUXUIf8nN58GgUbNtiSIwm5G4tdUBtbEeO8VFXQqx3ZKHUoCMA+7TYyU5nNhv5qCt6h91lp1P5TOSQtikPaXHIND/6MmSAWdrmVZzTXrUrFasXSn8ImzwMsvZajnPS7KmL30YPBJKysGBKUvefMEvmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957120; c=relaxed/simple;
	bh=a3h8n5g+xD7qwPxHGaTofVMYCCZ8d1Cr7f3GnU4SQmM=;
	h=Date:To:From:Subject:Message-Id; b=i4tYrS5hJbKfd9M23nLqDYolc6m7h/tCSi79nwslrALqjwUJf2XwYGD5M8Kwe5M1VSD/0bMJe3H25Xx6JL3OK7IhKY/MB17xWO24j1sAfk8g2MaZWQ8bSf8pjO9ZfFAVKqCkQGzKNHN8xFZeowQQvklii806O36stwymZ7MPAQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GRujxRBB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GRujxRBB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CE7C113CC;
	Mon,  6 May 2024 00:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957120;
	bh=a3h8n5g+xD7qwPxHGaTofVMYCCZ8d1Cr7f3GnU4SQmM=;
	h=Date:To:From:Subject:From;
	b=GRujxRBBJd1jSL/4NNNzf3HC3+ZNx0+4bCru8iNC/UDr+jJ4UrUblclgCLR2lIR7d
	 EkcKTz+PMRLSspYNiYT1m8Hb5ak+5G6KqeJ6mQFVSjKAywVJlDZ6vQ972iGlaOot/S
	 gizIKz4AZ0djDnVOMR5GJazaDnQk2U0lTZeMRXKs=
Date: Sun, 05 May 2024 17:58:39 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,mszeredi@redhat.com,jack@suse.cz,hcochran@kernelspring.com,axboe@kernel.dk,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-correct-calculation-of-wbs-bg_thresh-in-cgroup-domain.patch removed from -mm tree
Message-Id: <20240506005840.32CE7C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: correct calculation of wb's bg_thresh in cgroup domain
has been removed from the -mm tree.  Its filename was
     mm-correct-calculation-of-wbs-bg_thresh-in-cgroup-domain.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: correct calculation of wb's bg_thresh in cgroup domain
Date: Thu, 25 Apr 2024 21:17:22 +0800

wb_calc_thresh() is calculating wb's share of bg_thresh in the global
domain.  However in case of cgroup writeback this is not the right
thing to do.  Consider the following domain hierarchy:

                global domain (> 20G)
                /                 \
          cgroup1 (10G)     cgroup2 (10G)
                |                 |
bdi            wb1               wb2

and assume wb1 and wb2 have the same bandwidth and the background
threshold is set at 10%.  The bg_thresh of cgroup1 and cgroup2 is going
to be 1G.  Now because wb_calc_thresh(mdtc->wb, mdtc->bg_thresh)
calculates per-wb threshold in the global domain as (wb bandwidth) /
(domain bandwidth) it returns bg_thresh for wb1 as 0.5G although it has
nobody to compete against in cgroup1.

Fix the problem by calculating wb's share of bg_thresh in the cgroup
domain.

Test as following:
/* make it easier to observe the issue */
echo 300000 > /proc/sys/vm/dirty_expire_centisecs
echo 100 > /proc/sys/vm/dirty_writeback_centisecs

/* run fio in wb1 */
cd /sys/fs/cgroup
echo "+memory +io" > cgroup.subtree_control
mkdir group1
cd group1
echo 10G > memory.high
echo 10G > memory.max
echo $$ > cgroup.procs
mkfs.ext4 -F /dev/vdb
mount /dev/vdb /bdi1/
fio -name test -filename=/bdi1/file -size=600M -ioengine=libaio -bs=4K \
-iodepth=1 -rw=write -direct=0 --time_based -runtime=600 -invalidate=0

/* run fio in wb2 with a new shell */
cd /sys/fs/cgroup
mkdir group2
cd group2
echo 10G > memory.high
echo 10G > memory.max
echo $$ > cgroup.procs
mkfs.ext4 -F /dev/vdc
mount /dev/vdc /bdi2/
fio -name test -filename=/bdi2/file -size=600M -ioengine=libaio -bs=4K \
-iodepth=1 -rw=write -direct=0 --time_based -runtime=600 -invalidate=0

Before fix, the wrttien pages of wb1 and wb2 reported from
toos/writeback/wb_monitor.py keep growing. After fix, rare written pages
are accumulated.
There is no obvious change in fio result.

[jack@suse.cz: changelog rewording]
Link: https://lkml.kernel.org/r/20240425131724.36778-3-shikemeng@huaweicloud.com
Fixes: 74d369443325 ("writeback: Fix performance regression in wb_over_bg_thresh()")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Howard Cochran <hcochran@kernelspring.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page-writeback.c~mm-correct-calculation-of-wbs-bg_thresh-in-cgroup-domain
+++ a/mm/page-writeback.c
@@ -2137,7 +2137,7 @@ bool wb_over_bg_thresh(struct bdi_writeb
 		if (mdtc->dirty > mdtc->bg_thresh)
 			return true;
 
-		thresh = wb_calc_thresh(mdtc->wb, mdtc->bg_thresh);
+		thresh = __wb_calc_thresh(mdtc, mdtc->bg_thresh);
 		if (thresh < 2 * wb_stat_error())
 			reclaimable = wb_stat_sum(wb, WB_RECLAIMABLE);
 		else
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


