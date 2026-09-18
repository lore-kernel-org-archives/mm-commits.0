Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E94498915
	for <mm-commits@vger.kernel.org>; Fri, 18 Sep 2026 21:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789767098; cv=none; b=B7qpkF5HXLXt/JEpLw/9uU4Ojrqug7iV08pPHHcQwBllNIR5TrjGgAOfVuJGIwd0oApRudLz1197eFxYHFWzo0+sLMcQt9DOjlVsTD9K+k4QIEkxddpJRN70LgB3jskF/mnW/UaYuUOuaD/0Qdzb3QqcyLkSPwiD+coStbx1bTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789767098; c=relaxed/simple;
	bh=qzD66IZ2IrZe29wIWiWZyFQOoUFitRVeyjcSWRIDjUc=;
	h=Date:To:From:Subject:Message-Id; b=gpQlO8BClpO/dJu5I0sZnWZwUJTFxYndFy9ECObtW4MVSNYx+XHAmREs3iedtbjjJtbsrJg7DQW7jNO5y7rX3BojKDLwy7e0CCUWU0LQuMzAPtOgP07pqg5+m5MUdRz3qzDU6l0iYp8l+Yb+GIwD31+9XkNzdVHwzunpyocz/6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NAr2ZdwS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NAr2ZdwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4907C1F000FF;
	Fri, 18 Sep 2026 21:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789767097;
	bh=+2tncUiJUuNDkOSeZplLxBj2eXdg5s0lCaDLga9K9XA=;
	h=Date:To:From:Subject;
	b=NAr2ZdwSy28cxDbLX58/sLa7Jo+NRTU5m4JSP8nsAX+bCis2L52KGeo/tM5xDlnfn
	 LV5RkyUDgRjE4VdOjjkUzAIfAIGMCCxltgMFRwQs9ngwqDRqgtWLVqrhJW+fxs+nGZ
	 LOFIduUEsiJOi6Rhx5DvIK7+a4SimtHrw2Cv+1WY=
Date: Fri, 18 Sep 2026 14:31:36 -0700
To: mm-commits@vger.kernel.org,pfalcato@suse.de,ljs@kernel.org,david@kernel.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-constify-arguments-in-default-pxdp_get.patch added to mm-new branch
Message-Id: <20260918213137.4907C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: constify arguments in default pxdp_get()
has been added to the -mm mm-new branch.  Its filename is
     mm-constify-arguments-in-default-pxdp_get.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-constify-arguments-in-default-pxdp_get.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm: constify arguments in default pxdp_get()
Date: Fri, 18 Sep 2026 12:19:28 +0530

Generic MM default pxdp_get() helpers fetch the values contained in
pgtable entries via READ_ONCE() without modifying them.  Just make their
arguments explicitly 'const' for some additional protection.

Link: https://lore.kernel.org/20260918064928.793742-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: David Hildenbrand <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
---

 include/linux/pgtable.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/pgtable.h~mm-constify-arguments-in-default-pxdp_get
+++ a/include/linux/pgtable.h
@@ -490,35 +490,35 @@ static inline int pudp_set_access_flags(
 #endif
 
 #ifndef ptep_get
-static inline pte_t ptep_get(pte_t *ptep)
+static inline pte_t ptep_get(const pte_t *ptep)
 {
 	return READ_ONCE(*ptep);
 }
 #endif
 
 #ifndef pmdp_get
-static inline pmd_t pmdp_get(pmd_t *pmdp)
+static inline pmd_t pmdp_get(const pmd_t *pmdp)
 {
 	return READ_ONCE(*pmdp);
 }
 #endif
 
 #ifndef pudp_get
-static inline pud_t pudp_get(pud_t *pudp)
+static inline pud_t pudp_get(const pud_t *pudp)
 {
 	return READ_ONCE(*pudp);
 }
 #endif
 
 #ifndef p4dp_get
-static inline p4d_t p4dp_get(p4d_t *p4dp)
+static inline p4d_t p4dp_get(const p4d_t *p4dp)
 {
 	return READ_ONCE(*p4dp);
 }
 #endif
 
 #ifndef pgdp_get
-static inline pgd_t pgdp_get(pgd_t *pgdp)
+static inline pgd_t pgdp_get(const pgd_t *pgdp)
 {
 	return READ_ONCE(*pgdp);
 }
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-make-ptval_to_str-generally-available.patch
mm-stop-using-pxd_error.patch
loongarch-mm-stop-using-pte_error.patch
parisc-mm-directly-use-generic-_clear_bad.patch
sh-mm-stop-using-pte_error.patch
sh-mm-stop-using-_error.patch
sh-mm-stop-using-pgd_error.patch
mm-drop-pxd_error.patch
mm-constify-arguments-in-default-pxdp_get.patch

