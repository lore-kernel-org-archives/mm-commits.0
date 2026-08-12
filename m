Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B027E342CBA;
	Wed, 12 Aug 2026 01:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786499051; cv=none; b=JV/wt50zwvT9btLPBU0RzVnPcW9TMbhUZs8eGQ8v6o+C6IFqHmFloa8u8p4sYQEglolmXkUEL5oQXuO6nObdorgWzxXFUdIgqaasUpeOMqDY9ppjXqMYtM53mi4BeE9aqSWJ13oLhZzkdSlHRJMq4gMYW79ANEbchf9l1RJl+L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786499051; c=relaxed/simple;
	bh=HIyjXJNOvVIi4R4qoI8P4AkbW3htonnpRHeLl1GiNqA=;
	h=Date:To:From:Subject:Message-Id; b=i6Cp+aGRul7Q0QCmt4RlNpreAM0oGLKf7DCUdLkntTS0RQoNfQBLclIiHM52eVQ5STPplGnVSvBamTa1TcTmkMpizLZ9XsI8cGE91919sC+KWdPklgpezQUjQjhYyNHBauIgP419xGEwF3BwsBXrBidHTFEqzjlKKJyXSR3jY1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BZwUX5FQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BZwUX5FQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1591F000E9;
	Wed, 12 Aug 2026 01:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786499049;
	bh=On/SI4zHyMx/R2LnOa3Ox5lSKFKSYpfluDSBRbEEz9U=;
	h=Date:To:From:Subject;
	b=BZwUX5FQ9ej5XyM4hSLaDMdvvKniANSkGGLj8dyJxc8zRdi+c2agJCt0k3airNEJS
	 1u9bKdwRSIm+ncvI/GyiZ/KrrxAduR2xXA9e3e/X7i9ueHsuA0dR3/GVHb/RZWp25k
	 bRWbeijgOqeqzwRM+d1Mo53bdvgRFZG/X3V3CrA8=
Date: Tue, 11 Aug 2026 18:44:09 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,usamaarif642@gmail.com,surenb@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,osalvador@suse.de,muchun.song@linux.dev,gthelen@google.com,fvdl@google.com,david@kernel.org,anshuman.khandual@arm.com,souravpanda@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hugetlb_cma-fix-null-nodemask-dereference-in-hugetlb_cma_alloc_frozen_folio-v5.patch removed from -mm tree
Message-Id: <20260812014409.AB1591F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-hugetlb_cma-fix-null-nodemask-dereference-in-hugetlb_cma_alloc_frozen_folio-v5
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_cma-fix-null-nodemask-dereference-in-hugetlb_cma_alloc_frozen_folio-v5.patch

This patch was dropped because it was folded into mm-hugetlb_cma-fix-null-nodemask-dereference-in-hugetlb_cma_alloc_frozen_folio.patch

------------------------------------------------------
From: Sourav Panda <souravpanda@google.com>
Subject: mm-hugetlb_cma-fix-null-nodemask-dereference-in-hugetlb_cma_alloc_frozen_folio-v5
Date: Sun, 9 Aug 2026 04:32:50 +0000

Changes in v5:
- Replaced defaulting nodemask to &node_states[N_MEMORY] with safely reading
  cpuset_current_mems_allowed using a seqcount retry loop, ensuring fallback
  allocations comply with task hardwall cpusets as suggested by Usama Arif.

Link: https://lore.kernel.org/20260809043250.2917406-1-souravpanda@google.com
Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepages")
Signed-off-by: Sourav Panda <souravpanda@google.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cma.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/hugetlb_cma.c~mm-hugetlb_cma-fix-null-nodemask-dereference-in-hugetlb_cma_alloc_frozen_folio-v5
+++ a/mm/hugetlb_cma.c
@@ -3,6 +3,7 @@
 #include <linux/mm.h>
 #include <linux/cma.h>
 #include <linux/compiler.h>
+#include <linux/cpuset.h>
 #include <linux/mm_inline.h>
 
 #include <asm/page.h>
@@ -30,12 +31,21 @@ struct folio *hugetlb_cma_alloc_frozen_f
 	int node;
 	struct folio *folio;
 	struct page *page = NULL;
+	nodemask_t local_node_mask;
 
 	if (!hugetlb_cma_size)
 		return NULL;
 
-	if (!nodemask)
-		nodemask = &node_states[N_MEMORY];
+	if (!nodemask) {
+		unsigned int cpuset_mems_cookie;
+
+		do {
+			cpuset_mems_cookie = read_mems_allowed_begin();
+			local_node_mask = cpuset_current_mems_allowed;
+		} while (read_mems_allowed_retry(cpuset_mems_cookie));
+
+		nodemask = &local_node_mask;
+	}
 
 	if (hugetlb_cma[nid] && node_isset(nid, *nodemask))
 		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
_

Patches currently in -mm which might be from souravpanda@google.com are

mm-hugetlb_cma-fix-null-nodemask-dereference-in-hugetlb_cma_alloc_frozen_folio.patch
mm-hugetlb_cma-support-percentage-based-hugetlb_cma-reservation.patch

