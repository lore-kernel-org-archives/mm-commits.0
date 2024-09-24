Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED4917993
	for <mm-commits@vger.kernel.org>; Tue, 24 Sep 2024 20:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727209015; cv=none; b=Lt4BUOjvv31NNcSC8Pfp2zsmxjgWRACNS4plhFo30kKqooy9yGIBpwlUc3YbSijWyu9esctVLDVJ3LeQ9jMFl7FJ8MC03O/QzDfzZEGB4wAnaguroZV0gj5gJjhfoP7PkPe4z+sPBRi1hI1Iip9ZrhTK10Md3LVZpCMZn7NSVYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727209015; c=relaxed/simple;
	bh=0U9k6ecTst2DwaF16JbgHjqs8v7O+DRLDdHzIeverPo=;
	h=Date:To:From:Subject:Message-Id; b=L9sedTkLtbpk4Gj68Ip2o/ccLe0W2M69lIfTd5rMQehCSuJFXjZUD028omyX2nacKQVivz5Ss2wAU2Hl4GhkGnO0A1RArJa+LTsmp+JrN4MtZFaUrVpRqGGudr6KZ6qXOcs1U5WENfCbYRrIFC+WbL+4w7QpFZl9Sd/AkREX3Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iRAs9np8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iRAs9np8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1FD7C4CEC4;
	Tue, 24 Sep 2024 20:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727209014;
	bh=0U9k6ecTst2DwaF16JbgHjqs8v7O+DRLDdHzIeverPo=;
	h=Date:To:From:Subject:From;
	b=iRAs9np8FoSChEQA66PVcTLBe9IZIz3DvNGJDeNe/CtnbFhJyH4t3SsEYUJV5N8TF
	 7MF76vwu576HObMjPfTU9agtCZZ4ls6R2oyOwrPomhd74AEYKMMGKyYWSP/GA6PYbA
	 uA9FVBUl/9OPejJl9oy+bM2/HYkW37yqYGI9E/qQ=
Date: Tue, 24 Sep 2024 13:16:54 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,cl@linux.com,aha310510@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-percpu-fix-typo-to-pcpu_alloc_noprof-description.patch added to mm-unstable branch
Message-Id: <20240924201654.A1FD7C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: percpu: fix typo to pcpu_alloc_noprof() description
has been added to the -mm mm-unstable branch.  Its filename is
     mm-percpu-fix-typo-to-pcpu_alloc_noprof-description.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-percpu-fix-typo-to-pcpu_alloc_noprof-description.patch

This patch will later appear in the mm-unstable branch at
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
From: Jeongjun Park <aha310510@gmail.com>
Subject: mm: percpu: fix typo to pcpu_alloc_noprof() description
Date: Wed, 25 Sep 2024 00:24:12 +0900

In the previous commit, the function name was changed from pcpu_alloc to
pcpu_alloc_noprof , but the function description was not changed
accordingly.  The function name should be changed to pcpu_alloc_noprof in
the description as well.

Link: https://lkml.kernel.org/r/20240924152412.118487-1-aha310510@gmail.com
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Cc: Christoph Lameter (Ampere) <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/percpu.c~mm-percpu-fix-typo-to-pcpu_alloc_noprof-description
+++ a/mm/percpu.c
@@ -1726,7 +1726,7 @@ static void pcpu_alloc_tag_free_hook(str
 #endif
 
 /**
- * pcpu_alloc - the percpu allocator
+ * pcpu_alloc_noprof - the percpu allocator
  * @size: size of area to allocate in bytes
  * @align: alignment of area (max PAGE_SIZE)
  * @reserved: allocate from the reserved chunk if available
_

Patches currently in -mm which might be from aha310510@gmail.com are

mm-percpu-fix-typo-to-pcpu_alloc_noprof-description.patch

