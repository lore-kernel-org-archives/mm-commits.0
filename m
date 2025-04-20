Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8C91C7014
	for <mm-commits@vger.kernel.org>; Sun, 20 Apr 2025 20:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745180739; cv=none; b=IQ+l/W1dO/dFRrvemmCB13jRp7E8GG/3r2oipI/C3PPwhUB7T9pdzWw54XV3RbhCvuBZJBbc089ZRToyAIv++RSn7WCPO8XU5BCaVC58tWyhkA7PQG1bXaJsTvk3g2OUlujVD46/RCRoEaAF8MWGUIxxDpGZ7gtCyCH8Skzbdnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745180739; c=relaxed/simple;
	bh=cWMCkBGU3vdtklBHiNw/p4+oE+RkWP/0l8fnM+O3/oU=;
	h=Date:To:From:Subject:Message-Id; b=Cu3BzH+ROQo73q9BJVmt/94/OL6OaCUocobjcypYYaz/k1RfrIh5mEdehrFr7nCe1Sn6TmuAa/jgR4rMHlp+DDYj91Ysf4jMR6eQy09EvXxqi5WiP8jLC5kZUKnpZdFTUO1tpIE0xDjgEstgur/ZftkEtvPARziBF92XQSFu7J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iT4eCbJg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iT4eCbJg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 928F5C4CEE2;
	Sun, 20 Apr 2025 20:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745180738;
	bh=cWMCkBGU3vdtklBHiNw/p4+oE+RkWP/0l8fnM+O3/oU=;
	h=Date:To:From:Subject:From;
	b=iT4eCbJgIDyYdszdcOEe1WoVxA0L9J9Y2m1yaDxAcOx4ayyB2B3tkufYy+jt35AzK
	 96fz1RZpO98lztcas3WB2gooZ6G0cZ9CXAIOKO+2Z75Ik0P6PIqkIuzp+k4pUK2EDx
	 LWbEZKFxZ1tR4l0qZC/8p+vv6nhmA+Ii8kFGEatI=
Date: Sun, 20 Apr 2025 13:25:38 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-document-nid-file.patch added to mm-unstable branch
Message-Id: <20250420202538.928F5C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: document 'nid' file
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-document-nid-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-document-nid-file.patch

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
Subject: Docs/admin-guide/mm/damon/usage: document 'nid' file
Date: Sun, 20 Apr 2025 12:40:28 -0700

Add description of 'nid' file, which is optionally used for specific DAMOS
quota goal metrics such as node_mem_{used,free}_bp on DAMON usage
document.

Link: https://lkml.kernel.org/r/20250420194030.75838-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-document-nid-file
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -81,7 +81,7 @@ comma (",").
     │ │ │ │ │ │ │ :ref:`quotas <sysfs_quotas>`/ms,bytes,reset_interval_ms,effective_bytes
     │ │ │ │ │ │ │ │ weights/sz_permil,nr_accesses_permil,age_permil
     │ │ │ │ │ │ │ │ :ref:`goals <sysfs_schemes_quota_goals>`/nr_goals
-    │ │ │ │ │ │ │ │ │ 0/target_metric,target_value,current_value
+    │ │ │ │ │ │ │ │ │ 0/target_metric,target_value,current_value,nid
     │ │ │ │ │ │ │ :ref:`watermarks <sysfs_watermarks>`/metric,interval_us,high,mid,low
     │ │ │ │ │ │ │ :ref:`{core_,ops_,}filters <sysfs_filters>`/nr_filters
     │ │ │ │ │ │ │ │ 0/type,matching,allow,memcg_path,addr_start,addr_end,target_idx,min,max
@@ -390,11 +390,11 @@ number (``N``) to the file creates the n
 to ``N-1``.  Each directory represents each goal and current achievement.
 Among the multiple feedback, the best one is used.
 
-Each goal directory contains three files, namely ``target_metric``,
-``target_value`` and ``current_value``.  Users can set and get the three
-parameters for the quota auto-tuning goals that specified on the :ref:`design
-doc <damon_design_damos_quotas_auto_tuning>` by writing to and reading from each
-of the files.  Note that users should further write
+Each goal directory contains four files, namely ``target_metric``,
+``target_value``, ``current_value`` and ``nid``.  Users can set and get the
+four parameters for the quota auto-tuning goals that specified on the
+:ref:`design doc <damon_design_damos_quotas_auto_tuning>` by writing to and
+reading from each of the files.  Note that users should further write
 ``commit_schemes_quota_goals`` to the ``state`` file of the :ref:`kdamond
 directory <sysfs_kdamond>` to pass the feedback to DAMON.
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-madvise-define-and-use-madvise_behavior-struct-for-madvise_do_behavior.patch
mm-madvise-batch-tlb-flushes-for-madv_free.patch
mm-memory-split-non-tlb-flushing-part-from-zap_page_range_single.patch
mm-madvise-batch-tlb-flushes-for-madv_dontneed.patch
mm-damon-core-introduce-damos-quota-goal-metrics-for-memory-node-utilization.patch
mm-damon-sysfs-schemes-implement-file-for-quota-goal-nid-parameter.patch
mm-damon-sysfs-schemes-connect-damos_quota_goal-nid-with-core-layer.patch
docs-mm-damon-design-document-node_mem_usedfree_bp.patch
docs-admin-guide-mm-damon-usage-document-nid-file.patch
docs-abi-damon-document-nid-file.patch
samples-damon-implement-a-damon-module-for-memory-tiering.patch

