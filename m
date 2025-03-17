Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FADE21518B
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188235; cv=none; b=oFSl3c8RiBdwzaFvMmi8GEcx5pTJlyoNvIpuJE6zPE/jNhStzIbsDRsFVox1urHLIeuMlEV5gNHD4kLN70phcCN7PTZ59qAMJybWSaupDw0y7XFiOxnbMtN20Xdknfj+2ZX4SAiS8GaY8PINTAZlPNSYtzqe0lI/9nG1xC+gD3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188235; c=relaxed/simple;
	bh=rd4fo3N0eIMjdZlBgWiWe3aE+lAPFozZzg0aSr66NL4=;
	h=Date:To:From:Subject:Message-Id; b=QZOgRiq2TxQm46q5dTbkoH5yjKAN5rTrQ6uQSiqOWYUY5L/TeOGWwQHAeyy7MmZeq9RFrETwldVkvvZ/kfIc1abHCY4kFmzbDyKQltmKLpBbguQT4eAppjtpxvvat2/AXQK/oLRwGUSv4CPirDLj7FFq2A+6v4tmi2j/SPxr/fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P2vYQ2Of; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P2vYQ2Of"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670E8C4CEEC;
	Mon, 17 Mar 2025 05:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188235;
	bh=rd4fo3N0eIMjdZlBgWiWe3aE+lAPFozZzg0aSr66NL4=;
	h=Date:To:From:Subject:From;
	b=P2vYQ2Ofz4JG25fLj/Uf38Of42yFDgd8bnS1ZOREi6kih1XBe3W1kpMK0EJdYXrLe
	 lJmqMHmLCi5e6neG3z/b0ZifiSj4a2PCnw+wkvLHxIqDsjXOAK8nehZzOVrp+3Y0ae
	 gg9aicFhYlXmT56ovv1FQPh2MaVNuW4pF8gI4h5o=
Date: Sun, 16 Mar 2025 22:10:34 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap_statec-fix-the-obsolete-code-comment.patch removed from -mm tree
Message-Id: <20250317051035.670E8C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap_state.c: fix the obsolete code comment
has been removed from the -mm tree.  Its filename was
     mm-swap_statec-fix-the-obsolete-code-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/swap_state.c: fix the obsolete code comment
Date: Wed, 5 Feb 2025 17:27:10 +0800

Patch series "Tiny cleanup and improvements about SWAP code".

These are all made during review and from reading the patchset "[PATCH v3
00/13] mm, swap: rework of swap allocator locks" from Kairui.


This patch (of 12):

Since commit 85a1333417a7 ("mm/swap: use dedicated entry for swap in
folio"), there's a dedicated field in folio for swap entry.  Let's update
the code comment above add_to_swap_cache() accordingly.

Link: https://lkml.kernel.org/r/20250205092721.9395-1-bhe@redhat.com
Link: https://lkml.kernel.org/r/20250205092721.9395-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Cc: Baoquan he <bhe@redhat.com>
Cc: Chris Li <chrisl@kernel.org> (Google)
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swap_state.c~mm-swap_statec-fix-the-obsolete-code-comment
+++ a/mm/swap_state.c
@@ -85,7 +85,7 @@ void *get_shadow_from_swap_cache(swp_ent
 
 /*
  * add_to_swap_cache resembles filemap_add_folio on swapper_space,
- * but sets SwapCache flag and private instead of mapping and index.
+ * but sets SwapCache flag and 'swap' instead of mapping and index.
  */
 int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
 			gfp_t gfp, void **shadowp)
_

Patches currently in -mm which might be from bhe@redhat.com are


