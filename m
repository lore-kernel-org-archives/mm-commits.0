Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CF02F50
	for <mm-commits@vger.kernel.org>; Thu, 13 Jun 2024 20:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718311018; cv=none; b=eWHk0iww1W4MGLLEE2dByEETkC7G+CEFXnwGoryAJ4NjKlK0T+R9GWSidQS5HnO9invpbTSCmjwyrNVPaPqdNPgqlJBdWXCiH4e0J1zKupjBJXIF1iYbki363TzX867RV2rwsaTdxXx4sPYfKjsbka5AX/rS/N3bp0avWis1wJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718311018; c=relaxed/simple;
	bh=Kpy1nSglNKhGkDrft2HmJYMCPU5VAmq70JfBVwv40hE=;
	h=Date:To:From:Subject:Message-Id; b=q6rS6LGopqRB2uUYT9V6LGna2V4f8M6TbTnN9/fMyN7HMvfDJQYNouKqJXgifzru996KFMbYIV+8C7aJlowPKu2Ds/OVLWwd3+FQgpINoDJk/olOY0AN+/rvonMDtvDq6pcMFYc855xY750tWoeipHA7/nAH0g9KiR/BDyHhWsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j8Buzfbh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j8Buzfbh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7D9C2BBFC;
	Thu, 13 Jun 2024 20:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718311017;
	bh=Kpy1nSglNKhGkDrft2HmJYMCPU5VAmq70JfBVwv40hE=;
	h=Date:To:From:Subject:From;
	b=j8BuzfbhR9/cWXMMEyCWsGe+/IB4t305smeqRHbleC44KHRY3xq/QhATaiMof6CeC
	 EZn2syStCljMe/z3ltNlyEpKO9Svx1xMWlsayVMdXoD1LQ4ym1REEEcixi9b+fxneF
	 EI/Kzu2WWUicp5lLAjrcmyimkrSOePPJOFwLQlGo=
Date: Thu, 13 Jun 2024 13:36:57 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-move-page_mapcount-to-fs-proc-internalh-fix.patch added to mm-unstable branch
Message-Id: <20240613203657.CE7D9C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/task_mmu: fix uninitialized variable in pagemap_pmd_range()
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-move-page_mapcount-to-fs-proc-internalh-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-move-page_mapcount-to-fs-proc-internalh-fix.patch

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
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: fs/proc/task_mmu: fix uninitialized variable in pagemap_pmd_range()
Date: Thu, 13 Jun 2024 17:34:33 +0300

The "folio" pointer is tested for NULL, but it's either valid or
uninitialized.  Initialize it to NULL.

Link: https://lkml.kernel.org/r/9d6eaba7-92f8-4a70-8765-38a519680a87@moroto.mountain
Fixes: 84f57f8b8914 ("fs/proc: move page_mapcount() to fs/proc/internal.h")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~fs-proc-move-page_mapcount-to-fs-proc-internalh-fix
+++ a/fs/proc/task_mmu.c
@@ -1492,7 +1492,7 @@ static int pagemap_pmd_range(pmd_t *pmdp
 		u64 flags = 0, frame = 0;
 		pmd_t pmd = *pmdp;
 		struct page *page = NULL;
-		struct folio *folio;
+		struct folio *folio = NULL;
 
 		if (vma->vm_flags & VM_SOFTDIRTY)
 			flags |= PM_SOFT_DIRTY;
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are

fs-proc-move-page_mapcount-to-fs-proc-internalh-fix.patch
checkpatch-check-for-missing-fixes-tags.patch

