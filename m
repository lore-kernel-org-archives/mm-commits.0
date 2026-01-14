Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A688625DAEA
	for <mm-commits@vger.kernel.org>; Wed, 14 Jan 2026 22:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768429771; cv=none; b=WlPoM6ndj6sLltgumJhLt4+ztOUihF2Ffrm+1o2ki5WDl5JNi6AwlwqwTgj6rtY9AD+VUFivhYETUW3m6NoY6P2uHY6WmzTijcW2KZVhWWz0z1y4reQ7ij1Cb3OFU+rWBOuC3bfY8HF6eNcTdXQjHAi5Op+kGwnS50CuseV4ETs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768429771; c=relaxed/simple;
	bh=yqYkXT/+6Rv3NbW5fPgZnKQVzN2LLCLek/lFn3H422E=;
	h=Date:To:From:Subject:Message-Id; b=irNP5/1jQKBUz4TVXz52fBf+rD2LusHNtRxcb2IAtRFiSdDyHaa1BsJtod5rtgwTdM6oFsvL0naK8MS6eap/QXyMD7cvHWogArjqNRC53cNyBtIuXdNFuRPGYfcRNX3O1GAgk+Fxn7gBxe95IGAOog2OtXBmyCcKMyzW6m5u3k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zE7gOhdf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zE7gOhdf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A707DC4CEF7;
	Wed, 14 Jan 2026 22:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768429770;
	bh=yqYkXT/+6Rv3NbW5fPgZnKQVzN2LLCLek/lFn3H422E=;
	h=Date:To:From:Subject:From;
	b=zE7gOhdfR3WUyxvA6RGFwgp7Ku1qZ4w9dhviWh/3b5IT7riEFV6hOP9b7FjP7XUNG
	 7noi1TeGuQJdxMpAwuEWHdS8Zc7tdPL9zpyOqyCMpgUeJIORDPuIe6HJc272mHbLVp
	 24HIpSQLEGSuwjwldrj6BxqGFnMRB01nCauti9ZU=
Date: Wed, 14 Jan 2026 14:29:30 -0800
To: mm-commits@vger.kernel.org,yi1.lai@linux.intel.com,clm@fb.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-cleanup-swap-entry-management-workflow-fix.patch added to mm-unstable branch
Message-Id: <20260114222930.A707DC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: fix locking and leaking with hibernation snapshot releasing
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-cleanup-swap-entry-management-workflow-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-cleanup-swap-entry-management-workflow-fix.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: fix locking and leaking with hibernation snapshot releasing
Date: Thu, 15 Jan 2026 00:15:27 +0800

fix leak, per Chris Mason.  Remove WARN_ON, per Lai Yi

Link: https://lkml.kernel.org/r/CAMgjq7AUz10uETVm8ozDWcB3XohkOqf0i33KGrAquvEVvfp5cg@mail.gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Lai Yi <yi1.lai@linux.intel.com>
Cc: Chris Mason <clm@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/swap.c |    2 +-
 mm/swapfile.c       |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/power/swap.c~mm-swap-cleanup-swap-entry-management-workflow-fix
+++ a/kernel/power/swap.c
@@ -199,7 +199,7 @@ void free_all_swap_pages(int swap)
 		ext = rb_entry(node, struct swsusp_extent, node);
 		rb_erase(node, &swsusp_extents);
 
-		for (offset = ext->start; offset < ext->end; offset++)
+		for (offset = ext->start; offset <= ext->end; offset++)
 			swap_free_hibernation_slot(swp_entry(swap, offset));
 
 		kfree(ext);
--- a/mm/swapfile.c~mm-swap-cleanup-swap-entry-management-workflow-fix
+++ a/mm/swapfile.c
@@ -2096,7 +2096,6 @@ void swap_free_hibernation_slot(swp_entr
 
 	ci = swap_cluster_lock(si, offset);
 	swap_entry_put_locked(si, ci, entry, 1);
-	WARN_ON(swap_entry_swapped(si, entry));
 	swap_cluster_unlock(ci);
 
 	/* In theory readahead might add it to the swap cache by accident */
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-rename-__read_swap_cache_async-to-swap_cache_alloc_folio.patch
mm-swap-split-swap-cache-preparation-loop-into-a-standalone-helper.patch
mm-swap-never-bypass-the-swap-cache-even-for-swp_synchronous_io.patch
mm-swap-always-try-to-free-swap-cache-for-swp_synchronous_io-devices.patch
mm-swap-simplify-the-code-and-reduce-indention.patch
mm-swap-free-the-swap-cache-after-folio-is-mapped.patch
mm-shmem-never-bypass-the-swap-cache-for-swp_synchronous_io.patch
mm-swap-swap-entry-of-a-bad-slot-should-not-be-considered-as-swapped-out.patch
mm-swap-consolidate-cluster-reclaim-and-usability-check.patch
mm-swap-split-locked-entry-duplicating-into-a-standalone-helper.patch
mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer.patch
mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer-fix.patch
mm-swap-remove-workaround-for-unsynchronized-swap-map-cache-state.patch
mm-swap-cleanup-swap-entry-management-workflow.patch
mm-swap-cleanup-swap-entry-management-workflow-fix.patch
mm-swap-add-folio-to-swap-cache-directly-on-allocation.patch
mm-swap-check-swap-table-directly-for-checking-cache.patch
mm-swap-clean-up-and-improve-swap-entries-freeing.patch
mm-swap-drop-the-swap_has_cache-flag.patch
mm-swap-remove-no-longer-needed-_swap_info_get.patch
mm-gup-remove-no-longer-used-gup_fast_undo_dev_pagemap.patch

