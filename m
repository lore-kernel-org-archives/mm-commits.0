Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A79217673
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188408; cv=none; b=IXdEZPOHSA8BRjldY/fD3PWIXBrX9ZaKfR4x0uVLIxPA2/xjZXfR7WHgp9uy2bwA8OWf1zOT7oByRUd+DPePlkyE0QvcFpUFo+o78KW5FatIVilXZbk1R7W7JdlMVx4OtpO8TYkUbKq2vtQaMevvn/smGMlu9sefb+W2HvCioKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188408; c=relaxed/simple;
	bh=MYrl0QKjUeGytjmHjESJV+MfoI0o9ZMws0E5hdMWC0M=;
	h=Date:To:From:Subject:Message-Id; b=Ka2KhlLqoIeICdwTIzMVWWoz5KO2Js/wJj3AEyl4olBBVJb75nr4I1LeQGV7Wc0eKhWthSetw5xPsxLgFm+/uvRFogH8ytH0kvxlm3Eu08J11MSL3rvbXpKdP5LQXAs9MLwUncFJttS2HZCDpGZsGA2kDzKSyLtkSJ3YEWmkEoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tzBaQteI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tzBaQteI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BCC3C4CEEC;
	Mon, 17 Mar 2025 05:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188408;
	bh=MYrl0QKjUeGytjmHjESJV+MfoI0o9ZMws0E5hdMWC0M=;
	h=Date:To:From:Subject:From;
	b=tzBaQteIPuKetid0AjVTTYO9zJo0sMFX643Y+8p31ePZGLh6Z6sddVaB7HX9X30Av
	 rup5KQEpL7O8mNhs/5UL3MnyEdSl5mjwJklvYy0k2sJrxAXKW65iNNV7clYiT1lWIF
	 +26H2oPOlwf4D1+w+6JMi14NgIIrgWJQwAk8eXq8=
Date: Sun, 16 Mar 2025 22:13:27 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,colin.i.king@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mincore-improve-performance-by-adding-an-unlikely-hint.patch removed from -mm tree
Message-Id: <20250317051328.2BCC3C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mincore: improve performance by adding an unlikely hint
has been removed from the -mm tree.  Its filename was
     mm-mincore-improve-performance-by-adding-an-unlikely-hint.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: mm/mincore: improve performance by adding an unlikely hint
Date: Wed, 19 Feb 2025 08:36:07 +0000

Adding an unlikely() hint on the masked start comparison error return path
improves run-time performance of the mincore system call.

Benchmarking on an i9-12900 shows an improvement of 7ns on mincore calls
on a 256KB mmap'd region where 50% of the pages we resident.  Improvement
was from ~970 ns down to 963 ns, so a small ~0.7% improvement.

Results based on running 20 tests with turbo disabled (to reduce clock
freq turbo changes), with 10 second run per test and comparing the number
of mincores calls per second.  The % standard deviation of the 20 tests
was ~0.10%, so results are reliable.

Link: https://lkml.kernel.org/r/20250219083607.5183-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Cc: Matthew Wilcow <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mincore.c~mm-mincore-improve-performance-by-adding-an-unlikely-hint
+++ a/mm/mincore.c
@@ -239,7 +239,7 @@ SYSCALL_DEFINE3(mincore, unsigned long,
 	start = untagged_addr(start);
 
 	/* Check the start address: needs to be page-aligned.. */
-	if (start & ~PAGE_MASK)
+	if (unlikely(start & ~PAGE_MASK))
 		return -EINVAL;
 
 	/* ..and we need to be passed a valid user-space range */
_

Patches currently in -mm which might be from colin.i.king@gmail.com are


