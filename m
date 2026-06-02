Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C593C4577
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439144; cv=none; b=Ch3ZhsvlYZ75p/cYjOjb4ckXtgdT14ZHz3ue7iVX8qBhYq4P51MAWCVosyNWQLn2hx+XQaU7GXlWmTtII7gtLbRppU24BJUxg4dYYHbboOSgRePqSH3HJtSdm1+N5cgN1P6TFSRyXGI/nyGGkIaneEJ69TzkPFDa4EV0EBNM3fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439144; c=relaxed/simple;
	bh=9M7gLuWf6ek6v7gAceUNtBZKXu7J1V0hWb34ieNS+lc=;
	h=Date:To:From:Subject:Message-Id; b=btxXh6IlQd7iiRVbrGqLMqkVYRXC6dSaa5D39QYXTos8dvC94OjN1dxLiG0j6fD/KTviwQjtBqIKWP//ZRXNYv4CzK93UdX+AtSpWl346TpvJAWtuvibxlEARCI4nnR57GvR4PJk/jk6w69wLy7HM8SEsDRdcnrESGEs83LnShs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FXs0DCN7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FXs0DCN7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352491F00893;
	Tue,  2 Jun 2026 22:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439143;
	bh=eThAZWELk8MbRbrXNHsu8R41sJaAZuSRxFGaVl1cHSc=;
	h=Date:To:From:Subject;
	b=FXs0DCN7GeeZOIjvLvsCkIyKqbq1b2AJviwhadq1YP8bceGKlwdWYykjulHMcRbfI
	 tGAZOehYNKxLGawtY6X90LkRYTO9tTFwlz0lepwm4HRj4ZCxwdX8XrLpOcJvPcLDpG
	 H/nKaJZnwWxYXBDNDgGksmPS1sqx51/xABHbWqxI=
Date: Tue, 02 Jun 2026 15:25:42 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,liam@infradead.org,jannh@google.com,gregkh@linuxfoundation.org,david@kernel.org,arnd@arndb.de,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-remove-mmap_action-success_hook.patch removed from -mm tree
Message-Id: <20260602222543.352491F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: remove mmap_action->success_hook
has been removed from the -mm tree.  Its filename was
     mm-vma-remove-mmap_action-success_hook.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm/vma: remove mmap_action->success_hook
Date: Tue, 2 Jun 2026 12:06:26 +0100

This hook was introduced to work around code that seemed to absolutely
require access to a VMA pointer upon mmap().

However, providing this hook leaves a backdoor to drivers getting access
to the very thing mmap_prepare eliminates - a pointer to the VMA.

Let's solve this contradiction by removing it.  The key intended user was
hugetlb, however it seems that the best course now is to avoid allowing
all drivers the ability to work around mmap_prepare, and find a different
solution there.

Link: https://lore.kernel.org/f79434e6d30af6d92999be6b76e197f1847105fa.1780397980.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h        |   10 ----------
 mm/util.c                       |    2 --
 tools/testing/vma/include/dup.h |   10 ----------
 3 files changed, 22 deletions(-)

--- a/include/linux/mm_types.h~mm-vma-remove-mmap_action-success_hook
+++ a/include/linux/mm_types.h
@@ -844,16 +844,6 @@ struct mmap_action {
 	enum mmap_action_type type;
 
 	/*
-	 * If specified, this hook is invoked after the selected action has been
-	 * successfully completed. Note that the VMA write lock still held.
-	 *
-	 * The absolute minimum ought to be done here.
-	 *
-	 * Returns 0 on success, or an error code.
-	 */
-	int (*success_hook)(const struct vm_area_struct *vma);
-
-	/*
 	 * If specified, this hook is invoked when an error occurred when
 	 * attempting the selected action.
 	 *
--- a/mm/util.c~mm-vma-remove-mmap_action-success_hook
+++ a/mm/util.c
@@ -1397,8 +1397,6 @@ static int mmap_action_finish(struct vm_
 
 	if (!err)
 		err = call_vma_mapped(vma);
-	if (!err && action->success_hook)
-		err = action->success_hook(vma);
 
 	/* do_munmap() might take rmap lock, so release if held. */
 	maybe_rmap_unlock_action(vma, action);
--- a/tools/testing/vma/include/dup.h~mm-vma-remove-mmap_action-success_hook
+++ a/tools/testing/vma/include/dup.h
@@ -483,16 +483,6 @@ struct mmap_action {
 	enum mmap_action_type type;
 
 	/*
-	 * If specified, this hook is invoked after the selected action has been
-	 * successfully completed. Note that the VMA write lock still held.
-	 *
-	 * The absolute minimum ought to be done here.
-	 *
-	 * Returns 0 on success, or an error code.
-	 */
-	int (*success_hook)(const struct vm_area_struct *vma);
-
-	/*
 	 * If specified, this hook is invoked when an error occurred when
 	 * attempting the selection action.
 	 *
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-huge_memory-use-correct-flags-for-device-private-pmd-entry.patch

