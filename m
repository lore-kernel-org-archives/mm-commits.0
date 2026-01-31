Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC145346A0B
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 21:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769896642; cv=none; b=sGLnDHTD9nHODa1pFJpNHKEChyaB/D18njNxQM+WtYKt31GX8MMMmZNzKM5C6G6VXlbsVoEQ3czt1c0S7DeY4xdKpsPY4F9PRcK6XX14DHfuPrr0xD8c8SzjbZqCqsJs9mm2iRFqxgkoqmvE3jwPLxz1vQcQGJ6hsFwutkQ9mHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769896642; c=relaxed/simple;
	bh=eyxgSlNDX3SCvIBfjGea4MKsUdD9Fwzk0mZbs6JxRLk=;
	h=Date:To:From:Subject:Message-Id; b=o8MzmIxiY2bqZcat9j0szrS6Ufdgww2vgpTu1qsARCrKw/pF+2OwVVNuR72OcJCe3ZAqtQQK27kGJ4gDPpoPRTKH+kbKRoCTNlSzZCcmDw+eOtt2gDe0/BJJCHdWAlfpqKVhjViMGoEWF78P8+gQcnvpsTyRGGPey3VenC0+/mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bFWVYEoj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bFWVYEoj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9F0C4CEF1;
	Sat, 31 Jan 2026 21:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769896642;
	bh=eyxgSlNDX3SCvIBfjGea4MKsUdD9Fwzk0mZbs6JxRLk=;
	h=Date:To:From:Subject:From;
	b=bFWVYEojINB9vv/ffr9cFvyZk+UT/9Xo+F5iNq8Q4AFoREY6HOK4u3cfUmy933u6f
	 KMxJYv5cRS90sBRa6mEbUE6i3+GtxMrBqmbKbC1wU5OfRfwFdgIu4wA/C5BQWA3Icf
	 xnk/FPU7JUNBgXytjd3tx+t2+Zw9HNBoqK9rDWXc=
Date: Sat, 31 Jan 2026 13:57:21 -0800
To: mm-commits@vger.kernel.org,zenghongling@kylinos.cn,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-pagewalk-use-min-to-simplify-the-code-fix.patch removed from -mm tree
Message-Id: <20260131215722.4F9F0C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-pagewalk-use-min-to-simplify-the-code-fix
has been removed from the -mm tree.  Its filename was
     mm-pagewalk-use-min-to-simplify-the-code-fix.patch

This patch was dropped because it was folded into mm-pagewalk-use-min-to-simplify-the-code.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-pagewalk-use-min-to-simplify-the-code-fix
Date: Tue Jan 20 08:54:09 AM PST 2026

add newline, per Lorenzo

Cc: David Hildenbrand <david@kernel.org>
Cc: Hongling Zeng <zenghongling@kylinos.cn>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/pagewalk.c~mm-pagewalk-use-min-to-simplify-the-code-fix
+++ a/mm/pagewalk.c
@@ -313,6 +313,7 @@ static unsigned long hugetlb_entry_end(s
 				       unsigned long end)
 {
 	unsigned long boundary = (addr & huge_page_mask(h)) + huge_page_size(h);
+
 	return min(boundary, end);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

procfs-avoid-fetching-build-id-while-holding-vma-lock-fix.patch
mm-pagewalk-use-min-to-simplify-the-code.patch
mm-relocate-the-page-table-ceiling-and-floor-definitions-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
liveupdate-luo_file-remember-retrieve-status-fix.patch

