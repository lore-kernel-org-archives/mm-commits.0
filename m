Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65EA9E571
	for <mm-commits@vger.kernel.org>; Tue, 16 Sep 2025 03:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757992690; cv=none; b=m+Pg3DlGpEJDc4Pw8qUaZCvTOW7XHJdPH8WmgkU3NB7po/Jj76TfdtKrEYbpntnxqJbD47uo3sY1GQN7Q/eaC3EuehtagFxeABv/DEPamSKahqTAHO9UXNrKUe/aKiNgbhZ0JW291tjhwqwcHRV6/5RosBTcPVih75bX4V7miAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757992690; c=relaxed/simple;
	bh=cU112z2sX8C+dlrHuaYfRDpBsoQFCCwX8zBdjrc7YEQ=;
	h=Date:To:From:Subject:Message-Id; b=IZWpEwWrBDFtOY2xL8L7gSzSmXdILrztyRHYL4E/Oy/s83kK0heB2tyTNfIvGV3cQ73bRXCT6u0qaM0Nl8gEFFdGbvfoghdua2OUSG3Llh2UzfPHtX0eK+/65wswqYT1fHmzQo0A/8MJTswEGDn1wCZ988Dk/AY56rdWdg1kd5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x2lcjQzw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x2lcjQzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4974C4CEEB;
	Tue, 16 Sep 2025 03:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757992689;
	bh=cU112z2sX8C+dlrHuaYfRDpBsoQFCCwX8zBdjrc7YEQ=;
	h=Date:To:From:Subject:From;
	b=x2lcjQzwewcm1eE3as/OPKVOyOxB11xSmJtbo87UDIc/M83qvUJfq3GPVPL9E64Ef
	 pKKhIeGc6Te3DZyxPn2ZD+2bwwINXcOEOt3c6AaFdMWeMBTmxaLXcO3574D/pBaQE9
	 Vgl8iBvRxRWuGTFibWT/dg1lE63mDAeGPXwNZYrU=
Date: Mon, 15 Sep 2025 20:18:09 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-ability-to-take-further-action-in-vm_area_desc-fix-2.patch added to mm-unstable branch
Message-Id: <20250916031809.C4974C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix incorrect mixedmap implementation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-ability-to-take-further-action-in-vm_area_desc-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-ability-to-take-further-action-in-vm_area_desc-fix-2.patch

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
Subject: mm: fix incorrect mixedmap implementation
Date: Mon, 15 Sep 2025 11:01:06 +0100

This was typo'd due to staring too long at the cramfs implementation.

Link: https://lkml.kernel.org/r/4ce3adda-6351-4530-92aa-103acf638004@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/util.c~mm-add-ability-to-take-further-action-in-vm_area_desc-fix-2
+++ a/mm/util.c
@@ -1364,15 +1364,14 @@ int mmap_action_complete(struct mmap_act
 		unsigned long pgnum = 0;
 		unsigned long pfn = action->mixedmap.pfn;
 		unsigned long addr = action->mixedmap.addr;
-		unsigned long vaddr = vma->vm_start;
 
 		VM_WARN_ON_ONCE(!(vma->vm_flags & VM_MIXEDMAP));
 
 		for (; pgnum < action->mixedmap.num_pages;
-		     pgnum++, pfn++, addr += PAGE_SIZE, vaddr += PAGE_SIZE) {
+		    pgnum++, pfn++, addr += PAGE_SIZE) {
 			vm_fault_t vmf;
 
-			vmf = vmf_insert_mixed(vma, vaddr, addr);
+			vmf = vmf_insert_mixed(vma, addr, pfn);
 			if (vmf & VM_FAULT_ERROR) {
 				err = vm_fault_to_errno(vmf, 0);
 				break;
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-specify-separate-file-and-vm_file-params-in-vm_area_desc.patch
mm-do-not-assume-file-==-vma-vm_file-in-compat_vma_mmap_prepare.patch
mm-shmem-update-shmem-to-use-mmap_prepare.patch
device-dax-update-devdax-to-use-mmap_prepare.patch
mm-add-vma_desc_size-vma_desc_pages-helpers.patch
relay-update-relay-to-use-mmap_prepare.patch
mm-vma-rename-__mmap_prepare-function-to-avoid-confusion.patch
mm-add-remap_pfn_range_prepare-remap_pfn_range_complete.patch
mm-introduce-io_remap_pfn_range_.patch
mm-introduce-io_remap_pfn_range_-fix.patch
mm-add-ability-to-take-further-action-in-vm_area_desc.patch
mm-add-ability-to-take-further-action-in-vm_area_desc-fix.patch
mm-add-ability-to-take-further-action-in-vm_area_desc-fix-2.patch
doc-update-porting-vfs-documentation-for-mmap_prepare-actions.patch
mm-hugetlbfs-update-hugetlbfs-to-use-mmap_prepare.patch
mm-update-mem-char-driver-to-use-mmap_prepare.patch
mm-update-resctl-to-use-mmap_prepare.patch
mm-update-cramfs-to-use-mmap_prepare.patch
fs-proc-add-the-proc_mmap_prepare-hook-for-procfs.patch
fs-proc-update-vmcore-to-use-proc_mmap_prepare.patch
fs-proc-update-vmcore-to-use-proc_mmap_prepare-fix.patch
kcov-update-kcov-to-use-mmap_prepare.patch

