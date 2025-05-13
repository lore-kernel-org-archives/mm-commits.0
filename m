Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B386183CB0
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747118622; cv=none; b=qRWadeu+b6HFS6dIM9Eg1xG3cTxnLWXB6iMFNAtdbAI5GJdO8v2WSFHLUgju4pVud3AbEAgPIOT1bJIa2jv1QCfZChWLTrcbqeBcExtCUzweJlrKOzCVqJRtuwiOwKfdeJYH5S/cjpO0EG6kc8sRuRLfG/JG8IIwHKvw/eM8wFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747118622; c=relaxed/simple;
	bh=yNYGK4QoLg7quZqx87zFxB4BpMzxQ2iqTlgU976/N2g=;
	h=Date:To:From:Subject:Message-Id; b=cyNyR4UlDjL7RZJR4+7udDv08pyeZqcGjPUrsfNdjF8XSOSh6OdvUW38b52OzxquBqldRgHpVJnRyIXnZr2fH6sftZFHFL13j9ZJ8njixngMz8EJ6lxzmft8LZn26GYsroJxaH4CgJkRtWyY/h/S/hU9RI/pWKrW8o8OsO1tX+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UZZjNs88; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UZZjNs88"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5E8C4CEE4;
	Tue, 13 May 2025 06:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747118620;
	bh=yNYGK4QoLg7quZqx87zFxB4BpMzxQ2iqTlgU976/N2g=;
	h=Date:To:From:Subject:From;
	b=UZZjNs88CwJgCgWzO4nQgyyZedRq4GxxZe+LLsxrL70rruLgaUhAwOfpiVBjORaES
	 7fxDyosK0gmywo/qSDOeYtG2I4jU5lhYuUT8Z7bgE0ZRneZd8CdwOqXMdcSj39JRqb
	 tjfwdQmedGVCDj1hQlHcPSYLNwiwWGAROXn1cCN0=
Date: Mon, 12 May 2025 23:43:39 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,pfalcato@suse.de,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,kees@kernel.org,jannh@google.com,jack@suse.cz,david@redhat.com,brauner@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality-fix.patch removed from -mm tree
Message-Id: <20250513064339.DF5E8C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality-fix
has been removed from the -mm tree.  Its filename was
     mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality-fix.patch

This patch was dropped because it was folded into mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality-fix
Date: Mon Apr 28 04:06:02 PM PDT 2025

fix comment typo

Link: https://lkml.kernel.org/r/80f0d0c6-0b68-47f9-ab78-0ab7f74677fc@lucifer.local
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vma.h~mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality-fix
+++ a/mm/vma.h
@@ -548,7 +548,7 @@ int expand_downwards(struct vm_area_stru
 
 int __vm_munmap(unsigned long start, size_t len, bool unlock);
 
-/* vma_exec.h */
+/* vma_exec.c */
 #ifdef CONFIG_MMU
 int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift);
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality.patch
mm-perform-vma-allocation-freeing-duplication-in-mm-fix.patch
filemap-do-not-use-folio_contains-for-swap-cache-folios-fix.patch
memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat-fix.patch
mm-add-zblock-allocator-fix.patch
mm-add-zblock-allocator-fix-2.patch
mm-add-zblock-allocator-fix-3.patch
mm-zblock-avoid-failing-the-build-fix.patch
revert-x86-mm-remove-unused-__set_memory_prot-fix.patch

