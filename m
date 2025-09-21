Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5346927281D
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758490018; cv=none; b=chZOy/q1a9rv7vMFddSIAZpBCZmzmwfdgBM5XSu3QM45jZcXDc7qEnA63YzFu9e+a/7iAUEC0ggYbEaEWDEbY+n7H3TObN2VYzszWCWninl+CHW/kbOHeLnonmCDzsxnfTbjRasvAe9crPZyAhsEQi+sP2MRa/Q3g1iqqwYSnXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758490018; c=relaxed/simple;
	bh=2SRdhPrqXW1DdRx9oYE/etGmwzdZ4/XJzUzxTtD7FRs=;
	h=Date:To:From:Subject:Message-Id; b=GoQXrsACzqsJsinEPttoNy9MZlP2fTrErLRY4cs70SnkY11dERBemvzAZhUoSXl1QOGtWOCOSWKB/8Q0n8bN/Hk1YDdn9ovWhJAnYpFHRd0mcOrsw6r63JnXPCIoPNjTIhv9wrMeZ5gbUSM2z3mTk6YMCsQrrJYmAVP4KHazf5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gzOW9Lht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gzOW9Lht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F5DC4CEE7;
	Sun, 21 Sep 2025 21:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758490018;
	bh=2SRdhPrqXW1DdRx9oYE/etGmwzdZ4/XJzUzxTtD7FRs=;
	h=Date:To:From:Subject:From;
	b=gzOW9LhtGxHyfZ7+nwsQ4uXN+NhbaRwPJ2UQ0atwsUdpkuurHBFVZwAdlyWkAERsI
	 jzndI6bC4GGby2E5Ol1dqnGMdOmzbbhOU7kZv02yQQN2fx6AP31D3NW5J4NnrTHovr
	 UKl4ltoJ3i/G0m254JbrpZ15wE53V9gLWgoQqBG8=
Date: Sun, 21 Sep 2025 14:26:57 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-start-add-target_pid-to-damos-example-command.patch removed from -mm tree
Message-Id: <20250921212658.27F5DC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/start: add --target_pid to DAMOS example command
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-start-add-target_pid-to-damos-example-command.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/start: add --target_pid to DAMOS example command
Date: Mon, 15 Sep 2025 20:23:38 -0700

The example command doesn't work [1] on the latest DAMON user-space tool,
since --damos_action option is updated to receive multiple arguments, and
hence cannot know if the final argument is for deductible monitoring
target or an argument for --damos_action option.  Add --target_pid option
to let damo understand it is for target pid.

Link: https://lkml.kernel.org/r/20250916032339.115817-5-sj@kernel.org
Link: https://github.com/damonitor/damo/pull/32 [2]
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/start.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/damon/start.rst~docs-admin-guide-mm-damon-start-add-target_pid-to-damos-example-command
+++ a/Documentation/admin-guide/mm/damon/start.rst
@@ -175,4 +175,4 @@ Below command makes every memory region
 
     $ sudo damo start --damos_access_rate 0 0 --damos_sz_region 4K max \
                       --damos_age 60s max --damos_action pageout \
-                      <pid of your workload>
+                      --target_pid <pid of your workload>
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-set-damon_ctx-min_sz_region-only-for-paddr-use-case.patch

