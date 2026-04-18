Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B5C34AB17
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498690; cv=none; b=dBlQdHeoZrXTVBvYmeF2BDMA8OY2fphUkgRmqehVxW3ykCbZdxqSh+s5uYqnbJKVi76wpPWfMPlOE3aenOEAdJD0usIIImjOgSs3eaWcxU/f4n4N9JiCVM4VRk38ZgqBh6Me0GL6ptQVLIMIPc6ZddQ6hTE+1A8/VkYqaTQ7eCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498690; c=relaxed/simple;
	bh=r+QC1ub9wCHjcVTmIR2X0yL4dvxHKU2Ix6KYX4fxisk=;
	h=Date:To:From:Subject:Message-Id; b=EyXVCkszfmX3+asi13XUqyBaxng3eYUN/sUnmxEbf7v2Wpt0QcJNagbivzRvurT4hMxwrx+1H0LuWSPaRkY7QQAIMtl25ApxJflYushbqQ3BtrKy9mzwFWEuCR0DyVfvY6WbxhUHYOqcNXL+EBsG79qOIWMzgH+e+Ayq0VeeUSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xfK1t2+g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xfK1t2+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4C7C19424;
	Sat, 18 Apr 2026 07:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498690;
	bh=r+QC1ub9wCHjcVTmIR2X0yL4dvxHKU2Ix6KYX4fxisk=;
	h=Date:To:From:Subject:From;
	b=xfK1t2+gdKGXboQWxF07ABgS1+4XfX1Jr+t83I7XmWOvprDzS3meXBzGTg6nA6g0o
	 9DCnfgslmyx4xbU/PDYzIb4TQW5oH1K7w+v77gX/oTTGaeA9dmvfgJuq9+HSP3dPt3
	 gLmc022pHctX7kCgULbtnJl6RAS8P+1mLkFghV7k=
Date: Sat, 18 Apr 2026 00:51:25 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shakeel.butt@linux.dev,qi.zheng@linux.dev,kasong@tencent.com,kaleshsingh@google.com,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-update-mglru-entry-to-reflect-current-status.patch removed from -mm tree
Message-Id: <20260418075129.5F4C7C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: update MGLRU entry to reflect current status
has been removed from the -mm tree.  Its filename was
     maintainers-update-mglru-entry-to-reflect-current-status.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: MAINTAINERS: update MGLRU entry to reflect current status
Date: Thu, 26 Mar 2026 18:56:29 +0000

We are moving to a far more proactive model of maintainership within mm
and thus put a great deal of emphasis on sub-maintainers being active
within the community both in terms of code contributions and review.

The MGLRU has not had much activity since being added to the kernel and
the current maintainers who kindly stepped up have unfortunately not been
able to contribute a great deal to it for over a year, nor engage all that
heavily in review.

As a result, and within no negative connotations implied whatsoever, it
seems appropriate to downgrade the current maintainers to reviewers.

At this time nobody is quite exercising the maintainer role in this area
of the kernel, but there is encouraging activity from a number of people
who are trusted elsewhere in the kernel, and who have contributed relevant
work or review.

Therefore add further reviewers, and at this stage - to reflect the
reality on the ground - we will not have any sub-maintainers listed at
all.

Each of the files listed are shared with other sections in MAINTAINERS, so
this doesn't reduce sub-maintainer coverage.

Link: https://lore.kernel.org/20260326185629.355476-1-ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: Axel Rasmussen <axelrasmussen@google.com>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Barry Song <baohua@kernel.org>
Acked-by: SeongJae Park <sj@kernel.org>
Acked-by: Kairui Song <kasong@tencent.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Yuanchu Xie <yuanchu@google.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/MAINTAINERS~maintainers-update-mglru-entry-to-reflect-current-status
+++ a/MAINTAINERS
@@ -16757,8 +16757,12 @@ F:	mm/migrate_device.c
 
 MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Axel Rasmussen <axelrasmussen@google.com>
-M:	Yuanchu Xie <yuanchu@google.com>
+R:	Kairui Song <kasong@tencent.com>
+R:	Qi Zheng <qi.zheng@linux.dev>
+R:	Shakeel Butt <shakeel.butt@linux.dev>
+R:	Barry Song <baohua@kernel.org>
+R:	Axel Rasmussen <axelrasmussen@google.com>
+R:	Yuanchu Xie <yuanchu@google.com>
 R:	Wei Xu <weixugc@google.com>
 L:	linux-mm@kvack.org
 S:	Maintained
_

Patches currently in -mm which might be from ljs@kernel.org are


