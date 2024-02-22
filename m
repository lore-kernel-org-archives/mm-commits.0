Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF4F17BC1
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708643986; cv=none; b=RghVmL2vbdqTLCog7Zt++cXQ5blhkgS5CmnGFlOdTjvZvbfnL5/bfebCO+5X0QhZqq55rojliQ03SIjOL6g6zfUxiy1tbhJIIgGZya9Ib8sFGwYICBGdMkOQbqOVy/CNtSOJeSqpC59m3D2QQDkXpzwQnD3IxNAM5QVhA5lf4fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708643986; c=relaxed/simple;
	bh=iCyH6+WRCdeX/BuNbdCpCNCNb/k2/C7+HJlHq5DtWJs=;
	h=Date:To:From:Subject:Message-Id; b=BoLt5na0UNe5GY8Nr00JBo29TSe8nJaUgDgKVyWoGeCTCJBB9ZfRNzwfLYzOfBmn4CBc2ibiAz8rOr2sigSKZOtIFz8S1enqEHBBy2xWRxyJfEEANXM97pT2GkE8RoT7vhR/Skn9GP2ttGsy3ImbzHMg62C8vjxvllB+1zigNMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CQqksBuW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CQqksBuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19313C433F1;
	Thu, 22 Feb 2024 23:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708643986;
	bh=iCyH6+WRCdeX/BuNbdCpCNCNb/k2/C7+HJlHq5DtWJs=;
	h=Date:To:From:Subject:From;
	b=CQqksBuWduGiDqmtrmK1iW8q8yjUffiUQtbVIJ24fYpwCYTyncyqkeDMN0/ZoKlA4
	 1Py1NSJL2XgYmN4MNkxStOMs6sY+2aVn5X3rJY6F7z+29lmxhWJTu9jYb6imOA06NS
	 ii//cU4xAtclRclZX+kLtxF5PBEXXciIdOw8rY1Y=
Date: Thu, 22 Feb 2024 15:19:45 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] docs-mm-damon-move-damon-operation-sets-list-from-the-usage-to-the-design-document-fix.patch removed from -mm tree
Message-Id: <20240222231946.19313C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: fix a typo on a reference link
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-move-damon-operation-sets-list-from-the-usage-to-the-design-document-fix.patch

This patch was dropped because it was folded into docs-mm-damon-move-damon-operation-sets-list-from-the-usage-to-the-design-document.patch

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: fix a typo on a reference link
Date: Wed, 21 Feb 2024 09:08:51 -0800

There was a typo cuasing a document build warning below.  Fix it.

    WARNING: undefined label: 'damon_design_confiurable_operations_set'

Link: https://lkml.kernel.org/r/20240221170852.55529-2-sj@kernel.org
Fixes: afc858f0e6db ("Docs/mm/damon: move DAMON operation sets list from the usage to the design document")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-mm-damon-move-damon-operation-sets-list-from-the-usage-to-the-design-document-fix
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -181,7 +181,7 @@ and three directories (``monitoring_attr
 exist.
 
 DAMON supports multiple types of :ref:`monitoring operations
-<damon_design_confiurable_operations_set>`, including those for virtual address
+<damon_design_configurable_operations_set>`, including those for virtual address
 space and the physical address space.  You can get the list of available
 monitoring operations set on the currently running kernel by reading
 ``avail_operations`` file.  Based on the kernel configuration, the file will
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-maintainer-profile-fix-reference-links-for-mm-stable-tree.patch
docs-mm-damon-move-the-list-of-damos-actions-to-design-doc.patch
docs-mm-damon-move-damon-operation-sets-list-from-the-usage-to-the-design-document.patch
docs-mm-damon-move-monitoring-target-regions-setup-detail-from-the-usage-to-the-design-document.patch
docs-admin-guide-mm-damon-usage-fix-wrong-quotas-diabling-condition.patch
mm-damon-core-set-damos_quota-esz-as-public-field-and-document.patch
mm-damon-sysfs-schemes-implement-quota-effective_bytes-file.patch
mm-damon-sysfs-implement-a-kdamond-command-for-updating-schemes-effective-quotas.patch
docs-abi-damon-document-effective_bytes-sysfs-file.patch
docs-admin-guide-mm-damon-usage-document-effective_bytes-file.patch
mm-damon-move-comments-and-fields-for-damos-quota-prioritization-to-the-end.patch
mm-damon-core-split-out-quota-goal-related-fields-to-a-struct.patch
mm-damon-core-add-multiple-goals-per-damos_quota-and-helpers-for-those.patch
mm-damon-sysfs-use-only-quota-goals.patch
mm-damon-core-remove-goal-field-of-damos_quota.patch
mm-damon-core-let-goal-specified-with-only-target-and-current-values.patch
mm-damon-core-support-multiple-metrics-for-quota-goal.patch
mm-damon-core-implement-psi-metric-damos-quota-goal.patch
mm-damon-sysfs-schemes-support-psi-based-quota-auto-tune.patch
docs-mm-damon-design-document-quota-goal-self-tuning.patch
docs-abi-damon-document-quota-goal-metric-file.patch
docs-admin-guide-mm-damon-usage-document-quota-goal-metric-file.patch
docs-admin-guide-mm-damon-usage-document-quota-goal-metric-file-fix.patch
mm-damon-reclaim-implement-user-feedback-driven-quota-auto-tuning.patch
mm-damon-reclaim-implement-memory-psi-driven-quota-self-tuning.patch
docs-admin-guide-mm-damon-reclaim-document-auto-tuning-parameters.patch

