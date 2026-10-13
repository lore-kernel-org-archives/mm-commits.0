Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF78483BFE
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791866002; cv=none; b=qPR5/sJbXWEjsx520F+MnigBQS6SydBvpKdh8igkvyldUP3MYw+bFGU24DCCtvBohXBYVcdux8MRcv2To9rwxikcSgv6Ak9kEgRKE1glwFrqX+xQOvRsZ9e60TRkgRkhN8o8rnkiVwAfOYPJWjqr0v7KU9SDtiv4taFG0Mw4h0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791866002; c=relaxed/simple;
	bh=A+jDrNrXfucQX+m3KzwuQh1nIKXiSl0juIL3F4/0/Ok=;
	h=Date:To:From:Subject:Message-Id; b=JTXNmvdu/bS3LwRrrfL1u40n6UY3mMBBbozYn7vBDQVKpq6guxhpHFGXGWS1DXanBsPTlIg5fT5d1q07fwz2hWqF8Fqrojks/fO9YzrQINthgenQp7l53Xcs4xLTN/Nrh2EvlG+hnPQ6HSpMObWRmqq6kMv9vHh7+AWih+yhCcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Juq3ovPB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Juq3ovPB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28AED1F000FF;
	Tue, 13 Oct 2026 04:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791866000;
	bh=fxd0jGg2xbCelZgFBIsRiwHEt4rbk4iyRKkeka9Rq78=;
	h=Date:To:From:Subject;
	b=Juq3ovPBQqfxywattXker6BK60Fuw8cWR3IAYxxdtE1si+QkUekSyLWt9Qrq1xh5x
	 1ISwH7VOxcXLd/vBor5PaQCjKnmfVj7j1g92gRc8Bla6f7BGOU6HP+rgUDa5loVBwX
	 Kfp4RPBOMVQ3SSbX2jIQiL5TRYarXeWg3oLruf60=
Date: Mon, 12 Oct 2026 21:33:19 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,youngjun.park@lge.com,sj@kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swapops-remove-unused-is_hwpoison_entry.patch removed from -mm tree
Message-Id: <20261013043320.28AED1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swapops: remove unused is_hwpoison_entry()
has been removed from the -mm tree.  Its filename was
     mm-swapops-remove-unused-is_hwpoison_entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: mm/swapops: remove unused is_hwpoison_entry()
Date: Sat, 19 Sep 2026 01:56:40 +0900

Since commit 93976a20345b ("mm: eliminate further swapops predicates"),
is_hwpoison_entry() has no callers.

So remove it.

No functional change.

Link: https://lore.kernel.org/20260918165642.1014988-1-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Youngjun Park <youngjun.park@lge.com>
---

 include/linux/swapops.h |    9 ---------
 1 file changed, 9 deletions(-)

--- a/include/linux/swapops.h~mm-swapops-remove-unused-is_hwpoison_entry
+++ a/include/linux/swapops.h
@@ -261,11 +261,6 @@ static inline swp_entry_t make_hwpoison_
 	return swp_entry(SWP_HWPOISON, page_to_pfn(page));
 }
 
-static inline int is_hwpoison_entry(swp_entry_t entry)
-{
-	return swp_type(entry) == SWP_HWPOISON;
-}
-
 #else
 
 static inline swp_entry_t make_hwpoison_entry(struct page *page)
@@ -273,10 +268,6 @@ static inline swp_entry_t make_hwpoison_
 	return swp_entry(0, 0);
 }
 
-static inline int is_hwpoison_entry(swp_entry_t swp)
-{
-	return 0;
-}
 #endif
 
 typedef unsigned long pte_marker;
_

Patches currently in -mm which might be from ekffu200098@gmail.com are


