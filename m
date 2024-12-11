Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E25F1FECAA
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 03:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733886566; cv=none; b=XD4ksyRtUXjPxsaqMhHv8SoiVgLh/jgBNzUntUFigHZbSkfoqOwfbwnd9DxUWZKhDBEw9qiAudw/qFPxkTqj2DjCwvz8vahMnH1tglH6obMTzAx/giazJo2fJ1O9I9sDm7WZGmE2uVp0kBL1MojKkk6Vy/igVAwSw+Shr0O4zBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733886566; c=relaxed/simple;
	bh=/BpZpO6QnfDn7jTLt23KIFt7rOfBkWx5wOr5ozaCJAQ=;
	h=Date:To:From:Subject:Message-Id; b=R297EvGW6w5LMGMqy58B77nZJDOAhXXJp+NKckFoMvtFmZTcerWVTl5FaxKLDd6JjAPdjUE5SaDunuhHmKXzgikETEYSf+/9zPIem8UUStF0gI286nMldTwcG8tXACYx69mppOt577n6sRBKmP4teSk+GIh99BYDyjLkJIoM7kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=El05wezf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="El05wezf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99449C4CED6;
	Wed, 11 Dec 2024 03:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733886565;
	bh=/BpZpO6QnfDn7jTLt23KIFt7rOfBkWx5wOr5ozaCJAQ=;
	h=Date:To:From:Subject:From;
	b=El05wezfN/nE6ddeLkEZ1zBe093SoYv+JR0QKTOCkQMmqdD/Dvx5BERcH7NgzTEaX
	 B4X4zBLFEO+REXh3BGawucWsXzmfzmqxO3X3bKYOg34NdEPHr8JKYMBcSSZ+LQABBm
	 Ub9nS8AtUu+j2buuBuhIkmayTQ2OHy3KgfbwPU3U=
Date: Tue, 10 Dec 2024 19:09:24 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,willy@infradead.org,will@kernel.org,rientjes@google.com,peterz@infradead.org,peterx@redhat.com,muchun.song@linux.dev,mgorman@suse.de,luto@kernel.org,lorenzo.stoakes@oracle.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,catalin.marinas@arm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-recheck-dst_pmd-entry-in-move_pages_pte-fix.patch added to mm-unstable branch
Message-Id: <20241211030925.99449C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-userfaultfd-recheck-dst_pmd-entry-in-move_pages_pte-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-userfaultfd-recheck-dst_pmd-entry-in-move_pages_pte-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-recheck-dst_pmd-entry-in-move_pages_pte-fix.patch

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm-userfaultfd-recheck-dst_pmd-entry-in-move_pages_pte-fix
Date: Tue, 10 Dec 2024 16:41:56 +0800

The following WARN_ON_ONCE()s can also be expected to be triggered, so
remove them as well.

if (WARN_ON_ONCE(pmd_none(*dst_pmd)) ||  WARN_ON_ONCE(pmd_none(*src_pmd)) ||
    WARN_ON_ONCE(pmd_trans_huge(*dst_pmd)) || WARN_ON_ONCE(pmd_trans_huge(*src_pmd))

Link: https://lkml.kernel.org/r/20241210084156.89877-1-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/userfaultfd.c~mm-userfaultfd-recheck-dst_pmd-entry-in-move_pages_pte-fix
+++ a/mm/userfaultfd.c
@@ -1193,8 +1193,8 @@ retry:
 	}
 
 	/* Sanity checks before the operation */
-	if (WARN_ON_ONCE(pmd_none(*dst_pmd)) ||	WARN_ON_ONCE(pmd_none(*src_pmd)) ||
-	    WARN_ON_ONCE(pmd_trans_huge(*dst_pmd)) || WARN_ON_ONCE(pmd_trans_huge(*src_pmd))) {
+	if (pmd_none(*dst_pmd) || pmd_none(*src_pmd) ||
+	    pmd_trans_huge(*dst_pmd) || pmd_trans_huge(*src_pmd)) {
 		err = -EINVAL;
 		goto out;
 	}
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-pgtable-make-ptep_clear-non-atomic.patch
mm-khugepaged-recheck-pmd-state-in-retract_page_tables.patch
mm-userfaultfd-recheck-dst_pmd-entry-in-move_pages_pte.patch
mm-userfaultfd-recheck-dst_pmd-entry-in-move_pages_pte-fix.patch
mm-introduce-zap_nonpresent_ptes.patch
mm-introduce-do_zap_pte_range.patch
mm-skip-over-all-consecutive-none-ptes-in-do_zap_pte_range.patch
mm-zap_install_uffd_wp_if_needed-return-whether-uffd-wp-pte-has-been-re-installed.patch
mm-do_zap_pte_range-return-any_skipped-information-to-the-caller.patch
mm-make-zap_pte_range-handle-full-within-pmd-range.patch
mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed.patch
mm-pgtable-reclaim-empty-pte-page-in-madvisemadv_dontneed-fix.patch
x86-mm-free-page-table-pages-by-rcu-instead-of-semi-rcu.patch
mm-pgtable-make-ptlock-be-freed-by-rcu.patch
x86-select-arch_supports_pt_reclaim-if-x86_64.patch

