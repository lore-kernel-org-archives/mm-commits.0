Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780D83ACEF3
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 04:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791519328; cv=none; b=YKZCRlMvO7JJPpv2zmfHRhBw/Bo72vq4gVOfajzVMSXBAiL9OYt1aB8lFLpwrBDeZajX7MgZ936oe0F3EBOcd3XJU9wLXM1HSzx2aq0lWFNkS4MPGg43ViyC0KlD/pDE87b5gUTuR3OR/pU5dkdBGCD/myp6Z2PmcpbW3jVc/bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791519328; c=relaxed/simple;
	bh=qIvWGtw+AWVN0+A9Mcu1t7Mwus8EMKGFZj84wBBfOGA=;
	h=Date:To:From:Subject:Message-Id; b=KncoDfc46W5Lqo/pgktpMVyXMEmQ9eUT8OcNA0LU/zghyCl+HWI3KjNqLGKTUBaIZExevkEjXrzJY3b83m3pjmUZvFKMP1BW9tHgNPLEYJXM/vfJwTtckUbpx0gplLALHgO735ua4KzMeTHH8jP7UYvpj1kibWpV5TOZiuEOZrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nOGmY3Wx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nOGmY3Wx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB541F000FF;
	Fri,  9 Oct 2026 04:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791519314;
	bh=+Ny2xhNxWHN5xDHLaT+qi+VcwoTGGRXFI1fTkcTMEQw=;
	h=Date:To:From:Subject;
	b=nOGmY3WxGhJ0YsLh1scVMA8tqE6vMuvy76jgmMkmVh113T5GpnBgFevYD1LOuEYAV
	 V1hqRH9Zi9LcHFdyPfeZw6RHX69gh/i1siqpBjBEeM7jIBbtAAqvM74tFJ5N+TUyKH
	 3NBPzNqRBpYTskADTlNjWvtuRAU0M/zyAl0l178A=
Date: Thu, 08 Oct 2026 21:15:14 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swap-add-folio_swap_entry-and-folio_page_swap_entry-fix.patch removed from -mm tree
Message-Id: <20261009041514.8DB541F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-swap-add-folio_swap_entry-and-folio_page_swap_entry-fix
has been removed from the -mm tree.  Its filename was
     mm-swap-add-folio_swap_entry-and-folio_page_swap_entry-fix.patch

This patch was dropped because it was folded into mm-swap-add-folio_swap_entry-and-folio_page_swap_entry.patch

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm-swap-add-folio_swap_entry-and-folio_page_swap_entry-fix
Date: Sun, 13 Sep 2026 17:52:28 -0400

adjust the folio_swap_entry() kerneldoc summary, per David

Link: https://lore.kernel.org/20260913-folio_swap_entry-doc-fix-1@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
---

 include/linux/swap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/swap.h~mm-swap-add-folio_swap_entry-and-folio_page_swap_entry-fix
+++ a/include/linux/swap.h
@@ -273,7 +273,7 @@ struct swap_info_struct {
 };
 
 /**
- * folio_swap_entry - Return the swap entry for a page within a folio.
+ * folio_swap_entry - Return the swap entry at a page index within a folio.
  * @folio: The folio.
  * @idx: The index of the page within the folio.
  *
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-remove-pagewriteback.patch
mm-swap-add-folio_swap_entry-and-folio_page_swap_entry.patch
mm-huge_memory-add-a-comment-to-the-open-coded-swap-entry.patch
mm-rmap-use-folio_page_swap_entry-in-ttu_anon_swapbacked_folio.patch
mm-zswap-use-folio_swap_entry-in-zswap_store_page.patch
mm-swapfile-use-folio_page_swap_entry.patch
arm64-mte-make-mte_save_tags-and-mte_restore_tags-static.patch
arm64-mte-pass-the-swap-entry-to-mte_save_tags.patch
mm-swap-remove-page_swap_entry.patch
mm-memcontrol-take-a-const-folio-in-folio_memcg-and-friends.patch
mm-memcontrol-constify-obj_cgroup_memcg-and-friends.patch
mm-memcontrol-constify-the-lruvec-helpers.patch
mm-page_io-take-a-const-folio-in-bio_associate_blkg_from_folio.patch
mm-memcontrol-constify-the-mem_cgroup-accessors.patch
mm-page_counter-constify-page_counter_read-and-page_counter_margin.patch
mm-memcontrol-constify-the-reclaim-protection-helpers.patch
mm-memcontrol-constify-the-memcg-and-lruvec-stat-readers.patch
mm-memcontrol-constify-the-swap-accounting-helpers.patch
mm-memcontrol-constify-mem_cgroup_swappiness-and-mem_cgroup_get_max.patch
mm-memcontrol-constify-the-zswap-and-socket-pressure-helpers.patch
vmcore-convert-mmap_vmcore_fault-to-use-folios.patch

