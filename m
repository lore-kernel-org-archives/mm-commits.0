Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8D014EC4B
	for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2024 17:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714065919; cv=none; b=tWDNPEN4CoV3E2wmkwKpesmH/JQyFQbjx0Z0QNanBpnl7wglJnJTPHnUtytV7qnLIMp3+6G+ARGNPe3559txNi3LBVDu1YHi3vHZeLUjMM/VrQJEZdsQM2t84r/B9yr39dr08CsQyAVT6Tb4YeldRQLsPkohymlNW8TAaPIs/WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714065919; c=relaxed/simple;
	bh=Wl5IINl0WWXzJk1Ip7JqeNoJ/M4SdDuwjEb/unXWeVM=;
	h=Date:To:From:Subject:Message-Id; b=NX1twrdpttd4z3ruG00stn8TiVGcjSD8+jZv49OKopaDuD6q1GtiK8ibfTkpFQplrzmROXMUlkULV1BGlzJKSG30ICsWDeP+Nf+YV7nsCmfQkxKT50PRFh9TvFsg++yt+b9ZP5e1HjxaVzfvwfFAlYHqhoEYrj/sFhID/083JrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=otWhEgH+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="otWhEgH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B4EC113CC;
	Thu, 25 Apr 2024 17:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714065919;
	bh=Wl5IINl0WWXzJk1Ip7JqeNoJ/M4SdDuwjEb/unXWeVM=;
	h=Date:To:From:Subject:From;
	b=otWhEgH+13BmUiaW/zaLl5pYuk96KHGbIEGW8ARyxavsXha3b7KEkn9yfSB/Gt/ij
	 uIFYfBI6HcBLkaBMOOyuD28NHu3QDgnmeq5w4IUjk9EAMyAhqMjGVevxYvX4uR+9yf
	 TIVp6uYd47UE5Z2xz8uwEOOj1isRLkwrTFoR/nEs=
Date: Thu, 25 Apr 2024 10:25:18 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,mszeredi@redhat.com,jack@suse.cz,hcochran@kernelspring.com,axboe@kernel.dk,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-correct-calculation-of-wbs-bg_thresh-in-cgroup-domain.patch added to mm-unstable branch
Message-Id: <20240425172518.F1B4EC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: correct calculation of wb's bg_thresh in cgroup domain
has been added to the -mm mm-unstable branch.  Its filename is
     mm-correct-calculation-of-wbs-bg_thresh-in-cgroup-domain.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-correct-calculation-of-wbs-bg_thresh-in-cgroup-domain.patch

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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: correct calculation of wb's bg_thresh in cgroup domain
Date: Thu, 25 Apr 2024 21:17:22 +0800

The wb_calc_thresh is supposed to calculate wb's share of bg_thresh in
global domain.  To calculate wb's share of bg_thresh in cgroup domain,
it's more reasonable to use __wb_calc_thresh in which way we calculate
dirty_thresh in cgroup domain in balance_dirty_pages().

Consider following domain hierarchy:
                global domain (> 20G)
                /                 \
        cgroup domain1(10G)     cgroup domain2(10G)
                |                 |
bdi            wb1               wb2
Assume wb1 and wb2 has the same bandwidth.
We have global domain bg_thresh > 2G, cgroup domain bg_thresh 1G.
Then we have:
wb's thresh in global domain = 2G * (wb bandwidth) / (system bandwidth)
= 2G * 1/2 = 1G
wb's thresh in cgroup domain = 1G * (wb bandwidth) / (system bandwidth)
= 1G * 1/2 = 0.5G
At last, wb1 and wb2 will be limited at 0.5G, the system will be limited
at 1G which is less than global domain bg_thresh 2G.

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

Link: https://lkml.kernel.org/r/20240425131724.36778-3-shikemeng@huaweicloud.com
Fixes: 74d369443325 ("writeback: Fix performance regression in wb_over_bg_thresh()")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Howard Cochran <hcochran@kernelspring.com>
Cc: Jan Kara <jack@suse.cz>
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

writeback-collect-stats-of-all-wb-of-bdi-in-bdi_debug_stats_show.patch
writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi.patch
writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi-fix.patch
writeback-add-wb_monitorpy-script-to-monitor-writeback-info-on-bdi.patch
writeback-rename-nr_reclaimable-to-nr_dirty-in-balance_dirty_pages.patch
mm-enable-__wb_calc_thresh-to-calculate-dirty-background-threshold.patch
mm-correct-calculation-of-wbs-bg_thresh-in-cgroup-domain.patch
mm-call-__wb_calc_thresh-instead-of-wb_calc_thresh-in-wb_over_bg_thresh.patch
mm-remove-stale-comment-__folio_mark_dirty.patch

