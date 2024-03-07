Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6F81369B9
	for <mm-commits@vger.kernel.org>; Thu,  7 Mar 2024 20:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709841984; cv=none; b=ufFbGLvA9RGMHwbl3XTRpZKk6Wx1SG7MBhbq6yrZJ+jlulKyiON4llRTacx6kn1XUb9eowF+avyQ1qAvExIcqCLvlGjEOZAgL0DV/LLLmF0Jkr8eFqcBPznQWrsJZ2Rcuz4pMsKodBDMYJs18d59yM8Ar+pP3BVkbBJC9ILh07s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709841984; c=relaxed/simple;
	bh=YuxGgIBvmD6mzoKrE/YGWoaMX2kh0Fk0DmlPWYsIPOQ=;
	h=Date:To:From:Subject:Message-Id; b=NomJthhc6EfVwlYSAnsDpoH7ynlakJz1GinzszwPouQbiZwWmDdczugbLfcy28wwW6wa790rr1mdcoXMRV4VICs6Vpfhm9Wz8kHXPnJM7rYaFRfVIkPFIgyQNzHvhqQadimC5C0Z+zuj9rqa4HJZmLFWHaw4ZlSQIH9MORas0Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h8KJQf09; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h8KJQf09"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C96C43390;
	Thu,  7 Mar 2024 20:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709841984;
	bh=YuxGgIBvmD6mzoKrE/YGWoaMX2kh0Fk0DmlPWYsIPOQ=;
	h=Date:To:From:Subject:From;
	b=h8KJQf09txdB8/bk+iaJJUbdGnMBRbgtOQckgoxeGuyi9KUDN45FhCxSlLIemZ3Sd
	 V4OYR6lNEPpbKWsH+jMxYq0hYN0Unz5nzEox7A5lFOi3mFoEDiAI92MaFS+P+VXR+E
	 a8cxCCNCl0EDNDO/zt4Fv+jllAfU+gnpkSXnA29I=
Date: Thu, 07 Mar 2024 12:06:23 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,kirill.shutemov@linux.intel.com,david@redhat.com,dan.carpenter@linaro.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-skip-invalid-debugfs-new_order-input-for-folio-split.patch added to mm-unstable branch
Message-Id: <20240307200624.64C96C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: skip invalid debugfs new_order input for folio split
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-skip-invalid-debugfs-new_order-input-for-folio-split.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-skip-invalid-debugfs-new_order-input-for-folio-split.patch

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
Subject: mm/huge_memory: skip invalid debugfs new_order input for folio split
Date: Thu, 7 Mar 2024 13:18:54 -0500

User can put arbitrary new_order via debugfs for folio split test. 
Although new_order check is added to split_huge_page_to_list_order() in
the prior commit, these two additional checks can avoid unnecessary folio
locking and split_folio_to_order() calls.

Link: https://lkml.kernel.org/r/20240307181854.138928-2-zi.yan@sent.com
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

 mm/huge_memory.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/huge_memory.c~mm-huge_memory-skip-invalid-debugfs-new_order-input-for-folio-split
+++ a/mm/huge_memory.c
@@ -3486,6 +3486,9 @@ static int split_huge_pages_pid(int pid,
 		if (!is_transparent_hugepage(folio))
 			goto next;
 
+		if (new_order >= folio_order(folio))
+			goto next;
+
 		total++;
 		/*
 		 * For folios with private, split_huge_page_to_list_to_order()
@@ -3553,6 +3556,9 @@ static int split_huge_pages_in_file(cons
 		total++;
 		nr_pages = folio_nr_pages(folio);
 
+		if (new_order >= folio_order(folio))
+			goto next;
+
 		if (!folio_trylock(folio))
 			goto next;
 
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-check-new-folio-order-when-split-a-folio.patch
mm-huge_memory-skip-invalid-debugfs-new_order-input-for-folio-split.patch

