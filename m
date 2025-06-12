Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13EE847B
	for <mm-commits@vger.kernel.org>; Thu, 12 Jun 2025 01:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749692100; cv=none; b=bSRxKBZm7qFSGpGxIw+zrROJKsd5gSUs9JoDR3lQKkkByh20C+kPtAwulC1v28EVFLi+HgxGveCkQD2d5GAjLUJIUfjHduDVRZ+Zzbqd8t8PX0pq83Nzu0Ylgq7n35LYiipnbFoMhKN4vNp6MEemBSRimj1FmDP80GDGzV5LSQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749692100; c=relaxed/simple;
	bh=Rl7SlkNo6qkD271iwp7IE+C8+GQwo8rQygN29860ogw=;
	h=Date:To:From:Subject:Message-Id; b=kmMk/2r7Kq0P/fNBOxHCsyD0kyqNFVSLzQl0UrDE+xc5x9AmkTAZB6AioPWNnXoM2xBtgUgl+dEK+32IslZbByG+pkbSJdyfAeb3zXwrU10fXVgG9dvccby0uxZUBtXvbbh18YdcDPbL18PVW794NTl81BP8LsLzTWWYKrd2Q5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DzjvtEay; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DzjvtEay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07057C4CEE3;
	Thu, 12 Jun 2025 01:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749692100;
	bh=Rl7SlkNo6qkD271iwp7IE+C8+GQwo8rQygN29860ogw=;
	h=Date:To:From:Subject:From;
	b=DzjvtEaynC9vTZ08+HIqohsYRW4dymGt/cfFsDldULSUMvKWp9Cyy59W6whDKgD2g
	 jtZeXk2gxB/V03F7blITOp9iXp2Y0uw+RfGLw2gAhc7+6pD2MHb+9+j3C/Qrj0Fhi6
	 bhZb9lXR0w4d3jH75+sICCy1T8BD4+OfPJyj5dJE=
Date: Wed, 11 Jun 2025 18:34:59 -0700
To: mm-commits@vger.kernel.org,git@elijahs.space,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-relay-use-__gfp_zero-in-relay_alloc_buf.patch added to mm-nonmm-unstable branch
Message-Id: <20250612013500.07057C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel: relay: use __GFP_ZERO in relay_alloc_buf
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-relay-use-__gfp_zero-in-relay_alloc_buf.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-relay-use-__gfp_zero-in-relay_alloc_buf.patch

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
From: Elijah Wright <git@elijahs.space>
Subject: kernel: relay: use __GFP_ZERO in relay_alloc_buf
Date: Tue, 10 Jun 2025 15:56:28 -0700

Passing the __GFP_ZERO flag to alloc_page should result in less overhead
th= an using memset()

Link: https://lkml.kernel.org/r/20250610225639.314970-3-git@elijahs.space
Signed-off-by: Elijah Wright <git@elijahs.space>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/relay.c~kernel-relay-use-__gfp_zero-in-relay_alloc_buf
+++ a/kernel/relay.c
@@ -118,7 +118,7 @@ static void *relay_alloc_buf(struct rcha
 		return NULL;
 
 	for (i = 0; i < n_pages; i++) {
-		buf->page_array[i] = alloc_page(GFP_KERNEL);
+		buf->page_array[i] = alloc_page(GFP_KERNEL | __GFP_ZERO);
 		if (unlikely(!buf->page_array[i]))
 			goto depopulate;
 		set_page_private(buf->page_array[i], (unsigned long)buf);
@@ -127,7 +127,6 @@ static void *relay_alloc_buf(struct rcha
 	if (!mem)
 		goto depopulate;
 
-	memset(mem, 0, *size);
 	buf->page_count = n_pages;
 	return mem;
 
_

Patches currently in -mm which might be from git@elijahs.space are

kernel-relay-use-__gfp_zero-in-relay_alloc_buf.patch

