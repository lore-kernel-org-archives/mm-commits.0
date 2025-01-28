Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EDE29CF0
	for <mm-commits@vger.kernel.org>; Tue, 28 Jan 2025 01:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738026104; cv=none; b=W/C0loYfQV0yTguo2Uws9qGO0FSkm6B2j56g2Q28WP7tI+91vc+c1sKWkMNKERV+NsZFHSMheTCqNd6YXyF68WwS+5mGQ5ODKrrq0yEevuk5G9OKw8KXX/X6DdBHRo40DOA7ydBUSYhFhFfQueH1OBhMfQGoEkASXrg1QpsQ3jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738026104; c=relaxed/simple;
	bh=s6jSOC4lG1KFEuw9N9jBkWf8XdY+v6HY2Shj34JYJWo=;
	h=Date:To:From:Subject:Message-Id; b=AHccG2athOQ5XRJA8hRVbOGMeN6z8LM/ROqQDZ8/bNuldNxWhLU2mbvUyv8Nipj6+Ep3MZoSgdCOK3HFGseAIWGf/BA6zyZQIXogZN5hSBWc+Axo7D3YRTHKWsMiNXn6lF9ahOUlmiZvrLdPhKW3+uqZcTyqQ/7wXeAIDGUIx7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FOYojEXW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FOYojEXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61E2C4CED2;
	Tue, 28 Jan 2025 01:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738026103;
	bh=s6jSOC4lG1KFEuw9N9jBkWf8XdY+v6HY2Shj34JYJWo=;
	h=Date:To:From:Subject:From;
	b=FOYojEXW2D0TA4BmR6Aj6lfej+axgC1cq/3PtSLwJrMSz+wFVHOgwMicDSw/sEnLa
	 WWsrsdf+CHL4FELgjBzttpL0F0lS1OilzbWRrLem/rfDmBzEZ0eeRwJAoxmRkIzjI0
	 spI0FaJIF8PAqqqOEKXXImAX4Ft+Tkkg+1PHGWjA=
Date: Mon, 27 Jan 2025 17:01:43 -0800
To: mm-commits@vger.kernel.org,jglisse@redhat.com,jgg@nvidia.com,sooraj20636@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hmm-prevent-infinite-loop-in-hmm_range_fault-during-ebusy-retries.patch added to mm-hotfixes-unstable branch
Message-Id: <20250128010143.D61E2C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hmm: prevent infinite loop in hmm_range_fault during EBUSY retries
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hmm-prevent-infinite-loop-in-hmm_range_fault-during-ebusy-retries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hmm-prevent-infinite-loop-in-hmm_range_fault-during-ebusy-retries.patch

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
From: sooraj <sooraj20636@gmail.com>
Subject: mm/hmm: prevent infinite loop in hmm_range_fault during EBUSY retries
Date: Tue, 28 Jan 2025 01:34:22 -0500

When hmm_vma_walk_test() skips a VMA (e.g., unsupported VM_IO/PFNMAP
range), it must update hmm_vma_walk->last to the end of the skipped VMA. 
Failing to do so causes hmm_range_fault() to restart from the same address
during -EBUSY retries, reprocessing the skipped VMA indefinitely.  This
results in an infinite loop if the VMA remains non-processable.

Update hmm_vma_walk->last to the VMA's end address in hmm_vma_walk_test()
when skipping the range.  This ensures subsequent iterations resume
correctly after the skipped VMA, preventing infinite retry loops.

Link: https://lkml.kernel.org/r/20250128063422.7604-1-sooraj20636@gmail.com
Signed-off-by: sooraj <sooraj20636@gmail.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hmm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/hmm.c~mm-hmm-prevent-infinite-loop-in-hmm_range_fault-during-ebusy-retries
+++ a/mm/hmm.c
@@ -547,6 +547,8 @@ static int hmm_vma_walk_test(unsigned lo
 
 	hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
 
+	/* Update last to the end of the skipped VMA to prevent reprocessing */
+	hmm_vma_walk->last = end;
 	/* Skip this vma and continue processing the next vma. */
 	return 1;
 }
_

Patches currently in -mm which might be from sooraj20636@gmail.com are

mm-hmm-prevent-infinite-loop-in-hmm_range_fault-during-ebusy-retries.patch

