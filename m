Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C97715D5B6
	for <mm-commits@vger.kernel.org>; Sun, 26 Oct 2025 04:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761453832; cv=none; b=DBCqntMFNvEvjknH0pcTKa696AHfmIn64vlyXs7jB1JL8j+MwuUWNhk3YQDj24TY7CifkShEd2DdeCFEJ3Hxg+ZAg3BCVV+rY+kdBT9W99+FXIghBpFji1acS7ffIRE7xsq9/MZqLl2WQlvhnSvBZcXOJwGyysc6O/cgFzUixKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761453832; c=relaxed/simple;
	bh=SoaUngh9ngt1YJ1iO5HsSgbj4RnLiParLVQl5+WrEAg=;
	h=Date:To:From:Subject:Message-Id; b=moPVO2u10IN/fBWJZTAUx/iHR7sjgvHkUPSRbMihjpLdytF2Jmoh5F8/xQmkbDFMI1SJyq/XfxD6coVYQpvqPtYUDOlLELc5H5MU1cp3a+L+mQMyyvSxOFuxSM+rpa1Mz3EX4+xm3IeUINz9OFNVHRVy8Pd+KX6sbvXaLk+dmJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lqRd/OWJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lqRd/OWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12A1C4CEE7;
	Sun, 26 Oct 2025 04:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761453832;
	bh=SoaUngh9ngt1YJ1iO5HsSgbj4RnLiParLVQl5+WrEAg=;
	h=Date:To:From:Subject:From;
	b=lqRd/OWJfkH2rl1initfVnYu9D6issaborw25YULYhrWDI4wgBLtArBap6TLiTrIb
	 guXaLf5zJJAlFOQDIifYgIgpstt0DpqlBsTnbAwu9LnWQafWmHJSWBnVRnxsiHCafL
	 y6PvKTBTkmC2oSvfNhu0QxnlbVjyHkig7FEjcy4M=
Date: Sat, 25 Oct 2025 21:43:51 -0700
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,david@redhat.com,catalin.marinas@arm.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-debug_vm_pgtable-add-_mkwrite_novma-tests-v3.patch added to mm-unstable branch
Message-Id: <20251026044351.F12A1C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-debug_vm_pgtable-add-_mkwrite_novma-tests-v3
has been added to the -mm mm-unstable branch.  Its filename is
     mm-debug_vm_pgtable-add-_mkwrite_novma-tests-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-debug_vm_pgtable-add-_mkwrite_novma-tests-v3.patch

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
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm-debug_vm_pgtable-add-_mkwrite_novma-tests-v3
Date: Fri, 24 Oct 2025 02:31:37 +0100

add a new test combination per Huang Ying

Link: https://lkml.kernel.org/r/20251024013137.136926-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-add-_mkwrite_novma-tests-v3
+++ a/mm/debug_vm_pgtable.c
@@ -202,6 +202,7 @@ static void __init pmd_basic_tests(struc
 	WARN_ON(pmd_dirty(pmd_wrprotect(pmd_mkclean(pmd))));
 	WARN_ON(!pmd_dirty(pmd_wrprotect(pmd_mkdirty(pmd))));
 
+	WARN_ON(!pmd_dirty(pmd_mkwrite_novma(pmd_mkdirty(pmd))));
 	WARN_ON(pmd_dirty(pmd_mkwrite_novma(pmd_mkclean(pmd))));
 	WARN_ON(!pmd_write(pmd_mkdirty(pmd_mkwrite_novma(pmd))));
 	WARN_ON(!pmd_write(pmd_mkwrite_novma(pmd_wrprotect(pmd))));
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-thp-drop-follow_devmap_pmd-default-stub.patch
mm-ptdump-replace-read_once-with-standard-page-table-accessors.patch
mm-replace-read_once-with-standard-page-table-accessors.patch
mm-dirty-replace-read_once-with-pudp_get.patch
mm-debug_vm_pgtable-add-_mkwrite_novma-tests.patch
mm-debug_vm_pgtable-add-_mkwrite_novma-tests-v3.patch

