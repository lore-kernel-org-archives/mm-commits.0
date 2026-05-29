Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAEF736F430;
	Fri, 29 May 2026 04:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027603; cv=none; b=GbjVPMpCAGZV+VUXXkBqG2tsB2N6Op5rIKhzbhB8kcp1i2nnifi+R1LGXpWlhxXublwM5hTrd23f5A+wR9JEj7deLQCFM9Aen3Uriz7bUXsBZARcn5LRxoSL/6NuxEtJuu05OVmgHEhsOkGZl9nccuXqcEOpLHxtFZ1okUy1Wm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027603; c=relaxed/simple;
	bh=3ciF1TbmTObgKQqjPycVwwnuSV6Ns2sr06JaNGMcslg=;
	h=Date:To:From:Subject:Message-Id; b=X5r+qMXTKJQNgjvi0jqXwQwqkzBE/B1NueqhXqjS5l3Eg+MdgEwStXrPEBcq4InQvaYm01BaswvExGuOlqTrgatiiGIsYNPFIi78gVhMgM9rxduU7Wg6dSQuKFr6wPkWeL75PqIZ4WiBbeZ5G8q/4FFWPII1qq4kvOKRKOKi+Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WJpjUJut; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WJpjUJut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2CB1F00898;
	Fri, 29 May 2026 04:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027601;
	bh=dfFLLipqNTN3MQj+LaZdc1MN59vjUmO13KxJ+wlR5d0=;
	h=Date:To:From:Subject;
	b=WJpjUJutvqyqJG4TLC66XDVEUUplfHjfs0mSxqhhjgO3V4akz2aSCVsTlb8s1iMrA
	 qXI8VgoXm2zly2hEaIP+lQWYDHDeq/HafnNeNdAhsGOYwAXK37vIXaB6IEaOyHqghp
	 kA6auLIjs1/4IHy9YTpWfFCQ0/Ub/THTnPWkAG1o=
Date: Thu, 28 May 2026 21:06:41 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,shuah@kernel.org,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jason@zx2c4.com,jannh@google.com,david@kernel.org,broonie@kernel.org,anthony.yznaga@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-mmap-errno-value-when-map_droppable-is-not-supported.patch removed from -mm tree
Message-Id: <20260529040641.8F2CB1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix mmap errno value when MAP_DROPPABLE is not supported
has been removed from the -mm tree.  Its filename was
     mm-fix-mmap-errno-value-when-map_droppable-is-not-supported.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anthony Yznaga <anthony.yznaga@oracle.com>
Subject: mm: fix mmap errno value when MAP_DROPPABLE is not supported
Date: Wed, 15 Apr 2026 20:39:37 -0700

Patch series "fix MAP_DROPPABLE not supported errno", v4.

Mark Brown reported seeing a regression in -next on 32 bit arm with the
mlock selftests.  Before exiting and marking the tests failed, the
following message was logged after an attempt to create a MAP_DROPPABLE
mapping:

Bail out! mmap error: Unknown error 524

It turns out error 524 is ENOTSUPP which is an error that userspace is not
supposed to see, but it indicates in this instance that MAP_DROPPABLE is
not supported.

The first patch changes the errno returned to EOPNOTSUPP.  The second
patch is a second version of a prior patch to introduce selftests to
verify locking behavior with droppable mappings with the additional change
to skip the tests when MAP_DROPPABLE is not supported.  The third patch
fixes the MAP_DROPPABLE selftest so that it is run by the framework and
skips if MAP_DROPPABLE is not supported.


This patch (of 3):

On configs where MAP_DROPPABLE is not supported (currently any 32-bit
config except for PPC32), mmap fails with errno set to ENOTSUPP.  However,
ENOTSUPP is not a standard error value that userspace knows about.  The
acceptable userspace-visible errno to use is EOPNOTSUPP.  checkpatch.pl
has a warning to this effect.

Link: https://lore.kernel.org/20260416033939.49981-1-anthony.yznaga@oracle.com
Link: https://lore.kernel.org/20260416033939.49981-2-anthony.yznaga@oracle.com
Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reported-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Liam Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap.c~mm-fix-mmap-errno-value-when-map_droppable-is-not-supported
+++ a/mm/mmap.c
@@ -504,7 +504,7 @@ unsigned long do_mmap(struct file *file,
 			break;
 		case MAP_DROPPABLE:
 			if (VM_DROPPABLE == VM_NONE)
-				return -ENOTSUPP;
+				return -EOPNOTSUPP;
 			/*
 			 * A locked or stack area makes no sense to be droppable.
 			 *
_

Patches currently in -mm which might be from anthony.yznaga@oracle.com are


