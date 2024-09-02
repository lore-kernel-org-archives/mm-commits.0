Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068533EA76
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247670; cv=none; b=DAa6TPJhhal/h5jbPxQ7iO7w+Md05m5+DyilWo3V+pvIE4TzOezK+33uX7S9ojp7e27ye/ZCmQbCLywFm9MiqOtwSeiSY9WNVz5ghr4hSHX2pW6N/NqSTsNcHirq7tXZ6oeLo1JE2jgQCSm4zWInDOKep9VSmau8CFpN33K+rzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247670; c=relaxed/simple;
	bh=kG9AWZG4kEDQtyDKhbfWqcqiqJj9+oItO3YI7wcN1xk=;
	h=Date:To:From:Subject:Message-Id; b=fAxqIq9hF4ROaJWH6kzBfy1rFzXxFf4S2BzGvgs3qYTFUREiVt0TTSFos11OLtzzF/b6fuhbAlRZmlQkUSpGk5kF/WpjWdwI3sFqmddais5pD8H8MbLS9M9tzwz9rMqZbzmwnfkFPZd+s0+xqQhzwxIQNzqcMAJnfC/6X9BQeGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gfMZX3au; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gfMZX3au"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91BB8C4CEC2;
	Mon,  2 Sep 2024 03:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247669;
	bh=kG9AWZG4kEDQtyDKhbfWqcqiqJj9+oItO3YI7wcN1xk=;
	h=Date:To:From:Subject:From;
	b=gfMZX3aufSUB2FwcYwbxhxZrgYTG+ywy91fqdoFeS8YfR/QHggWsOQDl1Xfqh53PT
	 Mm1pdhYFWyJ1Frs8RbjXXnlH9RCYBtFI3jK4HqZBMWgVFki2psbM+RiP/BAuBnXBQ5
	 pjwAi8wUwxOc7h0zBr3N7rMbNkG4A4F4ouknT6xQ=
Date: Sun, 01 Sep 2024 20:27:49 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-foll_flags-in-__get_user_pages.patch removed from -mm tree
Message-Id: <20240902032749.91BB8C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove foll_flags in __get_user_pages
has been removed from the -mm tree.  Its filename was
     mm-remove-foll_flags-in-__get_user_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Josef Bacik <josef@toxicpanda.com>
Subject: mm: remove foll_flags in __get_user_pages
Date: Thu, 18 Jul 2024 17:26:07 -0400

Now that we're not passing around a pointer to the flags, there's no
reason to have an extra variable for the gup_flags, simply pass the
gup_flags directly everywhere.

Link: https://lkml.kernel.org/r/1e79b84bd30287cc9847f2aeb002374e6e60a10f.1721337845.git.josef@toxicpanda.com
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/mm/gup.c~mm-remove-foll_flags-in-__get_user_pages
+++ a/mm/gup.c
@@ -1437,7 +1437,6 @@ static long __get_user_pages(struct mm_s
 
 	do {
 		struct page *page;
-		unsigned int foll_flags = gup_flags;
 		unsigned int page_increm;
 
 		/* first iteration or cross vma bound */
@@ -1488,9 +1487,9 @@ retry:
 		}
 		cond_resched();
 
-		page = follow_page_mask(vma, start, foll_flags, &ctx);
+		page = follow_page_mask(vma, start, gup_flags, &ctx);
 		if (!page || PTR_ERR(page) == -EMLINK) {
-			ret = faultin_page(vma, start, foll_flags,
+			ret = faultin_page(vma, start, gup_flags,
 					   PTR_ERR(page) == -EMLINK, locked);
 			switch (ret) {
 			case 0:
@@ -1547,13 +1546,12 @@ next_page:
 				 * large folio, this should never fail.
 				 */
 				if (try_grab_folio(folio, page_increm - 1,
-						   foll_flags)) {
+						   gup_flags)) {
 					/*
 					 * Release the 1st page ref if the
 					 * folio is problematic, fail hard.
 					 */
-					gup_put_folio(folio, 1,
-						      foll_flags);
+					gup_put_folio(folio, 1, gup_flags);
 					ret = -EFAULT;
 					goto out;
 				}
_

Patches currently in -mm which might be from josef@toxicpanda.com are


