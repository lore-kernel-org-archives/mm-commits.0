Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBE41DA10B
	for <mm-commits@vger.kernel.org>; Sat, 19 Jul 2025 23:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752966698; cv=none; b=h5NSv/3xo38bIwY/eHe7Ap7mIeVISU/hpi2scxAkj1r1iuiIZwy3cxgI0LzbBL12MTDhouAO7XLnm6pESIntG4t8eM7wyVECHN5Oi0gmbSpnYD9Sz0hSQDZevQjwKGoRHx5JtgQm0Pk48KAR3eUoeHX5Zlq6GuUL7v1jgeufFkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752966698; c=relaxed/simple;
	bh=bJ1A+Uq9x2c8SFYVL+vigiKU2vzgcGrIfRDoTDReYlA=;
	h=Date:To:From:Subject:Message-Id; b=u1ZGxUJzVM1rZSfAu016HIgVJdzPLEbsYMm0F7VtEWQB7sNrf2/QdNTEM3dRhNNtnVbljtzH70wr49uOz1Acbm1a8c0CAzFvQHIPTpTfi4E+1r6+Ln3JlIPPd3B0YW2+vh3FDbcNPFwNYRvg/eSMjGw/ouOSxAU0lM72YVoeSss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AgVrK6sO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AgVrK6sO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47FAFC4CEE3;
	Sat, 19 Jul 2025 23:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752966698;
	bh=bJ1A+Uq9x2c8SFYVL+vigiKU2vzgcGrIfRDoTDReYlA=;
	h=Date:To:From:Subject:From;
	b=AgVrK6sOLpW+XUA3WB447K4m2TFEymp4FJUTzVJW0vdaPE8tbB5yJEKyZXFoBc7ut
	 njNDtbQz26CzV1RTZ6I90k14ao/skX63oIcEDA8gtbec9k2Az91WjivOoplPLSHH8c
	 aSpHrKo9rha46AZ+uWtvQk7EXRGNfWwMQTlnto64=
Date: Sat, 19 Jul 2025 16:11:37 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-simplify-cma_maxchunk_get.patch added to mm-new branch
Message-Id: <20250719231138.47FAFC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: cma: simplify cma_maxchunk_get()
has been added to the -mm mm-new branch.  Its filename is
     mm-cma-simplify-cma_maxchunk_get.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-simplify-cma_maxchunk_get.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Subject: mm: cma: simplify cma_maxchunk_get()
Date: Sat, 19 Jul 2025 16:54:00 -0400

The function opencodes for_each_clear_bitrange().  Fix that and drop most
of housekeeping code.

Link: https://lkml.kernel.org/r/20250719205401.399475-3-yury.norov@gmail.com
Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma_debug.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/mm/cma_debug.c~mm-cma-simplify-cma_maxchunk_get
+++ a/mm/cma_debug.c
@@ -56,16 +56,8 @@ static int cma_maxchunk_get(void *data,
 	for (r = 0; r < cma->nranges; r++) {
 		cmr = &cma->ranges[r];
 		bitmap_maxno = cma_bitmap_maxno(cma, cmr);
-		end = 0;
-		for (;;) {
-			start = find_next_zero_bit(cmr->bitmap,
-						   bitmap_maxno, end);
-			if (start >= bitmap_maxno)
-				break;
-			end = find_next_bit(cmr->bitmap, bitmap_maxno,
-					    start);
+		for_each_clear_bitrange(start, end, cmr->bitmap, bitmap_maxno)
 			maxchunk = max(end - start, maxchunk);
-		}
 	}
 	spin_unlock_irq(&cma->lock);
 	*val = (u64)maxchunk << cma->order_per_bit;
_

Patches currently in -mm which might be from yury.norov@gmail.com are

mm-cma-simplify-cma_debug_show_areas.patch
mm-cma-simplify-cma_maxchunk_get.patch

