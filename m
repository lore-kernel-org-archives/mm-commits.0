Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA7F22D4F6
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343250; cv=none; b=TrWiZ9kWlvReKLb1BPfGXFhosKCPP48joyZggrLEyeH2/nuxL9y8etpjr49AxdmStJ21znIRP28puVeUCkcaIn9+ra3NOymzIrXtJ7+T+4FbX7mdyp+iZQlik4xm2OKdgre6EVgUNZYZZ2a738JGZtf8GVcAOXo8WZDz7bP/shU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343250; c=relaxed/simple;
	bh=5BIyzXRIj//wmcGcN+p/JAbtyTZWY0wpRbuo1aLA2rE=;
	h=Date:To:From:Subject:Message-Id; b=XzHXJhihjolQtN3dNagPVHt27SdgrmxMZEArtmUDM8UwMGIqrk2RbJzUXafKok4nhjOe8U91NXCmRhiYw9eR5oDA5RGh04r5GrrOIF3jpFHmb7a1YgDe66t6rmATRNU8jeHuKbsCoc6W5K9mUjimetSu/JKa3GgSncX2bQlfEa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ysNw4OED; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ysNw4OED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 981C2C116D0;
	Mon, 17 Nov 2025 01:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343250;
	bh=5BIyzXRIj//wmcGcN+p/JAbtyTZWY0wpRbuo1aLA2rE=;
	h=Date:To:From:Subject:From;
	b=ysNw4OEDtsj562FtpxYt+NzCtr4GqlSwEwLRvDKFmEDkU8TJ5rV2temk3dY08CuS3
	 feOOU4xMtWSwz2xAXDN6Liy/z+T8/nhNrnQgMOg4KEAc4P/qDvsQnbBIHAnEf17e2g
	 2KLmb/zwoNP9SSyA24tioRuJajvHbh1pkt5Q3uAw=
Date: Sun, 16 Nov 2025 17:34:10 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-stat-document-negative-idle-time.patch removed from -mm tree
Message-Id: <20251117013410.981C2C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/stat: document negative idle time
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-stat-document-negative-idle-time.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/stat: document negative idle time
Date: Sun, 26 Oct 2025 11:22:13 -0700

Commit a983a26d5298 ("mm/damon/stat: expose negative idle time")
introduced the negative idle time feature for DAMON_STAT.  But it is not
documented.  Document it on the usage document.

Link: https://lkml.kernel.org/r/20251026182216.118200-9-sj@kernel.org
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

 Documentation/admin-guide/mm/damon/stat.rst |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/Documentation/admin-guide/mm/damon/stat.rst~docs-admin-guide-mm-damon-stat-document-negative-idle-time
+++ a/Documentation/admin-guide/mm/damon/stat.rst
@@ -74,12 +74,13 @@ memory_idle_ms_percentiles
 Per-byte idle time (milliseconds) percentiles of the system.
 
 DAMON_STAT calculates how long each byte of the memory was not accessed until
-now (idle time), based on the current DAMON results snapshot.  If DAMON found a
-region of access frequency (nr_accesses) larger than zero, every byte of the
-region gets zero idle time.  If a region has zero access frequency
-(nr_accesses), how long the region was keeping the zero access frequency (age)
-becomes the idle time of every byte of the region.  Then, DAMON_STAT exposes
-the percentiles of the idle time values via this read-only parameter.  Reading
-the parameter returns 101 idle time values in milliseconds, separated by comma.
+now (idle time), based on the current DAMON results snapshot.  For regions
+having access frequency (nr_accesses) larger than zero, how long the current
+access frequency level was kept multiplied by ``-1`` becomes the idlee time of
+every byte of the region.  If a region has zero access frequency (nr_accesses),
+how long the region was keeping the zero access frequency (age) becomes the
+idle time of every byte of the region.  Then, DAMON_STAT exposes the
+percentiles of the idle time values via this read-only parameter.  Reading the
+parameter returns 101 idle time values in milliseconds, separated by comma.
 Each value represents 0-th, 1st, 2nd, 3rd, ..., 99th and 100th percentile idle
 times.
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-tests-core-kunit-remove-dynamic-allocs-on-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-split-out-damos_test_commit_filter-core-logic.patch
mm-damon-tests-core-kunit-extend-damos_test_commit_filter_for-for-union-fields.patch
mm-damon-tests-core-kunit-add-test-cases-to-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-add-damos_commit_quota_goal-test.patch
mm-damon-tests-core-kunit-add-damos_commit_quota_goals-test.patch
mm-damon-tests-core-kunit-add-damos_commit_quota-test.patch
mm-damon-core-pass-migrate_dests-to-damos_commit_dests.patch
mm-damon-tests-core-kunit-add-damos_commit_dests-test.patch
mm-damon-tests-core-kunit-add-damos_commit-test.patch
mm-damon-tests-core-kunit-add-damon_commit_target_regions-test.patch
mm-damon-rename-damos-core-filter-helpers-to-have-word-core.patch
mm-damon-rename-damos-filters-to-damos-core_filters.patch
mm-damon-vaddr-cleanup-using-pmd_trans_huge_lock.patch
mm-damon-vaddr-use-vm_normal_folio_pmd-instead-of-damon_get_folio.patch
mm-damon-vaddr-consistently-use-only-pmd_entry-for-damos_migrate.patch
mm-damon-tests-core-kunit-remove-damon_min_region-redefinition.patch
selftests-damon-sysfspy-merge-damon-status-dumping-into-commitment-assertion.patch
docs-mm-damon-maintainer-profile-fix-a-typo-on-mm-untable-link.patch
docs-mm-damon-maintainer-profile-fix-grammartical-errors.patch

