Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E3184FDA
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 18:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711477944; cv=none; b=qZAqnlxl6nQ9EydBRuIYSCtUUn1hj6mGNshE6T7Gh90sSfxN+Rh7dcILNEa+kKjd2XfoTBrLgs6B/GgFtnrLlskjCKESiemlq6lUouBWTjvYBzbc+PhQAOLLxyFisCQg0rysmUcuN55S8o6Bz/MLUhWEGnh1T0c3zCA/QwNaPTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711477944; c=relaxed/simple;
	bh=U0QVvc0+1gc5bVILXj7Ae98T1q2SyW9xu1z+qgtV4Pg=;
	h=Date:To:From:Subject:Message-Id; b=RJJsTW6F9s/ko1yZSQAr7xhC8s8mV1elXpeFrt1lceG4UT35LMIAWe3I7BNfz3+0nUMkmukgbLpXNyrgIyMw+lz8WPJylSXdojCM5u1vWvDpEgm8kkcEev3L1azOylwYuYXUEr+ltXrlYkBOWT/HqHvAJIxAWQbLdhJAznw6ckA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X/nJ1Ehb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X/nJ1Ehb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516E5C433C7;
	Tue, 26 Mar 2024 18:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711477944;
	bh=U0QVvc0+1gc5bVILXj7Ae98T1q2SyW9xu1z+qgtV4Pg=;
	h=Date:To:From:Subject:From;
	b=X/nJ1EhbQKujfGI1HKemmsZTWSobuxKvcZCfLfahSBkM8/zsVoKMn24VraVFG/3Ja
	 4wMUyQPXfRtFaO9UkX6UtpB33FeblGzGzDQyDjMuGuwnms8g1koGRnmcTy6iBABDf4
	 bAmA/V6Dj+mJ9A1PnKTjKVepCyCObLflLXgKRjAw=
Date: Tue, 26 Mar 2024 11:32:23 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,v-songbaohua@oppo.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix.patch added to mm-unstable branch
Message-Id: <20240326183224.516E5C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix.patch

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
Subject: mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix
Date: Tue Mar 26 11:30:46 AM PDT 2024

rewrap comment, per Matthew

Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/mm/vmscan.c~mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix
+++ a/mm/vmscan.c
@@ -1258,14 +1258,16 @@ retry:
 			if (folio_test_pmd_mappable(folio))
 				flags |= TTU_SPLIT_HUGE_PMD;
 			/*
-			 * Without TTU_SYNC, try_to_unmap will only begin to hold PTL
-			 * from the first present PTE within a large folio. Some initial
-			 * PTEs might be skipped due to races with parallel PTE writes
-			 * in which PTEs can be cleared temporarily before being written
-			 * new present values. This will lead to a large folio is still
-			 * mapped while some subpages have been partially unmapped after
-			 * try_to_unmap; TTU_SYNC helps try_to_unmap acquire PTL from the
-			 * first PTE, eliminating the influence of temporary PTE values.
+			 * Without TTU_SYNC, try_to_unmap will only begin to
+			 * hold PTL from the first present PTE within a large
+			 * folio. Some initial PTEs might be skipped due to
+			 * races with parallel PTE writes in which PTEs can be
+			 * cleared temporarily before being written new present
+			 * values. This will lead to a large folio is still
+			 * mapped while some subpages have been partially
+			 * unmapped after try_to_unmap; TTU_SYNC helps
+			 * try_to_unmap acquire PTL from the first PTE,
+			 * eliminating the influence of temporary PTE values.
 			 */
 			if (folio_test_large(folio) && list_empty(&folio->_deferred_list))
 				flags |= TTU_SYNC;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix.patch
mm-move-follow_phys-to-arch-x86-mm-pat-memtypec-fix.patch

