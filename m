Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AEA848E
	for <mm-commits@vger.kernel.org>; Wed, 10 Jul 2024 17:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720634206; cv=none; b=hIDiWSr7/TRlWoZDpALqRgYzUdvJau9lml+lUCiRhmisArG6M5WXJ2/JC2JfNKYh8gmeKPj76QvfgWSGa34HABbbUIh2I/bQZpIaIHsSpJILfP/CCrz0Rb4Me1dJle2Uiij82/QAg1kzTChL0YF364HPLnEVakGiVwHnTe+WcRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720634206; c=relaxed/simple;
	bh=b8Z7i5oOFQh9e0Sm+6GPrKTpIlR2ByezzHMlGGdJsno=;
	h=Date:To:From:Subject:Message-Id; b=UoaJ2SqFuK5yxc54HV1Cu4qj4wZHpkkmjcboaM/rJNCEhmrUWXI/mZDUfURUzH52HCJdqfB5mT4ggTYSYRxTatctbvUXaM97SSal4daoi886tUx5bFJkRCBbidJcMFj5arco2JK7e2KI8NAsGiLmxb150Xr/Kwaw9JX0KKFOlA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SAP2Ym3z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SAP2Ym3z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AACFC32781;
	Wed, 10 Jul 2024 17:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720634205;
	bh=b8Z7i5oOFQh9e0Sm+6GPrKTpIlR2ByezzHMlGGdJsno=;
	h=Date:To:From:Subject:From;
	b=SAP2Ym3zOTR2cdSDN1kMRpmwgfN/JqkZEKiogvSbWps2wSYgztat7OygwWm0VQd/f
	 xqsP+Old2Y+IcPSfXheEchEOrh05BVki95fGRhxGPG23t7CUTySg/mVz4g3wk5D8tH
	 yg8ayiPDT6tBzUfXZWCX+ohNVr0fK60AS9g5cKNo=
Date: Wed, 10 Jul 2024 10:56:39 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tonyb@cybernetics.com,rppt@kernel.org,ritesh.list@gmail.com,npiggin@gmail.com,muchun.song@linux.dev,luto@kernel.org,kirill.shutemov@linux.intel.com,david@redhat.com,ast@kernel.org,aneesh.kumar@kernel.org,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlbfs-ensure-generic_hugetlb_get_unmapped_area-returns-higher-address-than-mmap_min_addr.patch added to mm-unstable branch
Message-Id: <20240710175645.5AACFC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlbfs: ensure generic_hugetlb_get_unmapped_area() returns higher address than mmap_min_addr
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlbfs-ensure-generic_hugetlb_get_unmapped_area-returns-higher-address-than-mmap_min_addr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlbfs-ensure-generic_hugetlb_get_unmapped_area-returns-higher-address-than-mmap_min_addr.patch

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
From: Donet Tom <donettom@linux.ibm.com>
Subject: hugetlbfs: ensure generic_hugetlb_get_unmapped_area() returns higher address than mmap_min_addr
Date: Wed, 10 Jul 2024 00:19:12 -0500

generic_hugetlb_get_unmapped_area() was returning an address less than
mmap_min_addr if the mmap argument addr, after alignment, was less than
mmap_min_addr, causing mmap to fail.

This is because current generic_hugetlb_get_unmapped_area() code does not
take into account mmap_min_addr.

This patch ensures that generic_hugetlb_get_unmapped_area() always returns
an address that is greater than mmap_min_addr.  Additionally, similar to
generic_get_unmapped_area(), vm_end_gap() checks are included to maintain
stack gap.

How to reproduce
================

 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/mman.h>
 #include <unistd.h>

 #define HUGEPAGE_SIZE (16 * 1024 * 1024)

 int main() {

    void *addr = mmap((void *)-1, HUGEPAGE_SIZE,
                 PROT_READ | PROT_WRITE,
                 MAP_SHARED | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
    if (addr == MAP_FAILED) {
        perror("mmap");
        exit(EXIT_FAILURE);
    }

    snprintf((char *)addr, HUGEPAGE_SIZE, "Hello, Huge Pages!");

    printf("%s\n", (char *)addr);

    if (munmap(addr, HUGEPAGE_SIZE) == -1) {
        perror("munmap");
        exit(EXIT_FAILURE);
    }

    return 0;
 }

Result without fix
==================
 # cat /proc/meminfo |grep -i HugePages_Free
 HugePages_Free:       20
 # ./test
 mmap: Permission denied
 #

Result with fix
===============
 # cat /proc/meminfo |grep -i HugePages_Free
 HugePages_Free:       20
 # ./test
 Hello, Huge Pages!
 #

Link: https://lkml.kernel.org/r/20240710051912.4681-1-donettom@linux.ibm.com
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Reported-by Pavithra Prakash <pavrampu@linux.vnet.ibm.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Tony Battersby <tonyb@cybernetics.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-ensure-generic_hugetlb_get_unmapped_area-returns-higher-address-than-mmap_min_addr
+++ a/fs/hugetlbfs/inode.c
@@ -222,13 +222,13 @@ generic_hugetlb_get_unmapped_area(struct
 				  unsigned long flags)
 {
 	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
+	struct vm_area_struct *vma, *prev;
 	struct hstate *h = hstate_file(file);
 	const unsigned long mmap_end = arch_get_mmap_end(addr, len, flags);
 
 	if (len & ~huge_page_mask(h))
 		return -EINVAL;
-	if (len > TASK_SIZE)
+	if (len > mmap_end - mmap_min_addr)
 		return -ENOMEM;
 
 	if (flags & MAP_FIXED) {
@@ -239,9 +239,10 @@ generic_hugetlb_get_unmapped_area(struct
 
 	if (addr) {
 		addr = ALIGN(addr, huge_page_size(h));
-		vma = find_vma(mm, addr);
-		if (mmap_end - len >= addr &&
-		    (!vma || addr + len <= vm_start_gap(vma)))
+		vma = find_vma_prev(mm, addr, &prev);
+		if (mmap_end - len >= addr && addr >= mmap_min_addr &&
+		    (!vma || addr + len <= vm_start_gap(vma)) &&
+		    (!prev || addr >= vm_end_gap(prev)))
 			return addr;
 	}
 
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

hugetlbfs-ensure-generic_hugetlb_get_unmapped_area-returns-higher-address-than-mmap_min_addr.patch

