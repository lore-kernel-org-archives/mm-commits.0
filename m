Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A7A2F363B
	for <mm-commits@vger.kernel.org>; Wed, 22 Oct 2025 21:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761168421; cv=none; b=uSbuwT1IHOdt1N2MF3Huu0Vx1FcUx9yWdbJzcEKQ96Tl2C+8S4sHD/PerUZJAlN+mbHsvmmM1RtGlFFiV/DKLEYXlzV1VQ1wxol9OOIdQ+nvvq07hhUpKGMeFmVAKXqxMTIbt3N6b6pZ6+G8ITBVUJD3qr6VhMlSx+jqkwXFDaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761168421; c=relaxed/simple;
	bh=UhceWK4RiXawM7xuOhWPzNYEHozU0iU36ndUIpVlIiQ=;
	h=Date:To:From:Subject:Message-Id; b=NiryQYurVuDXFdZTLsU1HkrY0ZlE+c77JKwv3QkuHU17GeWSKM6h7KXl+Ar5yWjrpeUUGb5+cCFR2tFaNDOdzNinpqQhqL1J55b0ETUVbFefOP64D0FWPBwthLGV3TXPbhYOdqELXyb1OnjFPJzQXBysk5DJoznZhl/vKqRApIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gR5xEBoD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gR5xEBoD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A7CC4CEE7;
	Wed, 22 Oct 2025 21:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761168420;
	bh=UhceWK4RiXawM7xuOhWPzNYEHozU0iU36ndUIpVlIiQ=;
	h=Date:To:From:Subject:From;
	b=gR5xEBoDZhFegjhgFi2LUUk1+UrVp9DUvSro/vfJt/308VDDA8+9eWoVDkCnZM+AC
	 nnjVOhfLjY99p5fmXU0pMtcBqb8nffWcyrUMxDVZyh0BX613JAF3WAm35wTDoDSl6v
	 lloqLTB8B73RFECg6wbfKNZJC7KM2LhJzdmT85Rs=
Date: Wed, 22 Oct 2025 14:26:59 -0700
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,david@redhat.com,catalin.marinas@arm.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-debug_vm_pgtable-add-_mkwrite_novma-tests.patch added to mm-new branch
Message-Id: <20251022212700.70A7CC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/debug_vm_pgtable: add [pte|pmd]_mkwrite_novma() tests
has been added to the -mm mm-new branch.  Its filename is
     mm-debug_vm_pgtable-add-_mkwrite_novma-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-debug_vm_pgtable-add-_mkwrite_novma-tests.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/debug_vm_pgtable: add [pte|pmd]_mkwrite_novma() tests
Date: Wed, 22 Oct 2025 04:29:51 +0100

Add some [pte|pmd]_mkwrite_novma() relevant tests.

Link: https://lkml.kernel.org/r/20251022032951.3498553-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@linux.alibaba.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-add-_mkwrite_novma-tests
+++ a/mm/debug_vm_pgtable.c
@@ -102,6 +102,12 @@ static void __init pte_basic_tests(struc
 	WARN_ON(pte_write(pte_wrprotect(pte_mkwrite(pte, args->vma))));
 	WARN_ON(pte_dirty(pte_wrprotect(pte_mkclean(pte))));
 	WARN_ON(!pte_dirty(pte_wrprotect(pte_mkdirty(pte))));
+
+	WARN_ON(!pte_dirty(pte_mkwrite_novma(pte_mkdirty(pte))));
+	WARN_ON(pte_dirty(pte_mkwrite_novma(pte_mkclean(pte))));
+	WARN_ON(!pte_write(pte_mkdirty(pte_mkwrite_novma(pte))));
+	WARN_ON(!pte_write(pte_mkwrite_novma(pte_wrprotect(pte))));
+	WARN_ON(pte_write(pte_wrprotect(pte_mkwrite_novma(pte))));
 }
 
 static void __init pte_advanced_tests(struct pgtable_debug_args *args)
@@ -195,6 +201,12 @@ static void __init pmd_basic_tests(struc
 	WARN_ON(pmd_write(pmd_wrprotect(pmd_mkwrite(pmd, args->vma))));
 	WARN_ON(pmd_dirty(pmd_wrprotect(pmd_mkclean(pmd))));
 	WARN_ON(!pmd_dirty(pmd_wrprotect(pmd_mkdirty(pmd))));
+
+	WARN_ON(pmd_dirty(pmd_mkwrite_novma(pmd_mkclean(pmd))));
+	WARN_ON(!pmd_write(pmd_mkdirty(pmd_mkwrite_novma(pmd))));
+	WARN_ON(!pmd_write(pmd_mkwrite_novma(pmd_wrprotect(pmd))));
+	WARN_ON(pmd_write(pmd_wrprotect(pmd_mkwrite_novma(pmd))));
+
 	/*
 	 * A huge page does not point to next level page table
 	 * entry. Hence this must qualify as pmd_bad().
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-thp-drop-follow_devmap_pmd-default-stub.patch
mm-ptdump-replace-read_once-with-standard-page-table-accessors.patch
mm-replace-read_once-with-standard-page-table-accessors.patch
mm-dirty-replace-read_once-with-pudp_get.patch
mm-debug_vm_pgtable-add-_mkwrite_novma-tests.patch

