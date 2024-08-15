Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0066014A611
	for <mm-commits@vger.kernel.org>; Thu, 15 Aug 2024 22:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723761364; cv=none; b=fXj4krDIrjJG3DP+FhMN2MNeTAKfRNLALx2nbBAulQ5oDaCD9dgOK22X3Yj3lgY2rMvjqUP/KKibUyVjUfiaaL4B6P0v9m0SaWWEHW29CJwVrnh/Wq6IXQp5zKHK/7PROfXnmVxOUizYU1lm1i4HRG9sH5P1XJGJQAW4IfdQ3Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723761364; c=relaxed/simple;
	bh=sGZI/f7UMeVC7OptcYivp3uRkpyklsOiarBfK8wcNq8=;
	h=Date:To:From:Subject:Message-Id; b=RbuaZcNL7VPyKKsZj6wJYdVh58cvIpYX8sMFl8O8EQyspm99H8CKBcjAfjwS17GkGdIQvFDIiRVfbv+F9Gwqgodu6HaDapxu6p0oSxDSRSRJKigxvIu2rmYLysDuBeCUV1M/eNVRR1avK854lysZpFDImVGOCr3hL9TV4P8lPFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mzn75jvP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mzn75jvP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711D9C32786;
	Thu, 15 Aug 2024 22:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723761363;
	bh=sGZI/f7UMeVC7OptcYivp3uRkpyklsOiarBfK8wcNq8=;
	h=Date:To:From:Subject:From;
	b=Mzn75jvPmqXbj43ZszU0AAabZG7JnWZffd7QKppDeBdU/qmWsKwyF4FE50iF9sXwP
	 MJPLSSpVCJNysoWXtQIHpSYdnaE3bbY9Ln9yUX2NDsVH3kfAZhNDItEVtIM6uooux4
	 Op9jVxph75h/KL/x1i2WThikrfJR2M/DW1de9gHM=
Date: Thu, 15 Aug 2024 15:36:02 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,link@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp-fix.patch added to mm-unstable branch
Message-Id: <20240815223603.711D9C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: move the easily assessable conditions forward
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp-fix.patch

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
From: Huan Yang <link@vivo.com>
Subject: mm: move the easily assessable conditions forward
Date: Thu, 15 Aug 2024 16:31:01 +0800

Currently try_to_map_unused_to_zeropage() tries to use shared zero page to
save some memory of sub page.

If forbidding zeropage there is no need to do anything rather than
attempting to assess wthether to use it afterwards.

Link: https://lkml.kernel.org/r/20240815083102.653820-1-link@vivo.com
Signed-off-by: Huan Yang <link@vivo.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp-fix
+++ a/mm/migrate.c
@@ -192,6 +192,9 @@ static bool try_to_map_unused_to_zeropag
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(pte_present(*pvmw->pte), page);
 
+	if (mm_forbids_zeropage(pvmw->vma->vm_mm))
+		return false;
+
 	if (PageMlocked(page) || (pvmw->vma->vm_flags & VM_LOCKED))
 		return false;
 
@@ -204,7 +207,7 @@ static bool try_to_map_unused_to_zeropag
 	contains_data = memchr_inv(addr, 0, PAGE_SIZE);
 	kunmap_local(addr);
 
-	if (contains_data || mm_forbids_zeropage(pvmw->vma->vm_mm))
+	if (contains_data)
 		return false;
 
 	newpte = pte_mkspecial(pfn_pte(my_zero_pfn(pvmw->address),
_

Patches currently in -mm which might be from link@vivo.com are

mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp-fix.patch

