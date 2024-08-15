Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB6A24211
	for <mm-commits@vger.kernel.org>; Thu, 15 Aug 2024 22:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723759907; cv=none; b=n9v0b6OxWLnT1yR3P3AHhU6pBnwbRoiutN4US2qC8v2GYmXHkq+9+OhCnZCTSb0ysZAkqcdtRcnaskfc8YH2ZE0aWkaRS2FVWUoSORfH0ObdIWg3k2oh5CpIxHuLNr/XYwBW/DbWrlePU2CU6YbJs+0KnkgDz2gNrDkwXS/xX88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723759907; c=relaxed/simple;
	bh=dR73n4yQoplCpC7QHd4PUqXup/nFZLCFlJqssDajaMQ=;
	h=Date:To:From:Subject:Message-Id; b=N9/ChypVHVW/kkdVRLCP/+0+CAgZerGv5fNJwQNvzA9Xe9EqLQQq1VGywGb1Azzl1BEG8oUrLHCoqfTDJeB7S1S1eraLj4iY5IAogI/9cAxEzem2gvs0EJ7ZmSQ/PZ9/A/xHCv+lhzDhdLT6gRX2YCOVeuJDhK2xm8+yC3wIHoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WJtIwb4i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WJtIwb4i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9910EC32786;
	Thu, 15 Aug 2024 22:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723759906;
	bh=dR73n4yQoplCpC7QHd4PUqXup/nFZLCFlJqssDajaMQ=;
	h=Date:To:From:Subject:From;
	b=WJtIwb4iUKnkUJ0rCPSfHl33+wJB3HkHfF1pq7xIH5zotbLLAkneFXYyJwE98t+/a
	 OhHmAXDD6D4WeYz2N14u8nOsztcKlnoFkytzyS/ZiNKcdFMbcd5QGNZJDvPeRA/dnm
	 9B6YcM53ceu9NNuUoN9xAh4XQeCZ5gMm420TAACk=
Date: Thu, 15 Aug 2024 15:11:45 -0700
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-free-zapped-tail-pages-when-splitting-isolated-thp-fix.patch added to mm-unstable branch
Message-Id: <20240815221146.9910EC32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-free-zapped-tail-pages-when-splitting-isolated-thp-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-free-zapped-tail-pages-when-splitting-isolated-thp-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-free-zapped-tail-pages-when-splitting-isolated-thp-fix.patch

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
From: Usama Arif <usamaarif642@gmail.com>
Subject: mm-free-zapped-tail-pages-when-splitting-isolated-thp-fix
Date: Thu, 15 Aug 2024 20:16:56 +0100

fix bug going from v1 page version to the folio version of the patch in v3

Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Reported-by: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-free-zapped-tail-pages-when-splitting-isolated-thp-fix
+++ a/mm/huge_memory.c
@@ -3152,7 +3152,7 @@ static void __split_huge_page(struct pag
 
 			folio_clear_active(new_folio);
 			folio_clear_unevictable(new_folio);
-			if (!folio_batch_add(&free_folios, folio)) {
+			if (!folio_batch_add(&free_folios, new_folio)) {
 				mem_cgroup_uncharge_folios(&free_folios);
 				free_unref_folios(&free_folios);
 			}
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

mm-free-zapped-tail-pages-when-splitting-isolated-thp-fix.patch
mm-introduce-a-pageflag-for-partially-mapped-folios.patch
mm-introduce-a-pageflag-for-partially-mapped-folios-fix.patch
mm-split-underutilized-thps.patch
mm-add-sysfs-entry-to-disable-splitting-underutilized-thps.patch

