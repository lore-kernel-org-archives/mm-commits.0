Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E96E1EFF89
	for <mm-commits@vger.kernel.org>; Wed, 23 Apr 2025 22:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745446824; cv=none; b=q/ORrsT4SzNmCe1TZzxjAVMR9eKy6Y8VcGJrVi8KQvTRwdk5vwWyes8VCpHEXSg7AffPsb4IOTaErdH4WDV8n7FprXfeJVVzbqmaq8Erc7svmdEf1vF+TqMBP6jBt3MrQQ2vw4HNKdfvcZzhBwTu8fOJJ7jbyB1aHrEClgIhv6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745446824; c=relaxed/simple;
	bh=KsTDaXasFMgDqRioN8D+KgHCNEbBBYqPsJ8V5WxtYEw=;
	h=Date:To:From:Subject:Message-Id; b=i85Acm7DhzVt+n5HN4KQalLIgXhE6s/ikpCaRDjHDyCQ2HXL/KhwrY29Bu113BR5wBhCtaaKKlOIXMVu3xtJx9UPTWXuVQjtly8E+ggIVXk6mNuBTudfapWJ9Kzb2cako86FRzTgu8+TtAfA846z8zlWhdqAl1LUPwDDkS6jGck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n7hCRgG+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n7hCRgG+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224AEC4CEE2;
	Wed, 23 Apr 2025 22:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745446824;
	bh=KsTDaXasFMgDqRioN8D+KgHCNEbBBYqPsJ8V5WxtYEw=;
	h=Date:To:From:Subject:From;
	b=n7hCRgG+psyNuMkQVzg342mBnWZpNRY2gdW28wmYCpYiEwgAuD+F9tMROoofUB8wj
	 CiN+MvHSE0GDbQKifbbefL0zf5JAvo6F+/fNJ6UpRVDBuYcgo6DzCxWR24E/F7omhZ
	 7B8t2accIu47qqK4hDKhgiO/d3GFO/DH4OhdRVTI=
Date: Wed, 23 Apr 2025 15:20:23 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,pfalcato@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-workingset-simplify-lockdep-check-in-update_node.patch added to mm-new branch
Message-Id: <20250423222024.224AEC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: workingset: simplify lockdep check in update_node
has been added to the -mm mm-new branch.  Its filename is
     mm-workingset-simplify-lockdep-check-in-update_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-workingset-simplify-lockdep-check-in-update_node.patch

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
From: Pedro Falcato <pfalcato@suse.de>
Subject: mm: workingset: simplify lockdep check in update_node
Date: Mon, 21 Apr 2025 18:16:28 +0100

container_of(node->array, ..., i_pages) just to access i_pages again is an
incredibly roundabout way of accessing node->array itself.  Simplify it.

Link: https://lkml.kernel.org/r/20250421-workingset-simplify-v1-1-de5c40051e0e@suse.de
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/workingset.c~mm-workingset-simplify-lockdep-check-in-update_node
+++ a/mm/workingset.c
@@ -612,7 +612,6 @@ struct list_lru shadow_nodes;
 
 void workingset_update_node(struct xa_node *node)
 {
-	struct address_space *mapping;
 	struct page *page = virt_to_page(node);
 
 	/*
@@ -623,8 +622,7 @@ void workingset_update_node(struct xa_no
 	 * already where they should be. The list_empty() test is safe
 	 * as node->private_list is protected by the i_pages lock.
 	 */
-	mapping = container_of(node->array, struct address_space, i_pages);
-	lockdep_assert_held(&mapping->i_pages.xa_lock);
+	lockdep_assert_held(&node->array->xa_lock);
 
 	if (node->count && node->count == node->nr_values) {
 		if (list_empty(&node->private_list)) {
_

Patches currently in -mm which might be from pfalcato@suse.de are

mm-workingset-simplify-lockdep-check-in-update_node.patch

