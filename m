Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A731FAB
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560063; cv=none; b=WcBUn2JLCjItVUPnGUiANHgK1uEtZf9vbI3o7lV+Qw6R5vVJbkM9rMU52KwHVzDu0jFRTD1jjcKIJPSZD2BH5GM6NUf/5zdQJcpbh4ZslLs1xBCLmTLxhgBIIj5IrYnom9jcm7HzOtJC0IcZHqJXQcItJv+j4c3DnfvdBOcX3zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560063; c=relaxed/simple;
	bh=Nq793bgzxICR6M9RaSU4KShxeOtZjXX/3+VJhyyQkuw=;
	h=Date:To:From:Subject:Message-Id; b=pSVZoQGenDc4xht3PnRQjSm3nfg97Kn5/XbJmIlamsXm32o2qYRnbexD4GYyhrKg3JbSxYuKoFyLV/vHmnWPI5MSwsX5sga4fHjRiFWM29A5JiMkfGwtG7rOAFaAQ9MCE1PK4OTvljXeUeRVJMnVF5QLSZifglhD8f12ho534o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sDezwvwS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sDezwvwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FD4C43390;
	Thu, 22 Feb 2024 00:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560062;
	bh=Nq793bgzxICR6M9RaSU4KShxeOtZjXX/3+VJhyyQkuw=;
	h=Date:To:From:Subject:From;
	b=sDezwvwSD1YfkQduzg21vRrChZey4Nx2pu4NMnkKaC59MZnYfcDi+8sFhr1QMaTds
	 YR4ClTTDO8RzgTXd03u22v44aKusATXJsi/5g1tDxVV0wfSEvj2EL/OTwXYS+NMRLt
	 drvJu/LzjsmLRqVC7F0UXo5LWuMD3bNtY84eqo+A=
Date: Wed, 21 Feb 2024 16:01:02 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,lihongbo22@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-filemap-avoid-type-conversion.patch removed from -mm tree
Message-Id: <20240222000102.B3FD4C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/filemap: avoid type conversion
has been removed from the -mm tree.  Its filename was
     mm-filemap-avoid-type-conversion.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hongbo Li <lihongbo22@huawei.com>
Subject: mm/filemap: avoid type conversion
Date: Mon, 8 Jan 2024 12:48:15 +0800

The return type of function folio_test_hugetlb is bool type, there is no
need to assign it to an integer type.

Link: https://lkml.kernel.org/r/20240108044815.3291487-1-lihongbo22@huawei.com
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~mm-filemap-avoid-type-conversion
+++ a/mm/filemap.c
@@ -843,7 +843,7 @@ noinline int __filemap_add_folio(struct
 		struct folio *folio, pgoff_t index, gfp_t gfp, void **shadowp)
 {
 	XA_STATE(xas, &mapping->i_pages, index);
-	int huge = folio_test_hugetlb(folio);
+	bool huge = folio_test_hugetlb(folio);
 	bool charged = false;
 	long nr = 1;
 
_

Patches currently in -mm which might be from lihongbo22@huawei.com are


