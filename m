Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5A133F8DA;
	Sat, 28 Feb 2026 19:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772307188; cv=none; b=H0Tp5oJsTIQ2yg6nyhhRW9Dl9+4DptnjL/CEDE5JlRLovbSaLsSkYr6Moe0976WO8fWOFe3eBMi3Dil73Fvk1CiEYi6LTur5emeQ7v520u/JDSYZ3sYvSZvQff6VUrX7IsLZKQd30USwKvJA6dJ/mqS0SF9lFs+KodRLULndz/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772307188; c=relaxed/simple;
	bh=DCOqyvKSn75Oz0wmRxY7e71iW8eEcTFv7hqiQsOwmQo=;
	h=Date:To:From:Subject:Message-Id; b=qDhmzHKThmpmn6D3TO0yz7c137dlHwrqgJyV13gHFWLebxlNbICn2QTkGshusAM4SZIGumc3SiQua0njw5qYtnNQk9WvkVvtHrqQ9LQXdjVQdTxPjUc6nNC3OTTuDe2W6J8wKgg/OSFiMNAU4eWEpawX8t8RiWLLrFbFUjgpdvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZrGJKGTK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZrGJKGTK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F68C116D0;
	Sat, 28 Feb 2026 19:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772307188;
	bh=DCOqyvKSn75Oz0wmRxY7e71iW8eEcTFv7hqiQsOwmQo=;
	h=Date:To:From:Subject:From;
	b=ZrGJKGTKTWQfZubafWWSxJyR7TwC3Z3Qff6aI6flKlkwDy7XoRmuu9OEYoXK1hp55
	 gYyjML8/biMJrQ/9wvLCd8qLm9dkKpgtZ7oOkEJgIFJTG14LDw+TMN+PRQfcAgMTWy
	 asDZFIVG/+02LdqRHX/P1A4dNe98aIktOwagyfcA=
Date: Sat, 28 Feb 2026 11:33:07 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,hughd@google.com,dev.jain@arm.com,david@kernel.org,bas@dfinity.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-fix-a-folio_split-race-condition-with-folio_try_get.patch added to mm-hotfixes-unstable branch
Message-Id: <20260228193307.E3F68C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: fix a folio_split() race condition with folio_try_get()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-huge_memory-fix-a-folio_split-race-condition-with-folio_try_get.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-fix-a-folio_split-race-condition-with-folio_try_get.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: fix a folio_split() race condition with folio_try_get()
Date: Fri, 27 Feb 2026 20:06:14 -0500

During a pagecache folio split, the values in the related xarray should
not be changed from the original folio at xarray split time until all
after-split folios are well formed and stored in the xarray.  Current use
of xas_try_split() in __split_unmapped_folio() lets some after-split
folios show up at wrong indices in the xarray.  When these misplaced
after-split folios are unfrozen, before correct folios are stored via
__xa_store(), and grabbed by folio_try_get(), they are returned to
userspace at wrong file indices, causing data corruption.

Fix it by using the original folio in xas_try_split() calls, so that
folio_try_get() can get the right after-split folios after the original
folio is unfrozen.

Uniform split, split_huge_page*(), is not affected, since it uses
xas_split_alloc() and xas_split() only once and stores the original folio
in the xarray.

Fixes below points to the commit introduces the code, but folio_split() is
used in a later commit 7460b470a131f ("mm/truncate: use folio_split() in
truncate operation").

Link: https://lkml.kernel.org/r/20260228010614.2536430-1-ziy@nvidia.com
Fixes: 00527733d0dc8 ("mm/huge_memory: add two new (not yet used) functions for folio_split()")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: Bas van Dijk <bas@dfinity.org>
Closes: https://lore.kernel.org/all/CAKNNEtw5_kZomhkugedKMPOG-sxs5Q5OLumWJdiWXv+C9Yct0w@mail.gmail.com/
Tested-by: Lance Yang <lance.yang@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-a-folio_split-race-condition-with-folio_try_get
+++ a/mm/huge_memory.c
@@ -3631,6 +3631,7 @@ static int __split_unmapped_folio(struct
 	const bool is_anon = folio_test_anon(folio);
 	int old_order = folio_order(folio);
 	int start_order = split_type == SPLIT_TYPE_UNIFORM ? new_order : old_order - 1;
+	struct folio *origin_folio = folio;
 	int split_order;
 
 	/*
@@ -3656,7 +3657,13 @@ static int __split_unmapped_folio(struct
 				xas_split(xas, folio, old_order);
 			else {
 				xas_set_order(xas, folio->index, split_order);
-				xas_try_split(xas, folio, old_order);
+				/*
+				 * use the original folio, so that a parallel
+				 * folio_try_get() waits on it until xarray is
+				 * updated with after-split folios and
+				 * the original one is unfrozen.
+				 */
+				xas_try_split(xas, origin_folio, old_order);
 				if (xas_error(xas))
 					return xas_error(xas);
 			}
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-cma-move-put_page_testzero-out-of-vm_warn_on-in-cma_release.patch
mm-huge_memory-fix-a-folio_split-race-condition-with-folio_try_get.patch

