Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793404298;
	b=qWrqM+BkSDQmQ4T6bHMguZum3ebPWQaq+voZY4cu5M7H+ApXMQYAVPDzrU9EaOz9W/XA
	 sWCDXTrmqet5IIZP75WLvwAQWbloVNuaRq+EAzdekyyHUTF5SRqQYpT7eDEtbO4aZ0PnX
	 SogcpIHdbfFVw57lHVtabnjFvcdRRMy2JVhiL9hjLB9JvhuEJd3OzI7hbgAh8HrkyR7hV
	 nEb9Zaau5Whl1QugVFYb2N+80qddxN1F4Hu91LcxRPYX69Wcag8ioWWqeQ0Q9pkRqf8zm
	 35l0PxdsIOFUgjc0WN+164UbKrHFUbeXIXyny5wJjmqudLPCRZQ+apnIsEe4N14r/vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793404298;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=uQvkONAcdvNj30rqBr9JMQnXnyxr0ahbXYpH2AewR2g=;
	b=RTOvb5p/ZN9TpB6kuHIfuZgagQl2BEh4D3Xrm3ic5Ougx7Zn7nBAHjWgMQ2jRo2HMEVQ
	 yNXOEMn+0YKAvm/XlqlnRL0jomAOA71vz7HtjI5hjugSuy02CEgpxctebW1fpCVfYqVg5
	 kFHtDJ2kbKJ0IrZ5qXWwbw7TFd2dlA6pgGJgz/1HNc1uNeYqDuKsK0I4Z3cDeOxCVs5yC
	 3IagDhzs8vSnqYcMXFJNhXpvLs8U5kYi6b+QtWLn0VQpUhFErUODzpcivFL+HtpoRN7oq
	 EV50xhasvDB+LdSeGx6Nk1C1YjgpMSI1yks18OPAkg2BHxptH706I6OhTLn+ZlcWTPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=oTNsZC0A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB47606A31F
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 23:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=oTNsZC0A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B69D1F000C1;
	Fri, 30 Oct 2026 23:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793404297;
	bh=uQvkONAcdvNj30rqBr9JMQnXnyxr0ahbXYpH2AewR2g=;
	h=Date:To:From:Subject;
	b=oTNsZC0AdgOL6TAmIKt/1skvKukTBwOgLmh9eXFeewhl//WGxIKgKDscnMKWEBND5
	 +Xj8hLFwghh0obIc7dbpsQ+RpgAJ4U+O5h3THRg+EVyS8dWaoYc/n6lKNbkKUOQyft
	 oOvPSyThFwa+MghB6aORv1CyIz4iOV3GmpK4qPuA=
Date: Fri, 30 Oct 2026 16:51:37 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,
	liam@infradead.org,david@kernel.org,azpijr@gmail.com,
	anshuman.khandual@arm.com,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-merge-__vm_insert_mixed-into-vmf_insert_mixed.patch added to mm-new branch
Message-Id: <20261030235137.6B69D1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/memory: merge __vm_insert_mixed() into vmf_insert_mixed()
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-merge-__vm_insert_mixed-into-vmf_insert_mixed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-merge-__vm_insert_mixed-into-vmf_insert_mixed.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: mm/memory: merge __vm_insert_mixed() into vmf_insert_mixed()
Date: Sat, 03 Oct 2026 01:05:34 +0900

vmf_insert_mixed() just calls __vm_insert_mixed() with the same
arguments.

So merge __vm_insert_mixed() into vmf_insert_mixed().

No functional change.

Link: https://lore.kernel.org/20261002160535.661399-4-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/memory.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/mm/memory.c~mm-memory-merge-__vm_insert_mixed-into-vmf_insert_mixed
+++ a/mm/memory.c
@@ -2997,8 +2997,8 @@ static bool vm_mixed_ok(struct vm_area_s
 	return false;
 }
 
-static vm_fault_t __vm_insert_mixed(struct vm_area_struct *vma,
-		unsigned long addr, unsigned long pfn)
+vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long pfn)
 {
 	pgprot_t pgprot = vma->vm_page_prot;
 	int err;
@@ -3047,6 +3047,7 @@ static vm_fault_t __vm_insert_mixed(stru
 
 	return VM_FAULT_NOPAGE;
 }
+EXPORT_SYMBOL(vmf_insert_mixed);
 
 vm_fault_t vmf_insert_page_mkwrite(struct vm_fault *vmf, struct page *page,
 			bool write)
@@ -3068,13 +3069,6 @@ vm_fault_t vmf_insert_page_mkwrite(struc
 }
 EXPORT_SYMBOL_GPL(vmf_insert_page_mkwrite);
 
-vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
-		unsigned long pfn)
-{
-	return __vm_insert_mixed(vma, addr, pfn);
-}
-EXPORT_SYMBOL(vmf_insert_mixed);
-
 /*
  * maps a range of physical memory into the requested pages. the old
  * mappings are removed. any references to nonexistent pages results
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-memory-remove-unused-vmf_insert_mixed_mkwrite.patch
mm-memory-remove-the-mkwrite-argument-from-__vm_insert_mixed.patch
mm-memory-merge-__vm_insert_mixed-into-vmf_insert_mixed.patch

