Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0B34E9C0C
	for <mm-commits@vger.kernel.org>; Thu,  8 Oct 2026 15:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791473620; cv=none; b=Am6hib6ZPntG1uSH7/y7xFRef/9/6a0QPe0UxnieADovO4n9AuWZAoHa0qvwLbkTgPC0qES1N3BdcpxINvioS4/mzaB+Ipqij9olnzgAfZ6+eYutVuGYcYNuTN//bQQ+CfqmvvM3VxLTfZHQKWb7b3YkmIX2sPqhqabGraZsFno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791473620; c=relaxed/simple;
	bh=iWXR9p0cFDBaF3nBk5qddpCTy2z1hb/cEDc0JAlcIuo=;
	h=Date:To:From:Subject:Message-Id; b=DdKQj/iJjheF28TQ6MozKLxcYdGklRtrd/kv5rs0vmcFzkI2UesoyLp8hfYgsZ8kRJLoNrKhjPf3bORTmH/l7Ou647GepUuQt7LOQtUlm9DOReskVdvFcyAiDW6qrl54YNfgmMRblzhUtdBK2N7Lvk3ZOj/iUQfOY9adhru7Veg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vukVCOgn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vukVCOgn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D32A1F000FF;
	Thu,  8 Oct 2026 15:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791473609;
	bh=YTDcuPGo6lBlxpd/b/Zm7Pa6f0aBbUfXaAKL1TMDHck=;
	h=Date:To:From:Subject;
	b=vukVCOgn2A4JYqFusVPVSgTw9tHpf/QBuljA8DIKLI4bHNT5AjUUAykL3LZ3EjNPB
	 VHC02nz5koAoEzMEOgJxq2gKSbwaFiSu6dsts1h7htuHEN3VDUJ0bKyyNwIy6vLFGX
	 2Ldn6GDyD70Syqy4IvC11tSXkh2nuI+UHA7WdnIo=
Date: Thu, 08 Oct 2026 08:33:29 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,surenb@google.com,sshegde@linux.ibm.com,rppt@kernel.org,ritesh.list@gmail.com,qi.zheng@linux.dev,pfalcato@suse.de,npiggin@gmail.com,muchun.song@linux.dev,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jack@suse.cz,hughd@google.com,gourry@gourry.net,david@kernel.org,chleroy@kernel.org,baolin.wang@linux.alibaba.com,ayushr@modal.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-truncate-unmap-debug.patch added to mm-new branch
Message-Id: <20261008153329.9D32A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/truncate: catch shmem folios still mapped after unmap
has been added to the -mm mm-new branch.  Its filename is
     shmem-truncate-unmap-debug.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-truncate-unmap-debug.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/truncate: catch shmem folios still mapped after unmap
Date: Thu Oct  8 08:29:04 AM PDT 2026

Instrument truncate_cleanup_folio() to determine where the shmem "still
mapped when deleted" state is introduced.

truncate_inode_folio() calls truncate_cleanup_folio() under the folio
lock, and truncate_cleanup_folio() calls unmap_mapping_folio() before
filemap_remove_folio().  If a shmem folio is still mapped immediately
after that unmap, then the unmap itself failed to remove all mappings (or
a path outside the folio-lock serialization installed one concurrently).

If this warning does not fire but the later "still mapped when deleted"
warning still does, the mapping must have appeared after this point.  That
distinguishes the two cases without otherwise changing truncate behavior.

Limit the diagnostic to shmem and dump the folio on the first occurrence.

Assisted-by: LLMs
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Ayush Ranjan <ayushr@modal.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/truncate.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/truncate.c~shmem-truncate-unmap-debug
+++ a/mm/truncate.c
@@ -156,6 +156,16 @@ static void truncate_cleanup_folio(struc
 	if (folio_mapped(folio))
 		unmap_mapping_folio(folio);
 
+	/*
+	 * Pin down where the shmem "still mapped when deleted" state appears:
+	 * if the folio is clear here but mapped at removal, something installed
+	 * a mapping after cleanup rather than surviving unmap_mapping_folio().
+	 */
+	if (shmem_mapping(folio->mapping) &&
+	    WARN_ON_ONCE(folio_mapped(folio)))
+		dump_page(&folio->page,
+			  "shmem folio still mapped after unmap_mapping_folio");
+
 	if (folio_needs_release(folio))
 		folio_invalidate(folio, 0, folio_size(folio));
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory_hotplug-factor-out-node_is_memoryless-fix.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix-fix.patch
mm-selftests-add-shmem-into-memory-failure-test-fix.patch
proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma-fix.patch
mm-damon-core-introduce-damos_quota_goal-complement-fix.patch
shmem-truncate-unmap-debug.patch
lib-cmdline-fix-get_options-count-and-overflow-with-large-ranges-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

