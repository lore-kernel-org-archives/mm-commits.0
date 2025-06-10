Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D2623BF96
	for <mm-commits@vger.kernel.org>; Tue, 10 Jun 2025 19:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749584017; cv=none; b=FiYKzMLyEJnOw3M16nq0gxE9typnUn8T40dU7DBPx2vk/mJ/Fr5GjVatiIY0KT6oP+dRcG1Xq7ASJVzdSJfXoKlPwRXEZStrh/B+9qDnAxa4dmNda41RHfdjU3fy4Ccmwa2w6QaNZMB5KlLBioDw9wLjgD8zdLnarwY3KNC13Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749584017; c=relaxed/simple;
	bh=i5Y3ceImNUFyFCSTB4QrUs/TQYpd/RtKKby23gZ8Oro=;
	h=Date:To:From:Subject:Message-Id; b=K+sky52FP/wTabUleLQEIuWEVrzt0RTnkMu2SUc2KP/KqPe0rjRm4B+EJJLbwTwsvO6KRmKxHF6yrJbE1a7xqpH1fZ2noXQxCekRoCPcLpFINP1E3cbk1jxXcdGpceRz3YxRIiC2cl65C1u9mhPjnHLALbfFrw271s8hPITs9oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tNP04cZQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tNP04cZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31EDC4CEED;
	Tue, 10 Jun 2025 19:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749584016;
	bh=i5Y3ceImNUFyFCSTB4QrUs/TQYpd/RtKKby23gZ8Oro=;
	h=Date:To:From:Subject:From;
	b=tNP04cZQe6iMRfW7S7i3O6WstkQ0TpbJTsqktuq7lYLYlTeNPREFzu47P/W88GbOR
	 tGd6/QHku3e9FP7j98yinFBxohaKu+2V9/4DxV825cCYKNB837xthx5LPHZMY/SCLz
	 8grLNoRxuxKumh8ifc8w8vylRyr9qoIJwOTK2WZs=
Date: Tue, 10 Jun 2025 12:33:36 -0700
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,shikemeng@huaweicloud.com,nphamcs@gmail.com,hughd@google.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-swap-fix-softlockup-with-mthp-swapin-v3.patch added to mm-hotfixes-unstable branch
Message-Id: <20250610193336.D31EDC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-shmem-swap-fix-softlockup-with-mthp-swapin-v3
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shmem-swap-fix-softlockup-with-mthp-swapin-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-swap-fix-softlockup-with-mthp-swapin-v3.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm-shmem-swap-fix-softlockup-with-mthp-swapin-v3
Date: Wed, 11 Jun 2025 02:16:45 +0800

add comment

Link: https://lkml.kernel.org/r/20250610181645.45922-1-ryncsn@gmail.com
Fixes: 1dd44c0af4fa1 ("mm: shmem: skip swapcache for swapin of synchronous swap device")
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/shmem.c~mm-shmem-swap-fix-softlockup-with-mthp-swapin-v3
+++ a/mm/shmem.c
@@ -2273,6 +2273,8 @@ static int shmem_swapin_folio(struct ino
 		 * If uffd is active for the vma, we need per-page fault
 		 * fidelity to maintain the uffd semantics, then fallback
 		 * to swapin order-0 folio, as well as for zswap case.
+		 * Any existing sub folio in the swap cache also blocks
+		 * mTHP swapin.
 		 */
 		if (order > 0 && ((vma && unlikely(userfaultfd_armed(vma))) ||
 				  !zswap_never_enabled() ||
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-userfaultfd-fix-race-of-userfaultfd_move-and-swap-cache.patch
mm-shmem-swap-fix-softlockup-with-mthp-swapin.patch
mm-shmem-swap-fix-softlockup-with-mthp-swapin-v3.patch
mm-list_lru-refactor-the-locking-code.patch

