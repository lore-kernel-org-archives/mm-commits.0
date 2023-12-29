Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACAA312B9B
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QS3BXN44"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5705AC433C7;
	Fri, 29 Dec 2023 19:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703876840;
	bh=mp/xsSUIiX9QgdQOI3egInXDtomQiO+MWyL9H5ynZ0o=;
	h=Date:To:From:Subject:From;
	b=QS3BXN44eaVBcYCbzRXw1OFWkyaHwXz3QpMkw00yCFyUB/YUWulguSnkHI4PKvRvL
	 Y75+dkZ3BjVwJYUgo4IS/LtwRI8QsJGs9Sbj6xdmP62fGasvE1PtM5gLTXbogCRvnf
	 Xg8KSG0Jxk9g9gKJMjpFBiAE/eM+gFNM/aIKSje4=
Date: Fri, 29 Dec 2023 11:07:19 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,shy828301@gmail.com,cl@linux.com,riel@surriel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-align-larger-anonymous-mappings-on-thp-boundaries.patch removed from -mm tree
Message-Id: <20231229190720.5705AC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: align larger anonymous mappings on THP boundaries
has been removed from the -mm tree.  Its filename was
     mm-align-larger-anonymous-mappings-on-thp-boundaries.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rik van Riel <riel@surriel.com>
Subject: mm: align larger anonymous mappings on THP boundaries
Date: Thu, 14 Dec 2023 14:34:23 -0800

Align larger anonymous memory mappings on THP boundaries by going through
thp_get_unmapped_area if THPs are enabled for the current process.

With this patch, larger anonymous mappings are now THP aligned.  When a
malloc library allocates a 2MB or larger arena, that arena can now be
mapped with THPs right from the start, which can result in better TLB hit
rates and execution time.

Link: https://lkml.kernel.org/r/20220809142457.4751229f@imladris.surriel.com
Link: https://lkml.kernel.org/r/20231214223423.1133074-1-yang@os.amperecomputing.com
Signed-off-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christopher Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/mmap.c~mm-align-larger-anonymous-mappings-on-thp-boundaries
+++ a/mm/mmap.c
@@ -1829,6 +1829,9 @@ get_unmapped_area(struct file *file, uns
 		 */
 		pgoff = 0;
 		get_area = shmem_get_unmapped_area;
+	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
+		/* Ensures that larger anonymous mappings are THP aligned. */
+		get_area = thp_get_unmapped_area;
 	}
 
 	addr = get_area(file, addr, len, pgoff, flags);
_

Patches currently in -mm which might be from riel@surriel.com are


