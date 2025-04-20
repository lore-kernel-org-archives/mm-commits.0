Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D1D184F
	for <mm-commits@vger.kernel.org>; Sun, 20 Apr 2025 20:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745181065; cv=none; b=Jm+mgJVtegQj22Wu+33clqZmwsf93hojbPwOJyTAYsiBpdM+UcNGD02YtY7aoTS5h0lhn7a8Y9eDsCmDM0FVQJphOjXjQa6A+YXx7CLtY58dSMOtPfBemQR4sjXqHIuU/1JfN/ac5isUO9vC9JpYN2m9dqAj3FOCQC/RzmEd2qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745181065; c=relaxed/simple;
	bh=qliWzG5vAH2gW49xi0QxUVRHQi6J/+M2XwwWmcuuBFE=;
	h=Date:To:From:Subject:Message-Id; b=Nhqx51kkleL7DFQi5DstDUJz6Y7WR75NO5veE8xCa7EaPIoZVUAaGe2KfiXdgouFmMd2UMicxm5M/qI5SwBc3XMjD/CaInXcfs2i3lmiTWGFPgahQ13rAQegadWCTYfhF0++d4x1Pj/4DV93RQUSEhUa6ihUvDUIr8PQPq/x5i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IBafi9oK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IBafi9oK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CFE0C4CEE2;
	Sun, 20 Apr 2025 20:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745181065;
	bh=qliWzG5vAH2gW49xi0QxUVRHQi6J/+M2XwwWmcuuBFE=;
	h=Date:To:From:Subject:From;
	b=IBafi9oK9Kys4iD2r7clIS9eWg2mlc8nggzFw4mRa1O3JkTP+3S4zW/bfBpoQITLj
	 PkF0oSNY0AP+Fy3FXcwBYdImyDkuEb2D+3UD3m9EqPgi08RCUNPfoCf2GmgKIXHWyt
	 AHqD0Qkv99TnI4poPwwT9la/g60pgTR1xd50IY/0=
Date: Sun, 20 Apr 2025 13:31:04 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pvkumar5749404@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-typos-in-comments-in-mm_initc.patch added to mm-unstable branch
Message-Id: <20250420203105.5CFE0C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix typos in comments in mm_init.c
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-typos-in-comments-in-mm_initc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-typos-in-comments-in-mm_initc.patch

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
From: Prabhav Kumar Vaish <pvkumar5749404@gmail.com>
Subject: mm: fix typos in comments in mm_init.c
Date: Sun, 20 Apr 2025 19:34:40 +0530

Corrected minor typos in comments:
	- 'contigious' -> 'contiguous'
	- 'hierarcy' -> 'hierarchy'

This is a non-functional change in comment text only.

Link: https://lkml.kernel.org/r/20250420140440.18817-1-pvkumar5749404@gmail.com
Signed-off-by: Prabhav Kumar Vaish <pvkumar5749404@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mm_init.c~mm-fix-typos-in-comments-in-mm_initc
+++ a/mm/mm_init.c
@@ -834,7 +834,7 @@ overlap_memmap_init(unsigned long zone,
  * - physical memory bank size is not necessarily the exact multiple of the
  *   arbitrary section size
  * - early reserved memory may not be listed in memblock.memory
- * - non-memory regions covered by the contigious flatmem mapping
+ * - non-memory regions covered by the contiguous flatmem mapping
  * - memory layouts defined with memmap= kernel parameter may not align
  *   nicely with memmap sections
  *
@@ -1914,7 +1914,7 @@ void __init free_area_init(unsigned long
 		free_area_init_node(nid);
 
 		/*
-		 * No sysfs hierarcy will be created via register_one_node()
+		 * No sysfs hierarchy will be created via register_one_node()
 		 *for memory-less node because here it's not marked as N_MEMORY
 		 *and won't be set online later. The benefit is userspace
 		 *program won't be confused by sysfs files/directories of
_

Patches currently in -mm which might be from pvkumar5749404@gmail.com are

mm-fix-typos-in-comments-in-mm_initc.patch

