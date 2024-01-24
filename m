Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B00718C1A
	for <mm-commits@vger.kernel.org>; Wed, 24 Jan 2024 10:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706091458; cv=none; b=JnNh0fFSkYc1KDPuJcXDvDNEzxUAu8bgG40Q29Kf/Me1rBthMwpjLPg3NVmsePbpP3t6e8WksxUMKFrRg/OOXzgXxJ6Ii3hCrhy6qfb8utq4oprCKvJkgJAYD3kB7j224Mj2BVQfpvCVhIPYy1VMeMVUR+RDj9NrJ8KLDK6S+Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706091458; c=relaxed/simple;
	bh=sUk4XivHUpUZEdjlq71XMJsEBwPmgz5Yx1+JqNJ8o2A=;
	h=Date:To:From:Subject:Message-Id; b=JrU3v0sHhQ7DEPURsLVFxQCoKR0cAYcsgnqWmaj+5L12F69CtWf74uqZPyJfphslqgHveKWEgTGF/7oIFOs9ch6+vlKOecCD0Fxl6n5ymVqQwjc7K3k9sC1dK+x9SCCU6u++KAK4+7EkYGP7YfGJsultouMVpJhpPd+Ot55Yek4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F0aHEIVX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F0aHEIVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAFEAC43390;
	Wed, 24 Jan 2024 10:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706091458;
	bh=sUk4XivHUpUZEdjlq71XMJsEBwPmgz5Yx1+JqNJ8o2A=;
	h=Date:To:From:Subject:From;
	b=F0aHEIVXOXkgg3CjI/zUdspZSK0sU2UiJfMQFwKBVN1BQFpDIm/t7iCeNkGYbH0b1
	 PGGBF6Kh0BKIUUyHY4I+/LQ33Nt4jknr+D1rZ1dp8km66aB3alYW/eEHmd2nKycwyk
	 GLF9YsRzd8iAMngs/iNfHzwJQTWii+8wdg+/wBuE=
Date: Wed, 24 Jan 2024 02:17:35 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,aarcange@redhat.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-uffdio_move-implementation-should-use-ptep_get.patch added to mm-hotfixes-unstable branch
Message-Id: <20240124101737.EAFEAC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/userfaultfd: UFFDIO_MOVE implementation should use ptep_get()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-userfaultfd-uffdio_move-implementation-should-use-ptep_get.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-uffdio_move-implementation-should-use-ptep_get.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm/userfaultfd: UFFDIO_MOVE implementation should use ptep_get()
Date: Tue, 23 Jan 2024 14:17:55 +0000

Commit c33c794828f2 ("mm: ptep_get() conversion") converted all (non-arch)
call sites to use ptep_get() instead of doing a direct dereference of the
pte.  Full rationale can be found in that commit's log.

Since then, UFFDIO_MOVE has been implemented which does 7 direct pte
dereferences.  Let's fix those up to use ptep_get().

I've asserted in the past that there is no reliable automated mechanism to
catch these; I'm relying on a combination of Coccinelle (which throws up a
lot of false positives) and some compiler magic to force a compiler error
on dereference.  But given the frequency with which new issues are coming
up, I'll add it to my todo list to try to find an automated solution.

Link: https://lkml.kernel.org/r/20240123141755.3836179-1-ryan.roberts@arm.com
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/userfaultfd.c~mm-userfaultfd-uffdio_move-implementation-should-use-ptep_get
+++ a/mm/userfaultfd.c
@@ -902,8 +902,8 @@ static int move_present_pte(struct mm_st
 
 	double_pt_lock(dst_ptl, src_ptl);
 
-	if (!pte_same(*src_pte, orig_src_pte) ||
-	    !pte_same(*dst_pte, orig_dst_pte)) {
+	if (!pte_same(ptep_get(src_pte), orig_src_pte) ||
+	    !pte_same(ptep_get(dst_pte), orig_dst_pte)) {
 		err = -EAGAIN;
 		goto out;
 	}
@@ -946,8 +946,8 @@ static int move_swap_pte(struct mm_struc
 
 	double_pt_lock(dst_ptl, src_ptl);
 
-	if (!pte_same(*src_pte, orig_src_pte) ||
-	    !pte_same(*dst_pte, orig_dst_pte)) {
+	if (!pte_same(ptep_get(src_pte), orig_src_pte) ||
+	    !pte_same(ptep_get(dst_pte), orig_dst_pte)) {
 		double_pt_unlock(dst_ptl, src_ptl);
 		return -EAGAIN;
 	}
@@ -1016,7 +1016,7 @@ retry:
 	}
 
 	spin_lock(dst_ptl);
-	orig_dst_pte = *dst_pte;
+	orig_dst_pte = ptep_get(dst_pte);
 	spin_unlock(dst_ptl);
 	if (!pte_none(orig_dst_pte)) {
 		err = -EEXIST;
@@ -1024,7 +1024,7 @@ retry:
 	}
 
 	spin_lock(src_ptl);
-	orig_src_pte = *src_pte;
+	orig_src_pte = ptep_get(src_pte);
 	spin_unlock(src_ptl);
 	if (pte_none(orig_src_pte)) {
 		if (!(mode & UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES))
@@ -1054,7 +1054,7 @@ retry:
 			 * page isn't freed under us
 			 */
 			spin_lock(src_ptl);
-			if (!pte_same(orig_src_pte, *src_pte)) {
+			if (!pte_same(orig_src_pte, ptep_get(src_pte))) {
 				spin_unlock(src_ptl);
 				err = -EAGAIN;
 				goto out;
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

selftests-mm-ksm_tests-should-only-madv_hugepage-valid-memory.patch
mm-thp_get_unmapped_area-must-honour-topdown-preference.patch
mm-userfaultfd-uffdio_move-implementation-should-use-ptep_get.patch
tools-mm-add-thpmaps-script-to-dump-thp-usage-info.patch

