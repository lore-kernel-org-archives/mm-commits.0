Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866D57E105
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 21:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758663044; cv=none; b=fn3nPrjxKEtlVZbt1h6myzEg2AbQFji/PFc0B25iEiuH5NNaRMh7KwzzBzAr1/VA68ZTmFEVif3r2vIuNVSxxvxi/JnJnpWrZo4uQIMLpbiQjGIMYjC5YyMQ6a6H35hPOPwaFJSfiqiXaqhaw0WuvEj3q70vEdZJgoaCeaxTZ6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758663044; c=relaxed/simple;
	bh=GpXJWdHsuLly7gInU7kls92XLvncPKL1Rh4KMNLDkGI=;
	h=Date:To:From:Subject:Message-Id; b=ZduwCQJXg4P1MqYoYKk448hQuXSHfsVDd4zBygzpGp0Z2VwUX5ovDaOYWe9Hd6GJX3OIvAUspqTRYad7HKdGYXsOIL5jimQlm4oZTYtHPLTaWJ5eunj75u7n6cgrw0FH1T2l+wwZpUBXx7LocHalZY+SzTZjhb630JNvdwPp9K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XWKT7YpQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XWKT7YpQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2139C4CEF5;
	Tue, 23 Sep 2025 21:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758663044;
	bh=GpXJWdHsuLly7gInU7kls92XLvncPKL1Rh4KMNLDkGI=;
	h=Date:To:From:Subject:From;
	b=XWKT7YpQ6CKnFuHlefC78hRldvwfRbxQP4xWG0sMjWkhRyGcNXYPTghS66eazpQ7w
	 IlaI18/me3gcqz96RdMIz3au+AT+BP4NR3NOtoS1Q1Ac3VPRAC+6yJW/jlq2vg+B/W
	 DYLeYNV9/gvzJVrSxioiSkxZ3RP/hlhK7F6K2R/o=
Date: Tue, 23 Sep 2025 14:30:43 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,kas@kernel.org,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-mlock-large-folios-in-try_to_unmap_one-fix.patch added to mm-unstable branch
Message-Id: <20250923213043.F2139C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-rmap-mlock-large-folios-in-try_to_unmap_one-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-mlock-large-folios-in-try_to_unmap_one-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-mlock-large-folios-in-try_to_unmap_one-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-rmap-mlock-large-folios-in-try_to_unmap_one-fix
Date: Tue Sep 23 02:28:52 PM PDT 2025

s/CROSSSED/CROSSED/

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/rmap.c~mm-rmap-mlock-large-folios-in-try_to_unmap_one-fix
+++ a/mm/rmap.c
@@ -1933,7 +1933,7 @@ static bool try_to_unmap_one(struct foli
 			 * If page table boundary has been cross, current ptl
 			 * only protect part of ptes.
 			 */
-			if (pvmw.flags & PVMW_PGTABLE_CROSSSED)
+			if (pvmw.flags & PVMW_PGTABLE_CROSSED)
 				goto walk_done;
 
 			/* Restore the mlock which got missed */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix.patch
mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary-fix.patch
mm-rmap-fix-a-mlock-race-condition-in-folio_referenced_one-fix.patch
mm-rmap-mlock-large-folios-in-try_to_unmap_one-fix.patch
mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch

