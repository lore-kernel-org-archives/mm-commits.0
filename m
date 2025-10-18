Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47300B672
	for <mm-commits@vger.kernel.org>; Sat, 18 Oct 2025 00:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760746795; cv=none; b=NKfumbmMH1OS7wSIgZeDwddTI4kQYoj1y5tuuN+3/A9shn/u+qRPSl5Es9AYwCE65ZQXS1CQN/PRmwBPUnysLfDcPUMh4bW48nxrvy/VGGaLHvuDuMDXH8KyDIC8xQGQIa3NiJUW44YlXKVGOsPq3qkQD/725OxSNeVh3zwiY3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760746795; c=relaxed/simple;
	bh=wUvKxHIrK5bqZCh2VNoLgsml4+aBgHAlrAHgtVDFZ8M=;
	h=Date:To:From:Subject:Message-Id; b=VuqyLmsE64p9kTEbeeJc2mnQgGuyVHiRPjGssNq6jnB5UnGTMEDh09M0w4zhxuDUtYsvTNLlI4AveahHJDn0ifoyLa7ugktHZlYuZvJ43ZA/ubB5lV5QA+vp5veCCGW9cfPk9tPO5mVv10f45fHiSmyJ+bTVnlqhdSRurLVr0rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WyeBblSY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WyeBblSY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02671C4CEF9;
	Sat, 18 Oct 2025 00:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760746795;
	bh=wUvKxHIrK5bqZCh2VNoLgsml4+aBgHAlrAHgtVDFZ8M=;
	h=Date:To:From:Subject:From;
	b=WyeBblSY2dfhQ8W0wKZpoWiS1pVI6PLGyR6DjtmBrJGYXbNS3RodEUiGvSzyAEEhT
	 Fyqzx1BIq7mTUnZ65k7FtKR3X8N++tSoENo2lBKEzvPWiPgTqWw9p1khv9fvm4ft8Y
	 8/CAWKOz6MnmtnWtAiH8wyCq0prS0VUT3P3/wCBw=
Date: Fri, 17 Oct 2025 17:19:54 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-document-damos-quota-goal-path-file.patch added to mm-new branch
Message-Id: <20251018001955.02671C4CEF9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: document DAMOS quota goal path file
has been added to the -mm mm-new branch.  Its filename is
     docs-admin-guide-mm-damon-usage-document-damos-quota-goal-path-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-document-damos-quota-goal-path-file.patch

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
Subject: Docs/admin-guide/mm/damon/usage: document DAMOS quota goal path file
Date: Fri, 17 Oct 2025 14:27:01 -0700

A new DAMON sysfs interface file, namely 'path' has been added under DAMOS
quota goal directory, for specifying the cgroup for
DAMOS_QUOTA_NODE_MEMCG_{USED,FREE}_BP metrics.  Document it on the usage
document.

Link: https://lkml.kernel.org/r/20251017212706.183502-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-document-damos-quota-goal-path-file
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -81,7 +81,7 @@ comma (",").
     │ │ │ │ │ │ │ :ref:`quotas <sysfs_quotas>`/ms,bytes,reset_interval_ms,effective_bytes
     │ │ │ │ │ │ │ │ weights/sz_permil,nr_accesses_permil,age_permil
     │ │ │ │ │ │ │ │ :ref:`goals <sysfs_schemes_quota_goals>`/nr_goals
-    │ │ │ │ │ │ │ │ │ 0/target_metric,target_value,current_value,nid
+    │ │ │ │ │ │ │ │ │ 0/target_metric,target_value,current_value,nid,path
     │ │ │ │ │ │ │ :ref:`watermarks <sysfs_watermarks>`/metric,interval_us,high,mid,low
     │ │ │ │ │ │ │ :ref:`{core_,ops_,}filters <sysfs_filters>`/nr_filters
     │ │ │ │ │ │ │ │ 0/type,matching,allow,memcg_path,addr_start,addr_end,target_idx,min,max
@@ -402,9 +402,9 @@ number (``N``) to the file creates the n
 to ``N-1``.  Each directory represents each goal and current achievement.
 Among the multiple feedback, the best one is used.
 
-Each goal directory contains four files, namely ``target_metric``,
-``target_value``, ``current_value`` and ``nid``.  Users can set and get the
-four parameters for the quota auto-tuning goals that specified on the
+Each goal directory contains five files, namely ``target_metric``,
+``target_value``, ``current_value`` ``nid`` and ``path``.  Users can set and
+get the five parameters for the quota auto-tuning goals that specified on the
 :ref:`design doc <damon_design_damos_quotas_auto_tuning>` by writing to and
 reading from each of the files.  Note that users should further write
 ``commit_schemes_quota_goals`` to the ``state`` file of the :ref:`kdamond
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-fix-list_add_tail-call-on-damon_call.patch
mm-damon-core-use-damos_commit_quota_goal-for-new-goal-commit.patch
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

