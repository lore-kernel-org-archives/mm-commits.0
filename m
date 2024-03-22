Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D3D10E3
	for <mm-commits@vger.kernel.org>; Fri, 22 Mar 2024 01:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711069451; cv=none; b=ciMY6fBISCWC+d94nUJlEfXWdSuCfMaraJS4wriMrL0GmJNCqPro8v4iN+vBvUcCVQMpM2q19OHYghQ3hBpUFN6KdCzhpqZSG64L5Fl+pDp3hCfdfXObAxRcgka++SJmCga2Mw9SUsocLDr4HC4RVQlwukFmBp0jOneVF5xoamE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711069451; c=relaxed/simple;
	bh=SMVsPbGL2F1CUX+zEhXBWd/zEnNPJZIPNn6lMMj5trc=;
	h=Date:To:From:Subject:Message-Id; b=IEKBIgYfDHLGill7aKL9o6MTYrTmqYq8PKOz1rRKDDmFLMJU/L4VulXcYrXs8O+53VkbxLV9buvabYXCEIFu9qI6qfVUce7gYSjceL12xG5TKueKwKRYv7NsSwz6cE5kJNUgF0eb0AU4Fzv1J0gsld+YZiFfV58gxD7gVSKoijw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JxYriZS6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JxYriZS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE181C433C7;
	Fri, 22 Mar 2024 01:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711069450;
	bh=SMVsPbGL2F1CUX+zEhXBWd/zEnNPJZIPNn6lMMj5trc=;
	h=Date:To:From:Subject:From;
	b=JxYriZS6As84zkAvXz0+bYzE2ivCfa2qn0mJhy5N41xDWxTdDiug9RO2Kw7jjgTMV
	 lne8Uj7HEX6KLwiskmDUJCSrvdVvntIxUqdIH+oXWadhmoOzmkPzcKhvHXI0scdKxt
	 bhFbnp15UmxzZmM6VrvQMHsbAsf8Ej4qcgUo8/5g=
Date: Thu, 21 Mar 2024 18:04:10 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,naoya.horiguchi@nec.com,muchun.song@linux.dev,mhocko@kernel.org,linmiaohe@huawei.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-hugetlbpagerst-add-hugetlb-migration-description.patch added to mm-unstable branch
Message-Id: <20240322010410.BE181C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs: hugetlbpage.rst: add hugetlb migration description
has been added to the -mm mm-unstable branch.  Its filename is
     docs-hugetlbpagerst-add-hugetlb-migration-description.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-hugetlbpagerst-add-hugetlb-migration-description.patch

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
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
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

mm-record-the-migration-reason-for-struct-migration_target_control.patch
mm-hugetlb-make-the-hugetlb-migration-strategy-consistent.patch
docs-hugetlbpagerst-add-hugetlb-migration-description.patch

