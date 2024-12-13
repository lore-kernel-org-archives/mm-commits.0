Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675E58F5E
	for <mm-commits@vger.kernel.org>; Fri, 13 Dec 2024 04:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734062470; cv=none; b=TKrK6lCZiYDUEI388FZfmJUqUwC+fVygZp6FqEvy87Y2ICHGlSQdTzejAGoGkcuqPsdJVCMy/k359Ve7nrjYoxetrgExFS8USFxsQEe3htha+4wIdlo8ChjrkD2ejplqvIgTkViIWOMztjCEzR5Yd8U+NBpl4cpWtQUwAmcLqZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734062470; c=relaxed/simple;
	bh=G0lARfDO5yOrzAV0RXMRe1yX2Pw9J5f0T6DebRbHp4A=;
	h=Date:To:From:Subject:Message-Id; b=r9oSR6Tpk209mclYn5OvFUNOcJAAEFgpkwsdGwQt78+0VeXniPlLnq7YizFqAmyQ8383/NmzkqbIpq2sgkPh0IJv3fNQWOpfY44kVRPKvKmGBn0TkjCG3Sor7JpYcyh0zxCt9DAvZ02UTndsN5+w/hJ7AsFPrlOnNXToGrCmQlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gHjlG0SI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gHjlG0SI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3EFC4CED2;
	Fri, 13 Dec 2024 04:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734062470;
	bh=G0lARfDO5yOrzAV0RXMRe1yX2Pw9J5f0T6DebRbHp4A=;
	h=Date:To:From:Subject:From;
	b=gHjlG0SIbHsNQgCNNi49tt7AlIpVBqiK78Fokyj20OktuVbX7O672K6njZ6INJBsI
	 PN1Q4j+K0FOB15DxF7LXOTa0fgq/DMyWimZePr4TF8nsDHw9w3fI9HJCU6RbtyxCCj
	 TuitwUw9KY5+IU434XgfMo+aWjTS1wQlrH2OctT4=
Date: Thu, 12 Dec 2024 20:01:09 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xarray-remove-repeat-check-in-xas_squash_marks.patch added to mm-nonmm-unstable branch
Message-Id: <20241213040109.EB3EFC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Xarray: remove repeat check in xas_squash_marks()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xarray-remove-repeat-check-in-xas_squash_marks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xarray-remove-repeat-check-in-xas_squash_marks.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: Xarray: remove repeat check in xas_squash_marks()
Date: Fri, 13 Dec 2024 20:25:22 +0800

Caller of xas_squash_marks() has ensured xas->xa_sibs is non-zero.  Just
remove repeat check of xas->xa_sibs in xas_squash_marks().

Link: https://lkml.kernel.org/r/20241213122523.12764-5-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xarray.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/lib/xarray.c~xarray-remove-repeat-check-in-xas_squash_marks
+++ a/lib/xarray.c
@@ -128,9 +128,6 @@ static void xas_squash_marks(const struc
 	unsigned int mark = 0;
 	unsigned int limit = xas->xa_offset + xas->xa_sibs + 1;
 
-	if (!xas->xa_sibs)
-		return;
-
 	do {
 		unsigned long *marks = xas->xa_node->marks[mark];
 		if (find_next_bit(marks, limit, xas->xa_offset + 1) == limit)
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

xarray-do-not-return-sibling-entries-from-xas_find_marked.patch
xarray-move-forward-index-correctly-in-xas_pause.patch
xarray-distinguish-large-entries-correctly-in-xas_split_alloc.patch
xarray-remove-repeat-check-in-xas_squash_marks.patch
xarray-use-xa_mark_t-in-xas_squash_marks-to-keep-code-consistent.patch

