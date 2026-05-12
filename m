Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE30394499
	for <mm-commits@vger.kernel.org>; Tue, 12 May 2026 22:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778626175; cv=none; b=O5WmMVxRklpOrTbfr3Wn9Cc/Kx3LRE505JmHyrIiGg6MyO4v1RXqQegBGf0hEp3Ye0I45x6Mlo+EM/wLgoN3oCrqxGatORBLDvKZx1+GftJ/rmd5IRNRvVl+reqXyVZfq0PJ7rY2L79C58S4QWiyGYiCpDU6c4n/lBBOhZlMjiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778626175; c=relaxed/simple;
	bh=PvdsKumesBAm1xG9UBvy8mbppTQNs13p2zUiCc1ujPQ=;
	h=Date:To:From:Subject:Message-Id; b=bDKViOA8i08xb9aK9StG9ffu7dWncYbDXbfcFlJZlbupflytjp0Ulvo9KUzlEBqhhy2X5dQmkl0kQiSWeTg80Ig+xjizGofL0GivhHVp9gdYGi9mvLjBSKWKH0MOJ9jji79yGMkog48cymr90CYixxH6smNGKFRIAL7sASjoM0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vspy4peB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vspy4peB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E78C2BCF6;
	Tue, 12 May 2026 22:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778626174;
	bh=PvdsKumesBAm1xG9UBvy8mbppTQNs13p2zUiCc1ujPQ=;
	h=Date:To:From:Subject:From;
	b=vspy4peBbbt2JFM6qVct0IrjfSAzfsQ1W3vGOlPJVmZTiND8OZwV2Q9qGMSyjxz6Z
	 H2D2qy2tETF78yuw5sw02Nv6K3myfrDbvwmB85DUrO6fLMbCO4Nbcc9AES90nyH+6v
	 +OR+u6MM0wdGNLP1DXmGEZOGHjRYs9JTmO7ueNPE=
Date: Tue, 12 May 2026 15:49:31 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dodam@google.com,dennis@kernel.org,cl@linux.com,joonwonkang@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu-fix-wrong-chunk-hints-update.patch added to mm-new branch
Message-Id: <20260512224934.24E78C2BCF6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: percpu: fix wrong chunk hints update
has been added to the -mm mm-new branch.  Its filename is
     percpu-fix-wrong-chunk-hints-update.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu-fix-wrong-chunk-hints-update.patch

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
From: Joonwon Kang <joonwonkang@google.com>
Subject: percpu: fix wrong chunk hints update
Date: Sun, 10 May 2026 07:21:46 +0000

Chunk end offset was set to a block end offset, which could prevent chunk
hints from being updated correctly.  It was observed that the chunk free
size gets minus or shorter than the actual free size due to this.  This
commit fixes it.

Link: https://lore.kernel.org/20260510072149.1279887-1-joonwonkang@google.com
Fixes: 92c14cab4326 ("percpu: convert chunk hints to be based on pcpu_block_md")
Signed-off-by: Joonwon Kang <joonwonkang@google.com>
Reviewed-by: Dennis Zhou <dennis@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: <dodam@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/percpu.c~percpu-fix-wrong-chunk-hints-update
+++ a/mm/percpu.c
@@ -1054,7 +1054,7 @@ static void pcpu_block_update_hint_free(
 	else
 		pcpu_block_update(&chunk->chunk_md,
 				  pcpu_block_off_to_off(s_index, start),
-				  end);
+				  pcpu_block_off_to_off(e_index, end));
 }
 
 /**
_

Patches currently in -mm which might be from joonwonkang@google.com are

percpu-fix-wrong-chunk-hints-update.patch
percpu-do-not-trust-hint-starts-when-they-are-not-set.patch
percpu-introduce-struct-pcpu_region.patch
percpu-fix-hint-invariant-breakage.patch

