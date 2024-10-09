Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C402B161313
	for <mm-commits@vger.kernel.org>; Wed,  9 Oct 2024 20:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728505183; cv=none; b=d/xexWqdT6iLJxg7ZBUoo0zChn+bGzroU9nPA3sXSaiIGM400NtvnD+g+mVGRjZqzaQV59U0lsJuqbJoEdET0szQi4wFmorGEbrzRjSLbWxhnBY1VZ3B0Dj789YU8ByCTHA/xhDpyen9rMdWspzDT1bo6suHVStK8PdlMpSoY6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728505183; c=relaxed/simple;
	bh=Lh8d+z+bH0e2qQTf9hARTXhD87X5SV2wF8v/RO3nsKY=;
	h=Date:To:From:Subject:Message-Id; b=jLobmx2OipLCHU2fgo23LUWcHkO2iZBrYZ9wwsm5ZPFs8S+ld40DHy14DA6SyiWA4ri8tN9Y0HTqly/b8bm6dUUYxg4C236siORotHTsN9MBGTG9X9X+hMlHKKZvi7wpDVwEcJGvvwvYSTDAcgzLHUma1Vj0vxT2gW/lVxscmQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QePqy/kE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QePqy/kE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46AF4C4CEC3;
	Wed,  9 Oct 2024 20:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728505183;
	bh=Lh8d+z+bH0e2qQTf9hARTXhD87X5SV2wF8v/RO3nsKY=;
	h=Date:To:From:Subject:From;
	b=QePqy/kEd9pCJ10fcDHt1YgkjPdgaLtudBsT2ulOgaV8Ianrjy4HJholHj1EzlnNG
	 4bXuG8Tin+UkXjleYVgItmU+nUe1cRkPCJsiNxOSsddpV00eDNQS9xH93P6OIlAZhP
	 EmQssZcPH7OnqqvOPz/ze2w+SwuMwtIg7/uU4fps=
Date: Wed, 09 Oct 2024 13:19:42 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@oracle.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-memory-mapping-vma-co-maintainers.patch added to mm-hotfixes-unstable branch
Message-Id: <20241009201943.46AF4C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add memory mapping/VMA co-maintainers
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-memory-mapping-vma-co-maintainers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-memory-mapping-vma-co-maintainers.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add memory mapping/VMA co-maintainers
Date: Wed, 9 Oct 2024 21:10:32 +0100

Add myself and Liam as co-maintainers of the memory mapping and VMA code
alongside Andrew as we are heavily involved in its implementation and
maintenance.

Link: https://lkml.kernel.org/r/20241009201032.6130-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/MAINTAINERS~maintainers-add-memory-mapping-vma-co-maintainers
+++ a/MAINTAINERS
@@ -14913,9 +14913,9 @@ N:	include/linux/page[-_]*
 
 MEMORY MAPPING
 M:	Andrew Morton <akpm@linux-foundation.org>
-R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+M:	Liam R. Howlett <Liam.Howlett@oracle.com>
+M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Vlastimil Babka <vbabka@suse.cz>
-R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
@@ -24728,9 +24728,9 @@ F:	tools/testing/vsock/
 
 VMA
 M:	Andrew Morton <akpm@linux-foundation.org>
-R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+M:	Liam R. Howlett <Liam.Howlett@oracle.com>
+M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Vlastimil Babka <vbabka@suse.cz>
-R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	https://www.linux-mm.org
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mmap-correct-error-handling-in-mmap_region.patch
maple_tree-correct-tree-corruption-on-spanning-store.patch
maple_tree-add-regression-test-for-spanning-store-bug.patch
maintainers-add-memory-mapping-vma-co-maintainers.patch
selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch
mm-refactor-mm_access-to-not-return-null.patch
mm-refactor-mm_access-to-not-return-null-fix.patch
mm-madvise-unrestrict-process_madvise-for-current-process.patch
maple_tree-do-not-hash-pointers-on-dump-in-debug-mode.patch

