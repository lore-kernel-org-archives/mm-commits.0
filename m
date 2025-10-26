Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C307747F
	for <mm-commits@vger.kernel.org>; Sun, 26 Oct 2025 19:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761507950; cv=none; b=u/kgcxwuSFLAAbQCAtQBtW3YKeu/u8OVc3UW+nG1P/ckIATr+yOLGjGXbf1jtGrvVdaj5vnwDyq0GpKuY4um6BMcAM80OOArA/CDk4tyrhpHXTJnwRB1NuR6A0SmOpZHhn6cSCCRDBg8ZikHwME5V/fcenrwDVa5bJMd05HKyH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761507950; c=relaxed/simple;
	bh=W9BCuieWT+RTBXcGeOi7ZxWKoqjdXIPLehjH/viHvos=;
	h=Date:To:From:Subject:Message-Id; b=i7jI7UjpCodLVMbSw6dJnUyUBekb4nGIesVFxgBUbBIvbLVL2K+BCUsT/h8dnSpIMppaYYyrM69piEUpc3gsSns02YvDmW7LIkmqjS7cAS1VSYGN/kJjhJ9qFpc+gajJNWF7ivBnIYjyi0ngLiyaQt00CfNB6NBJVyd1AJOuWP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pQAO+q7L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pQAO+q7L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC15C4CEE7;
	Sun, 26 Oct 2025 19:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761507949;
	bh=W9BCuieWT+RTBXcGeOi7ZxWKoqjdXIPLehjH/viHvos=;
	h=Date:To:From:Subject:From;
	b=pQAO+q7Lep97KSUtnH31sZ6m96SKaNlhHUUmw+93HG1VEA4m1gYIsXwOAIlzARJ8B
	 m9mVwd8oG5tTE3uVNE6kSFMBE+APUXTr9k4XZFfPZAY91BnGXROO088EAW8XtOHsU7
	 KuTKgy39JbHk2X9aHzsYhK+RieGJ32OibqgrdcpM=
Date: Sun, 26 Oct 2025 12:45:49 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-stat-document-aggr_interval_us-parameter.patch added to mm-unstable branch
Message-Id: <20251026194549.BFC15C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/stat: document aggr_interval_us parameter
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-stat-document-aggr_interval_us-parameter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-stat-document-aggr_interval_us-parameter.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/stat: document aggr_interval_us parameter
Date: Sun, 26 Oct 2025 11:22:12 -0700

Commit cc7ceb1d14b0 ("mm/damon/stat: expose the current tuned aggregation
interval"), has introduced 'aggr_interval_us' parameter for DAMON_STAT. 
But the new parameter is not yet documented.  Document it on the usage
document for the module.

Link: https://lkml.kernel.org/r/20251026182216.118200-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/stat.rst |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/damon/stat.rst~docs-admin-guide-mm-damon-stat-document-aggr_interval_us-parameter
+++ a/Documentation/admin-guide/mm/damon/stat.rst
@@ -10,6 +10,8 @@ on the system's entire physical memory u
 access monitoring results statistics, namely idle time percentiles and
 estimated memory bandwidth.
 
+.. _damon_stat_monitoring_accuracy_overhead:
+
 Monitoring Accuracy and Overhead
 ================================
 
@@ -19,7 +21,9 @@ overhead minimum.  It auto-tunes the int
 events to be captured in each snapshot, while limiting the resulting sampling
 interval to be 5 milliseconds in minimum and 10 seconds in maximum.  On a few
 production server systems, it resulted in consuming only 0.x % single CPU time,
-while capturing reasonable quality of access patterns.
+while capturing reasonable quality of access patterns.  The tuning-resulting
+intervals can be retrieved via ``aggr_interval_us`` :ref:`parameter
+<damon_stat_aggr_interval_us>`.
 
 Interface: Module Parameters
 ============================
@@ -41,6 +45,18 @@ You can enable DAMON_STAT by setting the
 Setting it as ``N`` disables DAMON_STAT.  The default value is set by
 ``CONFIG_DAMON_STAT_ENABLED_DEFAULT`` build config option.
 
+.. _damon_stat_aggr_interval_us:
+
+aggr_interval_us
+----------------
+
+Auto-tuned aggregation time interval in microseconds.
+
+Users can read the aggregation interval of DAMON that is being used by the
+DAMON instance for DAMON_STAT.  It is :ref:`auto-tuned
+<damon_stat_monitoring_accuracy_overhead>` and therefore the value is
+dynamically changed.
+
 estimated_memory_bandwidth
 --------------------------
 
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
mm-damon-core-fix-wrong-comment-of-damon_call-return-timing.patch
docs-mm-damon-design-fix-wrong-link-to-intervals-goal-section.patch
docs-admin-guide-mm-damon-stat-fix-a-typo-s-sampling-events-sampling-interval.patch
docs-admin-guide-mm-damon-usage-document-empty-target-regions-commit-behavior.patch
docs-admin-guide-mm-damon-reclaim-document-addr_unit-parameter.patch
docs-admin-guide-mm-damon-lru_sort-document-addr_unit-parameter.patch
docs-admin-guide-mm-damon-stat-document-aggr_interval_us-parameter.patch
docs-admin-guide-mm-damon-stat-document-negative-idle-time.patch
mm-damon-core-add-damon_target-obsolete-for-pin-point-removal.patch
mm-damon-sysfs-test-commit-input-against-realistic-destination.patch
mm-damon-sysfs-implement-obsolete_target-file.patch
docs-admin-guide-mm-damon-usage-document-obsolete_target-file.patch
docs-abi-damon-document-obsolete_target-sysfs-file.patch
selftests-damon-_damon_sysfs-support-obsolete_target-file.patch
drgn_dump_damon_status-dump-damon_target-obsolete.patch
sysfspy-extend-assert_ctx_committed-for-monitoring-targets.patch
selftests-damon-sysfs-add-obsolete_target-test.patch

