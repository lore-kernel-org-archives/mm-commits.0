Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7D337E
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 18:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723572534; cv=none; b=oZB5Ha8s4b/i2+ZuI1ZRbAg5RmjbH38RN8E0UIcH7KkXsd2Nt5Zlwn3C9G3W5CZk4OK8HJCd1N3Yp+IBn8Dp9BT+ZrTAMa2bGgEcg9Hyy0PzjxubVuo0HnR6/GEmK5+rzmu84wZKdWxpOT0jEqbHtqg6JHqBipEae42VvM40Gv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723572534; c=relaxed/simple;
	bh=HCJNddCXgUbj9JoKZcuTdT3tgGcJe05PToNJgYnRMRo=;
	h=Date:To:From:Subject:Message-Id; b=tPUqT0H1k3/+LvTsqCyT1UMfbLAMwIfOBwI/5QeZ3Jan5HNWOJFK7p+AVHCm55PwGkqxst+BSYaLVIV+2SKyC+f2nfTEnf4ygytXWP1ehJ4UPfI0ipYaN8HQg7Kq0TElmU0WgDdb85EGiGVmdwsh0rxLcHJw8jATaaf8Y+fYruo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gEW6Y2lP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gEW6Y2lP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80D4C32782;
	Tue, 13 Aug 2024 18:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723572534;
	bh=HCJNddCXgUbj9JoKZcuTdT3tgGcJe05PToNJgYnRMRo=;
	h=Date:To:From:Subject:From;
	b=gEW6Y2lPxEM+HbBKalmzBar/ksxSYf2w3QrxwcDaOEWZ4oLIdKh40cSh6Xl6PZQly
	 rZPHocEPAz7JbGIqgwvDW+qGpu+nZQSMZPM7mMUmTHCz8Ae7s7CNedeeyrcPykRGjQ
	 CSaGE2SsaCsZJMza2otiOfb68sIfxg9lY7+FTSeA=
Date: Tue, 13 Aug 2024 11:08:53 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,hch@infradead.org,hariom1.p@samsung.com,shankerwangmiao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-add-optimization-hint-on-page-existence-check.patch added to mm-unstable branch
Message-Id: <20240813180853.E80D4C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmalloc: add optimization hint on page existence check
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-add-optimization-hint-on-page-existence-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-add-optimization-hint-on-page-existence-check.patch

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
From: Miao Wang <shankerwangmiao@gmail.com>
Subject: mm: vmalloc: add optimization hint on page existence check
Date: Wed, 14 Aug 2024 01:12:13 +0800

In commit 21e516b913c1 ("mm: vmalloc: dump page owner info if page is
already mapped"), a BUG_ON macro was changed into an if statement, where
the compiler optimization hint introduced in the BUG_ON macro was removed
along with this change.  This patch adds back the hint.

Link: https://lkml.kernel.org/r/20240814-fix_vmap_unlikely-v1-1-cd7954775f12@gmail.com
Fixes: 21e516b913c1 ("mm: vmalloc: dump page owner info if page is already mapped")
Signed-off-by: Miao Wang <shankerwangmiao@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hariom Panthi <hariom1.p@samsung.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-add-optimization-hint-on-page-existence-check
+++ a/mm/vmalloc.c
@@ -105,7 +105,7 @@ static int vmap_pte_range(pmd_t *pmd, un
 	if (!pte)
 		return -ENOMEM;
 	do {
-		if (!pte_none(ptep_get(pte))) {
+		if (unlikely(!pte_none(ptep_get(pte)))) {
 			if (pfn_valid(pfn)) {
 				page = pfn_to_page(pfn);
 				dump_page(page, "remapping already mapped page");
_

Patches currently in -mm which might be from shankerwangmiao@gmail.com are

mm-vmalloc-add-optimization-hint-on-page-existence-check.patch

