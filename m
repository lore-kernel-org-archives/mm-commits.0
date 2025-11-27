Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBE63FBA7
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764281937; cv=none; b=WtqRhZQOP3H0NrChq7xGlmFQzB2K4GrY8RS5oX4v75QMbNstgURVD/dIEik/HEBi+aPvGDGcDc8kDB+/5SLcas0YYYECoTgii+9GrHSYVlLhs2Wz4J5pzB4QDX+Y8Wix7Lu1++Or6Q2zhPsAkpK2Czrs57NHkHkS6M+YMyxLMmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764281937; c=relaxed/simple;
	bh=23f+muQ39ILlR/KzLL+YM/GKl5toqNGydeTnebR254Y=;
	h=Date:To:From:Subject:Message-Id; b=UyHrLdxc3Aw9jfDKy/R3Tl44vpYESqPu1VaRPstNzudLF3N7l7cA3rQFi27Tcf4PY5eAq13n3X7mYRsvEPBBM1e1cTdtHoXB3bPOWFjgjfFc1bPrOKKsCcRt0bZkTIhhzHtBmLInhwj+RPBMZMHRlvAWLljA8vtYTgI+I6v6pbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0FJ//08v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0FJ//08v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469B3C4CEFB;
	Thu, 27 Nov 2025 22:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764281936;
	bh=23f+muQ39ILlR/KzLL+YM/GKl5toqNGydeTnebR254Y=;
	h=Date:To:From:Subject:From;
	b=0FJ//08vVDDhgREqt6YpVRXHGm7lLr5PrWFQJVW+1KltQOJWo8MMA7wUFXQ+gjzI6
	 m0vZ8b6Vlekt5VjDsRQS0oYpftB3fXGMST934xikD92OYmeGm+zZq9Jh94aZu2q+C2
	 A3RIlT9F6OS8wqgmTU94TOPzC33oDSLzEkqT/UNc=
Date: Thu, 27 Nov 2025 14:18:55 -0800
To: mm-commits@vger.kernel.org,yanjun.zhu@linux.dev,tj@kernel.org,rppt@kernel.org,rdunlap@infradead.org,pratyush@kernel.org,pasha.tatashin@soleen.com,ojeda@kernel.org,masahiroy@kernel.org,jgg@ziepe.ca,jgg@nvidia.com,horms@kernel.org,graf@amazon.com,corbet@lwn.net,changyuanl@google.com,brauner@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] memblock-unpreserve-memory-in-case-of-error-fix.patch removed from -mm tree
Message-Id: <20251127221856.469B3C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memblock-unpreserve-memory-in-case-of-error-fix
has been removed from the -mm tree.  Its filename was
     memblock-unpreserve-memory-in-case-of-error-fix.patch

This patch was dropped because it was folded into memblock-unpreserve-memory-in-case-of-error.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memblock-unpreserve-memory-in-case-of-error-fix
Date: Mon Nov  3 07:23:35 PM PST 2025

s/err_no_fdt_page/err_report/ in prepare_kho_fdt(), per Mike

Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Simon Horman <horms@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memblock.c~memblock-unpreserve-memory-in-case-of-error-fix
+++ a/mm/memblock.c
@@ -2483,7 +2483,7 @@ static int __init prepare_kho_fdt(void)
 	fdt_page = alloc_page(GFP_KERNEL);
 	if (!fdt_page) {
 		err = -ENOMEM;
-		goto err_no_fdt_page;
+		goto err_report;
 	}
 
 	fdt = page_to_virt(fdt_page);
@@ -2527,7 +2527,7 @@ err_unpreserve_fdt:
 	kho_unpreserve_pages(fdt_page, 1);
 err_free_fdt:
 	put_page(fdt_page);
-err_no_fdt_page:
+err_report:
 	pr_err("failed to prepare memblock FDT for KHO: %d\n", err);
 
 	return err;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

genalloch-fix-htmldocs-warning.patch
memblock-unpreserve-memory-in-case-of-error.patch

