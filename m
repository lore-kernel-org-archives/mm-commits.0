Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E2537B017
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388673; cv=none; b=fzHA8gAnfoMELJjN5KcBiVFKKUJ7N4I+50bE6Fdlac5VnjG6giuRxbK5Se9o0xHTCnf8Wqs7GNsWBwskVH26MpFAvjvmr195vxzNaPbc7GHf4rN5wivoTyYXeEJAcCZo5GiH0Am3SeOudk5Cmyw1bxiEq7lS0+LqvqRmSjL+vIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388673; c=relaxed/simple;
	bh=UF0tk/RRPKG+DzDPfImyjuQ1GFDhvhoji6b4iVMwWDA=;
	h=Date:To:From:Subject:Message-Id; b=DZPIE8EHW/y6FGdW1UNRxk7qLznYE9G7yQEniZzTf9tEd4f3HFSsDvXIpAEd6XxEZnRhxjvI5KZX7sw2VzIQJq8pTSSoZmEFTtJtUWBvNhJXivj39g7TZsXa/mTpoB3aOX1StDb61sdsgWxWQN1r9AcJGO5ad2JGOBfFjOoDETE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fho2TiRb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fho2TiRb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9F3C19424;
	Tue, 24 Mar 2026 21:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388673;
	bh=UF0tk/RRPKG+DzDPfImyjuQ1GFDhvhoji6b4iVMwWDA=;
	h=Date:To:From:Subject:From;
	b=Fho2TiRbIHiIcdKUkAy8ZztCgH5I8lxz36fWaWd1hSZ6T2xzf/IRl177hGZfNMCtv
	 jlTKd6FOBrQHYPWLluoPf3Cmxd/f7+mko1iiFNHOnFepF0cW+DypbdhVWSAw+B3mc3
	 pNcSZ/ewIQ+5k2VkzLroPojFX/4SOqHd/0O5fifw=
Date: Tue, 24 Mar 2026 14:44:32 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,skhan@linuxfoundation.org,rppt@kernel.org,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hillf.zj@alibaba-inc.com,david@kernel.org,corbet@lwn.net,jane.chu@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-fix-a-hugetlbfs-reservation-statement.patch removed from -mm tree
Message-Id: <20260324214433.4A9F3C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation: fix a hugetlbfs reservation statement
has been removed from the -mm tree.  Its filename was
     documentation-fix-a-hugetlbfs-reservation-statement.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jane Chu <jane.chu@oracle.com>
Subject: Documentation: fix a hugetlbfs reservation statement
Date: Mon, 2 Mar 2026 13:10:15 -0700

Documentation/mm/hugetlbfs_reserv.rst has
	if (resv_needed <= (resv_huge_pages - free_huge_pages))
		resv_huge_pages += resv_needed;
which describes this code in gather_surplus_pages()
	needed = (h->resv_huge_pages + delta) - h->free_huge_pages;
	if (needed <= 0) {
		h->resv_huge_pages += delta;
		return 0;
	}
which means if there are enough free hugepages to account for the new
reservation, simply update the global reservation count without
further action.

But the description is backwards, it should be
	if (resv_needed <= (free_huge_pages - resv_huge_pages))
instead.

Link: https://lkml.kernel.org/r/20260302201015.1824798-1-jane.chu@oracle.com
Fixes: 70bc0dc578b3 ("Documentation: vm, add hugetlbfs reservation overview")
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/hugetlbfs_reserv.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/mm/hugetlbfs_reserv.rst~documentation-fix-a-hugetlbfs-reservation-statement
+++ a/Documentation/mm/hugetlbfs_reserv.rst
@@ -155,7 +155,7 @@ are enough free huge pages to accommodat
 the global reservation count resv_huge_pages is adjusted something like the
 following::
 
-	if (resv_needed <= (resv_huge_pages - free_huge_pages))
+	if (resv_needed <= (free_huge_pages - resv_huge_pages)
 		resv_huge_pages += resv_needed;
 
 Note that the global lock hugetlb_lock is held when checking and adjusting
_

Patches currently in -mm which might be from jane.chu@oracle.com are


