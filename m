Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635CE747F
	for <mm-commits@vger.kernel.org>; Sun, 26 Oct 2025 19:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761507946; cv=none; b=qiOu7OVivf+Ivf1jHm5hfUUA9rBV5QtJAW/gaTqU3gWIJeOUoCv4aL/8Dv+s6RAhqFuoZHdqXXM3vbvvb1F0gX8c6n1EiSMoJAOT0ESYOiMVZSUiySg3dEtwR+NpbrClYFr7DBV/+n7rf2APkQuJy0LbSGTc2m+/0+SAK+gEW90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761507946; c=relaxed/simple;
	bh=3rPhAc28MC/c66saLTSz4imUNcWyrp+MzJhTVxe3UCQ=;
	h=Date:To:From:Subject:Message-Id; b=jcKmp57Ote6sHyZ+AnmFcL7g994YZsuAiFPeEt3TKiyfwZCKHTlNcHMpRKosvfNETf80nilMoIPWdvKbLl+4rN6Mi07vGnc57zgeM0SdwI49lEnCGZKTCIMVzfBmU3iLmi8qD8YK1nquUrcUFOIWiQHF2B5BnukvuK6Lxnx8zMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=laxHEsma; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="laxHEsma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC603C4CEE7;
	Sun, 26 Oct 2025 19:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761507945;
	bh=3rPhAc28MC/c66saLTSz4imUNcWyrp+MzJhTVxe3UCQ=;
	h=Date:To:From:Subject:From;
	b=laxHEsmaH8fxB7wrAEKJ2RgjWiuoXcafw+YP2RZNi18BAUuSTW9FDdFrpY1PCrANc
	 5rbs28P2B3hJGXeE4wITz+HP1uZGCMdOCm6lTYfiOofwNuNBRzgzT2WVBvdpHnEgfz
	 m8M7i80zqqy9YLXCyTcZyiqGGhZVlTL+9KbLgAUU=
Date: Sun, 26 Oct 2025 12:45:45 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-reclaim-document-addr_unit-parameter.patch added to mm-unstable branch
Message-Id: <20251026194545.CC603C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/reclaim: document addr_unit parameter
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-reclaim-document-addr_unit-parameter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-reclaim-document-addr_unit-parameter.patch

This patch will later appear in the mm-unstable branch at
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

mm-zswap-remove-unnecessary-dlen-writes-for-incompressible-pages.patch
mm-zswap-fix-typos-s-zwap-zswap.patch
mm-zswap-s-red-black-tree-xarray.patch
docs-admin-guide-mm-zswap-s-red-black-tree-xarray.patch
mm-damon-document-damos_quota_goal-nid-use-case.patch
mm-damon-add-damos-quota-goal-type-for-per-memcg-per-node-memory-usage.patch
mm-damon-core-implement-damos_quota_node_memcg_used_bp.patch
mm-damon-sysfs-schemes-implement-path-file-under-quota-goal-directory.patch
mm-damon-sysfs-schemes-support-damos_quota_node_memcg_used_bp.patch
mm-damon-core-add-damos-quota-gaol-metric-for-per-memcg-per-numa-free-memory.patch
mm-damon-sysfs-schemes-support-damos_quota_node_memcg_free_bp.patch
docs-mm-damon-design-document-damos_quota_node_memcg_usedfree_bp.patch
docs-admin-guide-mm-damon-usage-document-damos-quota-goal-path-file.patch
docs-abi-damon-document-damos-quota-goal-path-file.patch
mm-damon-core-fix-wrong-comment-of-damon_call-return-timing.patch
docs-mm-damon-design-fix-wrong-link-to-intervals-goal-section.patch
docs-admin-guide-mm-damon-stat-fix-a-typo-s-sampling-events-sampling-interval.patch
docs-admin-guide-mm-damon-usage-document-empty-target-regions-commit-behavior.patch
docs-admin-guide-mm-damon-reclaim-document-addr_unit-parameter.patch
docs-admin-guide-mm-damon-lru_sort-document-addr_unit-parameter.patch
docs-admin-guide-mm-damon-stat-document-aggr_interval_us-parameter.patch
docs-admin-guide-mm-damon-stat-document-negative-idle-time.patch
mm-damon-core-add-damon_target-obsolete-for-pin-point-removal.patch
mm-damon-sysfs-test-commit-input-against-realistic-destination.patch
mm-damon-sysfs-implement-obsolete_target-file.patch
docs-admin-guide-mm-damon-usage-document-obsolete_target-file.patch
docs-abi-damon-document-obsolete_target-sysfs-file.patch
selftests-damon-_damon_sysfs-support-obsolete_target-file.patch
drgn_dump_damon_status-dump-damon_target-obsolete.patch
sysfspy-extend-assert_ctx_committed-for-monitoring-targets.patch
selftests-damon-sysfs-add-obsolete_target-test.patch

