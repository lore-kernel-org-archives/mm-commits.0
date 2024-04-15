Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462BE15686C
	for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2024 20:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713212945; cv=none; b=UmVWE6c9xdcB/cTe8WBiBImPM+xQ1NSPzEyMAAk8J48l7YrNto9OstyvPwM8QQYgUEeRWz2UDs1nkvPLZdU5mnW9yBLARQouslaL1vTK/u6vE81wKusMY2WIuNRwmKAFMW1hWkfaKzlRujn09aNvDUNgVWgaUkrBedC9MGdJ95o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713212945; c=relaxed/simple;
	bh=MB7Uf+LviHegN21BYhWvFzjob12Wc92gMH/u4nt39RY=;
	h=Date:To:From:Subject:Message-Id; b=dCiO8BRmUJr1XaNT3qRAJ6Fc0PMHgI3z1e5rva+4lgwBEK9yGKR/w26yL1hsPu/8zUILp+YL24e/phzjAH7M41vfZwRDrga8CzB6hJbhMQIq9ggplcQDgbqayT5Aq70CB8Sy29oFQKEMOxz401Ap/MFDXkTimXtKoRwdzFvBd1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=swppZkEH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="swppZkEH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8AAAC113CC;
	Mon, 15 Apr 2024 20:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713212945;
	bh=MB7Uf+LviHegN21BYhWvFzjob12Wc92gMH/u4nt39RY=;
	h=Date:To:From:Subject:From;
	b=swppZkEH5v2+3E6UzS3TUu24I4pcAJWLGHndz0Yn02UfyVYOUVHEM4+5KB9vjJ7kw
	 DQKkw+uCA7aH51sf7i6DiMjvfbXTWMR3YgGyXN/Ax8udLzCzuUh0K1Hq6p/0p9HbyD
	 3ddsjibfwgMFaKZfWDHm1Y6YWWE4RwvqktYahXzY=
Date: Mon, 15 Apr 2024 13:29:04 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-dissolve_free_huge_pages-to-folios-fix.patch added to mm-unstable branch
Message-Id: <20240415202904.E8AAAC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-hugetlb-convert-dissolve_free_huge_pages-to-folios-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-dissolve_free_huge_pages-to-folios-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-dissolve_free_huge_pages-to-folios-fix.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm-hugetlb-convert-dissolve_free_huge_pages-to-folios-fix
Date: Mon, 15 Apr 2024 12:14:09 -0700

remove unneeded `extern'

Link: https://lkml.kernel.org/r/71760ed4-e80d-493a-95ea-2545414b1aba@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reported-by: Vishal Moola <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-convert-dissolve_free_huge_pages-to-folios-fix
+++ a/include/linux/hugetlb.h
@@ -861,7 +861,7 @@ static inline int hstate_index(struct hs
 	return h - hstates;
 }
 
-extern int dissolve_free_hugetlb_folio(struct folio *folio);
+int dissolve_free_hugetlb_folio(struct folio *folio);
 extern int dissolve_free_huge_pages(unsigned long start_pfn,
 				    unsigned long end_pfn);
 
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-hugetlb-convert-dissolve_free_huge_pages-to-folios.patch
mm-hugetlb-convert-dissolve_free_huge_pages-to-folios-fix.patch
mm-hugetlb-convert-dissolve_free_huge_pages-to-folios-v2.patch
mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios.patch

