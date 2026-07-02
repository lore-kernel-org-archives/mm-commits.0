Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA6A431E5B
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 00:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782951341; cv=none; b=UERSkorr3Ix6PrxQLnGY4rb4m+Ad0FpK35ST+XI+Y3dEvjPr8rOWJg+0Y62KWYB5g+yLosBLPxcGd8ai72G/QWRdfo7ipmKN5dG3kdDOyLXRTXZJ/6Cz1sE/9qHUSn45fhB8oB/6/f7Y5qkoU/w3B3cKPkfp07jJY3rt5PN1aVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782951341; c=relaxed/simple;
	bh=3ugLIEeNrMGtZb6qpOxl9gGYdi3Odsv96jdC5BdVl+4=;
	h=Date:To:From:Subject:Message-Id; b=SyCGwk9G/hvAS+HXmkInNJUAJ1xxqGDbarqcv7utZw8is5/ilAFTrh0GGU81SAJnCxSDGJgtlytWzAUz3f1slikzikcy4V4S1kn8fJ6iIe6AHF6jpI9+dpogleGN1EMWAtqP5cnqJPFX3tjiprMeY64INDEKnSO/rL0s0m6iFRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CQMm1IPJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CQMm1IPJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A22E1F000E9;
	Thu,  2 Jul 2026 00:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782951340;
	bh=U5QvyvKgIi1f5OfmY/4VRohC0bBh9e/392UoiO53cn0=;
	h=Date:To:From:Subject;
	b=CQMm1IPJnbx8H+5nM2UiQcnq0vh40sDMqi07d3sVFO31qFz5JzXXcmvJBQg28SWqK
	 HKMW5KYpVTkd7rMu88YCx6wQ1Z2Cvgad2BRXWF5mg8ICBK2gJmaAPW3eglZF/F1+qT
	 Q2Lr6E1Fwb7D1rsv5gZrqj0yUBZOEzQ/4HNEkQ0E=
Date: Wed, 01 Jul 2026 17:15:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,rakie.kim@sk.com,mhocko@suse.com,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,jic23@kernel.org,gourry@gourry.net,dev.jain@arm.com,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-fix-stale-list-name-in-migrate_folios_move-comment.patch added to mm-unstable branch
Message-Id: <20260702001540.3A22E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate: fix stale list name in migrate_folios_move() comment
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-fix-stale-list-name-in-migrate_folios_move-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-fix-stale-list-name-in-migrate_folios_move-comment.patch

This patch will later appear in the mm-unstable branch at
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
From: Shivank Garg <shivankg@amd.com>
Subject: mm/migrate: fix stale list name in migrate_folios_move() comment
Date: Wed, 1 Jul 2026 05:17:21 +0000

The return-value description in migrate_folios_move() still refers to
unmap_folios, but that list no longer exists.  Update this name to
src_folios.

Link: https://lore.kernel.org/20260701-migrate-cleanups-prep-v2-2-d9e8f17130b1@amd.com
Signed-off-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-fix-stale-list-name-in-migrate_folios_move-comment
+++ a/mm/migrate.c
@@ -1739,7 +1739,7 @@ static void migrate_folios_move(struct l
 		/*
 		 * The rules are:
 		 *	0: folio will be freed
-		 *	-EAGAIN: stay on the unmap_folios list
+		 *	-EAGAIN: stay on the src_folios list
 		 *	Other errno: put on ret_folios list
 		 */
 		switch (rc) {
_

Patches currently in -mm which might be from shivankg@amd.com are

mm-migrate-rename-page-to-folio-leftovers.patch
mm-migrate-fix-stale-list-name-in-migrate_folios_move-comment.patch
mm-migrate-use-migrate_info-field-instead-of-private.patch

