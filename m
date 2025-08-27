Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712FF2D97AF
	for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2025 22:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756333582; cv=none; b=Dksimka4j9S0mxJETFoW+n4fQhM729kjD9rW+vucD8DXyJJwz4weY4gqe8FczrcHSpTFU4T7L9295Agpeb0VHdqdq6JLpTIe6qGe8nUfqdqmOIdcrO1oupfA0cFsZHtp3yPOprBh4mlXtNzWVIagwBDtfXnHCcWxQMpN5BplmRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756333582; c=relaxed/simple;
	bh=fb+kkXa7QK8Dlpt+ty7fZ2s22mJjLppCkYiPtsst8Dw=;
	h=Date:To:From:Subject:Message-Id; b=vGYj8cooQU/FDRQSdlJ/8bAcyZvKOifWwq61RnhEux39WPd4K2dpO/C3u+POSrZfl1QlQx8rs21kWDR7488758isKi3gW2QYpQPKD2cp0nbTg+6ifVC/MKzveexrTJVjr4UcQ0zIJsCMFVvbGJZ0YYvWooLJ8dL3oScQy4Kdtic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sCHr+ilk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sCHr+ilk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D572C4CEEB;
	Wed, 27 Aug 2025 22:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756333580;
	bh=fb+kkXa7QK8Dlpt+ty7fZ2s22mJjLppCkYiPtsst8Dw=;
	h=Date:To:From:Subject:From;
	b=sCHr+ilksUIAbHPAzbxlOcmYhnj0H4N19tAB89yIjmRJGY66e+Hd67PbCVEXpJ6mo
	 0mr8f1mrQO0P6Xtm2nf6TD6+NdXvpXtQGMDSDYFimfyBWyy27YCRW/QBc9DYvS+XCl
	 02MFnsan2yLIgqeqzbeUbbvJHfou3hV16A8mwU3c=
Date: Wed, 27 Aug 2025 15:26:20 -0700
To: mm-commits@vger.kernel.org,wqu@suse.com,willy@infradead.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,boris@bur.io,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-vmstat-for-kernel_file-pages.patch added to mm-new branch
Message-Id: <20250827222620.7D572C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add vmstat for kernel_file pages
has been added to the -mm mm-new branch.  Its filename is
     mm-add-vmstat-for-kernel_file-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-vmstat-for-kernel_file-pages.patch

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
From: Boris Burkov <boris@bur.io>
Subject: mm: add vmstat for kernel_file pages
Date: Thu, 21 Aug 2025 14:55:36 -0700

Kernel file pages are tricky to track because they are indistinguishable
from files whose usage is accounted to the root cgroup.

To maintain good accounting, introduce a vmstat counter tracking kernel
file pages.

Confirmed that these work as expected at a high level by mounting a btrfs
using AS_KERNEL_FILE for metadata pages, and seeing the counter rise with
fs usage then go back to a minimal level after drop_caches and finally
down to 0 after unmounting the fs.

Link: https://lkml.kernel.org/r/08ff633e3a005ed5f7691bfd9f58a5df8e474339.1755812945.git.boris@bur.io
Signed-off-by: Boris Burkov <boris@bur.io>
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Tested-by: syzbot@syzkaller.appspotmail.com
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qu Wenruo <wqu@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 +
 mm/filemap.c           |    7 +++++++
 mm/vmstat.c            |    1 +
 3 files changed, 9 insertions(+)

--- a/include/linux/mmzone.h~mm-add-vmstat-for-kernel_file-pages
+++ a/include/linux/mmzone.h
@@ -259,6 +259,7 @@ enum node_stat_item {
 	NR_HUGETLB,
 #endif
 	NR_BALLOON_PAGES,
+	NR_KERNEL_FILE_PAGES,
 	NR_VM_NODE_STAT_ITEMS
 };
 
--- a/mm/filemap.c~mm-add-vmstat-for-kernel_file-pages
+++ a/mm/filemap.c
@@ -190,6 +190,9 @@ static void filemap_unaccount_folio(stru
 		__lruvec_stat_mod_folio(folio, NR_FILE_THPS, -nr);
 		filemap_nr_thps_dec(mapping);
 	}
+	if (test_bit(AS_KERNEL_FILE, &folio->mapping->flags))
+		mod_node_page_state(folio_pgdat(folio),
+				    NR_KERNEL_FILE_PAGES, -nr);
 
 	/*
 	 * At this point folio must be either written or cleaned by
@@ -989,6 +992,10 @@ int filemap_add_folio(struct address_spa
 		if (!(gfp & __GFP_WRITE) && shadow)
 			workingset_refault(folio, shadow);
 		folio_add_lru(folio);
+		if (kernel_file)
+			mod_node_page_state(folio_pgdat(folio),
+					    NR_KERNEL_FILE_PAGES,
+					    folio_nr_pages(folio));
 	}
 	return ret;
 }
--- a/mm/vmstat.c~mm-add-vmstat-for-kernel_file-pages
+++ a/mm/vmstat.c
@@ -1290,6 +1290,7 @@ const char * const vmstat_text[] = {
 	[I(NR_HUGETLB)]				= "nr_hugetlb",
 #endif
 	[I(NR_BALLOON_PAGES)]			= "nr_balloon_pages",
+	[I(NR_KERNEL_FILE_PAGES)]		= "nr_kernel_file_pages",
 #undef I
 
 	/* system-wide enum vm_stat_item counters */
_

Patches currently in -mm which might be from boris@bur.io are

mm-filemap-add-as_kernel_file.patch
mm-filemap-add-as_kernel_file-fix.patch
mm-add-vmstat-for-kernel_file-pages.patch
btrfs-set-as_kernel_file-on-the-btree_inode.patch

