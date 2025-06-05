Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E18E20330
	for <mm-commits@vger.kernel.org>; Thu,  5 Jun 2025 21:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749159736; cv=none; b=UrVpHYfHHBb9B8OYwkxiQop/mCbSGX04xgU9yFCuikws5gQCghXXfKtwm9yS+MtRi/T9w3rARQr0JCw06/YeJ5QoRSd2GJ4PWqGs8BB3WdMTOd+nRI61hc0ZBB+msNuRWTbWtphLVQdXIMHduZ5PIjsNYLS+Sg1PA60uTCdaOJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749159736; c=relaxed/simple;
	bh=MHHE0dZVSm+BPJIAuLydEAs5DfbrtGfQjt3gcp+up/Q=;
	h=Date:To:From:Subject:Message-Id; b=K8rmoOChRbvlsIYndTP6pQ8MfEy/BLhLWXxedctDCOvn/2T6UHGPiDbft1IRtXcvKbKokZedXB5qpTK/0X4qpKWNR8Ek+KsVUCPou2xGyDeuSKmQNCIxQQo8/yGnCRyGxru/yXEuQFxp2wIP/53oip8BW/2p2l8glyBLz8qTdTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZFtzJSsa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZFtzJSsa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C177C4CEE7;
	Thu,  5 Jun 2025 21:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749159735;
	bh=MHHE0dZVSm+BPJIAuLydEAs5DfbrtGfQjt3gcp+up/Q=;
	h=Date:To:From:Subject:From;
	b=ZFtzJSsaRaFMZ0BytXliUErStE82GLNPDcVH1ImHM08oJufHHnlQUq826+BVDMJR4
	 Vg9JijdFsvDq6FDFEJz5hH5GMLV5rRFgKVGTt2an72+qBDy96kivFvsRkJjyC8SR6T
	 kThnhVM/zTvGS4rLj2UXD6PPryIZGgIDXvcabTmQ=
Date: Thu, 05 Jun 2025 14:42:14 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,liumartin@google.com,kaleshsingh@google.com,david@redhat.com,richardycc@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-pairing-the-trace_cma_alloc_start-finish.patch added to mm-new branch
Message-Id: <20250605214215.7C177C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/cma: pair the trace_cma_alloc_start/finish
has been added to the -mm mm-new branch.  Its filename is
     mm-cma-pairing-the-trace_cma_alloc_start-finish.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-pairing-the-trace_cma_alloc_start-finish.patch

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
From: Richard Chang <richardycc@google.com>
Subject: mm/cma: pair the trace_cma_alloc_start/finish
Date: Thu, 5 Jun 2025 07:25:32 +0000

In the bad input validation cases, there is no trace_cma_alloc_finish to
match the trace_cma_alloc_start.  Move the trace_cma_alloc_start event
after the validations.

Link: https://lkml.kernel.org/r/20250605072532.972081-1-richardycc@google.com
Signed-off-by: Richard Chang <richardycc@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Martin Liu <liumartin@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/cma.c~mm-cma-pairing-the-trace_cma_alloc_start-finish
+++ a/mm/cma.c
@@ -854,8 +854,6 @@ static struct page *__cma_alloc(struct c
 	unsigned long i;
 	const char *name = cma ? cma->name : NULL;
 
-	trace_cma_alloc_start(name, count, align);
-
 	if (!cma || !cma->count)
 		return page;
 
@@ -865,6 +863,8 @@ static struct page *__cma_alloc(struct c
 	if (!count)
 		return page;
 
+	trace_cma_alloc_start(name, count, align);
+
 	for (r = 0; r < cma->nranges; r++) {
 		page = NULL;
 
_

Patches currently in -mm which might be from richardycc@google.com are

mm-cma-pairing-the-trace_cma_alloc_start-finish.patch

