Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2514BF4F1
	for <mm-commits@vger.kernel.org>; Mon, 18 Aug 2025 02:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755484135; cv=none; b=dreMaItr2KRw39YS/7xj8y77niZV9RH6ttjFiHoNU0v3gtPWVac6H3+Imwt3C4aau1VlYdfXIIq3SU5MEghNPfxEMyCKzNxnTirNHLilDDsoDP48wOP0GzbJOyOL1YxDKWq1APCigPJGqWpzZE5hKW28slsTogdnqXAOxazYaqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755484135; c=relaxed/simple;
	bh=/wwrROTMVn8Qh0bDX5GbEBhNvbN7VzQ2Jo+PMEvfjaM=;
	h=Date:To:From:Subject:Message-Id; b=YzelxaicMulLPrd8y9g5x9i1aLIH+bq532dJoHNjjBEoNF7zZ8LKMAi0Yt/mIuT2xHrff7x50hCFxYcrCgMn60M0Ym9Es15O+yzXwhst4COAdsySRWc1+Wx7fwNwobdmL/2YgOeCJoWOIdJVkhD4SPTDcLl/LKl15ckOgJE5Tf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UAMp08bi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UAMp08bi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707C0C4CEEB;
	Mon, 18 Aug 2025 02:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755484134;
	bh=/wwrROTMVn8Qh0bDX5GbEBhNvbN7VzQ2Jo+PMEvfjaM=;
	h=Date:To:From:Subject:From;
	b=UAMp08bixZBbVFMdy3qVXTIqYjEJbq1KHGOh0PXzql3CFX64wL9RmvbhNmux0dU/2
	 7+OFiuoUKjFeU64nfON45U9vNMRvv/re+5+e0yg2XyJ9LqpL/DoB3qhuY86VHHTSvm
	 3c1TZbGlNj1gJsjUQyy2i6FbxPLPLcX3AZD2xZPw=
Date: Sun, 17 Aug 2025 19:28:53 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,hch@infradead.org,chizhiling@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-do-not-use-is_partially_uptodate-for-entire-folio.patch added to mm-new branch
Message-Id: <20250818022854.707C0C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/filemap: do not use is_partially_uptodate for entire folio
has been added to the -mm mm-new branch.  Its filename is
     mm-filemap-do-not-use-is_partially_uptodate-for-entire-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-do-not-use-is_partially_uptodate-for-entire-folio.patch

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
From: Chi Zhiling <chizhiling@kylinos.cn>
Subject: mm/filemap: do not use is_partially_uptodate for entire folio
Date: Mon, 28 Jul 2025 16:39:51 +0800

Patch series "Tiny optimization for large read operations".

This series contains two patches,

1. Skip calling is_partially_uptodate for entire folio to save time, I
   have reviewed the mpage and iomap implementations and didn't spot any
   issues, but this change likely needs more thorough review.

2. Skip calling filemap_uptodate if there are ready folios in the
   batch, This might save a few milliseconds in practice, but I didn't
   observe measurable improvements in my tests.


This patch (of 2):

When a folio is marked as non-uptodate, it means the folio contains some
non-uptodate data.  Therefore, calling is_partially_uptodate() to recheck
the entire folio is redundant.

If all data in a folio is actually up-to-date but the folio lacks the
uptodate flag, it will still be treated as non-uptodate in many other
places.  Thus, there should be no special case handling for filemap.

Link: https://lkml.kernel.org/r/20250728083952.75518-1-chizhiling@163.com
Link: https://lkml.kernel.org/r/20250728083952.75518-2-chizhiling@163.com
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/filemap.c~mm-filemap-do-not-use-is_partially_uptodate-for-entire-folio
+++ a/mm/filemap.c
@@ -2447,6 +2447,9 @@ static bool filemap_range_uptodate(struc
 		pos -= folio_pos(folio);
 	}
 
+	if (pos == 0 && count >= folio_size(folio))
+		return false;
+
 	return mapping->a_ops->is_partially_uptodate(folio, pos, count);
 }
 
_

Patches currently in -mm which might be from chizhiling@kylinos.cn are

mm-filemap-do-not-use-is_partially_uptodate-for-entire-folio.patch
mm-filemap-skip-non-uptodate-folio-if-there-are-available-folios.patch

