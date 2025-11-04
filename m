Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1B827979A
	for <mm-commits@vger.kernel.org>; Tue,  4 Nov 2025 03:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762226793; cv=none; b=X2cHEQXceWWELf3RTvcORPj8cUGnAriQ3h4SEsJ+2NPkdBniWwohyVe17JpJeJ5CD08oQfyf5gfuxa/pvoRX/1zlaEscnqGtYyvP+IqX3tLpxzaemVHre2MH5Hh60F3ElxxCuRa4YUPnnp1Bhekvx23QIIQbWdj6wSLNsTsg2+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762226793; c=relaxed/simple;
	bh=XPoyTFbi6l8ID0cz5Fuw7wNFlY7i93YR3epHju4KVt0=;
	h=Date:To:From:Subject:Message-Id; b=M4/jlZAcdS3jK/WY7O9XJTX7fBCCgPs+8Ozlrv5UKOgjHcRXhc14W6vAtGaOkQ0VMdypqy3mpSvnruznPxBEp/thiJ+Oi/F2YIYZ9pFQg/AdayaZAPuWUZx3abGW7604TWx8asH58rcoc7LnUlFEP9bDV95UzYZax1a6MEWlFpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MGQ8Kk+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MGQ8Kk+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364B1C113D0;
	Tue,  4 Nov 2025 03:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762226793;
	bh=XPoyTFbi6l8ID0cz5Fuw7wNFlY7i93YR3epHju4KVt0=;
	h=Date:To:From:Subject:From;
	b=MGQ8Kk+9lrta+isXCP7OF5QAGZWJxF/D+rjg2EsMZ+FGmej5hJq7JG5AR3A39y7H6
	 +mvBfLq97DXuYRQ44lIoaU7wWbzOs1oU6xrK8A/nO9w63U59xOO69vq8px54dyDYWr
	 FnhDYAk5sRQZ6xlahrVv0pUMTL7qnf/wPEw+biPM=
Date: Mon, 03 Nov 2025 19:26:32 -0800
To: mm-commits@vger.kernel.org,yanjun.zhu@linux.dev,tj@kernel.org,rppt@kernel.org,rdunlap@infradead.org,pratyush@kernel.org,pasha.tatashin@soleen.com,ojeda@kernel.org,masahiroy@kernel.org,jgg@ziepe.ca,jgg@nvidia.com,horms@kernel.org,graf@amazon.com,corbet@lwn.net,changyuanl@google.com,brauner@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memblock-unpreserve-memory-in-case-of-error-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20251104032633.364B1C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memblock-unpreserve-memory-in-case-of-error-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     memblock-unpreserve-memory-in-case-of-error-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memblock-unpreserve-memory-in-case-of-error-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
drivers-base-node-fold-register_node-into-register_one_node-fix.patch
mm-vmstat-fix-indentation-in-fold_diff-function-fix.patch
memcg-manually-uninline-__memcg_memory_event-fix.patch
mm-change-type-of-state-in-struct-memory_block-fix.patch
init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-fix.patch
panic-sys_info-factor-out-read-and-write-handlers-checkpatch-fixes.patch
lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_roundup-fix.patch
lib-add-mul_u64_add_u64_div_u64-and-mul_u64_u64_div_u64_roundup-fix-fix.patch
memblock-unpreserve-memory-in-case-of-error-fix.patch

