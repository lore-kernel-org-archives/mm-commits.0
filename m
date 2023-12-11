Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33C33C21
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hmTbV7FX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D21AC433C8;
	Mon, 11 Dec 2023 00:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256069;
	bh=Bs17v+jsjG8rzS5xkJafOqjBhgeJNFGjN+8Yi0Cvbak=;
	h=Date:To:From:Subject:From;
	b=hmTbV7FX8OW1GwQMrtHgBBdMRt8YIkss2YlOMbPM5+n/SKb1tO0LDamRn1ceXwOkG
	 tXJ/BVIOHL/H7JqniAQ7l+eWKm18pkAz4TG3M05d7XPS8rNYcTy6OodCPLcLPIgFWM
	 TO9zhwCSj7lrq1yXl5Gd7Fhj/QdgXLbT2mJ5u7zU=
Date: Sun, 10 Dec 2023 16:54:29 -0800
To: mm-commits@vger.kernel.org,rick.p.edgecombe@intel.com,corbet@lwn.net,akpm@linux-foundation.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-mm-drop-pte_bad-descriptions-from-arch-page-table-helpers.patch removed from -mm tree
Message-Id: <20231211005429.7D21AC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation/mm: drop pte_bad() descriptions from arch page table helpers
has been removed from the -mm tree.  Its filename was
     documentation-mm-drop-pte_bad-descriptions-from-arch-page-table-helpers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Documentation/mm: drop pte_bad() descriptions from arch page table helpers
Date: Tue, 14 Nov 2023 12:04:56 +0530

pte_bad() never existed unlike similar helpers at PMU, PUD, and PGD level.
This was added erroneously and hence should be dropped instead.

Link: https://lkml.kernel.org/r/20231114063456.339652-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/arch_pgtable_helpers.rst |    2 --
 1 file changed, 2 deletions(-)

--- a/Documentation/mm/arch_pgtable_helpers.rst~documentation-mm-drop-pte_bad-descriptions-from-arch-page-table-helpers
+++ a/Documentation/mm/arch_pgtable_helpers.rst
@@ -18,8 +18,6 @@ PTE Page Table Helpers
 +---------------------------+--------------------------------------------------+
 | pte_same                  | Tests whether both PTE entries are the same      |
 +---------------------------+--------------------------------------------------+
-| pte_bad                   | Tests a non-table mapped PTE                     |
-+---------------------------+--------------------------------------------------+
 | pte_present               | Tests a valid mapped PTE                         |
 +---------------------------+--------------------------------------------------+
 | pte_young                 | Tests a young PTE                                |
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are


