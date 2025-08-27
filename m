Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83D4258EF5
	for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2025 02:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756263398; cv=none; b=ZdONMgwaFitJlKy4/cB18Qty5jDtHJYTuJ8IvQVHFMr5jzQbx+XEl4E6umEdA4EisL1tUi2WeiGO8EW85Pe7xH4rvAmkaD1ub1710ID6u2h+zfW5+w41zLEM7ZV8FvuSxXEFckvZxoNuCZpWVLR4ISqR0rh9bFZ7Rh2Kjl1jv4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756263398; c=relaxed/simple;
	bh=Aocf9B+mnwICPflOzmhA8DpHXu8N/C4i3eeVxFphQZg=;
	h=Date:To:From:Subject:Message-Id; b=UFDnwwX/MWBkPCgiP6+PdAj7TgVbKL8630r7zBAlbx4c+OjlERgHuFPfGi5knmEq43WAjydKwZr/AVu+8/IHe7okjZSqrC/elDo4ADdsR3ZGkK2PWWjMzhxsDA5Q3y3Bdo3EMDNjGDg7dYVJErDIXK3RMqlahtukoDi8rT+tHv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0glQWRp+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0glQWRp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F57C4CEF1;
	Wed, 27 Aug 2025 02:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756263397;
	bh=Aocf9B+mnwICPflOzmhA8DpHXu8N/C4i3eeVxFphQZg=;
	h=Date:To:From:Subject:From;
	b=0glQWRp+O2ddnG2WH0WyVScyKf2e4ati/6R8MEAPpOdg0m+UipbAtO2N5KJDBKFdG
	 p7zb+v4v0a3tcvE11/l7969G5OtztlKK8nXtEEQLk+pYS6KSNloxR/m9j9byI0hg3B
	 NWOCvKtxePauV0dkAlNRrAErltHDF/4wHOOapXHU=
Date: Tue, 26 Aug 2025 19:56:36 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-fix-the-address-passed-to-notifier-on-testing-young-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20250827025637.54F57C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-khugepaged-fix-the-address-passed-to-notifier-on-testing-young-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-khugepaged-fix-the-address-passed-to-notifier-on-testing-young-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-fix-the-address-passed-to-notifier-on-testing-young-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-khugepaged-fix-the-address-passed-to-notifier-on-testing-young-fix
Date: Tue Aug 26 07:55:56 PM PDT 2025

fix whitespace, per everyone

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-fix-the-address-passed-to-notifier-on-testing-young-fix
+++ a/mm/khugepaged.c
@@ -1417,8 +1417,8 @@ static int hpage_collapse_scan_pmd(struc
 		 */
 		if (cc->is_khugepaged &&
 		    (pte_young(pteval) || folio_test_young(folio) ||
-		     folio_test_referenced(folio) || mmu_notifier_test_young(vma->vm_mm,
-								     _address)))
+		     folio_test_referenced(folio) ||
+		     mmu_notifier_test_young(vma->vm_mm, _address)))
 			referenced++;
 	}
 	if (!writable) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-khugepaged-fix-the-address-passed-to-notifier-on-testing-young-fix.patch
mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix.patch
mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix-fix.patch
mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors-fix.patch
memcg-optimize-exit-to-user-space-fix.patch

