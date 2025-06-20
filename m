Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EFE4C79;
	Fri, 20 Jun 2025 00:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750380411; cv=none; b=XyEjn85WLgcd80x6q4nMl180RaG1EScmW4xLq2ph/rBlCw+VC0HEOsIhgRSlvUamfekvEftN1nhgi3S/KtnUwuyZoF9ox3yeEO2twV1arHgeKvRzU/OQxEwPQ6MVGxolMn99O5yu5JTVIruB4V0nQM3ef9Z4Mr9MNlGc5QPyUyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750380411; c=relaxed/simple;
	bh=uA5jOxe0KkX6Ovyb4Dypn6lnImsadKIwpGcNNs722kQ=;
	h=Date:To:From:Subject:Message-Id; b=YQIC8jG8XsymVjjTaUvtIBCyiQbdBTEW95WO0DrJur3N5BBUgSMhHC1vI0LJ4nJDQl9ppKCk29VJD6Ub0nNUFNlpbqrHPRhsDr07TJzHaRNuDmOSxTp6YEZTBWI/wMDCDo7sJ7SW0Q5hvsT6KHmUjGQMw+wBKVICBHI/+XLKf/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UHKNu57P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UHKNu57P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9382C4CEEA;
	Fri, 20 Jun 2025 00:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750380411;
	bh=uA5jOxe0KkX6Ovyb4Dypn6lnImsadKIwpGcNNs722kQ=;
	h=Date:To:From:Subject:From;
	b=UHKNu57P7aUUuXG3BVR0J06IwFRRcwX6h0cAa4M9uKPi84GPU6iq5DW9qnOtYIsmu
	 BYF+oPXAuCzO7umbeyLcfYs9gJb8boCUBcyOrBMP6KdUszw2jZ4ORcmU9YuUG5yvKy
	 ics06vHZWOQNLPvK+UIgRIwnwTS5K8AJcrLiZebc=
Date: Thu, 19 Jun 2025 17:46:50 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-free-old-damon_sysfs_scheme_filter-memcg_path-on-write.patch added to mm-hotfixes-unstable branch
Message-Id: <20250620004650.E9382C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: free old damon_sysfs_scheme_filter->memcg_path on write
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-free-old-damon_sysfs_scheme_filter-memcg_path-on-write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-free-old-damon_sysfs_scheme_filter-memcg_path-on-write.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-damon-sysfs-schemes-free-old-damon_sysfs_scheme_filter-memcg_path-on-write.patch
mm-damon-introduce-damon_stat-module.patch
mm-damon-introduce-damon_stat-module-fix.patch
mm-damon-stat-calculate-and-expose-estimated-memory-bandwidth.patch
mm-damon-stat-calculate-and-expose-idle-time-percentiles.patch
docs-admin-guide-mm-damon-add-damon_stat-usage-document.patch
mm-damon-paddr-use-alloc_migartion_target-with-no-migration-fallback-nodemask.patch
revert-mm-rename-alloc_demote_folio-to-alloc_migrate_folio.patch
revert-mm-make-alloc_demote_folio-externally-invokable-for-migration.patch
selftets-damon-add-a-test-for-memcg_path-leak.patch

