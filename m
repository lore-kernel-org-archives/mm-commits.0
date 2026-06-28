Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440C72110E
	for <mm-commits@vger.kernel.org>; Sun, 28 Jun 2026 04:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782622322; cv=none; b=PFSd6mRMnZ8/NHz0sjRvy+3AI5ywFDTcAqFlqZPXEE2Sdi1wQ2UvM062890WcdYtSkaMpwzVnN9txYhwntd2mhZ3DFCaWRsVh8Nz0sABxXK8iXwPZhviQPMTnXl9+/YHIwyHohqBLBo6VHaMUl+DQ7DE3p/kvmTwSSOU8HS3GKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782622322; c=relaxed/simple;
	bh=wOVkhIFnbONP5k7E2PBaKJso4MutSiHzQETnl/6x4aE=;
	h=Date:To:From:Subject:Message-Id; b=lIWC7uUZb0+dPxJoop+6aJqnktxCtj49QtXXHPWOUauwgu1e22oGb1/I53oV87HS+HWyw7cvdybaCLtFdQFHHfULQRfzHtif3arItSdScgqpGbTe4fHhHwjjxatB7uj6nEm8oZZWoKqQ8hvilYvwgdW3zu/vlcMPLVLMD16pyiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YAb+NIZ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YAb+NIZ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0644F1F000E9;
	Sun, 28 Jun 2026 04:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782622321;
	bh=GeCQVD86y+ZRPihyUhHm8dbN0iIi5W/dJtlDoOxFNp4=;
	h=Date:To:From:Subject;
	b=YAb+NIZ9yDcLHuJ+dV+7mAmUlzzhpUixW/5YqR/t5+sfCdhuGb12OsbOZ93i4hD0m
	 UGr1vu8IqKHVDwaY3ULxeZgY30vIpvGVW6nhvMYDkAlZCwpdq4G+UD0q1xTaHgGx3S
	 osfYyjOjcLzZT9mgTHD7Ol8vvzwAARVOBDjEgmZM=
Date: Sat, 27 Jun 2026 21:52:00 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,sj@kernel.org,rppt@kernel.org,ljs@kernel.org,liam@infradead.org,kent.overstreet@linux.dev,jackmanb@google.com,harry@kernel.org,hao.ge@linux.dev,david@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-move-inactive-maintainer-to-credits.patch added to mm-new branch
Message-Id: <20260628045201.0644F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: move inactive maintainer to CREDITS
has been added to the -mm mm-new branch.  Its filename is
     maintainers-move-inactive-maintainer-to-credits.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-move-inactive-maintainer-to-credits.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: MAINTAINERS: move inactive maintainer to CREDITS
Date: Thu, 25 Jun 2026 11:48:56 -0700

Patch series "move alloc_tag.c file under mm/".

Memory allocation profiling is ultimately an mm feature and now that we
need to use some internal mm definitions in it [1], the time is right to
move its implementation under mm/. The move is straight-forward, involving
just alloc_tag.c file. Update config, makefiles and maintainers as well.


This patch (of 2):

Move Kent Overstreet from maintainers for Memory Allocation Profiling to
CREDITS in recognition of his co-authorship and contributions to this
feature.

Link: https://lore.kernel.org/20260625184857.2193482-2-surenb@google.com
Link: https://lore.kernel.org/all/20260622-alloc-trylock-v2-13-31f31367d420@google.com/ [1]
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Hao Ge <hao.ge@linux.dev>
Cc: Harry Yoo (Oracle) <harry@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    4 ++++
 MAINTAINERS |    1 -
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/CREDITS~maintainers-move-inactive-maintainer-to-credits
+++ a/CREDITS
@@ -3096,6 +3096,10 @@ N: Jens Osterkamp
 E: jens@de.ibm.com
 D: Maintainer of Spidernet network driver for Cell
 
+N: Kent Overstreet
+E: kent.overstreet@linux.dev
+D: Co-authored and contributed to Memory Allocation Profiling
+
 N: Gadi Oxman
 E: gadio@netvision.net.il
 D: Original author and maintainer of IDE/ATAPI floppy/tape drivers
--- a/MAINTAINERS~maintainers-move-inactive-maintainer-to-credits
+++ a/MAINTAINERS
@@ -16886,7 +16886,6 @@ F:	tools/testing/memblock/
 
 MEMORY ALLOCATION PROFILING
 M:	Suren Baghdasaryan <surenb@google.com>
-M:	Kent Overstreet <kent.overstreet@linux.dev>
 R:	Hao Ge <hao.ge@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
_

Patches currently in -mm which might be from surenb@google.com are

maintainers-move-inactive-maintainer-to-credits.patch

