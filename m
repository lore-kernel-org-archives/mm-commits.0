Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760A3145346
	for <mm-commits@vger.kernel.org>; Wed,  6 Aug 2025 23:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754521329; cv=none; b=oZED3EAgK0w05l+5tTIFjX+XPvoEbuUwhtWqLOV2yIkL1YiYYRd990GRbthrogOXfg+oYFY1gW0scpA+gK3xKpPdkqeed4FSsoXatcOINfIwRTRJt7J21C80Qz+tYNRatT6t/lYB+b7c/TS5cJ3HotPy4ANwOMPF/qo20XvPZuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754521329; c=relaxed/simple;
	bh=hlSr+ha5CHsTn6NuFNmHVLLcAlMFHMwVmhN838iARU4=;
	h=Date:To:From:Subject:Message-Id; b=iqzqmE6SoebP0Z9lPdtDDxbfy1tX2xpRWOWt9KwG46mQRpiFeb603wKEeF4Ay2eE7vToeT8rhnk8CyADfpAL5ffJsehd/SHJ611RcArXiIGt5HI+FFQhVGwfFZHfpCmWdRE/yoXbbg+NAd5Aza19fobGb6R6//RBYcR+qSlFF9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H08F/3Px; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H08F/3Px"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D24C4CEE7;
	Wed,  6 Aug 2025 23:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754521328;
	bh=hlSr+ha5CHsTn6NuFNmHVLLcAlMFHMwVmhN838iARU4=;
	h=Date:To:From:Subject:From;
	b=H08F/3PxvGN4JJfY6bogvYp2ZpNGvSyV905aCZnR25amHiArlJMfsQccLvJC+UtHc
	 vmgG4pizh6UOpmwrunkIJsl+nl+dWlUwK5d+og8TLGJRxevdP0TNWcAuGiLwtloQMN
	 Pb27B8vaXTZ1TmLf/NmAN8nl5F9VRkSpRfVV1YOc=
Date: Wed, 06 Aug 2025 16:02:08 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,adrianhuang0701@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-correct-misleading-comment-on-mmap_lock-field-in-mm_struct.patch added to mm-new branch
Message-Id: <20250806230208.D0D24C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: correct misleading comment on mmap_lock field in mm_struct
has been added to the -mm mm-new branch.  Its filename is
     mm-correct-misleading-comment-on-mmap_lock-field-in-mm_struct.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-correct-misleading-comment-on-mmap_lock-field-in-mm_struct.patch

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
From: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Subject: mm: correct misleading comment on mmap_lock field in mm_struct
Date: Wed, 6 Aug 2025 22:59:06 +0800

The comment previously described the offset of mmap_lock as 0x120 (hex),
which is misleading.  The correct offset is 56 bytes (decimal) from the
last cache line boundary.  Using '0x120' could confuse readers trying to
understand why the count and owner fields reside in separate cachelines.

This change also removes an unnecessary space for improved formatting.

Link: https://lkml.kernel.org/r/20250806145906.24647-1-adrianhuang0701@gmail.com
Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/mm_types.h~mm-correct-misleading-comment-on-mmap_lock-field-in-mm_struct
+++ a/include/linux/mm_types.h
@@ -1026,10 +1026,10 @@ struct mm_struct {
 					     * counters
 					     */
 		/*
-		 * With some kernel config, the current mmap_lock's offset
-		 * inside 'mm_struct' is at 0x120, which is very optimal, as
+		 * Typically the current mmap_lock's offset is 56 bytes from
+		 * the last cacheline boundary, which is very optimal, as
 		 * its two hot fields 'count' and 'owner' sit in 2 different
-		 * cachelines,  and when mmap_lock is highly contended, both
+		 * cachelines, and when mmap_lock is highly contended, both
 		 * of the 2 fields will be accessed frequently, current layout
 		 * will help to reduce cache bouncing.
 		 *
_

Patches currently in -mm which might be from adrianhuang0701@gmail.com are

mm-correct-misleading-comment-on-mmap_lock-field-in-mm_struct.patch

