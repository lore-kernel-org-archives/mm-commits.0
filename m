Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A393B25BAA0
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 22:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740608154; cv=none; b=eDSKO8yF41OKGEhCFdwdrWUH/0mc+cO+lT13CrB4O6S2RPY9G9nwyzs8NuA50AwU6tHRv2ZLXdwH47iPk4zwyx+YZMr6d5K9A8JnLKm/7McS5dJbrrkhn+xlHeaRcDmg0bRrJURBoy5sgtxMNucTcn4N5psO5KbfXoLhTGtE5uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740608154; c=relaxed/simple;
	bh=VzBpK1nK8o9BMFcehcONCkgn9yMJYJXjnbI/NL1le3A=;
	h=Date:To:From:Subject:Message-Id; b=NF3zE4pAYCwzgRqUso/+1xHj17Iul/PpVa8GwJikX5njgMxXSwycmW2EgrBEhQJ2O43jqaMJEDSrb5c6JzVrvdOj2ItvIDCsyGIUStOA8aFs0+BcTWIeWSZKumPrpbQTdldfDuO664ihQk4z/LGw8K3uXW4wgrM2UUjwaRoidss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XRvqcpG6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XRvqcpG6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F17C4CEE7;
	Wed, 26 Feb 2025 22:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740608154;
	bh=VzBpK1nK8o9BMFcehcONCkgn9yMJYJXjnbI/NL1le3A=;
	h=Date:To:From:Subject:From;
	b=XRvqcpG6GSkYneb1F7gnq7MQEC/qvBraiQ/ygcLKDSxi0YHait8d906I5m0P8LU0K
	 Z458eqgH3P8OXxb8aIGfqelaoOF9DdjgccIxGC8ZICzlTzXGP/UURFoUfw4cZiAZml
	 JHdaRuXuc86XKzhI1fMaT7oFwHP5CVk0tZReRLCM=
Date: Wed, 26 Feb 2025 14:15:53 -0800
To: mm-commits@vger.kernel.org,revest@chromium.org,pengfei.xu@intel.com,mcgrof@kernel.org,hughd@google.com,david@redhat.com,dave@stgolabs.net,brauner@kernel.org,rcn@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-remove-unnecessary-warning-in-shmem_writepage.patch added to mm-hotfixes-unstable branch
Message-Id: <20250226221554.02F17C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: remove unnecessary warning in shmem_writepage()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shmem-remove-unnecessary-warning-in-shmem_writepage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-remove-unnecessary-warning-in-shmem_writepage.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Ricardo Cañuelo Navarro <rcn@igalia.com>
Subject: mm: shmem: remove unnecessary warning in shmem_writepage()
Date: Wed, 26 Feb 2025 13:26:27 +0100

Although the scenario where shmem_writepage() is called with info->flags &
VM_LOCKED is unlikely to happen, it's still possible, as evidenced by
syzbot [1].  However, the warning in this case isn't necessary because the
situation is already handled correctly [2].

[2] https://lore.kernel.org/lkml/8afe1f7f-31a2-4fc0-1fbd-f9ba8a116fe3@google.com/

Link: https://lkml.kernel.org/r/20250226-20250221-warning-in-shmem_writepage-v1-1-5ad19420e17e@igalia.com
Fixes: 9a976f0c847b ("shmem: skip page split if we're not reclaiming")
Signed-off-by: Ricardo Cañuelo Navarro <rcn@igalia.com>
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Closes: https://lore.kernel.org/lkml/ZZ9PShXjKJkVelNm@xpf.sh.intel.com/ [1]
Suggested-by: Hugh Dickins <hughd@google.com>
Cc: Florent Revest <revest@chromium.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Florent Revest <revest@chromium.org>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-remove-unnecessary-warning-in-shmem_writepage
+++ a/mm/shmem.c
@@ -1548,7 +1548,7 @@ static int shmem_writepage(struct page *
 	if (WARN_ON_ONCE(!wbc->for_reclaim))
 		goto redirty;
 
-	if (WARN_ON_ONCE((info->flags & VM_LOCKED) || sbinfo->noswap))
+	if ((info->flags & VM_LOCKED) || sbinfo->noswap)
 		goto redirty;
 
 	if (!total_swap_pages)
_

Patches currently in -mm which might be from rcn@igalia.com are

mm-shmem-remove-unnecessary-warning-in-shmem_writepage.patch

