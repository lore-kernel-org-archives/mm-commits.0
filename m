Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0974C535D4
	for <mm-commits@vger.kernel.org>; Thu, 23 May 2024 20:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716495034; cv=none; b=F/7t8j/sbiFxs2LE5xJ0OAeBL7gutW0Y5Sv0o8XomvwLUUc4GLljszsotoJPAaBqG9j9geW8InPj8OKJGz7S6KBYlqAMTCJQCFQ56jxs2ZtaoWsujdweL1xe5eG+oz6RRPgZQ6v59S8qkLvNld7HZt7uYUvvwdEORaPgC+Ko3Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716495034; c=relaxed/simple;
	bh=7NoO5qDXo0d3ZNV8iIKq9BNGX/acE5SNqskiwJrqI98=;
	h=Date:To:From:Subject:Message-Id; b=DQaNPEgNQJCdx6F2JiIjvJrXK0YWRKVg4WGUdEbnh417nG5KPonUZi+4yCsvyHBcmN4xYKEeYq8NAgJLDFrNLwJH7e6jNbHZHTiK7EFOSV/Q7kQfwctrNl2XzuGs2s8syG7y3c6geJS11VVhKe6dxaI5JBgDfO4hga1Po0IxQBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dEO7xn9E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dEO7xn9E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B246C2BD10;
	Thu, 23 May 2024 20:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716495033;
	bh=7NoO5qDXo0d3ZNV8iIKq9BNGX/acE5SNqskiwJrqI98=;
	h=Date:To:From:Subject:From;
	b=dEO7xn9EcXuqi5S34m1AMY9F4zeM5Sic+6Z7csIS44YdVcYaTA/EaEIDNb7Fsvf2r
	 hvsRMBZ8Im3jqX5lZfA4I5TeILHHuR1kjPlxfR+mdNuBNzxnvfJIoqqXkCgQOoeYXA
	 Ps/Jeiraq3a1pIFj4v2X6bO9DaMwcSLubhlwwccg=
Date: Thu, 23 May 2024 13:10:32 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ryan.roberts@arm.com,ruansy.fnst@fujitsu.com,nao.horiguchi@gmail.com,linmiaohe@huawei.com,jiaqiyan@google.com,liyifei28@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-use-helper-llist_for_each_entry.patch added to mm-unstable branch
Message-Id: <20240523201033.8B246C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: use helper llist_for_each_entry()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-use-helper-llist_for_each_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-use-helper-llist_for_each_entry.patch

This patch will later appear in the mm-unstable branch at
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

mm-memory-failure-use-helper-llist_for_each_entry.patch

