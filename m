Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85E41552E4;
	Thu, 26 Sep 2024 21:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727384654; cv=none; b=WMtzPWmbBRIbinQuJLvW4IJFUvdj/4f2YC/RMcOIx1kYaZxoKaokPdrQweTn1cr588N4SkOYlmC9xB5ks8bcEAt4R6ywZTyUZtrfgu+ebrCfS+dDLc3GXkkbdQvpWFJ2sG4EjpeGpma6xFl/uc296pfzEsWUuC2L9yHGAimb/eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727384654; c=relaxed/simple;
	bh=JTEhPHV9meR7yy4NVqMGy5BuQKNLtgO5e+sEk6vYs+k=;
	h=Date:To:From:Subject:Message-Id; b=Hzlc1/pM2sjBYPurnwkk3IiRz8+uqZufo8AJfP1nritw1VvCtAKjSqXcFwbfF9Js22Hx15eCVvXvo19cNy8989ggQ6nM9ywn+YhoVG1vkgDLn0MOs3vTLjmqGvzLQ39hFpxIpX+d/qLQCHvH/pLKQY0V/IcJUPm0FLrHryNT3oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KStJvPmg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KStJvPmg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF53C4CEC5;
	Thu, 26 Sep 2024 21:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727384653;
	bh=JTEhPHV9meR7yy4NVqMGy5BuQKNLtgO5e+sEk6vYs+k=;
	h=Date:To:From:Subject:From;
	b=KStJvPmgQDthceTkTpPzONyTuDmRJghgEoy79zKiSR+PpkAQdzNYp7DAO/Tedc5ay
	 +QzVhYBvsunDbL8ZDXBMSkl5+DPWHY4VuPrq3gtqHGAssNPliVa7y925LHFr8nz90Z
	 NnzFv9IXWpCZ8cI0qESCdDbHcSNzv8mSPxcxIUts=
Date: Thu, 26 Sep 2024 14:04:12 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vivek.kasireddy@intel.com,stable@vger.kernel.org,peterx@redhat.com,muchun.song@linux.dev,jgg@nvidia.com,david@redhat.com,steven.sistare@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-gup-fix-memfd_pin_folios-alloc-race-panic.patch removed from -mm tree
Message-Id: <20240926210413.6CF53C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: fix memfd_pin_folios alloc race panic
has been removed from the -mm tree.  Its filename was
     mm-gup-fix-memfd_pin_folios-alloc-race-panic.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Steve Sistare <steven.sistare@oracle.com>
Subject: mm/gup: fix memfd_pin_folios alloc race panic
Date: Tue, 3 Sep 2024 07:25:21 -0700

If memfd_pin_folios tries to create a hugetlb page, but someone else
already did, then folio gets the value -EEXIST here:

        folio = memfd_alloc_folio(memfd, start_idx);
        if (IS_ERR(folio)) {
                ret = PTR_ERR(folio);
                if (ret != -EEXIST)
                        goto err;

then on the next trip through the "while start_idx" loop we panic here:

        if (folio) {
                folio_put(folio);

To fix, set the folio to NULL on error.

Link: https://lkml.kernel.org/r/1725373521-451395-6-git-send-email-steven.sistare@oracle.com
Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
Acked-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/gup.c~mm-gup-fix-memfd_pin_folios-alloc-race-panic
+++ a/mm/gup.c
@@ -3702,6 +3702,7 @@ long memfd_pin_folios(struct file *memfd
 					ret = PTR_ERR(folio);
 					if (ret != -EEXIST)
 						goto err;
+					folio = NULL;
 				}
 			}
 		}
_

Patches currently in -mm which might be from steven.sistare@oracle.com are


