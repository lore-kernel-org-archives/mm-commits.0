Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D77143878
	for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2024 22:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713996445; cv=none; b=i6QJ+48S+cBKi9tN4b/XJShElM9ZkhsWoFDy6iPegFrSVjJFkbuaOvOdjHHatOImf0RFJcekdHFCAfuTuITI0CYn3SatnFA2OYhby283XflHCoOBnfnEXOhkdxPx51ukeOaaAwIhOvVajV34Zy5tCRmoEnOkXoLYP6A1MvvLPM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713996445; c=relaxed/simple;
	bh=cnhNojfLbTi4hBQuIV8U83VM142J3Qc+xA1qi+kE0LA=;
	h=Date:To:From:Subject:Message-Id; b=pLCNDitbXx/8Yvelz46+AwmkzVPIq1qVY5SyorqEbkmGPHssbU6MqerooyMNmdzDDvIFTIQJZcPUG9PHhWf9fJlTd5Mqm0G7YevsLZIl7VGwtrhWFCoFL3msrv1FtxI9adJYCFFY/dH7uGOKggjHjXXJabVGALy1D9J48Jf6J20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ni8FExKj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ni8FExKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74EF3C113CD;
	Wed, 24 Apr 2024 22:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713996445;
	bh=cnhNojfLbTi4hBQuIV8U83VM142J3Qc+xA1qi+kE0LA=;
	h=Date:To:From:Subject:From;
	b=Ni8FExKjX4zjU+go1QLqcpL6qdsLJUFwOmWZybRl2Mx8Q9RaPmycafDDZd2HbXJX7
	 vjRmkcY6CMOtILsAc5A5ds0h+kvlSSmtm6+3F3h1rKZNhj6zkpM12be1SMO8ot7PFg
	 EQbvrsv6E3zju966DX8JVfoPFUJrIKW8v58h3pqk=
Date: Wed, 24 Apr 2024 15:07:24 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,sj@kernel.org,sfr@canb.auug.org.au,mjguzik@gmail.com,jack@suse.cz,dsterba@suse.com,dhowells@redhat.com,bfoster@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi-fix.patch added to mm-unstable branch
Message-Id: <20240424220725.74EF3C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: writeback: fix build problems of "writeback: support retrieving per group debug writeback stats of bdi"
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi-fix.patch

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
Subject: writeback: fix build problems of "writeback: support retrieving per group debug writeback stats of bdi"
Date: Tue, 23 Apr 2024 11:46:41 +0800

Fix two build problems:
1. implicit declaration of function 'cgroup_ino'.
2. unused variable 'stats'.

After this fix, No build problem is found when CGROUPS is disabled.
The wb_stats could be successfully retrieved when CGROUP_WRITEBACK is
disabled:
cat wb_stats
WbCgIno:                    1
WbWriteback:                0 kB
WbReclaimable:         685440 kB
WbDirtyThresh:      195530960 kB
WbDirtied:             691488 kB
WbWritten:               6048 kB
WbWriteBandwidth:      102400 kBps
b_dirty:                    2
b_io:                       0
b_more_io:                  0
b_dirty_time:               0
state:                      5

cat wb_stats
WbCgIno:                    1
WbWriteback:                0 kB
WbReclaimable:         818944 kB
WbDirtyThresh:      195527484 kB
WbDirtied:             824992 kB
WbWritten:               6048 kB
WbWriteBandwidth:      102400 kBps
b_dirty:                    2
b_io:                       0
b_more_io:                  0
b_dirty_time:               0
state:                      5

Link: https://lkml.kernel.org/r/20240423034643.141219-4-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reported-by: SeongJae Park <sj@kernel.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au> 
Cc: Brian Foster <bfoster@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/backing-dev.c~writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi-fix
+++ a/mm/backing-dev.c
@@ -172,7 +172,11 @@ static void wb_stats_show(struct seq_fil
 		   "b_more_io:         %10lu\n"
 		   "b_dirty_time:      %10lu\n"
 		   "state:             %10lx\n\n",
+#ifdef CONFIG_CGROUP_WRITEBACK
 		   cgroup_ino(wb->memcg_css->cgroup),
+#else
+		   1ul,
+#endif
 		   K(stats->nr_writeback),
 		   K(stats->nr_reclaimable),
 		   K(stats->wb_thresh),
@@ -192,7 +196,6 @@ static int cgwb_debug_stats_show(struct
 	unsigned long background_thresh;
 	unsigned long dirty_thresh;
 	struct bdi_writeback *wb;
-	struct wb_stats stats;
 
 	global_dirty_limits(&background_thresh, &dirty_thresh);
 
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

writeback-collect-stats-of-all-wb-of-bdi-in-bdi_debug_stats_show.patch
writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi.patch
writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi-fix.patch
writeback-add-wb_monitorpy-script-to-monitor-writeback-info-on-bdi.patch
writeback-rename-nr_reclaimable-to-nr_dirty-in-balance_dirty_pages.patch

