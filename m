Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCB82D3EEB
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 05:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787894700; cv=none; b=cKC/SINbl4ZkGQ+FbuJcdPjWULQ/W3DqWaRjpLsg9hYUohljy3fHC+oxOX5j8A3Oiwp8QIeWAQFGnR+s4gYOGHKf5o4NtP7ILKzmGwwi+7ic+HZiVWXC8AO96hSBhbWUmaO9xdqqgs7DYpxaZGIJChvFnP461d774iVuUO58TC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787894700; c=relaxed/simple;
	bh=1Rqh+evbtUrQm8uV5rkd2pp0NUuKGU4JyjwJLTBtFGw=;
	h=Date:To:From:Subject:Message-Id; b=o8ERltX/hTgHPCCTdrIGU1pgP7eMNmdVSoQ/oXbndSPZIZGNnp//B1XhXD+TXSy6jtTheWagfbPn1bUoLp+kVnG9odSsaY0k3cBY+qpHYoIILrwJgRu5KUP8qxLu9sJpaz1TncU8GD4MDl1zaC8+Jv4J/RM9+ga1SoSOMaqYxVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zOZOQepq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zOZOQepq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32031F000E9;
	Fri, 28 Aug 2026 05:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787894698;
	bh=qYjSraUfFjqbaWaw+Pz0cz2ruDzQi3BUjxjKigzCGKM=;
	h=Date:To:From:Subject;
	b=zOZOQepq4i4d2We3momjDVN0JHUPQEaIImXAkz1zpT0Vrt3HkMX/qMwPBxOmfhkmy
	 asjTpahuUcgU/vM2IMmuMddZcr3Uko9v5m3tPmpUm8VBPPs6Rp5EjJLZEI3HnckJmm
	 h+dNVuvqOpe0m2a4i6MiQZb9NbCR0W5hu82vAZf8=
Date: Thu, 27 Aug 2026 22:24:58 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,linmiaohe@huawei.com,david@kernel.org,xialonglong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-warn-instead-of-silently-bailing-gigantic-pages-without-runtime-support.patch added to mm-new branch
Message-Id: <20260828052458.A32031F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: warn instead of silently bailing gigantic pages without runtime support
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-warn-instead-of-silently-bailing-gigantic-pages-without-runtime-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-warn-instead-of-silently-bailing-gigantic-pages-without-runtime-support.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Longlong Xia <xialonglong@kylinos.cn>
Subject: mm/hugetlb: warn instead of silently bailing gigantic pages without runtime support
Date: Sun, 23 Aug 2026 12:40:52 +0800

remove_hugetlb_folio() and __update_and_free_hugetlb_folio() silently
return for gigantic hstates that lack runtime freeing support.  All
callers should already filter such hstates upstream, so turn the silent
bail into a VM_WARN_ON_ONCE to catch caller regressions instead of masking
them.

Link: https://lore.kernel.org/20260823044118.1097121-3-xialonglong2025@163.com
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Assisted-by: Codex:gpt-5.6-sol
Cc: David Hildenbrand <david@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-warn-instead-of-silently-bailing-gigantic-pages-without-runtime-support
+++ a/mm/hugetlb.c
@@ -1396,8 +1396,11 @@ void remove_hugetlb_folio(struct hstate
 	VM_BUG_ON_FOLIO(hugetlb_cgroup_from_folio_rsvd(folio), folio);
 
 	lockdep_assert_held(&hugetlb_lock);
-	if (hstate_is_gigantic_no_runtime(h))
+	if (hstate_is_gigantic_no_runtime(h)) {
+		/* Callers must filter gigantic_no_runtime upstream. */
+		VM_WARN_ON_ONCE(1);
 		return;
+	}
 
 	list_del(&folio->lru);
 
@@ -1458,8 +1461,11 @@ static void __update_and_free_hugetlb_fo
 {
 	bool clear_flag = folio_test_hugetlb_vmemmap_optimized(folio);
 
-	if (hstate_is_gigantic_no_runtime(h))
+	if (hstate_is_gigantic_no_runtime(h)) {
+		/* Callers must filter gigantic_no_runtime upstream. */
+		VM_WARN_ON_ONCE(1);
 		return;
+	}
 
 	/*
 	 * If we don't know which subpages are hwpoisoned, we can't free
_

Patches currently in -mm which might be from xialonglong@kylinos.cn are

mm-hugetlb-do-not-dissolve-gigantic-pages-without-runtime-support.patch
mm-hugetlb-warn-instead-of-silently-bailing-gigantic-pages-without-runtime-support.patch

