Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD62B1E3772
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747118647; cv=none; b=UprTW58Hxyl8mkgZjW6ZNRY55zWzV0hbLuzsewr1Z7rTzZOl20/vNkJ6C5rHVvap7rBdV+Ugo41oTE0e0jf0zBkkqXX2u60741re4YxfV7Y0+xmZZ2HPB5gyickzz7UZLT+CCNGYa3EMRjDZbC8jIKoemMnftzB8c2stoJCL9Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747118647; c=relaxed/simple;
	bh=gcwn9/LKBB/qZTeYOe15DCr6msFVSrMzuxUEc35z76s=;
	h=Date:To:From:Subject:Message-Id; b=cMQaGj01YtCzhHvdfy1EPWRsp6OnHGZP4BFV+XbXxkffI9Kt9MBIHLatZ2wp4LBListBqXo0WbrFvmwbOB2bKbJoymm8u7qJKTBeKFoA7LAbF3y4kesiJyrDkHmMbtQHOJCd44w3t5ThepvgKjC8s/iYswIJLc3hhzyXJuiDyoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c8Ua6lJT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c8Ua6lJT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D1CC4CEE4;
	Tue, 13 May 2025 06:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747118647;
	bh=gcwn9/LKBB/qZTeYOe15DCr6msFVSrMzuxUEc35z76s=;
	h=Date:To:From:Subject:From;
	b=c8Ua6lJTpSKz/GhpBzNQOxDSpqqniRkHzwGI+yB30JEDDZ69BX+ztk4av2VJ3m8Ev
	 3b7tUBRe+hyfa6f3P5ChUJvigNfFvi+JLVoKPhpw4OJQfdE5876N/loTcS+WHJT4Dh
	 fBb8NC+ex3QIJkcs/Mz734oSrdoAGpuRBlGdDghw=
Date: Mon, 12 May 2025 23:44:06 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,pfalcato@suse.de,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,kees@kernel.org,jannh@google.com,jack@suse.cz,david@redhat.com,brauner@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-perform-vma-allocation-freeing-duplication-in-mm-fix.patch removed from -mm tree
Message-Id: <20250513064407.81D1CC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-perform-vma-allocation-freeing-duplication-in-mm-fix
has been removed from the -mm tree.  Its filename was
     mm-perform-vma-allocation-freeing-duplication-in-mm-fix.patch

This patch was dropped because it was folded into mm-perform-vma-allocation-freeing-duplication-in-mm.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-perform-vma-allocation-freeing-duplication-in-mm-fix
Date: Mon Apr 28 12:52:37 PM PDT 2025

remove stray newline, per Liam

Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.h |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/vma.h~mm-perform-vma-allocation-freeing-duplication-in-mm-fix
+++ a/mm/vma.h
@@ -548,7 +548,6 @@ int expand_downwards(struct vm_area_stru
 
 int __vm_munmap(unsigned long start, size_t len, bool unlock);
 
-
 int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma);
 
 /* vma_init.h, shared between CONFIG_MMU and nommu. */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-perform-vma-allocation-freeing-duplication-in-mm.patch
filemap-do-not-use-folio_contains-for-swap-cache-folios-fix.patch
memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat-fix.patch
mm-add-zblock-allocator-fix.patch
mm-add-zblock-allocator-fix-2.patch
mm-add-zblock-allocator-fix-3.patch
mm-zblock-avoid-failing-the-build-fix.patch
revert-x86-mm-remove-unused-__set_memory_prot-fix.patch

