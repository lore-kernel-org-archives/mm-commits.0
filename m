Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C2512DD8E
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824909; cv=none; b=jVWua6TB6BQYLlUSWzeSspIp0ZBFCWJnH/UTPlcB5x5wBy7cHrYr3S3I2AqCpONCn/SO1RMZ9Bqgyb6WJajxudgGkUqWtCy8dPfDnnoQgb8C+OLoDjOR960blH1BeCdzzKySJyMIBTbWey0mF9ktVTKblsYtdFa5BWsa1NNONlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824909; c=relaxed/simple;
	bh=dLCZjCBSSLcjtFTSo3qQcy5SPw59Mp0JB233xZFFneQ=;
	h=Date:To:From:Subject:Message-Id; b=hdivCvXvLEWA6es1GAyxHcFOwVgFtUK6cKFbszKZO5XTrrom3nNKPnus9gkhKNatx+ShwVcPkijyTTAIVgIAK/M18zMFxZBxFvtQK7gUhhd3RKstj3UHEuh5PpMRuFJuv4fKCnoBH1JaU26Ha0wi1ePL9ntBhKnd4YyGPNqluDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zfkPg3jz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zfkPg3jz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160ACC32782;
	Fri, 12 Jul 2024 22:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824909;
	bh=dLCZjCBSSLcjtFTSo3qQcy5SPw59Mp0JB233xZFFneQ=;
	h=Date:To:From:Subject:From;
	b=zfkPg3jzX5JLRn3/zmkO/t3Mai6SkNxIlFwkg1f/8r5Sde6qDHH67moxHuXJl488S
	 kKalSPAFNzrceXeCEEXCM55oiVJJjqCM9RqBZpQRcTYxbKKA75MNmGWGvji0jEOhQY
	 fQVPzOgNZQaugO9B3yUFxKBMhoGl6nhStlcJ1Yws=
Date: Fri, 12 Jul 2024 15:55:08 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tonyb@cybernetics.com,rppt@kernel.org,ritesh.list@gmail.com,npiggin@gmail.com,muchun.song@linux.dev,luto@kernel.org,kirill.shutemov@linux.intel.com,david@redhat.com,ast@kernel.org,aneesh.kumar@kernel.org,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlbfs-ensure-generic_hugetlb_get_unmapped_area-returns-higher-address-than-mmap_min_addr.patch removed from -mm tree
Message-Id: <20240712225509.160ACC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlbfs: ensure generic_hugetlb_get_unmapped_area() returns higher address than mmap_min_addr
has been removed from the -mm tree.  Its filename was
     hugetlbfs-ensure-generic_hugetlb_get_unmapped_area-returns-higher-address-than-mmap_min_addr.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


