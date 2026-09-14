Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE63B1A9FA0
	for <mm-commits@vger.kernel.org>; Mon, 14 Sep 2026 02:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789353880; cv=none; b=jOh8Lvoa46iwl9Kr+8gp17AGsSFedhTI4K2fg2Bzhmtky2pnWppYOd9OGb7KAV4dLOurZsQRooU2qeSoT38DIOzhnJy8qVDhImGEVQRiF7IStAJvKr3iypDA6rr7JRm0N3OzxfX0As+6scSE2OpXlxsyh/3Rtt7QXdieb3nlHoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789353880; c=relaxed/simple;
	bh=SUGERVMuuZQ2FcO4v22iq62FYyIL6BotA4kj6IuE040=;
	h=Date:To:From:Subject:Message-Id; b=hJ+gyS0WA6gP/bkxE5HEpSJTaj11JT76PV0sOkJzXSK2OQf9ZSes1HPG35gZ2RIGyeuQCpt4K+QK+PD9uhDWgFWaBne8fvY1nBJnWjPhiB8bet3/tiQXWJLbCIckr24ozL4EzZKuZJ3vTsU+y9Cr7rRL5Hn7Efx3LVNlglH01JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fZNtg70r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fZNtg70r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47B4F1F000FF;
	Mon, 14 Sep 2026 02:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789353879;
	bh=1mUD0VCV9vBgAsh1MlTuYOBDD7vRgKlApfW6RAgkCjI=;
	h=Date:To:From:Subject;
	b=fZNtg70reCsHPt3zcwd1sNlZAuROPOLHRwSDFZu8ujEM8Vaw76fH3atlo1ZwAb5d6
	 GrFvjgjZD7XIC4ofGwMOseF1Oro0jfqnBP0KLTLQJ4sdEVpLaLjKzYYkMYnudfitbV
	 PhSqOG4UkC70pdsFdsyZGZOFOTezKSmSQlIIBH+g=
Date: Sun, 13 Sep 2026 19:44:38 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,hughd@google.com,dev.jain@arm.com,david@kernel.org,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-ignore-sysfs-configs-for-shmem-forced-collapse.patch added to mm-hotfixes-unstable branch
Message-Id: <20260914024439.47B4F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: ignore sysfs configs for shmem forced collapse
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shmem-ignore-sysfs-configs-for-shmem-forced-collapse.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-ignore-sysfs-configs-for-shmem-forced-collapse.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: ignore sysfs configs for shmem forced collapse
Date: Mon, 14 Sep 2026 10:12:41 +0800

According to Documentation/mm/transhuge.rst, MADV_COLLAPSE is expected to
ignore any THP or mTHP interface settings.

However, after commit 26c7d8413aaf ("mm: thp: support "THPeligible"
semantics for mTHP with anonymous shmem"), performing MADV_COLLAPSE on
shmem will depend on /sys/.../hugepages-2048kB/shmem_enabled being set to
"inherit" (although that is the default), which can cause MADV_COLLAPSE to
fail unexpectedly.

Fix this by returning the result of shmem_huge_global_enabled() directly
when MADV_COLLAPSE is requested, allowing PMD-order collapse while
ignoring shmem THP/mTHP settings.

Link: https://lore.kernel.org/063f655b4d6c4234f3aa27ed6ecab10283ecb880.1789351825.git.baolin.wang@linux.alibaba.com
Fixes: 26c7d8413aaf ("mm: thp: support "THPeligible" semantics for mTHP with anonymous shmem")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Closes: https://lore.kernel.org/all/20260908125105.1510704-7-kirill@shutemov.name/
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
---

 mm/shmem.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-ignore-sysfs-configs-for-shmem-forced-collapse
+++ a/mm/shmem.c
@@ -1847,8 +1847,11 @@ unsigned long shmem_allowable_huge_order
 
 	global_orders = shmem_huge_global_enabled(inode, index, write_end,
 						  shmem_huge_force, vma, vm_flags);
-	/* Tmpfs huge pages allocation */
-	if (!vma || !vma_is_anon_shmem(vma))
+	/*
+	 * Tmpfs huge pages allocation or forced collapse ignores
+	 * sysfs configs.
+	 */
+	if (!vma || !vma_is_anon_shmem(vma) || shmem_huge_force)
 		return global_orders;
 
 	/*
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

maintainers-add-baoquan-and-me-as-mglru-reviewers.patch
mm-shmem-ignore-sysfs-configs-for-shmem-forced-collapse.patch
mm-mglru-clear-the-reference-counter-for-rejected-folios.patch

