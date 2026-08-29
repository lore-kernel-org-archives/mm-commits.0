Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2662C3245
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 18:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788027847; cv=none; b=bfE8En7FoNh1JgCyqYFWch0l/K++LODKLOfo8DQ1p6Iwo5pDEZ4qOEX5smTeXynylIIOaT04NUn5kwHZG8nN4ywiWYJkjlJB4e0a2t2YkMeJDs5LIYweY944vMZWarSN6W8+hvYlnnyW++tuCcGsgJDsI3w1a5liYwo+b9BGQFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788027847; c=relaxed/simple;
	bh=J5HQy/WZGZq/Q+pd+4d3XcXDT7x37rf5k/+oUsw2v8g=;
	h=Date:To:From:Subject:Message-Id; b=V3ot6Xz4Z2n4vNVoEaADrG13VABqPrFrBG9dEMt4cUzrY1Ie2SYZ5RwjIzKrXhs29UiF6xpepRPES0zHjB40dwPn07Rm793AOPphHf+4sUQp82L5TjXL/6xI76qcFMGoML4E60r3rGMeCy/+xO/HH1sBxW9jfQh3DVOqwu1cwaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mRug7Woq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mRug7Woq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A411F000E9;
	Sat, 29 Aug 2026 18:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788027846;
	bh=O1KIbK4qh1nJVD7dbsJyCtE0QVmHqLdn8lgQJ/oMqyE=;
	h=Date:To:From:Subject;
	b=mRug7WoqytHB0wKaKxAIVPS336tLCnqhY4uEbmU9f/cHjiwIrIgmnjh+ywa/U9y/x
	 yuTpbqsiU9n0mrACj3YXHUm4ZboE72B9ircy9NvoeRrxPgEsvGG6GEK0UX+ACwlD1S
	 pGywEtPHC4E6Yl92cF9RCroaxKQhhoMw8tPn4vmQ=
Date: Sat, 29 Aug 2026 11:24:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,saravanand@crusoe.ai,ryan.roberts@arm.com,peterx@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jgg@ziepe.ca,dev.jain@arm.com,david@kernel.org,clg@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings-fix.patch removed from -mm tree
Message-Id: <20260829182405.E4A411F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings-fix
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings-fix
Date: Fri Aug 28 10:35:55 AM PDT 2026

s/vma_check_thp_tuneables_file/vma_file_check_thp_tuneables/, per Zi Yan

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Cedric Le Goater <clg@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Saravanan D <saravanand@crusoe.ai>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings-fix
+++ a/mm/huge_memory.c
@@ -143,7 +143,7 @@ static bool vma_thp_tuneables_allow_file
 	return false;
 }
 
-static bool vma_check_thp_tuneables_file(const struct vm_area_struct *vma,
+static bool vma_file_check_thp_tuneables(const struct vm_area_struct *vma,
 		vm_flags_t vm_flags, enum tva_type type)
 {
 	return vma_bypass_thp_tuneables_file(vma, type) ||
@@ -159,7 +159,7 @@ static bool vma_can_map_huge_file(const
 	 * Enforce THP collapse requirements as necessary. Anonymous vmas
 	 * were already handled in thp_vma_allowable_orders().
 	 */
-	if (!vma_check_thp_tuneables_file(vma, vm_flags, type))
+	if (!vma_file_check_thp_tuneables(vma, vm_flags, type))
 		return false;
 
 	switch (type) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

