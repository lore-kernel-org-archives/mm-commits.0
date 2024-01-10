Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFF3DDA1
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 05:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lc2ksB4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14EB6C433C7;
	Wed, 10 Jan 2024 05:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704864721;
	bh=60dvsn8BhT7E8seKp4woiiIyhIz92VrdEeMJpvTwo/g=;
	h=Date:To:From:Subject:From;
	b=lc2ksB4+6Eyg6q1swexwjzEQOWIbxjv50o6VaTZCjreRhK81ondpu42XgGsjLn2rH
	 yIFfwNFfc1IrQNdhktPRM30TjXK9LU9YqIR3Iih/tU7feD9xkDR/YOwZnXMLeLiK4V
	 KByfWQSuMmcPVGv5iSQoKb3D6sP8isHGSAgzPDYs=
Date: Tue, 09 Jan 2024 21:32:00 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,lihongbo22@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-avoid-type-conversion.patch added to mm-unstable branch
Message-Id: <20240110053201.14EB6C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/filemap: avoid type conversion
has been added to the -mm mm-unstable branch.  Its filename is
     mm-filemap-avoid-type-conversion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-avoid-type-conversion.patch

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
@@ -842,7 +842,7 @@ noinline int __filemap_add_folio(struct
 		struct folio *folio, pgoff_t index, gfp_t gfp, void **shadowp)
 {
 	XA_STATE(xas, &mapping->i_pages, index);
-	int huge = folio_test_hugetlb(folio);
+	bool huge = folio_test_hugetlb(folio);
 	bool charged = false;
 	long nr = 1;
 
_

Patches currently in -mm which might be from lihongbo22@huawei.com are

mm-filemap-avoid-type-conversion.patch

