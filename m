Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4C425228D
	for <mm-commits@vger.kernel.org>; Sat, 24 Jan 2026 03:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769223766; cv=none; b=sHAcATpbpSuFGz+Nvzb/BtHF7VFWERtF+QqnN6/qFiXNQY8YB5TC1ufXC2wbGF02HRpZfVJL5G+zLYrPHobWrKQBHXthLtyDESCyAxFVQCCFt3mG3zri/t0ZLs+eldphdOKdHOOtjCHvstE+jHOzvfS0HTZGyBcZZp7jlWkgyDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769223766; c=relaxed/simple;
	bh=yhcP+ryFANy5fjUwVXYhTjf+3Or1qNmWhiUh6tWKLj8=;
	h=Date:To:From:Subject:Message-Id; b=ayuDyAmOC3EcBNF+soUn6XwiVv9+mks7Z6dCFLR91oelcw8fWuR9O+dNjXCfqjCOEGGK9Z9mhvPWOQFF0e6dOJAv5wtVd3Dx4jb6FwFu443fR/fmbG0Iifv1MbNImMASWbONfOD4VdQy4sm55pX2RvF3BiaIpdxDL7KBYn99f3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o8duQ8Pr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o8duQ8Pr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36D1C19421;
	Sat, 24 Jan 2026 03:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769223765;
	bh=yhcP+ryFANy5fjUwVXYhTjf+3Or1qNmWhiUh6tWKLj8=;
	h=Date:To:From:Subject:From;
	b=o8duQ8PrYvLfQ9oMOruKTz74p9pU2U+/zRsYbkZ2eAKeuj/9LmycvrKmDdJwedsae
	 AUnBBDO6sq8KEssOmYMfJLUU9Gv6d0X3zX05XMr3AhU/DVr7WB44p1JsNn0jyrAklC
	 y2dLd03CT2b9Wl5YeEi6F/kt5wv9CKPzQcfiW0JM=
Date: Fri, 23 Jan 2026 19:02:45 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,anshuman.khandual@arm.com,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-make-khugepaged_collapse_control-static.patch added to mm-unstable branch
Message-Id: <20260124030245.A36D1C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: make khugepaged_collapse_control static
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-make-khugepaged_collapse_control-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-make-khugepaged_collapse_control-static.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Shivank Garg <shivankg@amd.com>
Subject: mm/khugepaged: make khugepaged_collapse_control static
Date: Sun, 18 Jan 2026 19:23:01 +0000

The global variable 'khugepaged_collapse_control' is not used outside of
mm/khugepaged.c.  Make it static to limit its scope.

Link: https://lkml.kernel.org/r/20260118192253.9263-14-shivankg@amd.com
Signed-off-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-make-khugepaged_collapse_control-static
+++ a/mm/khugepaged.c
@@ -827,7 +827,7 @@ static void khugepaged_alloc_sleep(void)
 	remove_wait_queue(&khugepaged_wait, &wait);
 }
 
-struct collapse_control khugepaged_collapse_control = {
+static struct collapse_control khugepaged_collapse_control = {
 	.is_khugepaged = true,
 };
 
_

Patches currently in -mm which might be from shivankg@amd.com are

mm-khugepaged-map-dirty-writeback-pages-failures-to-eagain.patch
mm-khugepaged-retry-with-sync-writeback-for-madv_collapse.patch
mm-khugepaged-remove-unnecessary-goto-skip-label.patch
mm-khugepaged-change-collapse_pte_mapped_thp-to-return-void.patch
mm-khugepaged-use-enum-scan_result-for-result-variables-and-return-types.patch
mm-khugepaged-make-khugepaged_collapse_control-static.patch

