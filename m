Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A64022D4F6
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343247; cv=none; b=LcdbgcWtfNcbdpIQMHAFMRq49hZmJpm9OHgW/iDnx7g/t2ff3EVNUWvJy1R9PCGm0DlxT06xPYmMSZiPej4upE7jzkMpKa2U9FJDhhNmWWP10W4AuJVOb4awDmE51Ff/qYFuTzsG1lzTprFjq2Ns5gcVKpVmb+nIQyTcIcIiirs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343247; c=relaxed/simple;
	bh=nSnnCX0OR2ZK8dEEdG61QoK5JYOPiF5WYYOCiAs83aE=;
	h=Date:To:From:Subject:Message-Id; b=ZAzK22+0IRE7/OKnK3Ktvv8QxPA3yf4JOfJKUUzEEPu1kB9wh0vPZcqqFT3JE1GBeTm84WcqQRkDPC7b6jAOHUetzVpGV6PxDZzWk17Ki2k9hM90We4jhI6HBJTONLNramRhHffVugU7srM9x/MFyFbR5hh/Br10zgjr/grJll4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cff45D4F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cff45D4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC65C2BC9E;
	Mon, 17 Nov 2025 01:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343247;
	bh=nSnnCX0OR2ZK8dEEdG61QoK5JYOPiF5WYYOCiAs83aE=;
	h=Date:To:From:Subject:From;
	b=cff45D4Fw+ilwNK3tQ1kPq96AqX96a2n0uMw7ORjdwJW0YNExVkhgTwnoLK+PFcog
	 MMJJgtIYbTxjGrhCOWQmjvQ8ePlD1SYFmdqIjXP0s6x+JD1Kn/b+21PzJyUxp6sge9
	 EZFJf396Q4eLvezx2c5FANOTwJnl3zv5lDz5UI6g=
Date: Sun, 16 Nov 2025 17:34:06 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-reclaim-document-addr_unit-parameter.patch removed from -mm tree
Message-Id: <20251117013407.0EC65C2BC9E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/reclaim: document addr_unit parameter
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-reclaim-document-addr_unit-parameter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/reclaim: document addr_unit parameter
Date: Sun, 26 Oct 2025 11:22:10 -0700

Commit 7db551fcfb2a ("mm/damon/reclaim: support addr_unit for
DAMON_RECLAIM") introduced the 'addr_unit' parameter for DAMON_RECLAIM. 
But the usage document is not updated for that.  Update the document.

Link: https://lkml.kernel.org/r/20251026182216.118200-6-sj@kernel.org
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

 Documentation/admin-guide/mm/damon/reclaim.rst |   22 +++++++++++++++
 1 file changed, 22 insertions(+)

--- a/Documentation/admin-guide/mm/damon/reclaim.rst~docs-admin-guide-mm-damon-reclaim-document-addr_unit-parameter
+++ a/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -232,6 +232,28 @@ The end physical address of memory regio
 against.  That is, DAMON_RECLAIM will find cold memory regions in this region
 and reclaims.  By default, biggest System RAM is used as the region.
 
+addr_unit
+---------
+
+A scale factor for memory addresses and bytes.
+
+This parameter is for setting and getting the :ref:`address unit
+<damon_design_addr_unit>` parameter of the DAMON instance for DAMON_RECLAIM.
+
+``monitor_region_start`` and ``monitor_region_end`` should be provided in this
+unit.  For example, let's suppose ``addr_unit``, ``monitor_region_start`` and
+``monitor_region_end`` are set as ``1024``, ``0`` and ``10``, respectively.
+Then DAMON_RECLAIM will work for 10 KiB length of physical address range that
+starts from address zero (``[0 * 1024, 10 * 1024)`` in bytes).
+
+``bytes_reclaim_tried_regions`` and ``bytes_reclaimed_regions`` are also in
+this unit.  For example, let's suppose values of ``addr_unit``,
+``bytes_reclaim_tried_regions`` and ``bytes_reclaimed_regions`` are ``1024``,
+``42``, and ``32``, respectively.  Then it means DAMON_RECLAIM tried to reclaim
+42 KiB memory and successfully reclaimed 32 KiB memory in total.
+
+If unsure, use only the default value (``1``) and forget about this.
+
 skip_anon
 ---------
 
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

