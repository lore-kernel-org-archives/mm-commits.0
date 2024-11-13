Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4D917C225
	for <mm-commits@vger.kernel.org>; Wed, 13 Nov 2024 06:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731481166; cv=none; b=BZXZ6oN7ehT4l+8DeDq9ijEjpaEoNIgYTroCFGR19sWL5Dtql5Uq8o5QOL/GKnLRS1URTyNhjKqNxEf3hAdHm45m9lU0mOpj6bNKyALr0EXU8ijODFviR0qcBIg5A3NnZHl6/xJ0o9CJiLIRk0v9b+onYSC8J7hCYWhtG4oSy4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731481166; c=relaxed/simple;
	bh=wcHyE8P0/8PYxlI9lyAwTUV06OqeJIo1YpIVvblGweY=;
	h=Date:To:From:Subject:Message-Id; b=n8r3A0i7HbHxBxQwf2qZ/CySbJagqh+OYNn+U/PEWxkVZsYa0wNzAClReK6gAsqyiPPCwYAcxbJsVZbWD7XqHPrVpb2jhqisy2c4szFKnlfR+YSEOExW1zvAR6WA9wzKclbF8NhE/30yQ/iHirJ9n4QPpN1KtDiL8C5GFR7KZfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yGZPDhwH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yGZPDhwH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D523C4CED0;
	Wed, 13 Nov 2024 06:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731481166;
	bh=wcHyE8P0/8PYxlI9lyAwTUV06OqeJIo1YpIVvblGweY=;
	h=Date:To:From:Subject:From;
	b=yGZPDhwH3NDWDteyPMhvn1mUNPY5YpuOoLikwzUhZZOCVnVgu1wnCsM48EMdcPOcX
	 h84GeOjIPEKnH9i3hp4X94zV41XaxynYGWiiMgmxSeDxvTFXCuzkrpo4ilroURb8hF
	 MKzfZBmg7Vitr18qTBQUR3S5AIFkFKpRtbTY7U8Q=
Date: Tue, 12 Nov 2024 22:59:25 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,sourabhjain@linux.ibm.com,sachinpb@linux.ibm.com,mpe@ellerman.id.au,mahesh@linux.ibm.com,maddy@linux.ibm.com,kirill.shutemov@linux.intel.com,hbathini@linux.ibm.com,donettom@linux.vnet.ibm.com,david@redhat.com,anshuman.khandual@arm.com,aneesh.kumar@kernel.org,ritesh.list@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + cma-enforce-non-zero-pageblock_order-during-cma_init_reserved_mem.patch added to mm-unstable branch
Message-Id: <20241113065926.1D523C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: cma: Enforce non-zero pageblock_order during cma_init_reserved_mem()
has been added to the -mm mm-unstable branch.  Its filename is
     cma-enforce-non-zero-pageblock_order-during-cma_init_reserved_mem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cma-enforce-non-zero-pageblock_order-during-cma_init_reserved_mem.patch

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
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: cma: Enforce non-zero pageblock_order during cma_init_reserved_mem()
Date: Fri, 11 Oct 2024 20:26:09 +0530

cma_init_reserved_mem() checks base and size alignment with
CMA_MIN_ALIGNMENT_BYTES. However, some users might call this during
early boot when pageblock_order is 0. That means if base and size does
not have pageblock_order alignment, it can cause functional failures
during cma activate area.

So let's enforce pageblock_order to be non-zero during
cma_init_reserved_mem().

Link: https://lkml.kernel.org/r/054b416302486c2d3fdd5924b624477929100bf6.1728656994.git.ritesh.list@gmail.com
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Donet Tom <donettom@linux.vnet.ibm.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mahesh Salgaonkar <mahesh@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Sachin P Bappalige <sachinpb@linux.ibm.com>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/cma.c~cma-enforce-non-zero-pageblock_order-during-cma_init_reserved_mem
+++ a/mm/cma.c
@@ -181,6 +181,15 @@ int __init cma_init_reserved_mem(phys_ad
 	if (!size || !memblock_is_region_reserved(base, size))
 		return -EINVAL;
 
+	/*
+	 * CMA uses CMA_MIN_ALIGNMENT_BYTES as alignment requirement which
+	 * needs pageblock_order to be initialized. Let's enforce it.
+	 */
+	if (!pageblock_order) {
+		pr_err("pageblock_order not yet initialized. Called during early boot?\n");
+		return -EINVAL;
+	}
+
 	/* ensure minimal alignment required by mm core */
 	if (!IS_ALIGNED(base | size, CMA_MIN_ALIGNMENT_BYTES))
 		return -EINVAL;
_

Patches currently in -mm which might be from ritesh.list@gmail.com are

cma-enforce-non-zero-pageblock_order-during-cma_init_reserved_mem.patch

