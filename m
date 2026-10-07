Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE50122D7A1
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334127; cv=none; b=ulcxoCjDLqW8/ijkMxxQUo8MNPN1xUBf9nzDYvEBb/TKk5zkVQgOtFnGSGok9OD35vqiMhtQZYuEUg+kjjUrBFa8JzdDoyhBWt9IPOYFNPOxGQuYqKc2t5zyxrC+puD9+qPWQXdMsYII0ggrjR3kr7d6fK/8l4Njyg43LfmTHQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334127; c=relaxed/simple;
	bh=v7BIq7+sLW6buYAc/FRzA9l/T3GFq1Xzh4thkrJuYfc=;
	h=Date:To:From:Subject:Message-Id; b=BemV4RNn7WYDQ+kLpw7aQhB0tNY4z5hhH0Krsc9Fuhjay/BL/snpWbR/KnnaXd3DXJpUoMgDmKZnVPlvlC93kVSY8OVNZbdQgQDBwr6hCg+Lkcy7DEneA3CdIE8EUxHGLSeng4ChrzLOMqNsSxfIm3u1sapV03Gkms0GHhcl8AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vm70X6Ih; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vm70X6Ih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38CD11F0089C;
	Wed,  7 Oct 2026 00:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334126;
	bh=vfQUMCbchXTPE62Xvip8mC4+2YWFKWaXdDp4dKJ2XA0=;
	h=Date:To:From:Subject;
	b=vm70X6IhziWbUtwkred5LkhfL3xewdqypZszFupXDSsLeXLtKhFYcG6qwO/YYy0k4
	 ofr8VDDRiv203AnHjns3NTCEbNLeQlcqfSy0Af+FpJC6zJJV8QX5GZ2MtLfP5hYgJc
	 2fwfz8Jv70og/v8+8LPbFrzDKK0W4aBJLC7UZZCM=
Date: Tue, 06 Oct 2026 17:48:45 -0700
To: mm-commits@vger.kernel.org,vivek.kasireddy@intel.com,steven.sistare@oracle.com,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-fix-resv_huge_pages-double-decrement-in-memfd-error-path.patch removed from -mm tree
Message-Id: <20261007004846.38CD11F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: fix resv_huge_pages double decrement in memfd error path
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-resv_huge_pages-double-decrement-in-memfd-error-path.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: mm/hugetlb: fix resv_huge_pages double decrement in memfd error path
Date: Tue, 25 Aug 2026 10:10:13 +0800

alloc_hugetlb_folio_reserve() decrements h->resv_huge_pages when dequeuing
a folio, but unlike the use_global_reservation handling in
hugetlb_alloc_folio(), it does not set HPageRestoreReserve on the folio.

Its sole caller memfd_alloc_folio() pre-allocates a reservation via
hugetlb_reserve_pages() before allocating.  When
hugetlb_add_to_page_cache() fails, folio_put() drops the folio without
HPageRestoreReserve set, so free_huge_folio() does not restore the
reservation.  The subsequent hugetlb_unreserve_pages() on the err_unresv
path decrements the counter a second time, leaving resv_huge_pages off by
one for every failed allocation.

Set HPageRestoreReserve when consuming the reservation in
alloc_hugetlb_folio_reserve().  On the error path, free_huge_folio() then
restores the reservation before hugetlb_unreserve_pages() releases it. 
The success path is unaffected, as hugetlb_add_to_page_cache() clears the
flag once the folio is added to the page cache.

Link: https://lore.kernel.org/20260825021013.25672-1-hongfu.li@linux.dev
Fixes: 26a8ea80929c ("mm/hugetlb: fix memfd_pin_folios resv_huge_pages leak")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Steven Sistare <steven.sistare@oracle.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
---

 mm/hugetlb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-resv_huge_pages-double-decrement-in-memfd-error-path
+++ a/mm/hugetlb.c
@@ -2187,8 +2187,10 @@ struct folio *alloc_hugetlb_folio_reserv
 
 	folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask, preferred_nid,
 					       nmask);
-	if (folio)
+	if (folio) {
+		folio_set_hugetlb_restore_reserve(folio);
 		h->resv_huge_pages--;
+	}
 
 	spin_unlock_irq(&hugetlb_lock);
 	return folio;
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

mm-page_owner-preserve-original-free_pid-free_tgid-during-folio-migration.patch
mm-memfd-fix-hugetlb-reservation-accounting-in-error-paths.patch
selftests-mm-fix-ptrace-peekdata-check-in-memfd_secret-test.patch
mm-hugetlb_cgroup-move-per-node-usage-on-cross-node-migration.patch
mm-hugetlb_cgroup-move-per-node-usage-on-cgroup-reparenting.patch
mm-hugetlb-account-migration-target-folio-in-per-node-nr_hugetlb-vmstat.patch
mm-memcg-migrate-per-node-hugetlb-lruvec-stat-together-with-hugetlb-folio.patch

