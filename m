Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C10432E137
	for <mm-commits@vger.kernel.org>; Wed,  4 Feb 2026 19:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770233823; cv=none; b=HT+f9FE+0kmTlra6bIRmcHBXwIUUxX34i8FoodiK/PN6vnre4jPOd0+600UO9jVBpBzkmp9O8unGGZFyT5C9Zpw6QMRqOvQFzatS+RjxXZ0i5lLBv2Qy6H4F1SgtMbstOesb7Pdxrm8wXDS32NenGECsY1w8yFlxgoSMB0rRhuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770233823; c=relaxed/simple;
	bh=Tfu71tVPJfWxlXCjyyuJl3Vs/+KpPzoN1PUGJv5cQS4=;
	h=Date:To:From:Subject:Message-Id; b=Ay2ySu96/khEDdHOss57YUEYUgAqQb9rjL31UGp77674B3kFo2y8zabS6v8OdbMx4BVUPXxFkrWKMhcfCmKC7uZIuF0kXCkbrLz6nhkxFxjMeHI5orKFtdVG6V6XdphAhKIhgpK4DhIYNGYU9cVEaF5U8MVe0VEce+p9fGm1cFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rNCyp4Pk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rNCyp4Pk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20541C4CEF7;
	Wed,  4 Feb 2026 19:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770233823;
	bh=Tfu71tVPJfWxlXCjyyuJl3Vs/+KpPzoN1PUGJv5cQS4=;
	h=Date:To:From:Subject:From;
	b=rNCyp4Pk25UjZjIkJZWj+Dgc4x6/oUCjjd51n2vZ/mgpBLnAEZiKA32nPYjNYPXeV
	 tA0nEa+hmIqnHgqj3fCTilUtcYWxCeI6eDGvy0bawlyDm+mJrR3MADfAzVjy2sGTaW
	 yhVwbOeaMnKW2HwGA2Pr+7sc/7qoWlheAjKfnOKE=
Date: Wed, 04 Feb 2026 11:37:02 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,roman.gushchin@linux.dev,muchun.song@linux.dev,david@fromorbit.com,ahacigu.linux@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shrinker-fix-refcount-leak-in-shrink_slab_memcg.patch added to mm-new branch
Message-Id: <20260204193703.20541C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shrinker: fix refcount leak in shrink_slab_memcg()
has been added to the -mm mm-new branch.  Its filename is
     mm-shrinker-fix-refcount-leak-in-shrink_slab_memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinker-fix-refcount-leak-in-shrink_slab_memcg.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Altan Hacigumus <ahacigu.linux@gmail.com>
Subject: mm/shrinker: fix refcount leak in shrink_slab_memcg()
Date: Tue, 3 Feb 2026 19:35:53 -0800

When kmem is disabled for memcg, slab-backed shrinkers are skipped. 
However, shrink_slab_memcg() doesn't drop the reference acquired via
shrinker_try_get() before continuing.

Add the missing shrinker_put().

Also, since memcg_kmem_online() and shrinker flags cannot change
dynamically, remove the shrinker from the bitmap to avoid unnecessary
future scans.

Link: https://lkml.kernel.org/r/20260204033553.50039-1-ahacigu.linux@gmail.com
Fixes: 50d09da8e119 ("mm: shrinker: make memcg slab shrink lockless")
Signed-off-by: Altan Hacigumus <ahacigu.linux@gmail.com>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
  Link: https://lore.kernel.org/r/20260203073757.135088-1-ahacigu.linux@gmail.com
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


_

Patches currently in -mm which might be from ahacigu.linux@gmail.com are

mm-shrinker-fix-refcount-leak-in-shrink_slab_memcg.patch

