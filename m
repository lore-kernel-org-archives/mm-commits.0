Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F8D3B05B6
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068111; cv=none; b=dzdHnuDIyQKrZAsGJJE96hYXgqwguwlFMw9FWCdcCxiu4N7tRRqtpcj2xNSJuCcR9Xr3Xz0GMPajJjosQIcpwNTTtEUKsPXkCyA8L9UAfk8hG3XXhOpLjnC8GmSLLlXZT2de/Y/fScQrw5FSyIfzcq+ldKLzpJ8/rpQ9cHmn5PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068111; c=relaxed/simple;
	bh=OWF9hf7g9zq290QxCZB7IPKokg81u+5VSkTWWrpWyAw=;
	h=Date:To:From:Subject:Message-Id; b=WndyFyJbbpYzJGbsIAWpQHlZ6jxG5WbLdC2bn2BOskv5s5WUwxUYqP6m5H/W/M1sve1Kk1jGP3Ri/1W03OLjitytFA8rQx4M3+eLJ3CtnI6AoAwJ08ODmy2JmPNhFljqHMxx4YBM1sYMOaCvdHcNSBSjGYGS8A+ZxIZmuFJUluk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Kebvlh3K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Kebvlh3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1B51F00A3A;
	Fri,  7 Aug 2026 02:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068110;
	bh=VF2UV4Sj1gpdGx7EF4Yqqs7GeR2XQc1jAQ740Vx2QIY=;
	h=Date:To:From:Subject;
	b=Kebvlh3KOKe/g/O29a264Y09FCurZu2rTpD/vUUz/hrJSGJuZ9AvkFQANslBr3Vln
	 O9YwOkRu8cdbjVS17oQnBeGdOD1a7NfQ8aNLNYPnCzV0mvgD94Nl024l6VeNzYxYYg
	 RP73YbayOfR+1JbwK9zKFf0pmHVtCgxpeL7CtCE4=
Date: Thu, 06 Aug 2026 19:01:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mincore-remove-xa_is_value-in-mincore_swap.patch removed from -mm tree
Message-Id: <20260807020150.2A1B51F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mincore: remove xa_is_value() in mincore_swap()
has been removed from the -mm tree.  Its filename was
     mm-mincore-remove-xa_is_value-in-mincore_swap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: mincore: remove xa_is_value() in mincore_swap()
Date: Fri, 17 Jul 2026 17:13:45 +0800

The swap_cache_get_folio() no longer returns shadow entries, so the
xa_is_value() check is unnecessary.

Link: https://lore.kernel.org/20260717091347.1144789-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/mincore.c~mm-mincore-remove-xa_is_value-in-mincore_swap
+++ a/mm/mincore.c
@@ -91,8 +91,7 @@ static unsigned char mincore_swap(swp_en
 	folio = swap_cache_get_folio(entry);
 	if (shmem)
 		put_swap_device(si);
-	/* The swap cache space contains either folio, shadow or NULL */
-	if (folio && !xa_is_value(folio)) {
+	if (folio) {
 		present = folio_test_uptodate(folio);
 		folio_put(folio);
 	}
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


