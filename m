Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D78A13C3F2
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 00:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746665774; cv=none; b=uC+zlwwnlrSvQDHffiMtuOnUYrNWvJbSji10nA2ybJtO/yEuTEUdv3u1C9c8CcQagNbm9rLoawEfIp8whyu+NV48K0TVfTLclcdTn4lzITiOc4uJ1WQiG9PRuMJE146N7kbrboo+cwMirF3BoYGfPbW/1WMVZhvnzB+vhM3hjz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746665774; c=relaxed/simple;
	bh=m1XLlqEUnAfHkZN9VYgNx7w9SSk+UfFUVuJBW6gJF+o=;
	h=Date:To:From:Subject:Message-Id; b=fEO/AQaIEjVmzpcr/kpHZjE/hpFblKWZpBQ3OlE0GmmFZTywanTVOi+iA6hhgOfEgFr49Rht0LGsUrAd0bfv4SlO0aR2L+pm3fNt3/SfIALhYwLnzrrnDdt2WCG9n2ZVNKeG4vAcqIJ0h/NrIJ0bzT9xwN80i9zN/e62nbGkNTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZqhILflZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZqhILflZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B435FC4CEE7;
	Thu,  8 May 2025 00:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746665773;
	bh=m1XLlqEUnAfHkZN9VYgNx7w9SSk+UfFUVuJBW6gJF+o=;
	h=Date:To:From:Subject:From;
	b=ZqhILflZ2YjZZo8L4gCDIyxh49s8IqfTrthtGLBYqQDJ53sDKfLtVbXXnZrfX9Rao
	 pZU14G8gWxnHCuJO8Uczt7IZW/8GDjGsrCQCxlL9trYXBDCPzSHhkgCMAhUmN3TDlw
	 k99S2383oRmObj4zZMWKnyvyiMhnb3K61/ytzso4=
Date: Wed, 07 May 2025 17:56:13 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,liam.howlett@oracle.com,jannh@google.com,jack@suse.cz,david@redhat.com,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-remove-mmap-retry-merge.patch added to mm-unstable branch
Message-Id: <20250508005613.B435FC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: remove mmap() retry merge
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vma-remove-mmap-retry-merge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-remove-mmap-retry-merge.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/vma: remove mmap() retry merge
Date: Wed, 7 May 2025 12:03:36 +0100

We have now introduced a mechanism that obviates the need for a
reattempted merge via the mmap_prepare() file hook, so eliminate this
functionality altogether.

The retry merge logic has been the cause of a great deal of complexity in
the past and required a great deal of careful manoeuvring of code to
ensure its continued and correct functionality.

It has also recently been involved in an issue surrounding maple tree
state, which again points to its problematic nature.

We make it much easier to reason about mmap() logic by eliminating this
and simply writing a VMA once.  This also opens the doors to future
optimisation and improvement in the mmap() logic.

For any device or file system which encounters unwanted VMA fragmentation
as a result of this change (that is, having not implemented .mmap_prepare
hooks), the issue is easily resolvable by doing so.

Link: https://lkml.kernel.org/r/e18be1070e9fcd7a43cd72ac45f19cf1080e73b5.1746615512.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   14 --------------
 1 file changed, 14 deletions(-)

--- a/mm/vma.c~mm-vma-remove-mmap-retry-merge
+++ a/mm/vma.c
@@ -24,7 +24,6 @@ struct mmap_state {
 	void *vm_private_data;
 
 	unsigned long charged;
-	bool retry_merge;
 
 	struct vm_area_struct *prev;
 	struct vm_area_struct *next;
@@ -2417,8 +2416,6 @@ static int __mmap_new_file_vma(struct mm
 			!(map->flags & VM_MAYWRITE) &&
 			(vma->vm_flags & VM_MAYWRITE));
 
-	/* If the flags change (and are mergeable), let's retry later. */
-	map->retry_merge = vma->vm_flags != map->flags && !(vma->vm_flags & VM_SPECIAL);
 	map->flags = vma->vm_flags;
 
 	return 0;
@@ -2624,17 +2621,6 @@ static unsigned long __mmap_region(struc
 	if (have_mmap_prepare)
 		set_vma_user_defined_fields(vma, &map);
 
-	/* If flags changed, we might be able to merge, so try again. */
-	if (map.retry_merge) {
-		struct vm_area_struct *merged;
-		VMG_MMAP_STATE(vmg, &map, vma);
-
-		vma_iter_config(map.vmi, map.addr, map.end);
-		merged = vma_merge_existing_range(&vmg);
-		if (merged)
-			vma = merged;
-	}
-
 	__mmap_complete(&map, vma);
 
 	return addr;
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-reverse-mapping-section.patch
maintainers-add-core-mm-section.patch
maintainers-add-mm-thp-section.patch
maintainers-add-mm-thp-section-fix.patch
tools-testing-selftests-fix-guard-region-test-tmpfs-assumption.patch
maintainers-add-mm-gup-section.patch
mm-vma-fix-incorrectly-disallowed-anonymous-vma-merges.patch
tools-testing-add-procmap_query-helper-functions-in-mm-self-tests.patch
tools-testing-selftests-assert-that-anon-merge-cases-behave-as-expected.patch
mm-move-mmap-vma-locking-logic-into-specific-files.patch
mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality.patch
mm-abstract-initial-stack-setup-to-mm-subsystem.patch
mm-move-dup_mmap-to-mm.patch
mm-perform-vma-allocation-freeing-duplication-in-mm.patch
mm-introduce-new-mmap_prepare-file-callback.patch
mm-secretmem-convert-to-mmap_prepare-hook.patch
mm-vma-remove-mmap-retry-merge.patch

