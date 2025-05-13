Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914F61EB9E3
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119205; cv=none; b=BeGI9zezSfVhtQU9ieLJ82wJVi8OOmXYIKPPTbr9UCS6M2CMt4vPKohfKxXJYDmKQC14wGdG6G6B7zcYre8XKJ8y+BIgRG+qCbDSl5lCslrBgh+xfNmR4F6S6IjG/K7D/VyaH99xgjrH+53AbNGL2104MfVjugaq7ptbibT5XLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119205; c=relaxed/simple;
	bh=IVjL1A53vHIRyjs1JWS0Xqa112lUSw0cE2WFFO3XsCU=;
	h=Date:To:From:Subject:Message-Id; b=OZeXDYypKia6zQgQOY/NC9v3vsjLTy/ygP0NKupWCC7myRATAfsK+1Xt4MqZznaZBQ0dOj0V1ejphGYqUWSIHEy2WAT/VSri515ljJGx9drR/B+7I+7T3F9RGw3sLhRb+LRaO+6BZB+OcE7NZjkrcBdYTq+u0aYghZ7qwZ4yA+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w/hXVktG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w/hXVktG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D7ECC4CEED;
	Tue, 13 May 2025 06:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119205;
	bh=IVjL1A53vHIRyjs1JWS0Xqa112lUSw0cE2WFFO3XsCU=;
	h=Date:To:From:Subject:From;
	b=w/hXVktG1rzVLMvmrT4KGoGpPWeqto8Z1PYSxDXXHhfjoOfYFfnu4MwLVl+wQzjjh
	 nKyIR4Fpyixqk4f/txLkdXdXp7Y7lJ8ZQCTvzDQ3Igb0rNUDY0rze+dibALe1OwSdS
	 tK3kNlQHvf+TDX7qj7O5yV6e1oE96chikTd2df6E=
Date: Mon, 12 May 2025 23:53:24 -0700
To: mm-commits@vger.kernel.org,yunjeong.mun@sk.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-document-nid-file.patch removed from -mm tree
Message-Id: <20250513065325.5D7ECC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: document 'nid' file
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-document-nid-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Yunjeong Mun <yunjeong.mun@sk.com>
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

mm-damon-core-warn-and-fix-nr_accesses-corruption.patch
mm-damon-sysfs-schemes-fix-wrong-comment-on-damons_sysfs_quota_goal_metric_strs.patch
mm-damon-paddr-remove-unused-variable-folio_list-in-damon_pa_stat.patch
mm-damon-tests-core-kunit-add-a-test-for-damos_set_filters_default_reject.patch
selftests-damon-_damon_sysfs-read-tried-regions-directories-in-order.patch
docs-damon-update-titles-and-brief-introductions-to-explain-damos.patch

