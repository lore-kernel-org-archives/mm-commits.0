Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB9612A177
	for <mm-commits@vger.kernel.org>; Sat,  1 Feb 2025 11:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738410659; cv=none; b=NgnA1HU6gaxyPog8KyM6RPaoq5Sa3e5hkA//TygGCF11uGpMV6HDmuM9Q2GGi9u0Mzjg2broRx3zsBnKXdj+KoWovbtdHCO1qxTk5UUc8DLBG2HDr78jKRbMceHBhoEK1gcIclE2Q/OuF4XWMfRtofQLeupDCVVC/Xj0IN767sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738410659; c=relaxed/simple;
	bh=9CgfSvo11Ii6s80tX6UQkDk2PxlK+pR/bCnhges6m8w=;
	h=Date:To:From:Subject:Message-Id; b=k3shxiowHr2u6yqW7EWN3w/1s9u2hzWfBunbDs6NVoJWcvC4pVTEP1qNZLEGFap9Su+WuXGo04kT96+fa2IBorz1vZ2k5GHelPUfjiBABVnffeq5pF+Rd+PBnYmXxrgRdtCf7vi+YYsjBOZZt2wVo9govnv9rMHkUPzc701Yw/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c5JrrCy8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c5JrrCy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47719C4CED3;
	Sat,  1 Feb 2025 11:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738410659;
	bh=9CgfSvo11Ii6s80tX6UQkDk2PxlK+pR/bCnhges6m8w=;
	h=Date:To:From:Subject:From;
	b=c5JrrCy8xgOjkH89UOkNs+XrkCdVilWJKylgGIe+yT8lCdip44UXbn6yjgLYMJ1v1
	 Z1UBCwtRC0x616LncNzcfsvBDQIN2gXl5LXS2axLa1lMaF62wkL1hyS34rfc0Gh05u
	 vLiCbq8uTf72RTIgy+r+ZwNVkKqmoG0JbGp+5L/E=
Date: Sat, 01 Feb 2025 03:50:58 -0800
To: mm-commits@vger.kernel.org,jhubbard@nvidia.com,david@redhat.com,apopple@nvidia.com,aijun.sun@unisoc.com,zhaoyang.huang@unisoc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-gup-fix-infinite-loop-within-__get_longterm_locked-v3.patch removed from -mm tree
Message-Id: <20250201115059.47719C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-gup-fix-infinite-loop-within-__get_longterm_locked-v3
has been removed from the -mm tree.  Its filename was
     mm-gup-fix-infinite-loop-within-__get_longterm_locked-v3.patch

This patch was dropped because it was folded into mm-gup-fix-infinite-loop-within-__get_longterm_locked.patch

------------------------------------------------------
From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Subject: mm-gup-fix-infinite-loop-within-__get_longterm_locked-v3
Date: Wed, 22 Jan 2025 09:26:04 +0800

move definition of local

Link: https://lkml.kernel.org/r/20250122012604.3654667-1-zhaoyang.huang@unisoc.com
Fixes: 67e139b02d99 ("mm/gup.c: refactor check_and_migrate_movable_pages()")
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Aijun Sun <aijun.sun@unisoc.com>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c~mm-gup-fix-infinite-loop-within-__get_longterm_locked-v3
+++ a/mm/gup.c
@@ -2324,9 +2324,9 @@ static void collect_longterm_unpinnable_
 		struct list_head *movable_folio_list,
 		struct pages_or_folios *pofs)
 {
-	unsigned long i;
 	struct folio *prev_folio = NULL;
 	bool drain_allow = true;
+	unsigned long i;
 
 	for (i = 0; i < pofs->nr_entries; i++) {
 		struct folio *folio = pofs_get_folio(pofs, i);
_

Patches currently in -mm which might be from zhaoyang.huang@unisoc.com are

mm-gup-fix-infinite-loop-within-__get_longterm_locked.patch

