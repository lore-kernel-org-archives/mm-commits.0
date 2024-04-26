Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56CC476408
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103975; cv=none; b=TRBoMEXl0+QuTy1czsDPVgRAjP2py/OKOHsIOQqwPUTuEWyv8M6feXNZ2dBKfIZzfkB+n9c0d6vduQ+E2VPv00aPhDP4l7BSF+2LaC34Xr9YhcxVFz1A7YH+zpJxtuGYOaOJT0qfM8uJ+Wp91DibHXPLGFeRZaKSPC3C+fuLQqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103975; c=relaxed/simple;
	bh=31F9Z12Z3S6/DNlFGVXHga33IVOGD7mhH9A9ThFp0Gk=;
	h=Date:To:From:Subject:Message-Id; b=W7NQm8ZkMP2ljnaazmdz4J0hIjaCvv6j+gXSWufPM4E9+r9XBZIRuk86t4ov0+D/xBge78E6x0gsGHcbf2033yKikV97VOjYrT42WK60l9UUQgyxCBC7Xb9JOeU97F0G4feXl3Na0Rpf81xGo9gbi1fBd+KMqiHN1+Bx0rxxyog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vr0CPazK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vr0CPazK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECCAC116B1;
	Fri, 26 Apr 2024 03:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103975;
	bh=31F9Z12Z3S6/DNlFGVXHga33IVOGD7mhH9A9ThFp0Gk=;
	h=Date:To:From:Subject:From;
	b=vr0CPazKFh4Q6G6PG8It1vn22UxkR5CMP6hSAoRpHYJ/fd+RDx7eRjtipMdrw7vE+
	 u657lzCTHIcP7bZlW1bK23jggEURxYnrh3a0ZKEQvuCNMdlm8ktrSVjoitJvkBRo31
	 bU3ecRkJsHZmK2QrAyMa3tfL6Tu5G2ZQP881QC3U=
Date: Thu, 25 Apr 2024 20:59:34 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,linmiaohe@huawei.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-hugetlbpagerst-add-hugetlb-migration-description.patch removed from -mm tree
Message-Id: <20240426035935.2ECCAC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs: hugetlbpage.rst: add hugetlb migration description
has been removed from the -mm tree.  Its filename was
     docs-hugetlbpagerst-add-hugetlb-migration-description.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: docs: hugetlbpage.rst: add hugetlb migration description
Date: Wed, 6 Mar 2024 18:13:28 +0800

Add some description of the hugetlb migration strategy.

Link: https://lkml.kernel.org/r/63fb16e7a4ebc5cb69ce655af86e29b2d8e9ba34.1709719720.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/hugetlbpage.rst |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/Documentation/admin-guide/mm/hugetlbpage.rst~docs-hugetlbpagerst-add-hugetlb-migration-description
+++ a/Documentation/admin-guide/mm/hugetlbpage.rst
@@ -376,6 +376,13 @@ Note that the number of overcommit and r
 as we don't know until fault time, when the faulting task's mempolicy is
 applied, from which node the huge page allocation will be attempted.
 
+The hugetlb may be migrated between the per-node hugepages pool in the following
+scenarios: memory offline, memory failure, longterm pinning, syscalls(mbind,
+migrate_pages and move_pages), alloc_contig_range() and alloc_contig_pages().
+Now only memory offline, memory failure and syscalls allow fallbacking to allocate
+a new hugetlb on a different node if the current node is unable to allocate during
+hugetlb migration, that means these 3 cases can break the per-node hugepages pool.
+
 .. _using_huge_pages:
 
 Using Huge Pages
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-page_alloc-allowing-mthp-compaction-to-capture-the-freed-page-directly.patch

