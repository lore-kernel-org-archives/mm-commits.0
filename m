Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B241BDCF
	for <mm-commits@vger.kernel.org>; Sun, 30 Mar 2025 21:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743369822; cv=none; b=CeCqVyQZG0Y6apTRsYNRU+taiH739wDmKOU9dVrcg9VvGDLmhx6QuFYbs0gLp8e414rVdrOn/3UnShUluvFzUWCuDx1hGAjYG15DVoTehJMGLKBuWwkpa4gUBo2zqqKdWYqvYfRqc+as8B8wcs1THe7XMxDGz2uafz3yNRyTwYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743369822; c=relaxed/simple;
	bh=ooTphQvzogXgIxsZiS8CEn/+dMlyEMqp3yKmDtSfzmo=;
	h=Date:To:From:Subject:Message-Id; b=H6BAyZCMJS/D+UOYcSpc/0CrCuplmNg7qZpVxGoKYeNKojWWQwetZTsavy4/pvgQQTMLguUDxfrqaCtkApomwzD4/TFKXdPM3ZnZN2MAv3O7B7Nu9RpF/x3YcvoplH9gryV6+/1fRG0M2qrz48ItK0Ws/3Wc61qQt3qAdjiV9lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uQX+8t/f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uQX+8t/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF71C4CEDD;
	Sun, 30 Mar 2025 21:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743369821;
	bh=ooTphQvzogXgIxsZiS8CEn/+dMlyEMqp3yKmDtSfzmo=;
	h=Date:To:From:Subject:From;
	b=uQX+8t/fUitizVVH4frUJ7N4zHHdaJxwTfSOnZzpoGrUdP44CgvX/A5ZYoVRpVNjT
	 6GwyVUQ0LqQjmhpAPfILoZbYhs9ef4JOh9ac51Z32uxyV9wK+qaFEFHpXueknc/05Y
	 nH2z2gpPXHm2HCoqHzzOAue9vHT5EiZkUdbcjiGQ=
Date: Sun, 30 Mar 2025 14:23:40 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@Oracle.com,harry.yoo@oracle.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-do-not-set-vrm-vma-null-immediately-prior-to-checking-it.patch added to mm-unstable branch
Message-Id: <20250330212341.5CF71C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: do not set vrm->vma NULL immediately prior to checking it
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mremap-do-not-set-vrm-vma-null-immediately-prior-to-checking-it.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-do-not-set-vrm-vma-null-immediately-prior-to-checking-it.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/mremap: do not set vrm->vma NULL immediately prior to checking it
Date: Sun, 30 Mar 2025 17:20:48 +0100

This seems rather unwise.  If we cannot merge, extend, then we need to
recall the original VMA to see if we need to uncharge.

If we do need to, do so.

Link: https://lkml.kernel.org/r/b2fb6b9c-376d-4e9b-905e-26d847fd3865@lucifer.local
Fixes: d5c8aec0542e ("mm/mremap: initial refactor of move_vma()")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-=by: "Lai, Yi" <yi1.lai@linux.intel.com>
Closes: https://lore.kernel.org/linux-mm/Z+lcvEIHMLiKVR1i@ly-workstation/
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/mremap.c~mm-mremap-do-not-set-vrm-vma-null-immediately-prior-to-checking-it
+++ a/mm/mremap.c
@@ -1561,11 +1561,12 @@ static unsigned long expand_vma_in_place
 	 * adjacent to the expanded vma and otherwise
 	 * compatible.
 	 */
-	vma = vrm->vma = vma_merge_extend(&vmi, vma, vrm->delta);
+	vma = vma_merge_extend(&vmi, vma, vrm->delta);
 	if (!vma) {
 		vrm_uncharge(vrm);
 		return -ENOMEM;
 	}
+	vrm->vma = vma;
 
 	vrm_stat_account(vrm, vrm->delta);
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mremap-do-not-set-vrm-vma-null-immediately-prior-to-checking-it.patch

