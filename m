Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB21410A1F
	for <mm-commits@vger.kernel.org>; Tue, 29 Oct 2024 00:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730163254; cv=none; b=Aq1YBNCJ8BL4LASsNeLZtHC/D7FWSxcYNPJpqCmlAiETzeoy4ctPFmQiTk6CPYL1ZbA/3vLlFk8ercvfgQgW3hFk6fUC6QWzfXXuPQiVhIpm7KmDBAYyoiduZbn3iMJ3/agIqirHoYIHWTA+3ZJmJz4uOfOisrqiC3MX0MS0cO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730163254; c=relaxed/simple;
	bh=oBR+NXYM4n40RKgx1TlL/g1GAfI93ZldEE6uLnlY8UY=;
	h=Date:To:From:Subject:Message-Id; b=FfLdi2v8WpCfhIPRiqAJK5xt3l0JhOgrF9GnUnCNg7G1HF81IfOJbRyj/6QY7tGvCEKsZ6NUlDPFfs7326Mr9TXInT8zRE8OGlS0dIvrcMaU0fojvppU7MnWY6dDkTp63oQEP5ik3BzSeBHwb5lbpSrFpKkVSX+SduslewOvdKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bn1T7Tl0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bn1T7Tl0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B00C4CEC3;
	Tue, 29 Oct 2024 00:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730163254;
	bh=oBR+NXYM4n40RKgx1TlL/g1GAfI93ZldEE6uLnlY8UY=;
	h=Date:To:From:Subject:From;
	b=bn1T7Tl0tLRWovEO0Qa847SIxvhZPteba1IQPQyZuF0BjxZbfTIIkAwnDXTmS+1eU
	 qmGrD6jg7eyOEb8rD4ofC5s+Rv+98OTO+YvZ03ZlFKyyYmYrOBPWGZWaP5qxmaUNcZ
	 89C0dvMD5Wigl70qpqlPcBtQ1eqfxEqaOiSfQ+Sc=
Date: Mon, 28 Oct 2024 17:54:13 -0700
To: mm-commits@vger.kernel.org,sui.jingfeng@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-scatterlist-use-sg_phys-helper.patch added to mm-nonmm-unstable branch
Message-Id: <20241029005414.57B00C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/scatterlist: use sg_phys() helper
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-scatterlist-use-sg_phys-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-scatterlist-use-sg_phys-helper.patch

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
From: Sui Jingfeng <sui.jingfeng@linux.dev>
Subject: lib/scatterlist: use sg_phys() helper
Date: Tue, 29 Oct 2024 02:29:20 +0800

This shorten the length of code in horizential direction, therefore is
easier to read.

Link: https://lkml.kernel.org/r/20241028182920.1025819-1-sui.jingfeng@linux.dev
Signed-off-by: Sui Jingfeng <sui.jingfeng@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/scatterlist.c~lib-scatterlist-use-sg_phys-helper
+++ a/lib/scatterlist.c
@@ -474,14 +474,14 @@ int sg_alloc_append_table_from_pages(str
 		return -EOPNOTSUPP;
 
 	if (sgt_append->prv) {
-		unsigned long next_pfn = (page_to_phys(sg_page(sgt_append->prv)) +
-			sgt_append->prv->offset + sgt_append->prv->length) / PAGE_SIZE;
+		unsigned long next_pfn;
 
 		if (WARN_ON(offset))
 			return -EINVAL;
 
 		/* Merge contiguous pages into the last SG */
 		prv_len = sgt_append->prv->length;
+		next_pfn = (sg_phys(sgt_append->prv) + prv_len) / PAGE_SIZE;
 		if (page_to_pfn(pages[0]) == next_pfn) {
 			last_pg = pfn_to_page(next_pfn - 1);
 			while (n_pages && pages_are_mergeable(pages[0], last_pg)) {
_

Patches currently in -mm which might be from sui.jingfeng@linux.dev are

scatterlist-fix-a-typo.patch
lib-scatterlist-use-sg_phys-helper.patch

