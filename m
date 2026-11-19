Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061304;
	b=Q0y4h3LJE8xn+xpzXvuw56VtmQ4LUT7K80lsKuqDvpUUVz7iRLFPX8hVLKqFNY6y07p/
	 d0pOUZJ7U3J4KW4PfrK35fJv/9p5OZtzmm72r3s4zGevn8fL0x0xCSSkdWr/gVxIwfMzi
	 LvxrFCHwGvwO6NwUw0CPEYplZGvZKk2YsinZQcXUsqIZCHohW/BKYRbpH3czdAeRhx6sn
	 aNINrdapdA2sPuF7xGKfOVLaki57YxkEitVPwvgNTb2TNBqXRD5fVIIGHMEhb+PAQ/t/n
	 FkgN2O6lxFFjUfAB97lIFwyNXtH4ROLjJ+QOJZ5CgABqz8VgeSqirzpOYQtRe71HFLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061304;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Dvr8oOKNWteOrQEVjSem6tl8d09TbWdHUa6R928ExYg=;
	b=Wynm+9/tqp9mJPHhwzhThjUyRfJkOmUlcBJgRSAZEI/4t6qPlVxCkItZP3UKtqJDMKj6
	 vBkCV6dwSgfjBLbwlx6fia63HK1DOdZ7yQHXqDoK8XLug/BXLHUTEHtmrrFeD2plV10IE
	 NjqKp2y/xg3aYFHN8GB9MUzYg0sHq4ggT9MA1buWe5xJbDf8vrawY8BgCOdV3Upg17P7M
	 iCkHBSm7iG4ZkS296RB4z9iagXVldWUgmMhPVJQESr3+LJMqbONwt3oKXfGz4b1de5lBM
	 uVxRO9z8qV0Mt2a3CEqi5Vf7wW5KXVlVoOB6toaLkAF/W1spq1v+JnCaxPp6kAwVslA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ILeR171i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABB1606A32C
	for <mm-commits@vger.kernel.org>; Thu, 19 Nov 2026 04:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ILeR171i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664551F000C4;
	Thu, 19 Nov 2026 04:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795061304;
	bh=Dvr8oOKNWteOrQEVjSem6tl8d09TbWdHUa6R928ExYg=;
	h=Date:To:From:Subject;
	b=ILeR171ib39pvPtfZw+7aeMDZQK89P/V1ZFO7eJUcNcAarZFqMoTlMqXHLuY1Gfb0
	 ARqb8D4hSTHXoSM54d2MDJcClWDqUxwEoMtW1wy8yGuREw4xb4PAXsNJLhY5Uu4DAM
	 K6XFJ8y2YZ2xLAsodGM0UGBBdr5EaI1mKBItZ9lI=
Date: Wed, 18 Nov 2026 20:08:23 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,
	liam@infradead.org,david@kernel.org,azpijr@gmail.com,
	anshuman.khandual@arm.com,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-memory-remove-unused-vmf_insert_mixed_mkwrite.patch removed from -mm tree
Message-Id: <20261119040824.664551F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/memory: remove unused vmf_insert_mixed_mkwrite()
has been removed from the -mm tree.  Its filename was
     mm-memory-remove-unused-vmf_insert_mixed_mkwrite.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: mm/memory: remove unused vmf_insert_mixed_mkwrite()
Date: Sat, 03 Oct 2026 01:05:32 +0900

Patch series "mm/memory: remove unused vmf_insert_mixed_mkwrite()", v2.

Since commit 38607c62b34b ("fs/dax: properly refcount fs dax pages"),
vmf_insert_mixed_mkwrite() has no callers. This series removes it and
the mkwrite handling that only it used.

Patch 1 removes the function.

Patch 2 removes the mkwrite argument, which is then always false. It
also removes the unreachable code in insert_pfn().

Patch 3 merges __vm_insert_mixed() into vmf_insert_mixed().

No functional change.


This patch (of 3):

Since commit 38607c62b34b ("fs/dax: properly refcount fs dax pages"),
vmf_insert_mixed_mkwrite() has no callers.

So remove the function and its declaration.

The comment above the function describes the -EBUSY handling in
__vm_insert_mixed(). Move it above that check.

No functional change.

Link: https://lore.kernel.org/20261002160535.661399-1-ekffu200098@gmail.com
Link: https://lore.kernel.org/20261002160535.661399-2-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>

 include/linux/mm.h |    2 --
 mm/memory.c        |   16 +++++-----------
 2 files changed, 5 insertions(+), 13 deletions(-)

--- a/include/linux/mm.h~mm-memory-remove-unused-vmf_insert_mixed_mkwrite
+++ a/include/linux/mm.h
@@ -5045,8 +5045,6 @@ vm_fault_t vmf_insert_pfn_prot(struct vm
 			unsigned long pfn, pgprot_t pgprot);
 vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn);
-vm_fault_t vmf_insert_mixed_mkwrite(struct vm_area_struct *vma,
-		unsigned long addr, unsigned long pfn);
 int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len);
 
 static inline vm_fault_t vmf_insert_page(struct vm_area_struct *vma,
--- a/mm/memory.c~mm-memory-remove-unused-vmf_insert_mixed_mkwrite
+++ a/mm/memory.c
@@ -3075,6 +3075,11 @@ static vm_fault_t __vm_insert_mixed(stru
 
 	if (err == -ENOMEM)
 		return VM_FAULT_OOM;
+	/*
+	 *  If the insertion of PTE failed because someone else already added a
+	 *  different entry in the mean time, we treat that as success as we assume
+	 *  the same entry was actually inserted.
+	 */
 	if (err < 0 && err != -EBUSY)
 		return VM_FAULT_SIGBUS;
 
@@ -3109,17 +3114,6 @@ vm_fault_t vmf_insert_mixed(struct vm_ar
 EXPORT_SYMBOL(vmf_insert_mixed);
 
 /*
- *  If the insertion of PTE failed because someone else already added a
- *  different entry in the mean time, we treat that as success as we assume
- *  the same entry was actually inserted.
- */
-vm_fault_t vmf_insert_mixed_mkwrite(struct vm_area_struct *vma,
-		unsigned long addr, unsigned long pfn)
-{
-	return __vm_insert_mixed(vma, addr, pfn, true);
-}
-
-/*
  * maps a range of physical memory into the requested pages. the old
  * mappings are removed. any references to nonexistent pages results
  * in null mappings (currently treated as "copy-on-access")
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-memory-remove-the-mkwrite-argument-from-__vm_insert_mixed.patch
mm-memory-merge-__vm_insert_mixed-into-vmf_insert_mixed.patch
fault-inject-use-a-shared-initialization-helper-for-the-random-state.patch
fault-inject-fix-wrong-unit-of-verbose_ratelimit_interval_ms.patch
fault-injection-fix-typo-in-failcmdsh.patch

