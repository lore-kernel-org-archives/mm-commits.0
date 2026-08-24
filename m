Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB85D3FE671
	for <mm-commits@vger.kernel.org>; Mon, 24 Aug 2026 17:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787591545; cv=none; b=gURE/6tMGlod4SkK+fTVvcwxnjf3605xN8sy7cIp2QhB8XR6A7Q6DqGyIzq7z9z1vrRRfAAJEipKV5bSnMN0obfah7d4XV5W3gnMc1uVxoHQlo6WwfCtXo0tV1rnbE+jRYY0DaG+9ketPgrCWC4gok+ik4vIZFYaMK7HGTa//HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787591545; c=relaxed/simple;
	bh=PDc/7um4E4rhkAfsSNkh7i0mJk5AuQvxS+Ge6WrIS/g=;
	h=Date:To:From:Subject:Message-Id; b=ZlnDkklComzhvRrX6qrQpfAytWHhR40yubKQ7UaY6aAiYizztdL5LM7Fu++nc0yLNbhQD0YpNS3ahM2/uRZjaVBlQl70uCnCD5a3l9FiUZqcuG6uS+xMWW7c8y9imjybrtmPk+ZLrnsaatVxJtHgREOdQuWL6ctbWOTXV+thWPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rgFzxv6u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rgFzxv6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82FF41F000E9;
	Mon, 24 Aug 2026 17:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787591543;
	bh=vrNWxbj6QYbuoU3kcqotq7GnkgEP67xHWqeMwH+lTR0=;
	h=Date:To:From:Subject;
	b=rgFzxv6ueriDLi4BI6IysNJXrNc2PwkRyrHwAmXegnQ06YCCvrZO0p6OULtictgxH
	 T/s3zrvmUjDzDr6GrLo1iLpKCvHGj8MY7fBIEhfUgWrEYnZK3Dcr4dmJaiIEzWoTJZ
	 v1LCbqnP8ITv4jV/az1XBSR26fIgyT/hngd1Qy3Y=
Date: Mon, 24 Aug 2026 10:12:23 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,nico.pache@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-fix-outdated-comments-fix.patch added to mm-unstable branch
Message-Id: <20260824171223.82FF41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-khugepaged-fix-outdated-comments-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-fix-outdated-comments-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-fix-outdated-comments-fix.patch

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
From: Nico Pache (Red Hat) <nico.pache@linux.dev>
Subject: mm-khugepaged-fix-outdated-comments-fix
Date:   Fri Aug 21 04:27:28 2026 -0600

fix outdated comments

Link: https://lore.kernel.org/1c96e2f3-802f-472b-81e6-4af17a721a3c@linux.dev
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-fix-outdated-comments-fix
+++ a/mm/khugepaged.c
@@ -1753,9 +1753,9 @@ static enum scan_result collapse_scan_pm
 		/*
 		 * Check if the page has any GUP (or other external) pins.
 		 *
-		 * Here the check is racy, but such case is ephemeral and
-		 * we could always retry collapse later. Anyway the same
-		 * check will be done again later the risk seems low.
+		 * Here the check is racy, but such cases are ephemeral and
+		 * we can always retry collapse later. Anyway the same
+		 * check will be done again later, so the risk seems to be low.
 		 */
 		if (folio_expected_ref_count(folio) != folio_ref_count(folio)) {
 			result = SCAN_PAGE_COUNT;
_

Patches currently in -mm which might be from nico.pache@linux.dev are

mm-khugepaged-refactor-per-scan-state-clearing-into-collapse_control_init_scan.patch
mm-khugepaged-extract-reference-check-into-folio_pte_referenced-helper.patch
mm-khugepaged-extract-reference-check-into-folio_pte_referenced-helper-fix.patch
mm-khugepaged-introduce-a-count_collapse_event-helper.patch
mm-khugepaged-fix-outdated-comments.patch
mm-khugepaged-fix-outdated-comments-fix.patch
mm-khugepaged-unmap-pte-before-releasing-vma-write-lock.patch
mm-documentation-clarify-where-the-mthp-stats-live.patch

