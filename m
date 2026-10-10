Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADFF0331EB8
	for <mm-commits@vger.kernel.org>; Sat, 10 Oct 2026 21:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791668359; cv=none; b=hZfUXDYWdCmF0ycCenpOYoJB9ixf6IhDmn5aznhbXuSwMwWcebeN9YAaJ4O+SZl0Pc0slqeYN5ZO+Iyk/i6M5pbuKGvnL3yVDcTf+QUDiV3MgMECkk8b2diJe/cxmlYRQ0LNbA+W/yZepvuQGFr6E0tPVbWQTi4vQCId9VDK6bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791668359; c=relaxed/simple;
	bh=zjO8vx/4epC35QMFMLMaDZutmZInOeVKTPUo4Nf8+80=;
	h=Date:To:From:Subject:Message-Id; b=FtZH+lxcBYQS2L58RKbqduNzJz2QMUT1CLlEGxQzI4AoT5MJuoJujJK0gvOykDx1foz1w2/Yl4iDg4CceHzeGte9JRFp1uW0HjbRXbdUUY3dOOpqC+E+opg32YWdi0KUBMW5VH/LhGTXCCRbWY6y77vRWTynuQfqVNH+xtmiFKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xj4ijTPh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xj4ijTPh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 471F21F00893;
	Sat, 10 Oct 2026 21:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791668358;
	bh=k7izoUAouaadSyAT85lsjtgMUd4YeNPMVtzdxuArUTI=;
	h=Date:To:From:Subject;
	b=xj4ijTPhH/tCinpupdXOtLS4QfGYgusCBwNQGP/prEdrRiU5qiyMc3QiDssdjcLZm
	 nxWpg3Vqi6llakb6N0fTUWWoD0lTYXCaIEwDSIDDZ5w3jyin375JbjqyHCoV73qbnM
	 cDDkycgjvG/trNbKj9dkZ/npqKUodyGdBS/+dI48=
Date: Sat, 10 Oct 2026 14:39:17 -0700
To: mm-commits@vger.kernel.org,okerixx@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-consistently-validate-vma-state-after-mmap-hooks-fix.patch removed from -mm tree
Message-Id: <20261010213918.471F21F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: keep the unlinked VMA off the file across unmap on mmap hook failure
has been removed from the -mm tree.  Its filename was
     mm-consistently-validate-vma-state-after-mmap-hooks-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Oleg Keri <okerixx@gmail.com>
Subject: mm/vma: keep the unlinked VMA off the file across unmap on mmap hook failure
Date: Wed,  7 Oct 2026 21:47:08 +0200

Since commit 2ceb21171dd9 ("mm: consistently validate VMA state after
mmap[_prepare] hooks"), the mmap error path clears vma->vm_file only
after unmap_region(), so free_pgtables() unlinks the never-linked VMA
and drops i_mmap_writable. Once it goes negative, every later shared
writable mmap of that file fails with -EPERM until reboot.

Clear vm_file across unmap_region() only, so that free_pgtables() does
not unlink a VMA that was never linked to the file, and restore it for
vma_close(): when the hook succeeded and the validation failed, the
driver's close() still runs and may use vma->vm_file.

Link: https://lore.kernel.org/20261007194708.2009-1-okerixx@gmail.com
Fixes: 2ceb21171dd9 ("mm: consistently validate VMA state after mmap[_prepare] hooks")
Signed-off-by: Oleg Keri <okerixx@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Bert Karwatzki <spasswolf@web.de>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
---

 mm/vma.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/vma.c~mm-consistently-validate-vma-state-after-mmap-hooks-fix
+++ a/mm/vma.c
@@ -2626,12 +2626,15 @@ static int __mmap_new_file_vma(struct mm
 	map->vm_file = vma->vm_file;
 
 	if (error) {
+		struct file *file = vma->vm_file;
 		UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
 			    map->prev, map->next);
 
+		vma->vm_file = NULL;
 		vma_iter_set(vmi, vma->vm_end);
 		/* Undo any partial mapping done by a device driver. */
 		unmap_region(&unmap);
+		vma->vm_file = file;
 		/* Only safe once unmapped. */
 		vma_close(vma);
 
_

Patches currently in -mm which might be from okerixx@gmail.com are


