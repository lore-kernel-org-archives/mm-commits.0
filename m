Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447EF262FD3
	for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2025 23:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756423056; cv=none; b=HmIMcec6EfrFmPtquFeRVlC+/YBxKLOZMvJv5VmP8ryPtgKIpsVXEZ9KhAPaipsCw1EFD8Fd9R/Wt8bhgEtqjfvebVLG3kPLiRqLLspApze37SW+scGP4QRu6sJ9JGwAz7qOYYXn8PSUueSxEWsFByacX1IL/pWQurCGGW2aBqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756423056; c=relaxed/simple;
	bh=v8vP0+4cHKhRzImmTwnzHG2EV0U39Yw25LdiNbH2b2U=;
	h=Date:To:From:Subject:Message-Id; b=IIWGaD2fV2wISgIsSHAPVUOTu1ewq+AxeHfHGTd8Zywqe7qgz8Et8ou7P90CMrJEvYlQQuawu4F1dsG+WfkipaTTmNpOd1g1aYa2ImQUaBg6ph0BOLBeh2okOfFQW/lBPgEoPWECPOMIkmOfGacKUMLV8rZjakkfw1hUZCquiQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o4sZLmDe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o4sZLmDe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C8FC4CEEB;
	Thu, 28 Aug 2025 23:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756423055;
	bh=v8vP0+4cHKhRzImmTwnzHG2EV0U39Yw25LdiNbH2b2U=;
	h=Date:To:From:Subject:From;
	b=o4sZLmDegjeKo8jqTYgn0dfB35osdxvectWwe+OTQ0lVguuk5jLTTM4s4qB5EUzPT
	 pEfZbuZsnHQhbuiUN6S1QGNhcdRCEbHjj/B3M0kAJJkeBFZ7fpL6xe+FaKqxGzcRwd
	 3OLaVugECUam3t7ncp5sElpo3VXZo489jEaEoANg=
Date: Thu, 28 Aug 2025 16:17:35 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jannh@google.com,cmllamas@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-fix-regression-in-vrm-new_addr-check.patch added to mm-hotfixes-unstable branch
Message-Id: <20250828231735.B2C8FC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: fix regression in vrm->new_addr check
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mremap-fix-regression-in-vrm-new_addr-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-fix-regression-in-vrm-new_addr-check.patch

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
From: Carlos Llamas <cmllamas@google.com>
Subject: mm/mremap: fix regression in vrm->new_addr check
Date: Thu, 28 Aug 2025 14:26:56 +0000

Commit 3215eaceca87 ("mm/mremap: refactor initial parameter sanity
checks") moved the sanity check for vrm->new_addr from mremap_to() to
check_mremap_params().

However, this caused a regression as vrm->new_addr is now checked even
when MREMAP_FIXED and MREMAP_DONTUNMAP flags are not specified.  In this
case, vrm->new_addr can be garbage and create unexpected failures.

Fix this by moving the new_addr check after the vrm_implies_new_addr()
guard.  This ensures that the new_addr is only checked when the user has
specified one explicitly.

Link: https://lkml.kernel.org/r/20250828142657.770502-1-cmllamas@google.com
Fixes: 3215eaceca87 ("mm/mremap: refactor initial parameter sanity checks")
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/mremap.c~mm-mremap-fix-regression-in-vrm-new_addr-check
+++ a/mm/mremap.c
@@ -1774,15 +1774,18 @@ static unsigned long check_mremap_params
 	if (!vrm->new_len)
 		return -EINVAL;
 
-	/* Is the new length or address silly? */
-	if (vrm->new_len > TASK_SIZE ||
-	    vrm->new_addr > TASK_SIZE - vrm->new_len)
+	/* Is the new length silly? */
+	if (vrm->new_len > TASK_SIZE)
 		return -EINVAL;
 
 	/* Remainder of checks are for cases with specific new_addr. */
 	if (!vrm_implies_new_addr(vrm))
 		return 0;
 
+	/* Is the new address silly? */
+	if (vrm->new_addr > TASK_SIZE - vrm->new_len)
+		return -EINVAL;
+
 	/* The new address must be page-aligned. */
 	if (offset_in_page(vrm->new_addr))
 		return -EINVAL;
_

Patches currently in -mm which might be from cmllamas@google.com are

mm-mremap-fix-regression-in-vrm-new_addr-check.patch

