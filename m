Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5420321ABBD
	for <mm-commits@vger.kernel.org>; Sat,  7 Jun 2025 23:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749338811; cv=none; b=niJmvu7dIOcRNASngIJfhMTEEI9AynigyeHYJ59r2eVhkDARsGU/GrqMVHB62ztR9U8z2gYjsxluC3iSiEDQr25zpvzdmmFs5tdk//9YN44Vb0IQEyhhk66cZSnHfmxyp+TIDrcM9PJxLorIDeXEG0RRlyL9Yam0HOWX8vrnVqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749338811; c=relaxed/simple;
	bh=/WUsqoML8teJjEYO1y3NcuYZ4/ivasGCWRNJeGUBttw=;
	h=Date:To:From:Subject:Message-Id; b=sAX+fLzAunRggF6Bvn/1z3oRmYQQCERvOZr85u1z9pbOubKu5d0H3wD6qVaDAQKeHmQBl5ZZdAirpspdnkN5j1eI6N87FzrFf4zuef7gBAe/OYLQZdcn7wOsCLY5nSEoi/2ArREAHQVxfoUeX4xq3ZpsI/Aq0IYdc9M9bJKIVpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pCLxtXSR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pCLxtXSR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0709AC4CEE4;
	Sat,  7 Jun 2025 23:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749338811;
	bh=/WUsqoML8teJjEYO1y3NcuYZ4/ivasGCWRNJeGUBttw=;
	h=Date:To:From:Subject:From;
	b=pCLxtXSR3X864o5Zw4szrCyV09R2XLT2/VEhTxZYFgIOHU2ZzlWim8CLS0Nvb/ocq
	 Y5o+43awCMeRF3vkyGn6LdfT+63jP/q0j8/tHFqcihUlWaLeDw+gtpKtl2PB69Xf4m
	 XrVmZb1xRcLfWSck95mhcp8vlDAhCJqXbKUbLGnA=
Date: Sat, 07 Jun 2025 16:26:50 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jhubbard@nvidia.com,jgg@ziepe.ca,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-remove-vm_bug_ons-fix.patch added to mm-new branch
Message-Id: <20250607232651.0709AC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-gup-remove-vm_bug_ons-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-gup-remove-vm_bug_ons-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-remove-vm_bug_ons-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: David Hildenbrand <david@redhat.com>
Subject: mm-gup-remove-vm_bug_ons-fix
Date: Fri, 6 Jun 2025 10:08:20 +0200

use the _FOLIO variant where possible, per Lorenzo


Link: https://lkml.kernel.org/r/844bd929-a551-48e3-a12e-285cd65ba580@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c~mm-gup-remove-vm_bug_ons-fix
+++ a/mm/gup.c
@@ -64,7 +64,7 @@ static inline void sanity_check_pinned_p
 		    !folio_test_anon(folio))
 			continue;
 		if (!folio_test_large(folio) || folio_test_hugetlb(folio))
-			VM_WARN_ON_ONCE_PAGE(!PageAnonExclusive(&folio->page), page);
+			VM_WARN_ON_ONCE_FOLIO(!PageAnonExclusive(&folio->page), folio);
 		else
 			/* Either a PTE-mapped or a PMD-mapped THP. */
 			VM_WARN_ON_ONCE_PAGE(!PageAnonExclusive(&folio->page) &&
_

Patches currently in -mm which might be from david@redhat.com are

mm-gup-remove-vm_bug_ons.patch
mm-gup-remove-vm_bug_ons-fix.patch

