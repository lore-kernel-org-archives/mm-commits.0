Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873EE3D3B8
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247675; cv=none; b=gwBqFbz+krVC0hvJEcYL9Ld8EbfF7yhSKBwkPcONvdFDM6EsA8Futqkdw1i1hBdKMTFv/OPrcGOvMHbiRTGp8GE4/1tX13hWh4qTF1vbYZw08CV9mgeWnPJJjdvCKR77ZqBDFQKWMkZQU/lcuquaKFKyyOsjrK11bfWIoT7b2RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247675; c=relaxed/simple;
	bh=3xrTINQD8howWFvWCxgR+OVb6GVYPpH6sAYwDxST62I=;
	h=Date:To:From:Subject:Message-Id; b=GHJi5mL4AsMradogwdmFd4Tn0ZKvgIfLHP6NJMduIZF2YeXFI5SK+BDCC7IvIUK2H9wnAGSUPDwJt+WRg4I6256cA6KhsrD4RVhUXtlOHd9RMrtlJjUDGNyBIQGsime+w8IAqMV9wvFB7R6rZuWNcmNTTLXptdfKzRxMijDyN5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KkMUKXK7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KkMUKXK7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0B7C4CEC2;
	Mon,  2 Sep 2024 03:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247675;
	bh=3xrTINQD8howWFvWCxgR+OVb6GVYPpH6sAYwDxST62I=;
	h=Date:To:From:Subject:From;
	b=KkMUKXK7vFtAEZ/6GIwAJnuShxCf5iX17mnwwhNF1U5oUYWkvs+EdcyLryaS7AEvB
	 SNYMX1vpTJRqneDxlk2ZPueZg0M3gtQqTao+DaLjJvAwtFUhvDnoAtQYu3WPSGH2Ts
	 ftvw/fN7gaNk6BIPwQtH2GeAQa/oLaLkuAS8N0EY=
Date: Sun, 01 Sep 2024 20:27:54 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,wangkefeng.wang@huawei.com,lorenzo.stoakes@oracle.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memory-tiering-count-pgpromote_success-when-mem-tiering-is-enabled.patch removed from -mm tree
Message-Id: <20240902032755.5D0B7C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memory tiering: count PGPROMOTE_SUCCESS when mem tiering is enabled.
has been removed from the -mm tree.  Its filename was
     memory-tiering-count-pgpromote_success-when-mem-tiering-is-enabled.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: memory tiering: count PGPROMOTE_SUCCESS when mem tiering is enabled.
Date: Wed, 24 Jul 2024 09:01:15 -0400

memory tiering can be enabled/disabled at runtime and
sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING is used to
check it.  In migrate_misplaced_folio(), the check is missing when
PGPROMOTE_SUCCESS is incremented.  Add the missing check.

Link: https://lkml.kernel.org/r/20240724130115.793641-4-ziy@nvidia.com
Fixes: 33024536bafd ("memory tiering: hot page selection with hint page fault latency")
Reported-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Closes: https://lore.kernel.org/linux-mm/f4ae2c9c-fe40-4807-bdb2-64cf2d716c1a@huawei.com/
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~memory-tiering-count-pgpromote_success-when-mem-tiering-is-enabled
+++ a/mm/migrate.c
@@ -2636,7 +2636,9 @@ int migrate_misplaced_folio(struct folio
 		putback_movable_pages(&migratepages);
 	if (nr_succeeded) {
 		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
-		if (!node_is_toptier(folio_nid(folio)) && node_is_toptier(node))
+		if ((sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
+		    && !node_is_toptier(folio_nid(folio))
+		    && node_is_toptier(node))
 			mod_node_page_state(pgdat, PGPROMOTE_SUCCESS,
 					    nr_succeeded);
 	}
_

Patches currently in -mm which might be from ziy@nvidia.com are


