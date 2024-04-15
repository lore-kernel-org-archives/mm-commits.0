Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1C715686C
	for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2024 20:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713212947; cv=none; b=pyET24aSLzGf19JoXUGYXPHLEfnn57G1mmK8IDsEq+HVtew+8Diu8dwujaaFaz7RLtZypzGTAeXaF6jyNol+Yqxx4ArvWD6D5Udu95D4RSUgLX0CeU5eEWA0thnW7m6I+D/izLKv01RYlu3WB7WjgMhaMDVv5IsIl5sRI5skjcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713212947; c=relaxed/simple;
	bh=bs4fVW4Ccr3Nl1Of9hNHA2d19xxx6XmF1ptsZftyDjU=;
	h=Date:To:From:Subject:Message-Id; b=R5uCvyBz9/Z5TXwT7i1nYG0TApJdSomCMkY3Vrm+qaHIXRLG+hFsIiLJOfDk5iW7vk9w7tNMAkzsPz5CvZReSUf/JryXQcQANzIT9HgDJ8wtRWgrt0A/LFC6LTI3Tw0czrqcxR877lyOnHlZ7oKit5lkpocR5yfyEK7hJIc5wG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pshPEWpO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pshPEWpO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FBBAC113CC;
	Mon, 15 Apr 2024 20:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713212947;
	bh=bs4fVW4Ccr3Nl1Of9hNHA2d19xxx6XmF1ptsZftyDjU=;
	h=Date:To:From:Subject:From;
	b=pshPEWpOIkVqCSyui4IpuMLbBPHoDZklODub6i1cfilXvFDKcmQxKEHo52qmBpsr1
	 J/SZ2NNUHt9ewCFUFqfW+HpfUJjDOLzQPvt8M1igDWcKTQBASioa7MJfXWfSCVwOrG
	 CJdtbjDYXmW8dmUZvp1/WrnzkozReRvVCedaQ+FA=
Date: Mon, 15 Apr 2024 13:29:06 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,linmiaohe@huawei.com,jane.chu@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios-fix.patch added to mm-unstable branch
Message-Id: <20240415202907.3FBBAC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios-fix.patch

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
Subject: mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios-fix
Date: Mon Apr 15 01:28:36 PM PDT 2024

remove unneeded `extern'

Cc: Jane Chu <jane.chu@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios-fix
+++ a/include/linux/hugetlb.h
@@ -862,7 +862,7 @@ static inline int hstate_index(struct hs
 }
 
 int dissolve_free_hugetlb_folio(struct folio *folio);
-extern int dissolve_free_hugetlb_folios(unsigned long start_pfn,
+int dissolve_free_hugetlb_folios(unsigned long start_pfn,
 				    unsigned long end_pfn);
 
 #ifdef CONFIG_MEMORY_FAILURE
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled-v2-fix.patch
selftests-harness-remove-use-of-line_max-fix.patch
mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix.patch
sh-remove-use-of-pg_arch_1-on-individual-pages-fix.patch
mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing-fix.patch
mm-allow-anon-exclusive-check-over-hugetlb-tail-pages-fix.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess-checkpatch-fixes.patch
mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch

