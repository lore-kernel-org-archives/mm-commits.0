Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0496B72629
	for <mm-commits@vger.kernel.org>; Thu, 23 Oct 2025 23:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761261591; cv=none; b=T5AIATDRvd5wr19WCiFA474Ke6boR5mKjaJC1y82579DtcZTsJgnV3yaiqlc8GVQvd7tVpUGWNrdtFXA3tB/oZgTEGKbrXPVvr/No2mhV63AeLv5BOuWQdDcaHkVHL5xrE+a7uMAt3c8JRHwXNg1vBB4ULqBhy88xnFLAqGg2DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761261591; c=relaxed/simple;
	bh=x5bNLdkK25ibE1iQztfI6owP9rUoymNx/Jv/L66OccY=;
	h=Date:To:From:Subject:Message-Id; b=Xpr5kHNjmBLVPYSeRLqUObib5rnK7g7tSe5g2Ojp++LbwerSKFv6ZoAnzKWS/oSkSS1aQdG6N1NkHVo/P4UN68HXgDHAqAUQGMJHB1P1LTp3hzXVdRPDqtKqhCstuouW8aTd+eJ8ybAvii7+dfpcgNZaxJMJUnD+3/MSS6gke8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F9PPcDp2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F9PPcDp2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990EBC4CEE7;
	Thu, 23 Oct 2025 23:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761261590;
	bh=x5bNLdkK25ibE1iQztfI6owP9rUoymNx/Jv/L66OccY=;
	h=Date:To:From:Subject:From;
	b=F9PPcDp28+lAj0NdCUbtRVL0crKnjNxGOllheAGTNyUKWvG+Uv8AEQXi1ITX6iYd+
	 pFGpI5dIMe3tOqwul7Z5ROBKGIZp2XmYg9y7b2fQxq+Jpj2onPfPNraHd6q0xopNCy
	 6NHq9w48LqfJZKA/rs6IYSl/l70uXN5enZg9FDC8=
Date: Thu, 23 Oct 2025 16:19:50 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,bijan311@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drgn_dump_damon_status-dump-damon_target-obsolete.patch added to mm-new branch
Message-Id: <20251023231950.990EBC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drgn_dump_damon_status: dump damon_target->obsolete
has been added to the -mm mm-new branch.  Its filename is
     drgn_dump_damon_status-dump-damon_target-obsolete.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drgn_dump_damon_status-dump-damon_target-obsolete.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: SeongJae Park <sj@kernel.org>
Subject: drgn_dump_damon_status: dump damon_target->obsolete
Date: Wed, 22 Oct 2025 18:25:31 -0700

A new field of damon_target for pin-point target removal, namely obsolete,
has newly been added.  Extend drgn_dump_damon_status.py to dump it, for
easily writing a future DAMON selftests of it.

Link: https://lkml.kernel.org/r/20251023012535.69625-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Bijan Tabatabai <bijan311@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/drgn_dump_damon_status.py |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py~drgn_dump_damon_status-dump-damon_target-obsolete
+++ a/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -73,6 +73,7 @@ def target_to_dict(target):
         ['pid', int],
         ['nr_regions', int],
         ['regions_list', regions_to_list],
+        ['obsolete', bool],
         ])
 
 def targets_to_list(targets):
_

Patches currently in -mm which might be from sj@kernel.org are

mm-zswap-remove-unnecessary-dlen-writes-for-incompressible-pages.patch
mm-zswap-fix-typos-s-zwap-zswap.patch
mm-zswap-s-red-black-tree-xarray.patch
docs-admin-guide-mm-zswap-s-red-black-tree-xarray.patch
mm-damon-document-damos_quota_goal-nid-use-case.patch
mm-damon-add-damos-quota-goal-type-for-per-memcg-per-node-memory-usage.patch
mm-damon-core-implement-damos_quota_node_memcg_used_bp.patch
mm-damon-sysfs-schemes-implement-path-file-under-quota-goal-directory.patch
mm-damon-sysfs-schemes-support-damos_quota_node_memcg_used_bp.patch
mm-damon-core-add-damos-quota-gaol-metric-for-per-memcg-per-numa-free-memory.patch
mm-damon-sysfs-schemes-support-damos_quota_node_memcg_free_bp.patch
docs-mm-damon-design-document-damos_quota_node_memcg_usedfree_bp.patch
docs-admin-guide-mm-damon-usage-document-damos-quota-goal-path-file.patch
docs-abi-damon-document-damos-quota-goal-path-file.patch
mm-damon-core-add-damon_target-obsolete-for-pin-point-removal.patch
mm-damon-sysfs-test-commit-input-against-realistic-destination.patch
mm-damon-sysfs-implement-obsolete_target-file.patch
docs-admin-guide-mm-damon-usage-document-obsolete_target-file.patch
docs-abi-damon-document-obsolete_target-sysfs-file.patch
selftests-damon-_damon_sysfs-support-obsolete_target-file.patch
drgn_dump_damon_status-dump-damon_target-obsolete.patch
sysfspy-extend-assert_ctx_committed-for-monitoring-targets.patch
selftests-damon-sysfs-add-obsolete_target-test.patch

