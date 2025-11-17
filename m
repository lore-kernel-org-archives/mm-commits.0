Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA352367DC
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343261; cv=none; b=uWInCPWtw+9dCl99YoXrJB9nQk2QMLDvZ7vfF1ayoHwKXB2d3kb8KPSN7Et81rdXlo+3+ywGz3OUjiTSYW6csermgihvIO7CwSoj313rRIWUYZ28Wnf3lM4dbASGigunEVds2ZEkMGPhp7+dNWbzo50WHTavXjOJz9NGHaW/iSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343261; c=relaxed/simple;
	bh=RFLDy3yZ1/+V96dieR69IbmpW4KvqpcXpkGKn5ZQ5EM=;
	h=Date:To:From:Subject:Message-Id; b=fgScl3SS/T007G7d95EbrF6Ty/90nelCU3ThucvfRxaMjgNBlipt38fJtlEkfZT1oc5z4XUFjFA0LSsJ78vs1akW7E4Me9ZVlPE4aI1ZiCs0awqVaagutWTUcldaHf9pcbJ/7q9b9loY+ZIhUiGx1sK7VfI1b4UB49HxrEf2s8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IWRQizWd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IWRQizWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15E2C19422;
	Mon, 17 Nov 2025 01:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343260;
	bh=RFLDy3yZ1/+V96dieR69IbmpW4KvqpcXpkGKn5ZQ5EM=;
	h=Date:To:From:Subject:From;
	b=IWRQizWdvhHV9VqJ38A99xfwH2B14FYLaJlBW5CKVnD6VPvE3VLY1rN6uI5l9NnLa
	 Fe36DOWSifLY1J8E8SAdDAcfPXw2XkDuRfAdr3lN1ILBqoMtHRCmfAB7xj6XCV4spr
	 V46gsMpka6Y+PzHEEkdUxPzXK+nXChvAwuU5P+XU=
Date: Sun, 16 Nov 2025 17:34:20 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,bijan311@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] drgn_dump_damon_status-dump-damon_target-obsolete.patch removed from -mm tree
Message-Id: <20251117013420.B15E2C19422@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drgn_dump_damon_status: dump damon_target->obsolete
has been removed from the -mm tree.  Its filename was
     drgn_dump_damon_status-dump-damon_target-obsolete.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: drgn_dump_damon_status: dump damon_target->obsolete
Date: Wed, 22 Oct 2025 18:25:31 -0700

A new field of damon_target for pin-point target removal, namely obsolete,
has newly been added.  Extend drgn_dump_damon_status.py to dump it, for
easily writing a future DAMON selftests of it.

Link: https://lkml.kernel.org/r/20251023012535.69625-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Bijan Tabatabai <bijan311@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/drgn_dump_damon_status.py |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py~drgn_dump_damon_status-dump-damon_target-obsolete
+++ a/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -73,6 +73,7 @@ def target_to_dict(target):
         ['pid', int],
         ['nr_regions', int],
         ['regions_list', regions_to_list],
+        ['obsolete', bool],
         ])
 
 def targets_to_list(targets):
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

