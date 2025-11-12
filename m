Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F48D17C77
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762906485; cv=none; b=B38KBW41NnvjNFDT2RL1nmqCCF42ioA9mRh1IW7J/uoavuBp16wQmOARPpScu7VjqTBK/FRJdmksiwrHSBeq5txXuZnxYYzKaZE17qUFfwpy2cbCWGio/HN7+G23dttuCdxyXXTjRjJzqt9h+1F+obb0yCoYKJbXEIhwyOji/DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762906485; c=relaxed/simple;
	bh=ZawTEIbzmQscBtC8QplH4OP0OO3cMfbBExWKjgfkHx0=;
	h=Date:To:From:Subject:Message-Id; b=EZRE1z5KU2UIaliLa6ZFc5b+g+mHghhhOVGxKxLIcZSHbCW8kdIT7Ae+nd0jnvki7Ha94z7ARg2EG2aPWY5AthQvKX8+svlmp60IIDOpG9WtvyMMcDShcZgDXCw0n9ke32fRj63h9zuoC6346JuQkV3krlCf3O0/BYQLu20qb6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yRb/ahev; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yRb/ahev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E617C113D0;
	Wed, 12 Nov 2025 00:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762906485;
	bh=ZawTEIbzmQscBtC8QplH4OP0OO3cMfbBExWKjgfkHx0=;
	h=Date:To:From:Subject:From;
	b=yRb/ahevI14xSokerfeC16O+3PfR/dqNxo2nFTOLxpMAzSBdIkGOAZOfNfwH6Trjt
	 6zIh0hbSMriyaPJ9BqKjje5binmpPgHq4JJgaL3mMvZjZnanU4Wgvs04hQqvsiMk1e
	 l//nq7v8U0rFLdEF3NwP/SIvmHeiLCFJLdvDvarA=
Date: Tue, 11 Nov 2025 16:14:44 -0800
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,david@redhat.com,catalin.marinas@arm.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-debug_vm_pgtable-add-_mkwrite_novma-tests-v3.patch removed from -mm tree
Message-Id: <20251112001445.2E617C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-debug_vm_pgtable-add-_mkwrite_novma-tests-v3
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-add-_mkwrite_novma-tests-v3.patch

This patch was dropped because it was folded into mm-debug_vm_pgtable-add-_mkwrite_novma-tests.patch

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
mm-make-invalid_phys_addr-a-generic-macro.patch

