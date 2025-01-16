Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D313186E40
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006289; cv=none; b=docfHPpiAEwxOVl4Lz3IG2GkJby/U9kPB+GGLyAsU4ZHc7aD6gtJhiSRsr74+Yyq5gSJNC5O0jokUjdEkUBhAOmIUpG1aUdHBWIW/4EV+cOTAVlPtl9bagFyeN23J77OF619GqxtUCZ/Z8kZqYrySFkEE4WFQ9aMn9x98RW70VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006289; c=relaxed/simple;
	bh=CWgT6i4rCm4wmkNiY0Jd8o5JvSqz6USmCKyLW3JzKtA=;
	h=Date:To:From:Subject:Message-Id; b=Eu/LAyj2n49dHOZ0BpE89OtVuLE/93MLGdnHD9zRcs4zJ9Eb8C0huVa6NjGmB5dEJHJa5KerKnAzXmVGItgAYvbwYKD27YMIu4X/bBACVor7hJsn5XuapGgFy/+534nJurgSqcnyaJNnZVay8HpW13ZAWAIUdOAEtiTsPM1v2DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ECUNX22u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ECUNX22u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67AE3C4CED6;
	Thu, 16 Jan 2025 05:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006289;
	bh=CWgT6i4rCm4wmkNiY0Jd8o5JvSqz6USmCKyLW3JzKtA=;
	h=Date:To:From:Subject:From;
	b=ECUNX22u84q6qcGH1GHDQXVqkWChY51oyZ9Er8zJ8d6C93N18Mzl+R5kNF1cmeFMj
	 CzRRws6QunQ9VITNUAPuY68dzVSkAZAAkfCx50y9/tEvGjlmJbdm2cJoNFuMh0E76S
	 mE6yPLhFW6lWapZDXYfWGBJcHQcBP+dxZyRN2k3k=
Date: Wed, 15 Jan 2025 21:44:48 -0800
To: mm-commits@vger.kernel.org,yunjeong.mun@sk.com,honggyu.kim@sk.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch removed from -mm tree
Message-Id: <20250116054449.67AE3C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: fix and add missing DAMOS filter sysfs files on files hierarchy
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: fix and add missing DAMOS filter sysfs files on files hierarchy
Date: Fri, 10 Jan 2025 10:52:30 -0800

DAMOS filter directory part of DAMON sysfs files hierarchy on the usage
document is wrong.  'memcg_path' file under the directory is wrongly
written as 'memcg_id'.  Also the directory has 'addr_start', 'addr_end',
and 'target_idx' files, but the list is missing those.  Fix the wrong name
and add missing files.

Link: https://lkml.kernel.org/r/20250110185232.54907-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Yunjeong Mun <yunjeong.mun@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -83,7 +83,7 @@ comma (",").
     │ │ │ │ │ │ │ │ │ 0/target_metric,target_value,current_value
     │ │ │ │ │ │ │ :ref:`watermarks <sysfs_watermarks>`/metric,interval_us,high,mid,low
     │ │ │ │ │ │ │ :ref:`filters <sysfs_filters>`/nr_filters
-    │ │ │ │ │ │ │ │ 0/type,matching,memcg_id,allow
+    │ │ │ │ │ │ │ │ 0/type,matching,allow,memcg_path,addr_start,addr_end,target_idx
     │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,qt_exceeds
     │ │ │ │ │ │ │ :ref:`tried_regions <sysfs_schemes_tried_regions>`/total_bytes
     │ │ │ │ │ │ │ │ 0/start,end,nr_accesses,age,sz_filter_passed
_

Patches currently in -mm which might be from sj@kernel.org are


