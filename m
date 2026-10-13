Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EF9480DFC
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865931; cv=none; b=Nmw3FNvKorEPhYHPX7hUknpiuaoiujMbhibcuWATc9fl4xIfcmCcx0P7pfFjHnCYigm3PdMa6hbduICDWNTM8dz5iPinHNqXZyqzbyIeUGqeyo9CMGXFIJyONgu3Tl7UNiyxXWiNtCI1p3DWfyzHU6/l6YubRCzJCwkimPgI6zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865931; c=relaxed/simple;
	bh=goxbD7BRUMmUmTGPhwG+GqomCgnkjhVrYW/54MpSNZs=;
	h=Date:To:From:Subject:Message-Id; b=aJOMTQljLyDdxUg/TbfeZlthgvRh8Syg+HeZwIvh/BtpIc6ajN3p+BYV4L/0JoS8U0lQGnGLf+0fT0a9jZAngJjhYoiWJeLQbzqrCUqOi0Wwi1rJQ+diLfb3J+eHOJVVMBTlg7wxkQWE0+FuuH9JL3rJ0vtigU1F99jiIsa4kdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J4fW95P9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J4fW95P9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9C31F00898;
	Tue, 13 Oct 2026 04:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865930;
	bh=wGTYJ+D5d88Vg1yPbRdOJjqTVnt5uafVprybo/KYNA0=;
	h=Date:To:From:Subject;
	b=J4fW95P9oCDkhYJnD246c/LtySLrMWtWYLvenuRAf9lMkRwjtOD6tIl6eN9rTIK2k
	 xjhwue3HuP5n7Rux9Uw3mUYMjBfeXJAvALc8QAHgDMwvipYStNat95Fzl6BZMuXfwB
	 StRVzHh7XyHcNvGEQtSqoNbp+s9/pnPlpav+wlKY=
Date: Mon, 12 Oct 2026 21:32:09 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-ops-common-support-hugepage_size-damon-filter-matching.patch removed from -mm tree
Message-Id: <20261013043210.4A9C31F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/ops-common: support hugepage_size damon filter matching
has been removed from the -mm tree.  Its filename was
     mm-damon-ops-common-support-hugepage_size-damon-filter-matching.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/ops-common: support hugepage_size damon filter matching
Date: Tue, 15 Sep 2026 07:33:52 -0700

Update ops-common data attribute filter matching logic to support
hugepage_size filter type.

Link: https://lore.kernel.org/20260915143359.91472-4-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/damon/ops-common.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/damon/ops-common.c~mm-damon-ops-common-support-hugepage_size-damon-filter-matching
+++ a/mm/damon/ops-common.c
@@ -536,6 +536,7 @@ bool damon_ops_filter_match(struct damon
 {
 	bool matched = false;
 	struct mem_cgroup *memcg;
+	size_t folio_sz;
 
 	switch (filter->type) {
 	case DAMON_FILTER_TYPE_ANON:
@@ -558,6 +559,15 @@ bool damon_ops_filter_match(struct damon
 			matched = filter->memcg_id == mem_cgroup_id(memcg);
 		rcu_read_unlock();
 		break;
+	case DAMON_FILTER_TYPE_HUGEPAGE_SIZE:
+		if (!folio) {
+			matched = false;
+			break;
+		}
+		folio_sz = folio_size(folio);
+		matched = filter->range_min <= folio_sz &&
+			folio_sz <= filter->range_max;
+		break;
 	default:
 		break;
 	}
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-damos_quota_goal-complement.patch
mm-damon-core-add-complement-argument-to-damos_new_quota_goal.patch
mm-damon-sysfs-schemes-support-quota-goal-complement-flag.patch
mm-damon-tests-core-kunit-test-quota_goal-complement-commit.patch
selftests-damon-sysfssh-test-quota-goal-complement-flag-file.patch
docs-mm-damon-design-document-damos-quota-goal-complement-flag.patch
docs-admin-guide-mm-damon-usage-update-for-quota-goal-complement-file.patch
docs-abi-damon-update-for-quota-goal-metric-complement-sysfs-file.patch

