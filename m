Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BFB37474C
	for <mm-commits@vger.kernel.org>; Mon, 23 Feb 2026 20:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771877537; cv=none; b=B8du/RgWapW3FF49CmIt1aKm0QWV2rmeEzrMCq87dC2a4WHQ+hc8zu4nI2Ul6M3VPljH2a0Xe2C6lIbasqKm1WeAru9t1+cm3BeEZexkput49QSb0eJVVVTRZt4Qqqz9beVHtk6dDfBLgN3Z7SygyWBwSv8V+aOWZhSLNt4NXBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771877537; c=relaxed/simple;
	bh=03jUB21huD9WXALJGJv0bSZYCb+998/0dA32FF25SE0=;
	h=Date:To:From:Subject:Message-Id; b=Nk/ZxZ4nLn/4vA0HgrRyO4M/BN/2x0SLTMDECJx34GosawVODCziJubH6U9ZAo5ogFa1GjfUuOzhIGx/THFR3FFPKILKB34Gpq5MJCaSdB9lCzsrQZC55g/QmJKRtX6JeKTubAx+6fBr0zo7qWZy12k+LZUF7i7isEDrC475SHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ILIhgFN2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ILIhgFN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63AE7C19421;
	Mon, 23 Feb 2026 20:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771877536;
	bh=03jUB21huD9WXALJGJv0bSZYCb+998/0dA32FF25SE0=;
	h=Date:To:From:Subject:From;
	b=ILIhgFN2xXXA9QZ5uTQ7EnfFgahdsPnRuoEdIY6GnxxMONTI2cM+7kxAZxUskJqCn
	 3AIfBjqGXDJB0G77D15DJx22mMuF0p2W8FO5YmBpM1+29sqCKcJxQEGtICED4gh+GA
	 0A4qx6CGgHOWKObej9wbhF+mo4yGeQpZ7c0cRNMA=
Date: Mon, 23 Feb 2026 12:12:15 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix.patch added to mm-unstable branch
Message-Id: <20260223201216.63AE7C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix
Date: Mon Feb 23 12:09:18 PM PST 2026

update comment per Matthew and David

Cc: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/internal.h~mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix
+++ a/mm/internal.h
@@ -521,10 +521,10 @@ void pmd_install(struct mm_struct *mm, p
  * @mm: The mm_struct.
  * @pmdp: Pointer to the pmd that was found to be pmd_none().
  *
- * When we stumble over a pmd_none() without holding the PTL while unmapping a
- * folio that could have been mapped at that PMD, it could be that concurrent
- * zapping of the PMD is not complete yet. While the PMD might be pmd_none()
- * already, the folio might still appear to be mapped (folio_mapped()).
+ * When we find a pmd_none() while unmapping a folio without holding the PTL,
+ * zap_huge_pmd() may have cleared the PMD but not yet modified the folio to
+ * indicate that it's unmapped. Skipping the PMD without synchronization could
+ * make folio unmapping code assume that unmapping failed.
  *
  * Wait for concurrent zapping to complete by grabbing the PTL.
  */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
maple_tree-add-cp_is_new_root-helper-fix-fix.patch
lib-introduce-hierarchical-per-cpu-counters-fix.patch
mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix.patch
kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch

