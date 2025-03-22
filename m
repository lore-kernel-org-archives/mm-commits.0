Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94E912F399
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742619673; cv=none; b=ubF9ZxfRc1OUyElKmRFTxDWJJG90KwpF5NHdvNKNPvMdlQbzUasZzfb6kC+QZHaVP+V7KNY7NvS9qmKP7bE2LBaxkSkiu1KDOg5ecSDpW1A5FdaZrqDQzcxerOkjujyCHLSDVqK/UJ/K/yNwJ28kE7JmMpQJ/rrtsr7Mgy4cvdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742619673; c=relaxed/simple;
	bh=o+LSGMbhSATFyviMbNp60cByI6+iSE9/18PfpxiERdg=;
	h=Date:To:From:Subject:Message-Id; b=prVQ9zoI8Xjkti9frrhMU47t/49/vOotDB/apHZtu/D2UVuLLMPUbufwBpCIcG+Rt/+vX6wioJyuEy1TXURJL+7jkg2+kJgTGeNi+s3nxpBZq2e+l5eBq/4atHgHUJtm7lPoyWTZFBlBFKS/Fafzvs0Hg+SeGIF/JnRoPMpIeEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZHrIknej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZHrIknej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA530C4CEDD;
	Sat, 22 Mar 2025 05:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742619672;
	bh=o+LSGMbhSATFyviMbNp60cByI6+iSE9/18PfpxiERdg=;
	h=Date:To:From:Subject:From;
	b=ZHrIknej9J8PyFwrdyZWFcHJO8I+ifiudVEmHPQTZpW+wsl/AMTI1/J8JcVIEzmjj
	 +zq1Z/zws8+GtH4JmmSOHNe4dk/R7x4KGKfo3N5fQJ3jAHZFS2E0urmGbBataErpTy
	 JHeq0fmbMHuuybVbg9Nl+r5oqgTZZUGkekq1tmco=
Date: Fri, 21 Mar 2025 22:01:11 -0700
To: mm-commits@vger.kernel.org,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] meminfo-add-a-per-node-counter-for-balloon-drivers-fix.patch removed from -mm tree
Message-Id: <20250322050112.CA530C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation: document Balloon Meminfo entry
has been removed from the -mm tree.  Its filename was
     meminfo-add-a-per-node-counter-for-balloon-drivers-fix.patch

This patch was dropped because it was folded into meminfo-add-a-per-node-counter-for-balloon-drivers.patch

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: Documentation: document Balloon Meminfo entry
Date: Mon, 17 Mar 2025 16:07:18 -0600

Add a Balloon entry to the Meminfo documention.

Link: https://lkml.kernel.org/r/a0315ccf-f244-460e-8643-fd7388724fe5@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    3 +++
 1 file changed, 3 insertions(+)

--- a/Documentation/filesystems/proc.rst~meminfo-add-a-per-node-counter-for-balloon-drivers-fix
+++ a/Documentation/filesystems/proc.rst
@@ -1081,6 +1081,7 @@ Example output. You may not have all of
     FilePmdMapped:         0 kB
     CmaTotal:              0 kB
     CmaFree:               0 kB
+    Balloon:               0 kB
     HugePages_Total:       0
     HugePages_Free:        0
     HugePages_Rsvd:        0
@@ -1255,6 +1256,8 @@ CmaTotal
               Memory reserved for the Contiguous Memory Allocator (CMA)
 CmaFree
               Free remaining memory in the CMA reserves
+Balloon
+              Memory returned to Host by VM Balloon Drivers
 HugePages_Total, HugePages_Free, HugePages_Rsvd, HugePages_Surp, Hugepagesize, Hugetlb
               See Documentation/admin-guide/mm/hugetlbpage.rst.
 DirectMap4k, DirectMap2M, DirectMap1G
_

Patches currently in -mm which might be from npache@redhat.com are

meminfo-add-a-per-node-counter-for-balloon-drivers.patch
balloon_compaction-update-the-nr_balloon_pages-state.patch
hv_balloon-update-the-nr_balloon_pages-state.patch
xen-balloon-update-the-nr_balloon_pages-state.patch
documentation-add-unaccepted-meminfo-entry.patch

