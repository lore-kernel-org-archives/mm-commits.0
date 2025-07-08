Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8452CBE6C
	for <mm-commits@vger.kernel.org>; Tue,  8 Jul 2025 01:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751939038; cv=none; b=uGzzGiGDAkImmfUx6WKgNG7mWBy7rob0nEUb4sEOLu5MTSBFQnTxJgEFKMmg+QubPzCBq8y09m/u+RWNgsO6Hc38sf9Lg0v+XPhoTkU4dNq7awYrtXIZ2T8A3K3CgI7j+tWA1pde4vbHE+sbLqN7Hwky/s/e6Iq0F7+gKJoXJTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751939038; c=relaxed/simple;
	bh=dOv5Tbh0bgURj4jXJm5J0O8ebt6S142MoIxPSRBzXnM=;
	h=Date:To:From:Subject:Message-Id; b=fKXmG0Quf7KtWJ/2K/jom3/oI9jhXsPnd3rf7qKEJ1gwIIKeE9eW2OXePHKGGPJFZrFM07jVkMNcQb1ax1k6NgGD07rwjb8uMk7g4gesjo3YGYlEn1HS7tr6YXBgYdy66Q5fdjz2PWtjCLQeIqJgAR9ZLA2onkOE9rVtCn7qz5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MbsQtSKf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MbsQtSKf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E589C4CEE3;
	Tue,  8 Jul 2025 01:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751939036;
	bh=dOv5Tbh0bgURj4jXJm5J0O8ebt6S142MoIxPSRBzXnM=;
	h=Date:To:From:Subject:From;
	b=MbsQtSKf0/y9nIZ/LgyVFOOaXyiosQHfvOoUoEme/czqQZb83H0Qe72FS05TO7waU
	 m/j5y8jJ/i26sc5cq0zVdyLcsvK95c6pQI8Tn6mGFrdjDPT5YgwkNRt3Xv5Hlsy/RC
	 Yzu5EPgIFrjIPmhFwPUp9UIeMv/oGNr3zwOxq4w8=
Date: Mon, 07 Jul 2025 18:43:55 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,jhubbard@nvidia.com,gourry@gourry.net,david@redhat.com,byungchul@sk.com,apopple@nvidia.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-remove-the-eexist-conversion-for-move_pages.patch added to mm-new branch
Message-Id: <20250708014356.8E589C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate: remove the -EEXIST conversion for move_pages()
has been added to the -mm mm-new branch.  Its filename is
     mm-migrate-remove-the-eexist-conversion-for-move_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-remove-the-eexist-conversion-for-move_pages.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/migrate: remove the -EEXIST conversion for move_pages()
Date: Mon, 7 Jul 2025 06:57:11 +0000

The -EEXIST conversion is introduced in commit 65462462ffb2 ("mm/gup:
follow_pfn_pte(): -EEXIST cleanup"), since follow_page() may call
follow_pfn_pte() which may return -EEXIST.

But after commit 7dff875c9436 ("mm/migrate: convert
add_page_for_migration() from follow_page() to folio_walk"), it use
folio_walk instead.  This limit the error code and won't return -EEXIST.

Remove the error code conversion here.

Link: https://lkml.kernel.org/r/20250707065711.18056-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/mm/migrate.c~mm-migrate-remove-the-eexist-conversion-for-move_pages
+++ a/mm/migrate.c
@@ -2361,13 +2361,6 @@ static int do_pages_move(struct mm_struc
 		}
 
 		/*
-		 * The move_pages() man page does not have an -EEXIST choice, so
-		 * use -EFAULT instead.
-		 */
-		if (err == -EEXIST)
-			err = -EFAULT;
-
-		/*
 		 * If the page is already on the target node (!err), store the
 		 * node, otherwise, store the err.
 		 */
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

maple_tree-fix-mt_destroy_walk-on-root-leaf-node.patch
mm-migrate-remove-the-eexist-conversion-for-move_pages.patch

