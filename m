Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062BF28467B
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126229; cv=none; b=l01OTjks4NK/xUxZUcICyz0KXINC6z/Y7DC7vA4kJtkuOegjnOTXwMhVCrVZ1uhZ382I35s7k+j4/EtDGMFhdYgIGz15sbFoubHj1y9LeIi0qbKfA2rXloTzg3o1sx59c/dsjTvgIzlqcHzTHQiISluOZooAwQxSuvaw2b6av/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126229; c=relaxed/simple;
	bh=g0kw1hhOzYXUyty7K+bI0QIAQ5QCioAXsHt6EBGVvGs=;
	h=Date:To:From:Subject:Message-Id; b=nzrX8Q1WQ5p86r3i57/7hy4VtWonalQ9iusGbLnpXBdWkRBsENyj/G0DCreeeMmqKICV1vv43y9kg89BnulyTSRex704DkFLlLX6XEMWx2UCfMJu3x+rgvPzwLxyVQNKJk8579ZIJerUsHGDy/Wm8MRrbShT8nMIO6thGkX6kzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s8K9aLXN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s8K9aLXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE41FC4CEE3;
	Thu, 10 Jul 2025 05:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126228;
	bh=g0kw1hhOzYXUyty7K+bI0QIAQ5QCioAXsHt6EBGVvGs=;
	h=Date:To:From:Subject:From;
	b=s8K9aLXN6FelN1Qffumpll7ZKmcOW/Cm7LKT/1HvxXow+srPvC5CQXH5PahhTdCmn
	 Moxgijz/Qauf6yuXG12X8jSJGpMH5fOOCv1jutKGGkV+Ier/0uO1PI8UK5uMI3rcba
	 pBpKholhCCn+Z0W3G3GTU3iwhKYyatucv+fLmyqM=
Date: Wed, 09 Jul 2025 22:43:48 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,liumartin@google.com,kaleshsingh@google.com,david@redhat.com,richardycc@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cma-pairing-the-trace_cma_alloc_start-finish.patch removed from -mm tree
Message-Id: <20250710054348.CE41FC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/cma: pair the trace_cma_alloc_start/finish
has been removed from the -mm tree.  Its filename was
     mm-cma-pairing-the-trace_cma_alloc_start-finish.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


