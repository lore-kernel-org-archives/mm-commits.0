Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7951C1DE4FB
	for <mm-commits@vger.kernel.org>; Wed,  8 Oct 2025 00:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759882938; cv=none; b=HFMa7ymzmzx7PqKw7Nz1nXhALqdEB6p0UeBNcVA90LAdtScPwkhzFTPPFxB/bo4qRhyNptjAgwsxT9CBKd2H1O5vLEAXOQCTK1yiX3T+n4lfPdTOvIANCJ1CNyIclXPTGUb5w6z3k/kwPhQ4MQ+W5dettYSl2KSLNLgW5KYxWf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759882938; c=relaxed/simple;
	bh=p68WiqL0MjMO0Slk/BsRNjtsOy2PEB/9xsrDTKBuj9E=;
	h=Date:To:From:Subject:Message-Id; b=qft1XUIh8Y5laGEINwHohJimugaKpE/fYG3D1Uns6IlKGi5luSqlRyfZDJbG+Z+lwvrTTskQkV03p+79PryCJHI0gS3XP1XITwiS8sVuYCupJABeRZVOgzsBLlT0MU7UyGPuBymUYUKxUNwHWexeY8GL0VFz/4PZXK1hrIuwgYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IfUorCjr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IfUorCjr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9E6C4CEF1;
	Wed,  8 Oct 2025 00:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759882938;
	bh=p68WiqL0MjMO0Slk/BsRNjtsOy2PEB/9xsrDTKBuj9E=;
	h=Date:To:From:Subject:From;
	b=IfUorCjrwEQ/JzQ30VVbj8sFcFujz3+d7xkYWGdpig2lmVr7gRxmRPGL6N5YCXc/l
	 oi1uLFh5x1WGKd7QiI61eKJiB7dRvS7VA3fsm1qsIfHqTePxjcRycp5GsHUbBHYty2
	 5POuM//l7jz/dWojjsopsrVRaGdEqlH5iOzcrzLM=
Date: Tue, 07 Oct 2025 17:22:17 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hannes@cmpxchg.org,david@redhat.com,corbet@lwn.net,chrisl@kernel.org,chengming.zhou@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-zswap-s-red-black-tree-xarray.patch added to mm-new branch
Message-Id: <20251008002217.ED9E6C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/zswap: s/red-black tree/xarray/
has been added to the -mm mm-new branch.  Its filename is
     docs-admin-guide-mm-zswap-s-red-black-tree-xarray.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-zswap-s-red-black-tree-xarray.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/zswap: s/red-black tree/xarray/
Date: Fri, 3 Oct 2025 13:38:51 -0700

The change from commit 796c2c23e14e ("zswap: replace RB tree with xarray")
is not reflected on the document.  Update the document.

Link: https://lkml.kernel.org/r/20251003203851.43128-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/zswap.rst |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/Documentation/admin-guide/mm/zswap.rst~docs-admin-guide-mm-zswap-s-red-black-tree-xarray
+++ a/Documentation/admin-guide/mm/zswap.rst
@@ -59,11 +59,11 @@ returned by the allocation routine and t
 accessed.  The compressed memory pool grows on demand and shrinks as compressed
 pages are freed.  The pool is not preallocated.
 
-When a swap page is passed from swapout to zswap, zswap maintains a mapping
-of the swap entry, a combination of the swap type and swap offset, to the
-zsmalloc handle that references that compressed swap page.  This mapping is
-achieved with a red-black tree per swap type.  The swap offset is the search
-key for the tree nodes.
+When a swap page is passed from swapout to zswap, zswap maintains a mapping of
+the swap entry, a combination of the swap type and swap offset, to the zsmalloc
+handle that references that compressed swap page.  This mapping is achieved
+with an xarray per swap type.  The swap offset is the search key for the xarray
+nodes.
 
 During a page fault on a PTE that is a swap entry, the swapin code calls the
 zswap load function to decompress the page into the page allocated by the page
_

Patches currently in -mm which might be from sj@kernel.org are

mm-zswap-remove-unnecessary-dlen-writes-for-incompressible-pages.patch
mm-zswap-fix-typos-s-zwap-zswap.patch
mm-zswap-s-red-black-tree-xarray.patch
docs-admin-guide-mm-zswap-s-red-black-tree-xarray.patch

