Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9FC2DCC01;
	Mon,  5 Jan 2026 21:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767647507; cv=none; b=XzDhbbisdwQc/S6XAtbGGGkhKs9qxdiZV+/XZ5GsqdOgI6On0F6d/gTO/cEu4YLfbhwmWyLv2AR5xafV705HHypHXWSKWt6xsdueKwZbbCNwHkuX7VnFBmqO3wSDTl9IcleE59zsO6+D2njLfyEwFSO40WUqVMSmcJTbdo3zr8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767647507; c=relaxed/simple;
	bh=Meln78RHQvTGgpc8eJxE13RW8JBjoXlRF8gcVGntq+w=;
	h=Date:To:From:Subject:Message-Id; b=C+EknM1RA1LSxjlH6E/CvOy0I5jIuVuz+063whNJ8Z9ur0UeSEKrX91FPtne6A/SIA1rnAMNi7TpyuxEGftK0CeUMbvikHZ2aK9yLsbTX0SQ0c7dNNZzbCUhYpTgqOnGcXQK4Ri9FTsRR0947NGnD66KREiKw1V/bvePJiD8d74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yct4yFye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yct4yFye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B275C116D0;
	Mon,  5 Jan 2026 21:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767647507;
	bh=Meln78RHQvTGgpc8eJxE13RW8JBjoXlRF8gcVGntq+w=;
	h=Date:To:From:Subject:From;
	b=yct4yFyexFcF5bBwdtYmwnO8elZoUF6DKU8gyN1pms1kay34EDpDEnV1zgBTe3Lml
	 /0O82+coWspmltQ9LMWTzH6ZPaVbOge2Biln/1ZpuaXS/YkEhlizs/jlM7V/VlO9sE
	 UdSg26q7b0T5h2k83gZq7tY7D1e4lduShPIxY7kc=
Date: Mon, 05 Jan 2026 13:11:46 -0800
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,vbabka@suse.cz,stable@vger.kernel.org,riel@surriel.com,pfalcato@suse.de,liam.howlett@oracle.com,jannh@google.com,david@kernel.org,aha310510@gmail.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-enforce-vma-fork-limit-on-unfaultedfaulted-mremap-merge-too.patch added to mm-hotfixes-unstable branch
Message-Id: <20260105211147.5B275C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: enforce VMA fork limit on unfaulted,faulted mremap merge too
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vma-enforce-vma-fork-limit-on-unfaultedfaulted-mremap-merge-too.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-enforce-vma-fork-limit-on-unfaultedfaulted-mremap-merge-too.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/vma: enforce VMA fork limit on unfaulted,faulted mremap merge too
Date: Mon, 5 Jan 2026 20:11:49 +0000

The is_mergeable_anon_vma() function uses vmg->middle as the source VMA. 
However when merging a new VMA, this field is NULL.

In all cases except mremap(), the new VMA will either be newly established
and thus lack an anon_vma, or will be an expansion of an existing VMA thus
we do not care about whether VMA is CoW'd or not.

In the case of an mremap(), we can end up in a situation where we can
accidentally allow an unfaulted/faulted merge with a VMA that has been
forked, violating the general rule that we do not permit this for reasons
of anon_vma lock scalability.

Now we have the ability to be aware of the fact we are copying a VMA and
also know which VMA that is, we can explicitly check for this, so do so.

This is pertinent since commit 879bca0a2c4f ("mm/vma: fix incorrectly
disallowed anonymous VMA merges"), as this patch permits unfaulted/faulted
merges that were previously disallowed running afoul of this issue.

While we are here, vma_had_uncowed_parents() is a confusing name, so make
it simple and rename it to vma_is_fork_child().

Link: https://lkml.kernel.org/r/6e2b9b3024ae1220961c8b81d74296d4720eaf2b.1767638272.git.lorenzo.stoakes@oracle.com
Fixes: 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA merges")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jeongjun Park <aha310510@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

--- a/mm/vma.c~mm-vma-enforce-vma-fork-limit-on-unfaultedfaulted-mremap-merge-too
+++ a/mm/vma.c
@@ -67,18 +67,13 @@ struct mmap_state {
 		.state = VMA_MERGE_START,				\
 	}
 
-/*
- * If, at any point, the VMA had unCoW'd mappings from parents, it will maintain
- * more than one anon_vma_chain connecting it to more than one anon_vma. A merge
- * would mean a wider range of folios sharing the root anon_vma lock, and thus
- * potential lock contention, we do not wish to encourage merging such that this
- * scales to a problem.
- */
-static bool vma_had_uncowed_parents(struct vm_area_struct *vma)
+/* Was this VMA ever forked from a parent, i.e. maybe contains CoW mappings? */
+static bool vma_is_fork_child(struct vm_area_struct *vma)
 {
 	/*
 	 * The list_is_singular() test is to avoid merging VMA cloned from
-	 * parents. This can improve scalability caused by anon_vma lock.
+	 * parents. This can improve scalability caused by the anon_vma root
+	 * lock.
 	 */
 	return vma && vma->anon_vma && !list_is_singular(&vma->anon_vma_chain);
 }
@@ -115,11 +110,19 @@ static bool is_mergeable_anon_vma(struct
 	VM_WARN_ON(src && src_anon != src->anon_vma);
 
 	/* Case 1 - we will dup_anon_vma() from src into tgt. */
-	if (!tgt_anon && src_anon)
-		return !vma_had_uncowed_parents(src);
+	if (!tgt_anon && src_anon) {
+		struct vm_area_struct *copied_from = vmg->copied_from;
+
+		if (vma_is_fork_child(src))
+			return false;
+		if (vma_is_fork_child(copied_from))
+			return false;
+
+		return true;
+	}
 	/* Case 2 - we will simply use tgt's anon_vma. */
 	if (tgt_anon && !src_anon)
-		return !vma_had_uncowed_parents(tgt);
+		return !vma_is_fork_child(tgt);
 	/* Case 3 - the anon_vma's are already shared. */
 	return src_anon == tgt_anon;
 }
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-fix-anon_vma-uaf-on-mremap-faulted-unfaulted-merge.patch
tools-testing-selftests-add-tests-for-tgt-src-mremap-merges.patch
mm-vma-enforce-vma-fork-limit-on-unfaultedfaulted-mremap-merge-too.patch
tools-testing-selftests-add-forked-un-faulted-vma-merge-tests.patch

