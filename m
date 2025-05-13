Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B69E1EBA0D
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119219; cv=none; b=hXLB5QnAqxFF6FO6UE0LemlrJ3VuYAKYOYcH/Q1ZqtFGUBPDLwgQkxLtfkG5uJ8CKCVq92PXdxuMQVX+hMS3elzQi0euDl0bqRe5aMBNltAMoaWUMmBu3HzTIGKUi9meTd/gKO4kShoBR58QbRGypIQofpsioBPdSTeUVgf7aHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119219; c=relaxed/simple;
	bh=E2aOE0eAaErw5sUN+HzFZkvrN4Dbn55m7OuBLeWdUfE=;
	h=Date:To:From:Subject:Message-Id; b=MKWe1jTGKYhTxeGbdHyCxoj8KNJt41cE9V4yh4psAZO4wLGwe9c337ansCOxwx790NK1VModFSg0baHDkiDAMXlB/SzvpqPLiv1CMNS5zc4kipQMhdO9Mq20/FGrWs1XdnNvi/z9qiRemjd0R8z6Qpgb9qY4UoW1xg9HAbXOVfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a/gRktaA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a/gRktaA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C9CC4CEE4;
	Tue, 13 May 2025 06:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119219;
	bh=E2aOE0eAaErw5sUN+HzFZkvrN4Dbn55m7OuBLeWdUfE=;
	h=Date:To:From:Subject:From;
	b=a/gRktaA2rbHDGoS6LRwA3KK1OjcWmDM2PZrx83G5wKQCV2BjFzGbke5bgm/2liTa
	 4SyYCm/7RGjeD81cURII46c09c4UO1QswUOZOXG+yr+7HH0sxiQSM1rCl7fMm1fowy
	 xmnjpI25WOjaaU4BbT+UPp5r+cQb00EiD9TPDfJk=
Date: Mon, 12 May 2025 23:53:38 -0700
To: mm-commits@vger.kernel.org,peterz@infradead.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] execmem-enforce-allocation-size-aligment-to-page_size.patch removed from -mm tree
Message-Id: <20250513065338.E4C9CC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: execmem: enforce allocation size aligment to PAGE_SIZE
has been removed from the -mm tree.  Its filename was
     execmem-enforce-allocation-size-aligment-to-page_size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: execmem: enforce allocation size aligment to PAGE_SIZE
Date: Wed, 23 Apr 2025 17:48:07 +0300

Before introduction of ROX cache execmem allocation size was always
implicitly aligned to PAGE_SIZE inside vmalloc.

However, when allocation happens from the ROX cache, this is not
enforced.

Make sure that the allocation size is always consistently aligned to
PAGE_SIZE.

Mike said:

: Right now it'll make the maple trees in execmem_cache more compact. 
: And it's a precaution for the case when execmem callers would want to
: change permissions on unaligned range because that would WARN_ON()
: loudly.

Peter said

: It should not have a runtime effect -- currently all this code is used
: with PAGE_SIZE multiples and everything just works.  But whilst I was
: perusing this code, I noticed that nothing actually enforced this.  If
: someone were to break this assumption things will go sideways.

Link: https://lkml.kernel.org/r/20250423144808.1619863-1-rppt@kernel.org
Fixes: 2e45474ab14f ("execmem: add support for cache of large ROX pages")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/execmem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/execmem.c~execmem-enforce-allocation-size-aligment-to-page_size
+++ a/mm/execmem.c
@@ -377,6 +377,8 @@ void *execmem_alloc(enum execmem_type ty
 	pgprot_t pgprot = range->pgprot;
 	void *p;
 
+	size = PAGE_ALIGN(size);
+
 	if (use_cache)
 		p = execmem_cache_alloc(range, size);
 	else
_

Patches currently in -mm which might be from rppt@kernel.org are


