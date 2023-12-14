Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88296ABB5
	for <mm-commits@vger.kernel.org>; Thu, 14 Dec 2023 22:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wXxYSNo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21672C433C8;
	Thu, 14 Dec 2023 22:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702594134;
	bh=y6SlKcEe0o1a0GShIRqS20t2HPFJIT23V9iU/JQS3Lo=;
	h=Date:To:From:Subject:From;
	b=wXxYSNo1ctdKAsmSHckUQhogelrV92fwkzZIvAyZGWw+3nuy81B1auRbNfWE42H5w
	 NnN1w8OdPUOu+/fpqZllfbbSZ4oeU3NHqMO/ejcGLaZ4nfhB9rpD0ggQtAZRG5kQxd
	 tuhTjn+/HwnNuJtVJBb/zDYXkYMx13lQzJ+WZt1I=
Date: Thu, 14 Dec 2023 14:48:53 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,shy828301@gmail.com,cl@linux.com,riel@surriel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-align-larger-anonymous-mappings-on-thp-boundaries.patch added to mm-unstable branch
Message-Id: <20231214224854.21672C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: align larger anonymous mappings on THP boundaries
has been added to the -mm mm-unstable branch.  Its filename is
     mm-align-larger-anonymous-mappings-on-thp-boundaries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-align-larger-anonymous-mappings-on-thp-boundaries.patch

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

mm-align-larger-anonymous-mappings-on-thp-boundaries.patch

