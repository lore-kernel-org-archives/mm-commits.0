Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414A91D619F
	for <mm-commits@vger.kernel.org>; Wed, 14 Aug 2024 20:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723668029; cv=none; b=fxTADPj8Rjk3z8jZHMbkLB7jhGpQqfbjcJ6JIGQgULX32PJZ7vl2/RO5NE7UpsIq4oJer3VS9Sfdao9sBVtr2u2BuDLQSoqapcMoOjdbwUzNmm+m4lEdS2Pa3bwUuKGCfXhUfe9HFsz18SAnvlPMjkzwsj9xcwz4WnPeUkhcZl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723668029; c=relaxed/simple;
	bh=DtR+wxYTeAQZeUClPJGKrkyppoRKI4VvX+GuYXzrqec=;
	h=Date:To:From:Subject:Message-Id; b=iB94gg0i0aB+ZZ5GTwErgLcJg3ghXiD9Kz2VW9CA2glFrCfa6r+E+ZuYVDmvn0Q9CQMPLJs7lNTvqFu1niecM0S70em0fLZidOGwvAwtl0e4VNJ8WJthFdg2YI/KFv80fOM7biKWe9EtNTno417nbyxyfawo5te5zX/0hjvpVGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FKt/ku7c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FKt/ku7c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14BB0C116B1;
	Wed, 14 Aug 2024 20:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723668029;
	bh=DtR+wxYTeAQZeUClPJGKrkyppoRKI4VvX+GuYXzrqec=;
	h=Date:To:From:Subject:From;
	b=FKt/ku7cp3qr41T/BEuzZmAR4pbzGOsYS95KedczbPc8AjxKv9yRY5PZl5Ii9onJ3
	 NBLdHmeBOxihxvuvafdZclx3gMDfYMrQIJikVvLQJghHF7Qz8UuNyykOZTSotHcvx4
	 FghoWMR0x/Cs696gpXdtdyT/NCVqHwZNk3dBdkMs=
Date: Wed, 14 Aug 2024 13:40:28 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-preallocate-nodes-in-mas_erase.patch added to mm-unstable branch
Message-Id: <20240814204029.14BB0C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: preallocate nodes in mas_erase()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-preallocate-nodes-in-mas_erase.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-preallocate-nodes-in-mas_erase.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: preallocate nodes in mas_erase()
Date: Wed, 14 Aug 2024 12:19:33 -0400

Use mas_wr_preallocate() in mas_erase() to preallocate enough nodes to
complete the erase.  Add error handling by skipping the store if the
preallocation lead to some error besides no memory.

Link: https://lkml.kernel.org/r/20240814161944.55347-7-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-preallocate-nodes-in-mas_erase
+++ a/lib/maple_tree.c
@@ -6371,14 +6371,18 @@ write_retry:
 
 	/* Must reset to ensure spanning writes of last slot are detected */
 	mas_reset(mas);
-	mas_wr_store_setup(&wr_mas);
-	mas_wr_store_entry(&wr_mas);
+	mas_wr_preallocate(&wr_mas, NULL);
 	if (mas_nomem(mas, GFP_KERNEL)) {
 		/* in case the range of entry changed when unlocked */
 		mas->index = mas->last = index;
 		goto write_retry;
 	}
 
+	if (mas_is_err(mas))
+		goto out;
+
+	mas_wr_store_entry(&wr_mas);
+out:
 	mas_destroy(mas);
 	return entry;
 }
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

maple_tree-reset-mas-index-and-mas-last-on-write-retries.patch
maple_tree-add-test-to-replicate-low-memory-race-conditions.patch
maple_tree-introduce-store_type-enum.patch
maple_tree-introduce-mas_wr_prealloc_setup.patch
maple_tree-move-up-mas_wr_store_setup-and-mas_wr_prealloc_setup.patch
maple_tree-introduce-mas_wr_store_type.patch
maple_tree-remove-mas_destroy-from-mas_nomem.patch
maple_tree-preallocate-nodes-in-mas_erase.patch
maple_tree-use-mas_store_gfp-in-mtree_store_range.patch
maple_tree-print-store-type-in-mas_dump.patch
maple_tree-use-store-type-in-mas_wr_store_entry.patch
maple_tree-convert-mas_insert-to-preallocate-nodes.patch
maple_tree-simplify-mas_commit_b_node.patch
maple_tree-remove-mas_wr_modify.patch
maple_tree-have-mas_store-allocate-nodes-if-needed.patch
maple_tree-remove-node-allocations-from-various-write-helper-functions.patch
maple_tree-remove-repeated-sanity-checks-from-write-helper-functions.patch
maple_tree-remove-unneeded-mas_wr_walk-in-mas_store_prealloc.patch
maple_tree-make-write-helper-functions-void.patch

