Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC38220F067
	for <mm-commits@vger.kernel.org>; Wed, 14 Jan 2026 21:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768427865; cv=none; b=sF1sQFPudoxVkF0iM181gJu/tIDaXl/ujsiqcrtbVfi/8ZXkwccYbjCj5h1gAu/zYP8a8qGD3Mq0mOreJDcVgdyKpTfdQsmkzsQU+xz4cjKgxs9Zd5Wv4w9YeWbv37TP87jBofT9NeVzj6NtT7S6w/aOouKbWgXIixnnkxblK/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768427865; c=relaxed/simple;
	bh=oDp+QTQu/vVHeC3lvzny/NO+i1v4k9OX3bzeai9Vrhg=;
	h=Date:To:From:Subject:Message-Id; b=X9YiTnQxiXK+R8OQLduhCfzwhy6XTdLMh3YuIBx4z8tURDZ0NVy1BfEsefBWsYTah0+qKxJl/nubhRpwxX5aJ3ZumANSb0tleKAv44CAgyGnWQfZnqNjLHFxOqPcqKvt8n4WYArcb3LOkkrUx3DH8+/pZ9RARZtmGqdcAtG6vFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WOu0gwK7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WOu0gwK7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE524C4CEF7;
	Wed, 14 Jan 2026 21:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768427864;
	bh=oDp+QTQu/vVHeC3lvzny/NO+i1v4k9OX3bzeai9Vrhg=;
	h=Date:To:From:Subject:From;
	b=WOu0gwK7fCzma0LzzZ+15rH4elBND/7nuXFfmym5K/uGTGiG/tsG27ccLPQJYB5+7
	 X4CfcJjrMNAXb/Lrz1XnQCu+Sqw7bgpGqPEXpQOLLy+SuPBAc325alubx2Ib/cL4D+
	 QtKqLd337lFui9yDlqjXFbvR8bmyjnETb+HL6Wr8=
Date: Wed, 14 Jan 2026 13:57:43 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts-fix.patch added to mm-unstable branch
Message-Id: <20260114215744.CE524C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts-fix.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts-fix
Date: Wed, 14 Jan 2026 18:52:37 +0000

fix missed unlock, per Suren

Link: https://lkml.kernel.org/r/6fb9d6b4-ad39-41de-8db0-aa41a6406378@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/rmap.c~mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts-fix
+++ a/mm/rmap.c
@@ -432,7 +432,7 @@ int anon_vma_fork(struct vm_area_struct
 static void cleanup_partial_anon_vmas(struct vm_area_struct *vma)
 {
 	struct anon_vma_chain *avc, *next;
-	bool locked = false;
+	struct anon_vma *root = NULL;
 
 	/*
 	 * We exclude everybody else from being able to modify anon_vma's
@@ -444,15 +444,18 @@ static void cleanup_partial_anon_vmas(st
 		struct anon_vma *anon_vma = avc->anon_vma;
 
 		/* All anon_vma's share the same root. */
-		if (!locked) {
-			anon_vma_lock_write(anon_vma);
-			locked = true;
+		if (!root) {
+			root = anon_vma->root;
+			anon_vma_lock_write(root);
 		}
 
 		anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
 		list_del(&avc->same_vma);
 		anon_vma_chain_free(avc);
 	}
+
+	if (root)
+		anon_vma_unlock_write(root);
 }
 
 /**
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-do-not-leak-memory-when-mmap_prepare-swaps-the-file.patch
mm-remove-unnecessary-and-incorrect-mmap-lock-assert.patch
mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts.patch
mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts-fix.patch
mm-rmap-skip-unfaulted-vmas-on-anon_vma-clone-unlink.patch
mm-rmap-remove-unnecessary-root-lock-dance-in-anon_vma-clone-unmap.patch
mm-rmap-remove-anon_vma_merge-function.patch
mm-rmap-make-anon_vma-functions-internal.patch
mm-mmap_lock-add-vma_is_attached-helper.patch
mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible.patch
mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible-fix.patch
mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone.patch
mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone-fix.patch

