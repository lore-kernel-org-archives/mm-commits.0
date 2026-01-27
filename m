Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296543191B9
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486723; cv=none; b=Ipedinar8tHpg4oTHrTLBzwwX8PkCjOt8LIgNjJyyhzEgl8Nbrc7lhY1X0Ct19W6usjfvt1SpVyBRpR7bPBvdFIIkGUiOK+KVJRN/WJk2+moY4C5Lbrj+8C5A5J3E4SIU7hn4UWInx+gktwbi74zeq4NIdiidhzrlabjzf6jSjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486723; c=relaxed/simple;
	bh=VoMczrlcSW2CL7RpYwxUHFarZ8KYP03x/fHRHqRdgL8=;
	h=Date:To:From:Subject:Message-Id; b=NPtKaUCOY7YKNOtOF7nvJIgq4s703qMOXvqi6zFoefGK/K1fVNRtoUmaNeYdhibg45STLns8oIa2lXl903yWKofxTqtnVBKLlv+UiZUlKqAvm7H4H4LpRnhRNs5jHtqnFf160gFzCjOunAhk5K0Nqcx8utbK9szVNLyn71+tyGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sl0gyJ2J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sl0gyJ2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0227DC116C6;
	Tue, 27 Jan 2026 04:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486723;
	bh=VoMczrlcSW2CL7RpYwxUHFarZ8KYP03x/fHRHqRdgL8=;
	h=Date:To:From:Subject:From;
	b=Sl0gyJ2JmqrF7eDOYRGM50F9ehOGFdfgnODGHvRWhT/zVAr5o/c7Vg+sCILvNK5sR
	 SRaHd126mNwwAwdroS+Q3DK++zYgfcbfsu7PDQdDyvE+WZmJwvJPDtgCznQR22Y3Dy
	 JKGiT9hSCyHT4QGYY69lHvK6WxEy4DJW46tWI0Io=
Date: Mon, 26 Jan 2026 20:05:22 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,lianux.mm@gmail.com,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-lru_sort-document-intervals-autotuning.patch removed from -mm tree
Message-Id: <20260127040523.0227DC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/lru_sort: document intervals autotuning
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-lru_sort-document-intervals-autotuning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/lru_sort: document intervals autotuning
Date: Tue, 13 Jan 2026 07:27:16 -0800

Document a newly added DAMON_LRU_SORT module parameter for using
monitoring intervals auto-tuning feature of DAMON.

Link: https://lkml.kernel.org/r/20260113152717.70459-12-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Acked-by: wang lian <lianux.mm@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/lru_sort.rst |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/Documentation/admin-guide/mm/damon/lru_sort.rst~docs-admin-guide-mm-damon-lru_sort-document-intervals-autotuning
+++ a/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -91,6 +91,17 @@ increases and decreases the effective le
 
 Disabled by default.
 
+Auto-tune monitoring intervals
+------------------------------
+
+If this parameter is set as ``Y``, DAMON_LRU_SORT automatically tunes DAMON's
+sampling and aggregation intervals.  The auto-tuning aims to capture meaningful
+amount of access events in each DAMON-snapshot, while keeping the sampling
+interval 5 milliseconds in minimum, and 10 seconds in maximum.  Setting this as
+``N`` disables the auto-tuning.
+
+Disabled by default.
+
 filter_young_pages
 ------------------
 
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-sysfs_memcg_path_leaksh-use-kmemleak.patch
selftests-damon-wss_estimation-test-for-up-to-160-mib-working-set-size.patch
selftests-damon-access_memory-add-repeat-mode.patch
selftests-damon-wss_estimation-ensure-number-of-collected-wss.patch
selftests-damon-wss_estimation-deduplicate-failed-samples-output.patch
mm-damon-remove-damon_operations-cleanup.patch
mm-damon-core-cleanup-targets-and-regions-at-once-on-kdamond-termination.patch
mm-damon-core-cancel-damos_walk-before-damon_ctx-kdamond-reset.patch
mm-damon-core-process-damon_call_control-requests-on-a-local-list.patch
mm-damon-document-damon_call_control-dealloc_on_cancel-repeat-behavior.patch
mm-damon-core-rename-damos_filter_out-to-damos_core_filter_out.patch
mm-damon-rename-damon_min_region-to-damon_min_region_sz.patch
mm-damon-rename-min_sz_region-of-damon_ctx-to-min_region_sz.patch
docs-mm-damon-index-simplify-the-intro.patch
docs-mm-damon-design-link-repology-instead-of-fedora-package.patch
docs-mm-damon-design-document-damon-sample-modules.patch
docs-mm-damon-design-add-reference-to-damon_stat-usage.patch
docs-admin-guide-mm-damon-usage-introduce-damon-modules-at-the-beginning.patch
docs-admin-guide-mm-damon-usage-update-stats-update-process-for-refresh_ms.patch
docs-mm-damon-maintainer-profile-fix-wrong-maitnainers-section-name.patch
docs-mm-damon-maintainer-profile-remove-damon-tests-perf-suggestion.patch
maple_tree-start-using-maple-copy-node-for-destination-fix.patch

