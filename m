Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59641B808;
	Fri, 27 Mar 2026 00:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774572236; cv=none; b=EZu8KgzYOekTzAEzTfhOUDfIVznQN1+lGfUT7Qw7cWiu+UfR3ARCZE5jI8eLbUa0GOGvfyxV8dVSvnGA29ON0JDwAOdL9h/moYWfCahbqVVDTCBhTz+lwcdifwLnqw5RhiLy+LFABYFrhURwcmX4zqVX32923xrOIBLnApaWbH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774572236; c=relaxed/simple;
	bh=A1baT92GkExPeLSVcPdQDvtQiYQMSXImJ3IARwj7h3o=;
	h=Date:To:From:Subject:Message-Id; b=imLj2cbg/wEAH5ODtP3HrGKrcGop9aBmqW/WcuzWzZ0nbRT96bXT1cC9Gsy9JQvG7J0JI08ATP3IPxb7GI5ex55SITuPnNR8zJaEudF2dWLOIlbLogZGEbENZPHaaZ5lmN/7SVBgMvczE/j5bb7US1O7NwcAYp48xMj3fdSNiuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OCqRmyww; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OCqRmyww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2720C116C6;
	Fri, 27 Mar 2026 00:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774572235;
	bh=A1baT92GkExPeLSVcPdQDvtQiYQMSXImJ3IARwj7h3o=;
	h=Date:To:From:Subject:From;
	b=OCqRmywwFlKSumVS3fOrad2x+GuqEf7mZxJiwZkG0FHjhVBT+lOzZEPw6aLvV9MTy
	 gbTh1NVPE0zpwtCPV1cZGt0/Z496TPxIeJkGvgR0xYfaBHhMh8sQu+/qKu4QrtOB0N
	 JjXpYDkUJ6LEKqtt/LW3zeG8Wd1KoPOYhQ59qXB8=
Date: Thu, 26 Mar 2026 17:43:55 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,miklos@szeredi.hu,jack@suse.cz,hch@infradead.org,hannes@cmpxchg.org,joannelkoong@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-start-background-writeback-based-on-per-wb-threshold-for-strictlimit-bdis.patch added to mm-hotfixes-unstable branch
Message-Id: <20260327004355.A2720C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: start background writeback based on per-wb threshold for strictlimit BDIs
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-start-background-writeback-based-on-per-wb-threshold-for-strictlimit-bdis.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-start-background-writeback-based-on-per-wb-threshold-for-strictlimit-bdis.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Joanne Koong <joannelkoong@gmail.com>
Subject: mm: start background writeback based on per-wb threshold for strictlimit BDIs
Date: Thu, 26 Mar 2026 16:46:29 -0700

The proactive nr_dirty > gdtc->bg_thresh check in balance_dirty_pages()
only checks the global dirty threshold to start background writeback
while the writer is still free-running, but for strictlimit BDIs (eg
fuse), the per-wb dirty count can exceed the per-wb background threshold
while the global threshold is not yet exceeded, so background writeback
for this case never gets proactively started.

This leads to severe stalls and degraded throughput.  On fuse, buffered
write performance drops from 1400 MiB/s to 2000 KiB/s.

Add a per-wb threshold check for strictlimit BDIs so that background
writeback is started when wb_dirty exceeds wb_bg_thresh, which drains
dirty pages before the writer hits the throttle wall, matching the
proactive behavior that the global check provides for non-strictlimit
BDIs.

fio runs on fuse show about a 3-4% improvement in perf for buffered
writes:
fio --name=writeback_test --ioengine=psync --rw=write --bs=128k \
    --size=2G --numjobs=4 --ramp_time=10 --runtime=20 \
    --time_based --group_reporting=1 --direct=0

Link: https://lkml.kernel.org/r/20260326234629.840938-2-joannelkoong@gmail.com
Fixes: 64dd89ae01f2 ("mm/block/fs: remove laptop_mode") 
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/page-writeback.c~mm-start-background-writeback-based-on-per-wb-threshold-for-strictlimit-bdis
+++ a/mm/page-writeback.c
@@ -1835,7 +1835,9 @@ static int balance_dirty_pages(struct bd
 			balance_domain_limits(mdtc, strictlimit);
 		}
 
-		if (nr_dirty > gdtc->bg_thresh && !writeback_in_progress(wb))
+		if (!writeback_in_progress(wb) &&
+		    (nr_dirty > gdtc->bg_thresh ||
+		     (strictlimit && gdtc->wb_dirty > gdtc->wb_bg_thresh)))
 			wb_start_background_writeback(wb);
 
 		/*
_

Patches currently in -mm which might be from joannelkoong@gmail.com are

mm-start-background-writeback-based-on-per-wb-threshold-for-strictlimit-bdis.patch

