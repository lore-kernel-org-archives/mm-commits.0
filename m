Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793404293;
	b=MSMR0HXcJw6+f1RAZs+f0+7+SSqLJiC2HpnJGcSrBJHxGGlQ6qIXzWpzCKudzyQDTlbJ
	 ebYCCaIlCPJmDEcmmBuyE/+enYZeUOgssVjXDwkTV8iZXpjdTkNPTtBE5o1HI6bCA5P0D
	 wLNArDF2s0X1WCLY0ePqky8DffwQm/795YlMxk/wZhP0MOI0143RPo6IHXNr50fAyvQKN
	 CW1dq1YhDToIuhImZO63VQ44XyRJmfuVdITo7eakL2xEoeiZo969Qbdwhqh3dWf2iptCW
	 Z4tIrHjHNYBUgF577G38lvGeZtdsDadk9ueCQDrmhjbistcBMj6IBPA/4p/tcLznTjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793404293;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Ie3EhAu/K/l8qn/fPsVnzWB5UBSkKsb7gVpQMJduoaY=;
	b=zLDKZblibE9Wuo+pKX4fDp23UzHugWHf5xczEJ5NG74Hok3GehXOOUuH5Uw4bsjMyc7l
	 rk/n7LIneO24bzdXaUqZsVFIVlkYArg5m2yiaN1IM651AGdAHqSpitWKB0zpPG4+NQTLT
	 bKcGFJ5BC7jGpIf7eZDSZO4WumMYib08i+MsqPSvaXxWJnJBYR0oRrT8YPqw8UKEDlVEZ
	 M0o3enQsmCfuFjIhTVkJs6m7f959b9EhUjKr0VSN4/NJFjYKTcV+E/peXetQZJ8Fm04ml
	 BlgVA0HPzDAqWPGN07jN/oK0tdDbRxt/ehAOcX1uRSfSajyG8tr5wL+0AkULHRVkxNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SRmPhLS8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBC9606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 23:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SRmPhLS8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207121F000C1;
	Fri, 30 Oct 2026 23:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793404293;
	bh=Ie3EhAu/K/l8qn/fPsVnzWB5UBSkKsb7gVpQMJduoaY=;
	h=Date:To:From:Subject;
	b=SRmPhLS8hdwertfZ00dUhCaLEF3VTgFZOc+BffyuBVKkafdqWNa4r8+W8fUKzs+3l
	 k8zKk7H9H7z0TWLXycZmKLYO2XRWvGdUOZY49BBxACg4CC6DsAEsCfYsDtZnH1U5Fx
	 TwQU+OYNs9GGBcKs7X8cfVSgPvPwVAut6e1cZNVA=
Date: Fri, 30 Oct 2026 16:51:32 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,
	liam@infradead.org,david@kernel.org,azpijr@gmail.com,
	anshuman.khandual@arm.com,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-remove-unused-vmf_insert_mixed_mkwrite.patch added to mm-new branch
Message-Id: <20261030235133.207121F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/memory: remove unused vmf_insert_mixed_mkwrite()
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-remove-unused-vmf_insert_mixed_mkwrite.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-remove-unused-vmf_insert_mixed_mkwrite.patch

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
---

 include/linux/mm.h |    2 --
 mm/memory.c        |   16 +++++-----------
 2 files changed, 5 insertions(+), 13 deletions(-)

--- a/include/linux/mm.h~mm-memory-remove-unused-vmf_insert_mixed_mkwrite
+++ a/include/linux/mm.h
@@ -4986,8 +4986,6 @@ vm_fault_t vmf_insert_pfn_prot(struct vm
 			unsigned long pfn, pgprot_t pgprot);
 vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn);
-vm_fault_t vmf_insert_mixed_mkwrite(struct vm_area_struct *vma,
-		unsigned long addr, unsigned long pfn);
 int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len);
 
 static inline vm_fault_t vmf_insert_page(struct vm_area_struct *vma,
--- a/mm/memory.c~mm-memory-remove-unused-vmf_insert_mixed_mkwrite
+++ a/mm/memory.c
@@ -3058,6 +3058,11 @@ static vm_fault_t __vm_insert_mixed(stru
 
 	if (err == -ENOMEM)
 		return VM_FAULT_OOM;
+	/*
+	 *  If the insertion of PTE failed because someone else already added a
+	 *  different entry in the mean time, we treat that as success as we assume
+	 *  the same entry was actually inserted.
+	 */
 	if (err < 0 && err != -EBUSY)
 		return VM_FAULT_SIGBUS;
 
@@ -3092,17 +3097,6 @@ vm_fault_t vmf_insert_mixed(struct vm_ar
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

mm-memory-remove-unused-vmf_insert_mixed_mkwrite.patch
mm-memory-remove-the-mkwrite-argument-from-__vm_insert_mixed.patch
mm-memory-merge-__vm_insert_mixed-into-vmf_insert_mixed.patch

