Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03E614264A
	for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2024 20:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710274070; cv=none; b=Tp3bMHw3lTgwEcbE65XBCODYJllkp+wXHRIRuq7MkliPWEIGLHnsn0gcFMHmhCEGv6nRAFO4QLE1igKse7NHL4NzuN6oiBoobEzhk6FZfFi/ZgsrWwa5+uAh2gpuAJC24jI62sYFTWi5nBNSBo2L/r+4SuXcb6AoTp9+UIBaYNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710274070; c=relaxed/simple;
	bh=YyXs2ulQUkUXjp5yWRGT2lroLRNNYj5XCIbrmDErTTY=;
	h=Date:To:From:Subject:Message-Id; b=gGxFDTOa813OkDShgBVx9TlPJEDlJgi3fu6pfANKU9gfW+fWGK7m4V25C7lYPCAT+Eq+kd9xxBpn6PGcvMHYS8A7J2Igmqwv+RHUMC+1+nLIJ8AvO3Sczq5Ef4s3ET3IugtDOGjvNPllmTM6jDWd7w9fDo2KWPQv96vssoNffrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UuFIF+4b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UuFIF+4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D94C43390;
	Tue, 12 Mar 2024 20:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710274070;
	bh=YyXs2ulQUkUXjp5yWRGT2lroLRNNYj5XCIbrmDErTTY=;
	h=Date:To:From:Subject:From;
	b=UuFIF+4bbkjajjI/iZljYcVTFoosNVwnEMk6XXmSPBaYB8w5a1WcZeaCXEJk0ua9l
	 NvZrgrP/DOwccVX/MU6Ah9gLFyq4npa2vhJsM0rUReddxj9TxmUprpE1o52Duwjynf
	 RVLmc1M0JAnlxhZy0+o9gEyfuf2LJC71bu1W0mTE=
Date: Tue, 12 Mar 2024 13:07:49 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,kirill.shutemov@linux.intel.com,david@redhat.com,dan.carpenter@linaro.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-skip-invalid-debugfs-new_order-input-for-folio-split.patch removed from -mm tree
Message-Id: <20240312200750.52D94C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: skip invalid debugfs new_order input for folio split
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-skip-invalid-debugfs-new_order-input-for-folio-split.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


