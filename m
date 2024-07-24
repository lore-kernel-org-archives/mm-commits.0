Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E641514F6
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 19:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721850920; cv=none; b=ZZedzPhlwJnFOSWZJsCcXlO4XjJ0LPht9b0s3PsuDExPpIWoNiZ/lt5tV5Cp8nzDn7IsqqwU+CGi7e3i4rhTA2t7q9nWcLiI0ePon+ADzRNDTrXZGP1QNM3rEKTQPs/byP9YHZtnuEg/PGsZHW77eFPeghPl9TCsiez972TlyY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721850920; c=relaxed/simple;
	bh=jhMyAF0wp9SQwToDzPlYcO4Erk9DrkB8ssBTNa2P2zg=;
	h=Date:To:From:Subject:Message-Id; b=ecCe41O/oNePVc3xQ8dPcK177pFAuFY3lJ+T9FbKgVh/BqowSoXfjIgQgZ8xCNQCGk4iCnIXw+sWvUcmRL5PTJqH0mVlW3+6eArAt5fpIeg5mJv3tz9wiXLP93c6NBjXOqbimBJDRgE5uBt670VLBKBDcvY3Tfjo/U2gucTiR/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kqSKCBQy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kqSKCBQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE31C32786;
	Wed, 24 Jul 2024 19:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721850919;
	bh=jhMyAF0wp9SQwToDzPlYcO4Erk9DrkB8ssBTNa2P2zg=;
	h=Date:To:From:Subject:From;
	b=kqSKCBQyHZeXqAVpgRpnW9T3Q/sxZF8pn8UKnrZ95zM3Z6HYYrwjQbXpwY9uaSVqc
	 UNJTUO1pjkQLuO4JzioGg3LI0uPCfKhKbJTEMOJqL2OVW/Wpd4tYOK6MPqkKH60em/
	 fZwGZ/O5bIellSIu9o1hlrEbFrgoqZOPaHmfoZnA=
Date: Wed, 24 Jul 2024 12:55:19 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,baohua@kernel.org,justinjiang@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shrink-skip-folio-mapped-by-an-exiting-process.patch added to mm-unstable branch
Message-Id: <20240724195519.8AE31C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shrink skip folio mapped by an exiting process
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shrink-skip-folio-mapped-by-an-exiting-process.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrink-skip-folio-mapped-by-an-exiting-process.patch

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
From: Zhiguo Jiang <justinjiang@vivo.com>
Subject: mm: shrink skip folio mapped by an exiting process
Date: Wed, 10 Jul 2024 16:36:41 +0800

The releasing process of the non-shared anonymous folio mapped solely by
an exiting process may go through two flows: 1) the anonymous folio is
firstly is swaped-out into swapspace and transformed into a swp_entry in
shrink_folio_list; 2) then the swp_entry is released in the process
exiting flow.  This will result in the high cpu load of releasing a
non-shared anonymous folio mapped solely by an exiting process.

When the low system memory and the exiting process exist at the same time,
it will be likely to happen, because the non-shared anonymous folio mapped
solely by an exiting process may be reclaimed by shrink_folio_list.

This patch is that shrink skips the non-shared anonymous folio solely
mapped by an exting process and this folio is only released directly in
the process exiting flow, which will save swap-out time and alleviate the
load of the process exiting.

Link: https://lkml.kernel.org/r/20240710083641.546-1-justinjiang@vivo.com
Signed-off-by: Zhiguo Jiang <justinjiang@vivo.com>
Acked-by: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c   |   15 +++++++++++++++
 mm/vmscan.c |    7 ++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

--- a/mm/rmap.c~mm-shrink-skip-folio-mapped-by-an-exiting-process
+++ a/mm/rmap.c
@@ -75,6 +75,7 @@
 #include <linux/memremap.h>
 #include <linux/userfaultfd_k.h>
 #include <linux/mm_inline.h>
+#include <linux/oom.h>
 
 #include <asm/tlbflush.h>
 
@@ -870,6 +871,20 @@ static bool folio_referenced_one(struct
 			continue;
 		}
 
+		/*
+		 * Skip the non-shared swapbacked folio mapped solely by
+		 * the exiting or OOM-reaped process. This avoids redundant
+		 * swap-out followed by an immediate unmap.
+		 */
+		if ((!atomic_read(&vma->vm_mm->mm_users) ||
+		    check_stable_address_space(vma->vm_mm)) &&
+		    folio_test_anon(folio) && folio_test_swapbacked(folio) &&
+		    !folio_likely_mapped_shared(folio)) {
+			pra->referenced = -1;
+			page_vma_mapped_walk_done(&pvmw);
+			return false;
+		}
+
 		if (pvmw.pte) {
 			if (lru_gen_enabled() &&
 			    pte_young(ptep_get(pvmw.pte))) {
--- a/mm/vmscan.c~mm-shrink-skip-folio-mapped-by-an-exiting-process
+++ a/mm/vmscan.c
@@ -863,7 +863,12 @@ static enum folio_references folio_check
 	if (vm_flags & VM_LOCKED)
 		return FOLIOREF_ACTIVATE;
 
-	/* rmap lock contention: rotate */
+	/*
+	 * There are two cases to consider.
+	 * 1) Rmap lock contention: rotate.
+	 * 2) Skip the non-shared swapbacked folio mapped solely by
+	 *    the exiting or OOM-reaped process.
+	 */
 	if (referenced_ptes == -1)
 		return FOLIOREF_KEEP;
 
_

Patches currently in -mm which might be from justinjiang@vivo.com are

mm-shrink-skip-folio-mapped-by-an-exiting-process.patch

