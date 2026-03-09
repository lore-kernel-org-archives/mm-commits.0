Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10435218AB9
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 19:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773083789; cv=none; b=U33/0ecj0RVWXj3cWZj6/QS2+zNWzzyja8SkteiSxCXBQZg1SutMqnPg/R280y3AuYNjcJmJKic60xc8U0JZYhGW84n5bIi7e68Um5kfMt8L0D6DR+ef504Yi18EmR71kYDjB+t2iSsqIhRxwSfyoMUWpiidDKzsgbUmcgLHPHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773083789; c=relaxed/simple;
	bh=/h/fM+7w+Q8bPx+4PBpB6tTw7Cvt5gfZX57zBkhjDiU=;
	h=Date:To:From:Subject:Message-Id; b=AlvPU9kzUUqwQgetPc4Jqy8Jt5J8eSfxDpvfrzKkTJqYhRip7QMjxYS+K2tOCjHtE2VznFfjDsbmomGkJdUgWNA/+w911svqVRMhYsiJy2FpcVB2dCcDbVEvaFJvmF9ZgBA4yJMXZBUvLpapq7YZYRn5H04ovYo//dxonC9pogw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PpXuSjB/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PpXuSjB/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1BD4C4CEF7;
	Mon,  9 Mar 2026 19:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773083788;
	bh=/h/fM+7w+Q8bPx+4PBpB6tTw7Cvt5gfZX57zBkhjDiU=;
	h=Date:To:From:Subject:From;
	b=PpXuSjB/YGb792vWzQoYDBrDzMia7eAFByQHU66Ncwy9k/hIlzymvfLsV7SUR0VK7
	 YO6P1ok9Dclxg+4La7iWigLzEsJubtzv1sflVEYWCBZkSSF/HMWs5iySk8C4WDPrtK
	 fahIDk5gSBue56ivAoheBPhzRkeiqZM7lIjxRn3Q=
Date: Mon, 09 Mar 2026 12:16:29 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jason@zx2c4.com,jannh@google.com,david@kernel.org,anthony.yznaga@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-prevent-droppable-mappings-from-being-locked.patch removed from -mm tree
Message-Id: <20260309191628.B1BD4C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: prevent droppable mappings from being locked
has been removed from the -mm tree.  Its filename was
     mm-prevent-droppable-mappings-from-being-locked.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Anthony Yznaga <anthony.yznaga@oracle.com>
Subject: mm: prevent droppable mappings from being locked
Date: Fri, 6 Mar 2026 12:45:50 -0800

Mappings created with MAP_DROPPABLE cannot be locked via mlock() due to
the check in mlock_fixup().  However, they will be locked indirectly if
they are created after mlockall(MCL_FUTURE).

Link: https://lkml.kernel.org/r/20260306204550.8405-1-anthony.yznaga@oracle.com
Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 +++
 mm/mlock.c         |    4 ++--
 mm/vma.c           |    2 +-
 3 files changed, 6 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h~mm-prevent-droppable-mappings-from-being-locked
+++ a/include/linux/mm.h
@@ -573,6 +573,9 @@ enum {
 /* This mask represents all the VMA flag bits used by mlock */
 #define VM_LOCKED_MASK	(VM_LOCKED | VM_LOCKONFAULT)
 
+/* This mask prevents VMAs from being mlock'd */
+#define VM_NO_MLOCK_MASK	(VM_SPECIAL | VM_DROPPABLE)
+
 /* These flags can be updated atomically via VMA/mmap read lock. */
 #define VM_ATOMIC_SET_ALLOWED VM_MAYBE_GUARD
 
--- a/mm/mlock.c~mm-prevent-droppable-mappings-from-being-locked
+++ a/mm/mlock.c
@@ -472,9 +472,9 @@ static int mlock_fixup(struct vma_iterat
 	int ret = 0;
 	vm_flags_t oldflags = vma->vm_flags;
 
-	if (newflags == oldflags || (oldflags & VM_SPECIAL) ||
+	if (newflags == oldflags || (oldflags & VM_NO_MLOCK_MASK) ||
 	    is_vm_hugetlb_page(vma) || vma == get_gate_vma(current->mm) ||
-	    vma_is_dax(vma) || vma_is_secretmem(vma) || (oldflags & VM_DROPPABLE))
+	    vma_is_dax(vma) || vma_is_secretmem(vma))
 		/* don't set VM_LOCKED or VM_LOCKONFAULT and don't count */
 		goto out;
 
--- a/mm/vma.c~mm-prevent-droppable-mappings-from-being-locked
+++ a/mm/vma.c
@@ -2589,7 +2589,7 @@ static void __mmap_complete(struct mmap_
 
 	vm_stat_account(mm, vma->vm_flags, map->pglen);
 	if (vm_flags & VM_LOCKED) {
-		if ((vm_flags & VM_SPECIAL) || vma_is_dax(vma) ||
+		if ((vm_flags & VM_NO_MLOCK_MASK) || vma_is_dax(vma) ||
 					is_vm_hugetlb_page(vma) ||
 					vma == get_gate_vma(mm))
 			vm_flags_clear(vma, VM_LOCKED_MASK);
_

Patches currently in -mm which might be from anthony.yznaga@oracle.com are

mm-prevent-droppable-mappings-from-being-locked-fix.patch

