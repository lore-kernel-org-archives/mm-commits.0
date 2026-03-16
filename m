Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813311A9FAF
	for <mm-commits@vger.kernel.org>; Mon, 16 Mar 2026 17:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773682950; cv=none; b=HHfqzp4vpG3HU4AJIxFOvNZVEGO3lbLlM+rD7DtPoFMhESmJQcajOIhkgPzyBp4z9dwTi2HxwdsRX53sHlcSYmfqxR1xK0uh31xTrov8TtSGgOsIZrSjUqLGBACT4k0CWezqX621IqmxC0DMng7JomsGgJpNVUC1hchezYIg+Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773682950; c=relaxed/simple;
	bh=5F2rHkIjw6Bg3TB7ql0Jtrl+wbXEu+PxH/1TEb2thdQ=;
	h=Date:To:From:Subject:Message-Id; b=OEimZmYe8qrBuhl/qQgofClLkiiRQ4NhGaFO/emRtcBceSOFy4407RQ24a7BfPuv0p2LQeyqaRNXmloDUNf4lfFZ+ER8lPNzougIenDWiJBcMvovQog4nxDKRLzQ9Sld8NzZr2tSXSH7tbK0+woEyJ+2tPhzssTBvMVlJG1WxJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RHPXa9CN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RHPXa9CN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B89FC19421;
	Mon, 16 Mar 2026 17:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773682950;
	bh=5F2rHkIjw6Bg3TB7ql0Jtrl+wbXEu+PxH/1TEb2thdQ=;
	h=Date:To:From:Subject:From;
	b=RHPXa9CNgiUFokmsoBcnaI36rC4+vasoMnHUceW0C/50F7aTOMrs/9rTouaFz2y0U
	 HcvUSlK15H9uoLWyO/IzvtMUPt514lEbxpxzvW1NhChstfmoJXgCTcA2YTcMVKESzn
	 HFQGCkCS4hM8vS6d8XfKuk175A+46ZK+vfG+DKtY=
Date: Mon, 16 Mar 2026 10:42:29 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,avagin@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy-fix.patch added to mm-unstable branch
Message-Id: <20260316174230.1B89FC19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: fix lock leak in mfill_get_vma()
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy-fix.patch

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
From: Andrei Vagin <avagin@google.com>
Subject: userfaultfd: fix lock leak in mfill_get_vma()
Date: Mon, 16 Mar 2026 17:38:28 +0000

In mfill_get_vma(), both the per-VMA lock (via uffd_mfill_lock()) and the
map_changing_lock are acquired.  However, state->vma was only assigned at
the very end of the function.  If any validation checks failed after lock
acquisition but before this assignment, the function would jump to the
out_unlock label and call mfill_put_vma(state).

Since mfill_put_vma() only performs cleanup if state->vma is non-NULL,
these error paths would leak both the per-VMA lock and the
map_changing_lock.

Link: https://lkml.kernel.org/r/20260316173829.1126728-1-avagin@google.com
Reported-by: syzbot+cf5ad2009a9bae03cb23@syzkaller.appspotmail.com
Signed-off-by: Andrei Vagin <avagin@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy-fix
+++ a/mm/userfaultfd.c
@@ -188,6 +188,7 @@ static int mfill_get_vma(struct mfill_st
 	 * request the user to retry later
 	 */
 	down_read(&ctx->map_changing_lock);
+	state->vma = dst_vma;
 	err = -EAGAIN;
 	if (atomic_read(&ctx->mmap_changing))
 		goto out_unlock;
@@ -210,7 +211,7 @@ static int mfill_get_vma(struct mfill_st
 		goto out_unlock;
 
 	if (is_vm_hugetlb_page(dst_vma))
-		goto out;
+		return 0;
 
 	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
 		goto out_unlock;
@@ -218,8 +219,6 @@ static int mfill_get_vma(struct mfill_st
 	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
 		goto out_unlock;
 
-out:
-	state->vma = dst_vma;
 	return 0;
 
 out_unlock:
_

Patches currently in -mm which might be from avagin@google.com are

userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy-fix.patch

