Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42CA1946BC
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 00:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774572991; cv=none; b=BMDos8oynQqVmYQ9K5XIcmspVyYrCkNQqU/ECmxShICQ6ocQg+oGjToVuuW/V/6RhA0UG/Y/SMZbg8+DdzHU0/VQy+ubPbaeRnbuTcv5ukfNc05A7QuGJzfCLj90NcmXAubaXr9TCRrMIcHRpctTVa5N3y9sdiW1a53RaGn+Xno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774572991; c=relaxed/simple;
	bh=VgKvI6bGtlNrjinur4BFNQ7BUYH2EttykvG2U4Y4itI=;
	h=Date:To:From:Subject:Message-Id; b=PatIsSloUF2UowAGwEfRDB6pNOSyc43fT58kNL7Ns5FI4+PW8bcS5RO410Mh86unTzYnQATLq+SVN6Q9V/iOq/k15hHKY5rRz0GHzT0sjxQH/9IdhyoIOUrjthpd1yEQzGgXJ8PBw4wZ0AMvalSueFDOtIeFhMaFV5eNXDbSyCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J0nWg5SE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J0nWg5SE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF7DC19423;
	Fri, 27 Mar 2026 00:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774572991;
	bh=VgKvI6bGtlNrjinur4BFNQ7BUYH2EttykvG2U4Y4itI=;
	h=Date:To:From:Subject:From;
	b=J0nWg5SEKicUWqZMZG1DQEWB8VbBC02hhiAYhN4YfQWTQZych6E37/64cRlh5fFYo
	 VyfcWmK9effKrcAmzyRN3noZMd+v1ZFw3+eCt5g1ielhREDOs9M3iXUb8lVDDFR5Fw
	 R6vrrT7q0n3qXfF4kqkt8Fw0omp/InUFKUv0nSIU=
Date: Thu, 26 Mar 2026 17:56:30 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,miklos@szeredi.hu,jack@suse.cz,hch@infradead.org,hannes@cmpxchg.org,joannelkoong@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-start-background-writeback-based-on-per-wb-threshold-for-strictlimit-bdis.patch added to mm-new branch
Message-Id: <20260327005631.2FF7DC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: start background writeback based on per-wb threshold for strictlimit BDIs
has been added to the -mm mm-new branch.  Its filename is
     mm-start-background-writeback-based-on-per-wb-threshold-for-strictlimit-bdis.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-start-background-writeback-based-on-per-wb-threshold-for-strictlimit-bdis.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
only checks the global dirty threshold to start background writeback while
the writer is still free-running, but for strictlimit BDIs (eg fuse), the
per-wb dirty count can exceed the per-wb background threshold while the
global threshold is not yet exceeded, so background writeback for this
case never gets proactively started.

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
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

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
@@ -1862,15 +1864,9 @@ free_running:
 		 * Unconditionally start background writeback if it's not
 		 * already in progress. We need to do this because the global
 		 * dirty threshold check above (nr_dirty > gdtc->bg_thresh)
-		 * doesn't account for these cases:
-		 *
-		 * a) strictlimit BDIs: throttling is calculated using per-wb
-		 * thresholds. The per-wb threshold can be exceeded even when
-		 * nr_dirty < gdtc->bg_thresh
-		 *
-		 * b) memcg-based throttling: memcg uses its own dirty count and
-		 * thresholds and can trigger throttling even when global
-		 * nr_dirty < gdtc->bg_thresh
+		 * doesn't account for the memcg-based throttling case. memcg
+		 * uses its own dirty count and thresholds and can trigger
+		 * throttling even when global nr_dirty < gdtc->bg_thresh
 		 *
 		 * Writeback needs to be started else the writer stalls in the
 		 * throttle loop waiting for dirty pages to be written back
_

Patches currently in -mm which might be from joannelkoong@gmail.com are

mm-reinstate-unconditional-writeback-start-in-balance_dirty_pages.patch
mm-start-background-writeback-based-on-per-wb-threshold-for-strictlimit-bdis.patch

