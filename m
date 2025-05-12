Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1902F298CA3
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 22:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747088237; cv=none; b=D+juwjZO6oGBlmSIiztZKgTpJttmRBcRZ8glYnCRKjx5WE+hz8xPsiJWaX75pVtxcdQnQ/RRS+l0EsCZiLcvVSDau/HkTl7VXxMB7OEIzFM9m/i5Mi38qlVsE2VG1NfMwYBffex9NtvwRXWq+NXBGE486XaPhUZuOOMu0kiDwyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747088237; c=relaxed/simple;
	bh=uPN76SPqpY/uIrKh6qk4GtxcdjZ9Gmz8cjR4UiKtjJw=;
	h=Date:To:From:Subject:Message-Id; b=rP7SeLeavdg1E1tNZJPNlyBDV/erknhyaSffTiPl2ZWCiRmM8Qy6ZowLLtFRPdnwNepK3f2jzY0dfc4Nrdrg11J/Bkzaj8x4Yn5JUglpaJ03etZNNzqoSPogbEwwHKgDxCvxM7hopMTLUwTksBZ2OSCp9+lFINCHN7rEv0vumpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b722nz0p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b722nz0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A957C4CEED;
	Mon, 12 May 2025 22:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747088236;
	bh=uPN76SPqpY/uIrKh6qk4GtxcdjZ9Gmz8cjR4UiKtjJw=;
	h=Date:To:From:Subject:From;
	b=b722nz0pVTJtGwGJ5m1LgZc7rw6K/Hkz0B2S5FJp17achkdET/xgeQqEd75ExQQP4
	 cIXSUNKOljeEcRzfpLG2u5+85LghFOEHxRV3eErVahOwMIJDEYPlCeG5g0TujzEFDM
	 ikvgwIDJ9d2IeR06eqi7aNWyBs+QyKMDHnkfliLY=
Date: Mon, 12 May 2025 15:17:15 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuzhao@google.com,shakeel.butt@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-mm-reclaim-section.patch added to mm-hotfixes-unstable branch
Message-Id: <20250512221716.7A957C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add mm reclaim section
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-mm-reclaim-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-mm-reclaim-section.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add mm reclaim section
Date: Mon, 12 May 2025 15:31:22 +0100

In furtherance of ongoing efforts to ensure people are aware of who
de-facto maintains/has an interest in specific parts of mm, as well trying
to avoid get_maintainers.pl listing only Andrew and the mailing list for
mm files - establish a reclaim memory management section and add relevant
maintainers/reviewers.

This is a key part of memory management so sensibly deserves its own
section.

This encompasses both 'classical' reclaim and MGLRU and thus reflects this
in the reviewers from both, as well as those who have contributed
specifically on the memcg side of things.

Link: https://lkml.kernel.org/r/20250512143122.87740-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/MAINTAINERS~maintainers-add-mm-reclaim-section
+++ a/MAINTAINERS
@@ -15581,6 +15581,19 @@ F:	mm/compaction.c
 F:	mm/page_alloc.c
 F:	mm/page_isolation.c
 
+MEMORY MANAGEMENT - RECLAIM
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Johannes Weiner <hannes@cmpxchg.org>
+R:	David Hildenbrand <david@redhat.com>
+R:	Michal Hocko <mhocko@kernel.org>
+R:	Qi Zheng <zhengqi.arch@bytedance.com>
+R:	Shakeel Butt <shakeel.butt@linux.dev>
+R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	mm/pt_reclaim.c
+F:	mm/vmscan.c
+
 MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@redhat.com>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-update-page-allocator-section.patch
maintainers-add-mm-reclaim-section.patch
mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality.patch
mm-abstract-initial-stack-setup-to-mm-subsystem.patch
mm-move-dup_mmap-to-mm.patch
mm-perform-vma-allocation-freeing-duplication-in-mm.patch
mm-introduce-new-mmap_prepare-file-callback.patch
mm-secretmem-convert-to-mmap_prepare-hook.patch
mm-vma-remove-mmap-retry-merge.patch

