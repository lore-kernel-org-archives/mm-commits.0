Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5161369B9
	for <mm-commits@vger.kernel.org>; Thu,  7 Mar 2024 20:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709841983; cv=none; b=Rka/wVQqOXWvRL7s/KM7QQKr3PRQPnlNSqSV6nOXdvnZZKkIPMxLc92ojAjiaMBQgrfhOf8P64Fm9ZtTHC2KBNfu7QnPAut5939JqSqdowaGjsl4k1tFTK5lsaobEhAGtfHY85yQl/2jKWXlXpmgzZ7WGOh4zmo7Gooi7mAP0So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709841983; c=relaxed/simple;
	bh=OIYLKAohZzb5GJLzqbZNrXw3Yaccij1AM9ayrmqkvu0=;
	h=Date:To:From:Subject:Message-Id; b=CkXCLPl6iUheteC5S9rDIsPIZBSXGK1b1DKfGNecEl+lv8hDruQxkpvdCCwuN5/K8hMBZPkSyfU0gqflx9CPoQ9bYykAS/eYN/3eB5gVFriemP0TB4s/RGROXdzTtd3O6zF9t/P7G43svhxVzDm36vAAiFy5Gpuccz4j4yf3Jcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bb4fk3JE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bb4fk3JE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05A7C433C7;
	Thu,  7 Mar 2024 20:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709841983;
	bh=OIYLKAohZzb5GJLzqbZNrXw3Yaccij1AM9ayrmqkvu0=;
	h=Date:To:From:Subject:From;
	b=Bb4fk3JEdVBie8NgNkyjXwTKseg9373ZUP4kQgYHXbswQPCKMcB59D3ZCLMJ1Ex39
	 hnHa7fXDAfMr0FC2Wx73UIDu/OQo7schEKa0lkntt1Ufi+6ZYzi40iLSXTgGTdgZI3
	 lieIs86bQMfPzKocmEkvYyIkinZmV0gT/zbJlBnY=
Date: Thu, 07 Mar 2024 12:06:22 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,kirill.shutemov@linux.intel.com,david@redhat.com,dan.carpenter@linaro.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-check-new-folio-order-when-split-a-folio.patch added to mm-unstable branch
Message-Id: <20240307200622.E05A7C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: check new folio order when split a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-check-new-folio-order-when-split-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-check-new-folio-order-when-split-a-folio.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: check new folio order when split a folio
Date: Thu, 7 Mar 2024 13:18:53 -0500

A folio can only be split into lower orders.  Check new_order to make sure
it is smaller than input folio order.

Link: https://lkml.kernel.org/r/20240307181854.138928-1-zi.yan@sent.com
Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-mm/7dda9283-b437-4cf8-ab0d-83c330deb9c0@moroto.mountain/
Cc: David Hildenbrand <david@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/huge_memory.c~mm-huge_memory-check-new-folio-order-when-split-a-folio
+++ a/mm/huge_memory.c
@@ -3052,6 +3052,9 @@ int split_huge_page_to_list_to_order(str
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
 
+	if (new_order >= folio_order(folio))
+		return -EINVAL;
+
 	/* Cannot split anonymous THP to order-1 */
 	if (new_order == 1 && folio_test_anon(folio)) {
 		VM_WARN_ONCE(1, "Cannot split to order-1 folio");
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-check-new-folio-order-when-split-a-folio.patch
mm-huge_memory-skip-invalid-debugfs-new_order-input-for-folio-split.patch

