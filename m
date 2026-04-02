Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFC714F9FB;
	Thu,  2 Apr 2026 00:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775090756; cv=none; b=CBYv/3NdP2TXRZn7JkXTsdicz0uT6I5qJSIJiIRGd7zjHmIQIl5nJtMnl0t9FJDRO+DyLhievOsVD6jGP5efHFMyIg4PReHf1ZGEm+9zeAviJqHI8j5u6wFD06LE3mVo7jXX8TDNVibZBamc8e16hIU1QnPmPLjiR4J5seEduoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775090756; c=relaxed/simple;
	bh=pVvsWaXrzycnA45y3TLBCGTMUiskh5fVwMtFseh+E2U=;
	h=Date:To:From:Subject:Message-Id; b=Vy7m9PFcNFB/EDhB0JUGhH+5MaGM226vtnPCUicpJkIKBGU16gW/bQ1w0IALiRFDLOyl/jQCEFlbLY3tAehPZ+z3vB8wMbMv76B1X0NwMdDOeIfM4ak0ny4p+JIh9MLI3bLd/oDfvjqnTkjeBUVrr0/MqcujzuwcVm0pJLFop+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RvT9RJ3e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RvT9RJ3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBF8C4CEF7;
	Thu,  2 Apr 2026 00:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775090756;
	bh=pVvsWaXrzycnA45y3TLBCGTMUiskh5fVwMtFseh+E2U=;
	h=Date:To:From:Subject:From;
	b=RvT9RJ3eSUrcusx2vXahjcj1AE312MNRe4jYvrLsG9MHQDeIwOO7drJ5ZXMSE4cuV
	 tbMOHBp2yW9liIwyZmRasm5E7SurwlSbuzhk0A8uQ5sxSQmbchuCBxy+wt1w69fyN9
	 tx8AmaL5f0vDUBi4/r35xqDXGdxy96n54iVMcarI=
Date: Wed, 01 Apr 2026 17:45:55 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,shuah@kernel.org,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,jason@zx2c4.com,jannh@google.com,david@kernel.org,anthony.yznaga@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-mmap-errno-value-when-map_droppable-is-not-supported.patch added to mm-new branch
Message-Id: <20260402004555.EDBF8C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix mmap errno value when MAP_DROPPABLE is not supported
has been added to the -mm mm-new branch.  Its filename is
     mm-fix-mmap-errno-value-when-map_droppable-is-not-supported.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-mmap-errno-value-when-map_droppable-is-not-supported.patch

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
From: Anthony Yznaga <anthony.yznaga@oracle.com>
Subject: mm: fix mmap errno value when MAP_DROPPABLE is not supported
Date: Wed, 1 Apr 2026 17:34:16 -0700

On configs where MAP_DROPPABLE is not supported (currently any 32-bit
config except for PPC32), mmap fails with errno set to ENOTSUPP.  However,
ENOTSUPP is not a standard error value that userspace knows about.  The
acceptable userspace-visible errno to use is EOPNOTSUPP.  checkpatch.pl
has a warning to this affect.

Link: https://lkml.kernel.org/r/20260402003417.438037-2-anthony.yznaga@oracle.com
Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
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

mm-fix-mmap-errno-value-when-map_droppable-is-not-supported.patch

