Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96EF51FE44A
	for <mm-commits@vger.kernel.org>; Mon, 26 Jan 2026 20:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769458166; cv=none; b=W/QTA5H0xAdoiD4hrUyhHXqa9goIJaHBkcQdmMJvBVUUX9/OhLuRub3SaicSQf/2GA7NQq1JCn1VTnOjcSvtIKj98CvtGkbf4gZkri5n47wYY2yi7qobi9sm4J0bkAUlejTZ56Y1WQQPsZit1zkr+k98vN9dJ595CLsK7qRIFgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769458166; c=relaxed/simple;
	bh=xQ64SWCleAJeAJEu61g8NvgP0Apwip8zxDCjbd0rYtM=;
	h=Date:To:From:Subject:Message-Id; b=VIi+pIBms33+RipJB4oUwabcPKKPFjmu8nBtTCTmVZMFX3X1ZkNE/jbqd9WrYgh4g8sPGLBvVsgLn47/huxbUqiJjzaNmlSJ6uXSSCGXtzloOz2XQQ5J2/XGzE0tvNlwM5C4Kz1C77sk3RMgPLXFoxGyYhKQEVVeSZ8/zBbeDBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vndp/Osv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vndp/Osv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5401FC116C6;
	Mon, 26 Jan 2026 20:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769458166;
	bh=xQ64SWCleAJeAJEu61g8NvgP0Apwip8zxDCjbd0rYtM=;
	h=Date:To:From:Subject:From;
	b=vndp/Osvim4qrXYgpg7STX7nfeFhxEWj0IoUQ6MHJjqz2GUbANJhOrlnj+EVJJ32b
	 PBXMSGgLIAdaPispTfM4YyBP3EHLJmTOdYdODED4chNhVzpqVGAG8yGAlrl0EzDb1s
	 IkgPnD59jBU14+5q7vysV/nMltyTH0lTopO935BE=
Date: Mon, 26 Jan 2026 12:09:25 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,longman@redhat.com,liam.howlett@oracle.com,boqun.feng@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment-fix.patch added to mm-unstable branch
Message-Id: <20260126200926.5401FC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment-fix
Date: Mon Jan 26 12:08:39 PM PST 2026

fix typo, per Suren

Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm_types.h~mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment-fix
+++ a/include/linux/mm_types.h
@@ -1023,7 +1023,7 @@ struct vm_area_struct {
 	 *
 	 * > VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - A thread is either
 	 * write-locking or detaching a VMA is waiting on readers to
-	 * exit. IMPORTANT - as above, no ruther readers can increment the
+	 * exit. IMPORTANT - as above, no further readers can increment the
 	 * reference count.
 	 *
 	 * NOTE: Unstable RCU readers are allowed to read this.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kho-kho_preserve_vmalloc-dont-return-0-when-enomem.patch
memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch
mm-relocate-the-page-table-ceiling-and-floor-definitions-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix-fix.patch
sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests-fix.patch
mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment-fix.patch
mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
mm-pagewalk-use-min-to-simplify-the-code-fix.patch

