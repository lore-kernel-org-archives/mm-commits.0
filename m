Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F72E22E004
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343248; cv=none; b=UpKFk9RONQvV0xiFSGwKFI6gdjGqwnMrqugNegttEp+wk/g12uTZUJRMb0I0JoXy+1UqcpGEKyfbl+P1EKpGcU+CG9Tg2dWyfuKUnUhpmw33FO7zTBkGwKvRX820tnH+/QO8kJ+SO1XKkY8VsDwDnij55bgmZpAGnaoA94gzT4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343248; c=relaxed/simple;
	bh=/QRrt2GGMxoZBcgv1xJvLfjCKZQ2j6OeqaU0Cj1mkk0=;
	h=Date:To:From:Subject:Message-Id; b=l+JgM8GM+oxrKi89FYur1EwAlnY6lWMeuhMV3sORNIMDbEMjQNZhs4VD877eqL4gdrKb55Pur96aBDWHtPSkmtYOQk9JR8xQtPlQAnLNVAJrq3m+3syTRZYs7Xy+RQwIuxfTRWde+mN/Our7HScN4893XMeHKINAKzhi+jQ/xhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=baGugy3Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="baGugy3Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE685C116D0;
	Mon, 17 Nov 2025 01:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343245;
	bh=/QRrt2GGMxoZBcgv1xJvLfjCKZQ2j6OeqaU0Cj1mkk0=;
	h=Date:To:From:Subject:From;
	b=baGugy3YfHXkiGX+tynJJX9tRBeXRsrJWYplWO5zViMHWwIikiDFjA3k/4ICWYm/W
	 NbDWJJIpakdGpy5G5r5nvrlzbIqcq9zIRLeO4uzoCBSbsa8uqTPRv9qZLiDNsO0Ugf
	 4gfb1AvE/CAlcoft9/O/9ELs0gYmzUh+ZgpC8ZYM=
Date: Sun, 16 Nov 2025 17:34:05 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-document-empty-target-regions-commit-behavior.patch removed from -mm tree
Message-Id: <20251117013405.CE685C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: document empty target regions commit behavior
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-document-empty-target-regions-commit-behavior.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: document empty target regions commit behavior
Date: Sun, 26 Oct 2025 11:22:09 -0700

Committing a monitoring target with empty target regions is for keeping
the current monitoring results.  This behavior was introduced by commit
973233600676 ("mm/damon/sysfs: update monitoring target regions for online
input commit").  The behavior is not documented, though.  Update the usage
document for clarifying this behavior.

Link: https://lkml.kernel.org/r/20251026182216.118200-5-sj@kernel.org
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

 Documentation/admin-guide/mm/damon/usage.rst |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-document-empty-target-regions-commit-behavior
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -134,7 +134,8 @@ Users can write below commands for the k
 - ``on``: Start running.
 - ``off``: Stop running.
 - ``commit``: Read the user inputs in the sysfs files except ``state`` file
-  again.
+  again.  Monitoring :ref:`target region <sysfs_regions>` inputs are also be
+  ignored if no target region is specified.
 - ``update_tuned_intervals``: Update the contents of ``sample_us`` and
   ``aggr_us`` files of the kdamond with the auto-tuning applied ``sampling
   interval`` and ``aggregation interval`` for the files.  Please refer to
@@ -289,6 +290,11 @@ In the beginning, this directory has onl
 number (``N``) to the file creates the number of child directories named ``0``
 to ``N-1``.  Each directory represents each initial monitoring target region.
 
+If ``nr_regions`` is zero when committing new DAMON parameters online (writing
+``commit`` to ``state`` file of :ref:`kdamond <sysfs_kdamond>`), the commit
+logic ignores the target regions.  In other words, the current monitoring
+results for the target are preserved.
+
 .. _sysfs_region:
 
 regions/<N>/
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

