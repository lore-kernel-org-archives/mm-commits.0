Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCD213D244
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291592; cv=none; b=ZphiQaifXl8fOmGra0o1AHb7jC94JAPLEGS3IwWSYR0cuAqWaTJV0Fg6wsreHFwCI3ltFEZp90vIZxlBsWglu5RqmRqI4PUVqxh6s8Z7afWRl4CjPJZsV3afiP/66KnIMi8XW2c+/wRPVi+EyFgNTbgVsGNzH42UG4rQ9nLeyB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291592; c=relaxed/simple;
	bh=AAtQvTVgcIHzMmpJrcmzMFavGQWxaTCZPacnNAYdBEk=;
	h=Date:To:From:Subject:Message-Id; b=eyhIv1pzS7e3604K6rxCgoMf5Or6rtX9AhAjPlBPlaDqQAvKIznpLNDj1dHycnElHsWkwZApZqpbHYH7UtJmuHTWmaHIWNWPGCHE8LEU5m/4RR8OdjFRUyhx+rFFwQ1tflKHwr32ROZpCb5DUrnsGj+R17pGT/bSbSp0933Ed+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SjoWo/dJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SjoWo/dJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02AE5C32782;
	Tue, 25 Jun 2024 04:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291592;
	bh=AAtQvTVgcIHzMmpJrcmzMFavGQWxaTCZPacnNAYdBEk=;
	h=Date:To:From:Subject:From;
	b=SjoWo/dJ3WpnaAisQ5QQs9uz0qOSSNonqzv4+jx6IpUZPcLJMbhX4PtWykQQ9Vo0x
	 1MhzZXIUN8s/YK04rU1H4Qbbh+ZG2Focf41wh3+lkTm1TbaJ+Ld7AmN+K3Tbwcch2f
	 Noqg/CBdCOBTQtoGtODwoho8bv/BRK87W3kd9VX4=
Date: Mon, 24 Jun 2024 21:59:51 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ryan.roberts@arm.com,ruansy.fnst@fujitsu.com,nao.horiguchi@gmail.com,linmiaohe@huawei.com,jiaqiyan@google.com,liyifei28@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-use-helper-llist_for_each_entry.patch removed from -mm tree
Message-Id: <20240625045952.02AE5C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: use helper llist_for_each_entry()
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-use-helper-llist_for_each_entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yifei Li <liyifei28@huawei.com>
Subject: mm/memory-failure: use helper llist_for_each_entry()
Date: Mon, 13 May 2024 15:58:30 +0800

Change the llist_for_each_entry_safe function to the llist_for_each_entry
function and delete the next variable.  Because the linked list is not
modified,the llist_for_each_entry_safe function is not required.  No
functional changes are intended.

Link: https://lkml.kernel.org/r/20240513075830.2611-1-liyifei28@huawei.com
Signed-off-by: Yifei Li <liyifei28@huawei.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-use-helper-llist_for_each_entry
+++ a/mm/memory-failure.c
@@ -1935,7 +1935,7 @@ static int folio_set_hugetlb_hwpoison(st
 {
 	struct llist_head *head;
 	struct raw_hwp_page *raw_hwp;
-	struct raw_hwp_page *p, *next;
+	struct raw_hwp_page *p;
 	int ret = folio_test_set_hwpoison(folio) ? -EHWPOISON : 0;
 
 	/*
@@ -1946,7 +1946,7 @@ static int folio_set_hugetlb_hwpoison(st
 	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
 		return -EHWPOISON;
 	head = raw_hwp_list_head(folio);
-	llist_for_each_entry_safe(p, next, head->first, node) {
+	llist_for_each_entry(p, head->first, node) {
 		if (p->page == page)
 			return -EHWPOISON;
 	}
_

Patches currently in -mm which might be from liyifei28@huawei.com are


