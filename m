Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FB7AD4B
	for <mm-commits@vger.kernel.org>; Sat, 23 Aug 2025 01:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755913742; cv=none; b=iKYuFaPlytbM/KuzPmZf87lvZN3yARAgUcP4TqopmptCD9Qs46qqcp6L0+MV/lQG2WABjzH21oYAum24KSuEdhbjxRkJxG6hVuql/f2XnmXUI1t+ZGg4HvJb77EAyKqFjrrP92Jm36ETEm9T4ffxJoPjxgevsLfjaeQ36ntloAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755913742; c=relaxed/simple;
	bh=QC5i7E4EuNMP3/0mk2S3wXFYHesMrRaGZw0qXluSQnM=;
	h=Date:To:From:Subject:Message-Id; b=uP1jaNfICVFc3E8jjwK3TCZUTeNqmuEiFc+etNhsmgMd3XrAn15RxiU0VvJDWimmdWFW46cJGgjRwACGT40LvCbXFn2vPUg30bPeQMw5HIr3wWedgm8G7UOluOSoRyPLlU+lJ+GnbplFeQRjv2tWroJjbcPrTpLcnin8hT0GcIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U1rTOc0Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U1rTOc0Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F800C4CEED;
	Sat, 23 Aug 2025 01:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755913742;
	bh=QC5i7E4EuNMP3/0mk2S3wXFYHesMrRaGZw0qXluSQnM=;
	h=Date:To:From:Subject:From;
	b=U1rTOc0Z9pVUjtcTgaWfFvHcrJVlcYONcRSCf+D/gOVrNxiKjmvg9mHprngTSTO2A
	 yFJ/EHH+smKTyU2xeDu/57JGzk1P4b7+43VEvcFK4nINhoKvdmyO2SXes7F2NoQZTO
	 MNeoSricRNV+ftBGbXybuSO693XaDp9x0nIiSSyc=
Date: Fri, 22 Aug 2025 18:49:01 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vgupta@kernel.org,lorenzo.stoakes@oracle.com,lkp@intel.com,liuye@kylinos.cn,dev.jain@arm.com,david@redhat.com,chrisl@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix-fix.patch added to mm-unstable branch
Message-Id: <20250823014902.2F800C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix-fix
Date: Fri Aug 22 06:45:39 PM PDT 2025

avoid negative shifts, per Zi Yan

Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix-fix
+++ a/include/linux/mm.h
@@ -75,8 +75,8 @@ extern void * high_memory;
  * PAGE_SHIFT is the shift for page size (e.g., 12 for 4KB pages)
  * So (20 - PAGE_SHIFT) converts between pages and MB
  */
-#define PAGES_TO_KB(pages) ((pages) >> (10 - PAGE_SHIFT))
-#define KB_TO_PAGES(kb)    ((kb) << (10 - PAGE_SHIFT))
+#define PAGES_TO_KB(pages) ((pages) << (PAGE_SHIFT - 10))
+#define KB_TO_PAGES(kb)    ((kb) >> (PAGE_SHIFT - 10))
 #define PAGES_TO_MB(pages) ((pages) >> (20 - PAGE_SHIFT))
 #define MB_TO_PAGES(mb)    ((mb) << (20 - PAGE_SHIFT))
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix.patch
mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix-fix.patch
mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors-fix.patch
memcg-optimize-exit-to-user-space-fix.patch
mm-page_table_check-reinstate-address-parameter-in-page_table_check_pud_set-fix.patch
lib-sys_info-handle-sys_info_mask==0-case-fix.patch

