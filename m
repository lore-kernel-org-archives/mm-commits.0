Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8F521C195
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409725; cv=none; b=eBq5/yVPRU2WtLVzd1I7jRBtw7OXpQQZJ1xD4KgmjX95d8mHoYME41tiAYNpJLR3kq/dzN4Ip3ikR3+K+SJuHKIy/aH1jaMHdRz2UMd5f6dSyT0ffTDv1JmtBmXOJOInW2rJRMnVwKlInV/T0azugt1EouNfizT/l+a7A8NgQZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409725; c=relaxed/simple;
	bh=+ep6M4unQdOG2AKbhqPcpqZOyBQD9m8uflXnEK2nWN0=;
	h=Date:To:From:Subject:Message-Id; b=idaa2CYnBc6UGOOkk+irzO6Y/7no4Svt+r+rjVRfdKzo0J39XNfc3wB9Ru+xyGMdE1frD3F8j0dS8jNDAuzIWIXGm02JbY3Ul0V45fb0MvnE4OLlZgoZ1SAaNEeCLHueoDVLYiMCJDwbvbncBfYCRyNLsziDaakDWzIxAfO60lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dP09zK65; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dP09zK65"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1305EC4CEED;
	Fri, 25 Jul 2025 02:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409725;
	bh=+ep6M4unQdOG2AKbhqPcpqZOyBQD9m8uflXnEK2nWN0=;
	h=Date:To:From:Subject:From;
	b=dP09zK65voOamsbGnc4UBpcKm9M7uWyUQ/8vup+io8Lxv0FJjsleEauLyOZuQKZoV
	 sSMUXS7oipwBzYVMGVqenXkbntnGGRG7e+1JF7CMfmAq6842eU4lv2t/URt0ucCjS6
	 Dd6Aq4oYS0iCuzy6ffpuh8XKbBsenrLWfjYPRAWY=
Date: Thu, 24 Jul 2025 19:15:24 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,npache@redhat.com,matthew.brost@intel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,k.shutemov@gmail.com,hughd@google.com,dev.jain@arm.com,david@redhat.com,dan.carpenter@linaro.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,antonio@mandelbit.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-convert-vm_bug-to-vm_warn-in-__folio_split.patch removed from -mm tree
Message-Id: <20250725021525.1305EC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: convert VM_BUG* to VM_WARN* in __folio_split
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-convert-vm_bug-to-vm_warn-in-__folio_split.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: convert VM_BUG* to VM_WARN* in __folio_split
Date: Thu, 17 Jul 2025 22:29:58 -0400

These VM_BUG* can be handled gracefully without crashing kernel.

Link: https://lkml.kernel.org/r/20250718023000.4044406-5-ziy@nvidia.com
Link: https://lkml.kernel.org/r/20250718183720.4054515-5-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Antonio Quartulli <antonio@mandelbit.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <k.shutemov@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-convert-vm_bug-to-vm_warn-in-__folio_split
+++ a/mm/huge_memory.c
@@ -3601,8 +3601,8 @@ static int __folio_split(struct folio *f
 	pgoff_t end;
 	bool is_hzp;
 
-	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
-	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
 
 	if (folio != page_folio(split_at) || folio != page_folio(lock_at))
 		return -EINVAL;
@@ -3766,7 +3766,11 @@ static int __folio_split(struct folio *f
 		}
 
 		if (folio_test_swapcache(folio)) {
-			VM_BUG_ON(mapping);
+			if (mapping) {
+				VM_WARN_ON_ONCE_FOLIO(mapping, folio);
+				ret = -EINVAL;
+				goto fail;
+			}
 
 			swap_cache = swap_address_space(folio->swap);
 			xa_lock(&swap_cache->i_pages);
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-page_alloc-remove-trace_mm_alloc_contig_migrate_range_info.patch

