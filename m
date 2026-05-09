Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D262472AF
	for <mm-commits@vger.kernel.org>; Sat,  9 May 2026 01:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778290457; cv=none; b=fdoi70YS4BqVhvAAXGjri6xY0+PeaawlX6YHZOgi9TIZ7jKVe0Bu6IW/NWla+6X5zFYa2YV84+arnYadFw6+759CVy9Y8NPsCqahZGhKMnIeBLGGHcEleVhtaRfDOPlG0Q6UhvGvt/9dORNbVL7it9jQjt5UXAU90f6QqWjLMF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778290457; c=relaxed/simple;
	bh=gRXi7DiQW7PWPlZPj65vdR562IbDKPYbUOZzuFgISJA=;
	h=Date:To:From:Subject:Message-Id; b=kLhcCj0oxMfYCPVN27yjTTGQT10ad8rFZz3tclLCspUW5Ryl2sbAOTP8lnQTLYD7kLf5uB95a2jMWNe4BHur0HAQ7BcWiaJkZzZCWDgQ2o9ZLbTja+1yrFQiMtpsAi8m37cy8+RqO9UKMAzwTbkTL6fHsAVHMwrs8AkSjJFvGHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L7s2Pi6O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L7s2Pi6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D71C2BCB0;
	Sat,  9 May 2026 01:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778290456;
	bh=gRXi7DiQW7PWPlZPj65vdR562IbDKPYbUOZzuFgISJA=;
	h=Date:To:From:Subject:From;
	b=L7s2Pi6OiwY5h6d9y/662o1XiNZeWf4ZMKRkqt8k5YtEOFQKx9XB9EyhGesO8su1S
	 5NiLUz4dxNFxjcDoWMiHhd6XGb2uaoJPWdRoS9YZ4+rBNJFZmErx+jQT6TOzRE4yGj
	 v+44qJg9aAky9lITwHcFbjvr3ZDSeV9vFpBo87s8=
Date: Fri, 08 May 2026 18:34:16 -0700
To: mm-commits@vger.kernel.org,bigeasy@linutronix.de,zhouzhouyi@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + preempt_rt-fix-the-typo-in-the-comment-for-kunmap_atomic.patch added to mm-unstable branch
Message-Id: <20260509013416.97D71C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: highmem-internal.h: fix typo in the comment for kunmap_atomic()
has been added to the -mm mm-unstable branch.  Its filename is
     preempt_rt-fix-the-typo-in-the-comment-for-kunmap_atomic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/preempt_rt-fix-the-typo-in-the-comment-for-kunmap_atomic.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Zhouyi Zhou <zhouzhouyi@gmail.com>
Subject: highmem-internal.h: fix typo in the comment for kunmap_atomic()
Date: Tue, 5 May 2026 02:11:25 +0000

Replace `PREEMP_RT` with `PREEMPT_RT` in the header comment to match the
correct kernel configuration name.

Link: https://lore.kernel.org/20260505021125.1941691-1-zhouzhouyi@gmail.com
Signed-off-by: Zhouyi Zhou <zhouzhouyi@gmail.com>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem-internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/highmem-internal.h~preempt_rt-fix-the-typo-in-the-comment-for-kunmap_atomic
+++ a/include/linux/highmem-internal.h
@@ -262,7 +262,7 @@ static inline bool is_kmap_addr(const vo
  * @__addr:       Virtual address to be unmapped
  *
  * Unmaps an address previously mapped by kmap_atomic() and re-enables
- * pagefaults. Depending on PREEMP_RT configuration, re-enables also
+ * pagefaults. Depending on PREEMPT_RT configuration, re-enables also
  * migration and preemption. Users should not count on these side effects.
  *
  * Mappings should be unmapped in the reverse order that they were mapped.
_

Patches currently in -mm which might be from zhouzhouyi@gmail.com are

preempt_rt-fix-the-typo-in-the-comment-for-kunmap_atomic.patch

