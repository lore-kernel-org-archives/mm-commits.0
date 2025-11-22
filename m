Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5704327702D
	for <mm-commits@vger.kernel.org>; Sat, 22 Nov 2025 21:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763847476; cv=none; b=AUnA0s9JSe39unYomLbCZoeirl4E4sxDrRKq0oJbFsuLxvXNOA3408tEW3aj+BdGcpmBxJaw+LqkMkShCZFapqZjmLU4rmApl2f0guMDBunHorzImew4p3qWLjrYqDe+m3Lupc2RcLnAst+FjTVWtnSD2cNZ8Qo3kigiryl9xZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763847476; c=relaxed/simple;
	bh=lz3mRdJIpuNzFbXuiuj2be6WcULq4MV88b3i+FRHcxQ=;
	h=Date:To:From:Subject:Message-Id; b=i+XxwTsTxNJ2vR08vYp4UaskHsT0PfqNWD6P3vMwCAMFh4n9oUORTv8AbeZcL8ejuk3iKJ3lGpxOqghbHkfobBLdWSCAu+FF6aC3Kn6uA+aQp9Rm1eaZSetZaCsDq00+OOcQQ/6ENQ9ODI6GDod4ps4eVGVJwudWD0Nlw9MdDHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GgOe3nAS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GgOe3nAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED0AC4CEF5;
	Sat, 22 Nov 2025 21:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763847475;
	bh=lz3mRdJIpuNzFbXuiuj2be6WcULq4MV88b3i+FRHcxQ=;
	h=Date:To:From:Subject:From;
	b=GgOe3nASAiQTm6zcbd5XTElfDHN+pqfLaoMrsgjlt4z5rdFw6MkAwJQjlLJAPyFaA
	 uv4E388A3ow0jJ1BlrQ2UBhqqeNjU/RSDZ97yo30i0mximsyRg3AI1d0YZg7rxz4DT
	 4xCoip4w7KmYQi22vqxKRYiB622d7u2ZvpM7+3tQ=
Date: Sat, 22 Nov 2025 13:37:55 -0800
To: mm-commits@vger.kernel.org,vdavydov@virtuozzo.com,n-horiguchi@ah.jp.nec.com,koct9i@gmail.com,richard@nod.at,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + pagemap-update-buddy-flag-documentation.patch added to mm-new branch
Message-Id: <20251122213755.BED0AC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: pagemap: update BUDDY flag documentation
has been added to the -mm mm-new branch.  Its filename is
     pagemap-update-buddy-flag-documentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/pagemap-update-buddy-flag-documentation.patch

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
From: Richard Weinberger <richard@nod.at>
Subject: pagemap: update BUDDY flag documentation
Date: Sat, 22 Nov 2025 22:19:20 +0100

Since v4.6 the BUDDY flag is set for _all_ pages in the block
and no longer just for the first one.
This change was introduced by:
commit 832fc1de01ae ("/proc/kpageflags: return KPF_BUDDY for "tail" buddy pages")

Strictly speaking, this was an ABI change, but as nobody has noticed
since 2016, let's just update the documentation.

Link: https://lkml.kernel.org/r/20251122211920.3410371-1-richard@nod.at
Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/pagemap.rst |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/pagemap.rst~pagemap-update-buddy-flag-documentation
+++ a/Documentation/admin-guide/mm/pagemap.rst
@@ -115,7 +115,8 @@ Short descriptions to the page flags
     A free memory block managed by the buddy system allocator.
     The buddy system organizes free memory in blocks of various orders.
     An order N block has 2^N physically contiguous pages, with the BUDDY flag
-    set for and _only_ for the first page.
+    set for all pages.
+    Before 4.6 only the first page of the block had the flag set.
 15 - COMPOUND_HEAD
     A compound page with order N consists of 2^N physically contiguous pages.
     A compound page with order 2 takes the form of "HTTT", where H donates its
_

Patches currently in -mm which might be from richard@nod.at are

pagemap-update-buddy-flag-documentation.patch

