Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536882F3657;
	Wed, 25 Jun 2025 22:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750892158; cv=none; b=RULnNf5hEG/41uVztGpPp1Teg3N6NlQBawF6J/JV5e9VpqDOG6qHvf+m0YBX6yD//kZL01Ve7CGue6lkbTWMkJTv6mzWuIjTRiBrBx4Xbi61r+ugzsVpgLm3REgZhFqLxOB2FpGFukUZX0hwPjxeCIiqqMhma5vMRgmoK3l5GiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750892158; c=relaxed/simple;
	bh=DpJ4kcjO8FKbfmpi10Lh12Uqfbh/VQPJY1DnBlkFNsg=;
	h=Date:To:From:Subject:Message-Id; b=gXPAD8xt6XrED4j9rdfmrfHwssxJMslhjvXTrszsI61E4xUmjtoCFKzIk1EzZC3vNcLHT4WtJknKIvibu4HThz7sPO+EUsc7I+IqycmcEqNnRmCd767m3AH3/5tLv/G9yFnZY7IBszd/CTi4+lzsRY7MtIKcd5EvxPch+0AtfTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pBYD0tko; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pBYD0tko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25956C4CEEA;
	Wed, 25 Jun 2025 22:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750892158;
	bh=DpJ4kcjO8FKbfmpi10Lh12Uqfbh/VQPJY1DnBlkFNsg=;
	h=Date:To:From:Subject:From;
	b=pBYD0tkoB9BaoY8Dl5eTiAdZc2ZaOz6h0A03EVaNLKI+4HSHQoLU6prM/eD7Z+mTm
	 peDSmaFWFVCeV+xie9Fm3Ox0SFMEh+qhbeNdCUfs+bv7zNsLZ9YfrUbBVBzL3HD6uM
	 Mgqi3cNNPM/B310pIDbRJhbSV06I+ETGFI/NlNhw=
Date: Wed, 25 Jun 2025 15:55:57 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-sysfs-schemes-free-old-damon_sysfs_scheme_filter-memcg_path-on-write.patch removed from -mm tree
Message-Id: <20250625225558.25956C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: free old damon_sysfs_scheme_filter->memcg_path on write
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-free-old-damon_sysfs_scheme_filter-memcg_path-on-write.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: free old damon_sysfs_scheme_filter->memcg_path on write
Date: Thu, 19 Jun 2025 11:36:07 -0700

memcg_path_store() assigns a newly allocated memory buffer to
filter->memcg_path, without deallocating the previously allocated and
assigned memory buffer.  As a result, users can leak kernel memory by
continuously writing a data to memcg_path DAMOS sysfs file.  Fix the leak
by deallocating the previously set memory buffer.

Link: https://lkml.kernel.org/r/20250619183608.6647-2-sj@kernel.org
Fixes: 7ee161f18b5d ("mm/damon/sysfs-schemes: implement filter directory")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>		[6.3.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-free-old-damon_sysfs_scheme_filter-memcg_path-on-write
+++ a/mm/damon/sysfs-schemes.c
@@ -472,6 +472,7 @@ static ssize_t memcg_path_store(struct k
 		return -ENOMEM;
 
 	strscpy(path, buf, count + 1);
+	kfree(filter->memcg_path);
 	filter->memcg_path = path;
 	return count;
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-introduce-damon_stat-module.patch
mm-damon-introduce-damon_stat-module-fix.patch
mm-damon-stat-calculate-and-expose-estimated-memory-bandwidth.patch
mm-damon-stat-calculate-and-expose-idle-time-percentiles.patch
docs-admin-guide-mm-damon-add-damon_stat-usage-document.patch
mm-damon-paddr-use-alloc_migartion_target-with-no-migration-fallback-nodemask.patch
revert-mm-rename-alloc_demote_folio-to-alloc_migrate_folio.patch
revert-mm-make-alloc_demote_folio-externally-invokable-for-migration.patch
selftets-damon-add-a-test-for-memcg_path-leak.patch
mm-damon-sysfs-schemes-decouple-from-damos_quota_goal_metric.patch
mm-damon-sysfs-schemes-decouple-from-damos_action.patch
mm-damon-sysfs-schemes-decouple-from-damos_wmark_metric.patch
mm-damon-sysfs-schemes-decouple-from-damos_filter_type.patch
mm-damon-sysfs-decouple-from-damon_ops_id.patch

