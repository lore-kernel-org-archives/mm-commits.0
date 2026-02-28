Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69789301460
	for <mm-commits@vger.kernel.org>; Sat, 28 Feb 2026 21:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772315351; cv=none; b=BlNLZ5Vrfkavc+dIcrDyTKsgEXtHPQUuuWw0Xl2rjJLsjkZyRkOW+kfzK/2CGFOygXl+uXem86hljmwe4bZ79blEYRabhj2EPhb5f8BHkLt8vl2EZNN4Y1i4nf8y0VVpkKU/ESckF5dQB1mr8LTxMWDuqAZ2Chm2O3tOtV7z8T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772315351; c=relaxed/simple;
	bh=d2hb0JkUThYZdl+OlCkxHedo9Wi/IKfVoiJxLbJjLhQ=;
	h=Date:To:From:Subject:Message-Id; b=C0kesdl/ASZt56CLd7IMmXjA2FrifHvVJJZzyjPx1NT/Ftnx+11GeBR+Wwx3yFV1+1jRYASDqQ+PL24Vrcs+ofN/xjCsLgJ5Q1z4pIfCJ9pj4yR5JMvWvWMMNFEnRWyfVHg5hhH2Smx7rp/hm0MhwfA6iiGQEwlHRE5hh2LT7Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QdLyqaOE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QdLyqaOE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2FABC116D0;
	Sat, 28 Feb 2026 21:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772315350;
	bh=d2hb0JkUThYZdl+OlCkxHedo9Wi/IKfVoiJxLbJjLhQ=;
	h=Date:To:From:Subject:From;
	b=QdLyqaOEP2i58BIA8kOvrw91YYwBjpaNbZvQjXwguQ2MsWyRUwuw40eoS/4Gt5bPC
	 Gs+8514H8josHUD3uDmxZBJw++y3wbpEeWB0czJ92l4HSnfyRiR2WVc31kI+5nMbDV
	 kDUr5gLuNgK7c0phN0uiYRmnlNeMMATvhdeQN+1U=
Date: Sat, 28 Feb 2026 13:49:10 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,rppt@kernel.org,lorenzo.stoakes@oracle.com,david@kernel.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-replace-read_once-in-pud_trans_unstable.patch added to mm-new branch
Message-Id: <20260228214910.B2FABC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: replace READ_ONCE() in pud_trans_unstable()
has been added to the -mm mm-new branch.  Its filename is
     mm-replace-read_once-in-pud_trans_unstable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-replace-read_once-in-pud_trans_unstable.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm: replace READ_ONCE() in pud_trans_unstable()
Date: Fri, 27 Feb 2026 04:03:00 +0000

Replace READ_ONCE() with the existing standard page table accessor for PUD
aka pudp_get() in pud_trans_unstable().  This does not create any
functional change for platforms that do not override pudp_get(), which
still defaults to READ_ONCE().

Link: https://lkml.kernel.org/r/20260227040300.2091901-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: SeongJae Park <sj@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/pgtable.h~mm-replace-read_once-in-pud_trans_unstable
+++ a/include/linux/pgtable.h
@@ -2042,7 +2042,7 @@ static inline int pud_trans_unstable(pud
 {
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
 	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
-	pud_t pudval = READ_ONCE(*pud);
+	pud_t pudval = pudp_get(pud);
 
 	if (pud_none(pudval) || pud_trans_huge(pudval))
 		return 1;
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-debug_vm_pgtable-replace-write_once-with-pxd_clear.patch
mm-replace-read_once-in-pud_trans_unstable.patch

