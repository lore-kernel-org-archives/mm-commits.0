Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02231F463F
	for <mm-commits@vger.kernel.org>; Wed, 28 May 2025 22:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748472743; cv=none; b=JXSVrhMkZV+GPo4efVPwsGAQHyaGUfGlWeO8Dc/nXypA7GG1Hwc0cwwkkf0WEBuYieY1PIpjyKbT8PxTrAsa7KHqCQKLXRHccLmak4ot/tXB8A1ziRLhYSsGlZXkSdv30jw6m8TAMshIeE9VQdWjbyfwDNKkp1O38AzZdiqzNdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748472743; c=relaxed/simple;
	bh=FWw6xw2R0+q9LRsHBq2ytJV4/kSxzwC0x9l3RsVs1Vg=;
	h=Date:To:From:Subject:Message-Id; b=CBo/k3jhD+wsTwCkQ/PbDcqbqzyENY5dqmMmgWnmg0DvmvF7HJQnf+O4cH3LbDMqvc0eEbMncO1vwBJNK7fRptahS5rPUVHNHxZkPjQMF3qI/Ipr+KFZpZmBoDTVW6BnhwVXpP3N2R+f/HMMCJ59uI2nnCGheJUHxxXadXmXnx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PyQzYV9B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PyQzYV9B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B28C4CEE7;
	Wed, 28 May 2025 22:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748472742;
	bh=FWw6xw2R0+q9LRsHBq2ytJV4/kSxzwC0x9l3RsVs1Vg=;
	h=Date:To:From:Subject:From;
	b=PyQzYV9BM0tK4d+UzeOmVMvoae3RCb9CJglCH4h4ysqT6wHTLeghuTAWF0dtTIq84
	 yn9MrtKMBBjhJUGAqabowqK0BHe4RdCU4XAyP4qSXcflLnWdS4lI3Xbhfot2ofPa+g
	 lEHMKH3saWUPtw/OdH3ADMHkX2sZH+6pA7ZR6UOc=
Date: Wed, 28 May 2025 15:52:21 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-vma-add-missing-function-stub.patch added to mm-hotfixes-unstable branch
Message-Id: <20250528225222.90B28C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/vma: add missing function stub
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     tools-testing-vma-add-missing-function-stub.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-vma-add-missing-function-stub.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools/testing/vma: add missing function stub
Date: Wed, 28 May 2025 15:15:39 +0100

The hugetlb fix introduced in commit ee40c9920ac2 ("mm: fix copy_vma()
error handling for hugetlb mappings") mistakenly did not provide a stub
for the VMA userland testing, which results in a compile error when trying
to build this.

Provide this stub to resolve the issue.

Link: https://lkml.kernel.org/r/20250528-fix-vma-test-v1-1-c8a5f533b38f@oracle.com
Fixes: ee40c9920ac2 ("mm: fix copy_vma() error handling for hugetlb mappings")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by:  Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/vma_internal.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/testing/vma/vma_internal.h~tools-testing-vma-add-missing-function-stub
+++ a/tools/testing/vma/vma_internal.h
@@ -1242,4 +1242,9 @@ static inline int mapping_map_writable(s
 	return 0;
 }
 
+static inline void fixup_hugetlb_reservations(struct vm_area_struct *vma)
+{
+	(void)vma;
+}
+
 #endif	/* __MM_VMA_INTERNAL_H */
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

tools-testing-vma-add-missing-function-stub.patch

