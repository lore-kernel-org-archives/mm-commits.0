Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B5535A93B
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 21:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773091746; cv=none; b=Pdof0kvFnVRyS1vMhhiq0sM5hR+PK2MFoKSH1wUuSMxDxZNmcCj/P3J+3HYN5EQD8KEQ4c1WMeWmXiwErQMOVl+hNDa16xwkK651QnOFiiTo+xG8/eTHclieNh38SRJz1KRyrIVhPkICsIYgUwjDkNWUWZc4gEekT5sVWlVoWn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773091746; c=relaxed/simple;
	bh=jMcxqv8poBNUF54qM0kn5dAdTddeB7v65af811aixMc=;
	h=Date:To:From:Subject:Message-Id; b=dvUy3FzfvnSXgU58YlQOw6t01EwCLGp6PxUPp98J9W1gISLAYNlUxIIhcAd1YhQY493ExenTAeeA8+1akTPOAzJH2kJ8s8xV03Tc1nIMTh0qd1bmxOreX6/dzIMJSp1CCkbgOd5pWO/vjHg2zLe3oGxHOHT8M4q4N7jBh3q4CpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R63+7nhH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R63+7nhH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027EBC4CEF7;
	Mon,  9 Mar 2026 21:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773091746;
	bh=jMcxqv8poBNUF54qM0kn5dAdTddeB7v65af811aixMc=;
	h=Date:To:From:Subject:From;
	b=R63+7nhHeklbPGrkP0zM/ozkY5iLUG9E4gh5igiOF35UwnoOzfbea2sAsOhQXl2Og
	 GZS1XYRIrDXELGvhnjw8bBtWJVyyHQuRgyBviQ/q3d8iEbc4VSkgV50TRn75udmZ9T
	 VywYu4tKw3HhzJMCYdpqriScK+aNSfPHvmz+VFQg=
Date: Mon, 09 Mar 2026 14:29:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,npache@redhat.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate_device-document-folio_get-requirement-before-frozen-pmd-split.patch added to mm-unstable branch
Message-Id: <20260309212906.027EBC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate_device: document folio_get requirement before frozen PMD split
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate_device-document-folio_get-requirement-before-frozen-pmd-split.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate_device-document-folio_get-requirement-before-frozen-pmd-split.patch

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
From: Usama Arif <usama.arif@linux.dev>
Subject: mm/migrate_device: document folio_get requirement before frozen PMD split
Date: Mon, 9 Mar 2026 14:25:02 -0700

split_huge_pmd_address() with freeze=true splits a PMD migration entry
into PTE migration entries, consuming one folio reference in the process. 
The folio_get() before it provides this reference.

Add a comment explaining this relationship.  The expected folio refcount
at the start of migrate_vma_split_unmapped_folio() is 1.

Link: https://lkml.kernel.org/r/20260309212502.3922825-1-usama.arif@linux.dev
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Suggested-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Nico Pache <npache@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/migrate_device.c~mm-migrate_device-document-folio_get-requirement-before-frozen-pmd-split
+++ a/mm/migrate_device.c
@@ -908,6 +908,10 @@ static int migrate_vma_split_unmapped_fo
 	unsigned long flags;
 	int ret = 0;
 
+	/*
+	 * take a reference, since split_huge_pmd_address() with freeze = true
+	 * drops a reference at the end.
+	 */
 	folio_get(folio);
 	split_huge_pmd_address(migrate->vma, addr, true);
 	ret = folio_split_unmapped(folio, 0);
_

Patches currently in -mm which might be from usama.arif@linux.dev are

mm-migrate_device-document-folio_get-requirement-before-frozen-pmd-split.patch

