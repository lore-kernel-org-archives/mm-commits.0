Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3A914EC73
	for <mm-commits@vger.kernel.org>; Sat,  8 Feb 2025 03:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738983894; cv=none; b=rG1HO2DwdmzpGQNFMrw9P4e3umbG2j6kceG6A596iFyY5Zibm/qK/0L3nlvXXf9vT/6ouUllVtoE7uKvHAz9Zr8pficf70fQpOmjOjvCnNV82n10lhQlPLlheVh52/QnuFQuNokGXS45JpKf+uapJCr5bjUs9SfrEL8B8S/VyP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738983894; c=relaxed/simple;
	bh=4WP9I9eQXY+0/LhlYCGADDfgUW1TngHVbyp4/BkDCcw=;
	h=Date:To:From:Subject:Message-Id; b=DlBpQmvMxgBkEgFvDDDr/nLh0HtyKzjFgdBen6vKRyCH6MGsQQ9E3D1+imZ3UotM0P5NR0jc6ar/14TFC0xWxmQAiOPeL9sTT/7AAcBoqsf/RzZE4fyN7jVm77dGQws5+8izlqRD/TWfXw2PX+V5s7tTQM++CajSvEPZLQij+b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=14TmB1KB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="14TmB1KB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BFF4C4CED1;
	Sat,  8 Feb 2025 03:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738983894;
	bh=4WP9I9eQXY+0/LhlYCGADDfgUW1TngHVbyp4/BkDCcw=;
	h=Date:To:From:Subject:From;
	b=14TmB1KB4s88N5dEDn8zHGz7EL0hU7dRqBoOZKrgjg1pHU1FnyfWlXLPEwJDVJ21k
	 U2TlVt7PvuOp+RAGkRc0xlMfwmyTpnzCm/Jple59nznm8SpRHnfSV7xWtDmbGiJOyk
	 SVmNNJCXPqjBYTwdmMoOV6utTot2iNHCfw6iRPno=
Date: Fri, 07 Feb 2025 19:04:53 -0800
To: mm-commits@vger.kernel.org,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-drop-the-unused-macro.patch added to mm-unstable branch
Message-Id: <20250208030454.0BFF4C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: drop the unused macro
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-drop-the-unused-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-drop-the-unused-macro.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: drop the unused macro
Date: Fri, 7 Feb 2025 17:44:17 +0800

Patch series "Some trivial cleanups for shmem".

Patch 1 - Patch 5 do some trivial cleanups and refactoring for shmem.
Patch 6 adds myself as shmem reviewer.


This patch (of 6):

Drop the unused 'BLOCKS_PER_PAGE' macro.

Link: https://lkml.kernel.org/r/cover.1738918357.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/69264cee1d938442477e657004e4924f8a5c4dd4.1738918357.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickens <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-drop-the-unused-macro
+++ a/mm/shmem.c
@@ -86,7 +86,6 @@ static struct vfsmount *shm_mnt __ro_aft
 
 #include "internal.h"
 
-#define BLOCKS_PER_PAGE  (PAGE_SIZE/512)
 #define VM_ACCT(size)    (PAGE_ALIGN(size) >> PAGE_SHIFT)
 
 /* Pretend that each entry is of this size in directory's i_size */
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-drop-the-unused-macro.patch
mm-shmem-remove-fadvise-comments.patch
mm-shmem-remove-duplicate-error-validation.patch
mm-shmem-change-the-return-value-of-shmem_find_swap_entries.patch
mm-shmem-factor-out-the-within_size-logic-into-a-new-helper.patch
maintainers-add-myself-as-shmem-reviewer.patch

