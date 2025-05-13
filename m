Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495781EFF9A
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119353; cv=none; b=uTriD2jboPotkozZb7I9WsapYdAH2S7Tm3XhEz7CQmMg2xKAkRjjn/IG7V1VSc6a2FpH+eNGHwTdxI9fKMupK2VvCs9cfxyyZLtMzr0udmX7bl4OkE9yAu2S9IoweQ8JRJ/0io2mQrcpWnnRRPhJYqtO+3IvkbWnlH1yK/26o98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119353; c=relaxed/simple;
	bh=rvKtMLL4pbu+GyOa4+u4KhVmZWEeoWxAGLVG7QFeXKU=;
	h=Date:To:From:Subject:Message-Id; b=D9pOZxQP37N7P/CHFSumEZAfXc9XodyoIKUdl1IFNVE9fOiIC9il1yeg6QwtPJ3clfLJwB9LRWH6Q2xcD25mBa1T5CT75t1GyCIo+7F1tXiPtLl2bZDPcaabGtS8uBDcEqmfc6H/Azs0CnnvoKiF5zTz2QeJjTPY1iGfj57ZIxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b8xLyH1G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b8xLyH1G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52A3C4CEE4;
	Tue, 13 May 2025 06:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119352;
	bh=rvKtMLL4pbu+GyOa4+u4KhVmZWEeoWxAGLVG7QFeXKU=;
	h=Date:To:From:Subject:From;
	b=b8xLyH1GVx3VN4lbVWBI6HOGy/iCzwBIAXoho1s/hlxmIrX9Xk0Xgwq5dxmRTM3k+
	 VsymESYep5sNRQEdSrWys2OjpVCPCi5VYUimg2tDJrPr+109DBCXy964IUyFcAZSNM
	 U0Ft7fBcmSpYNzGOwo1qYFumwQ8+L4sJuvE0IiQ4=
Date: Mon, 12 May 2025 23:55:52 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,mingo@kernel.org,maobibo@loongson.cn,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,david@redhat.com,baohua@kernel.org,anshuman.khandual@arm.com,379943137@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-obsolete-pgd_offset_gate.patch removed from -mm tree
Message-Id: <20250513065552.B52A3C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove obsolete pgd_offset_gate()
has been removed from the -mm tree.  Its filename was
     mm-remove-obsolete-pgd_offset_gate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Feng Lee <379943137@qq.com>
Subject: mm: remove obsolete pgd_offset_gate()
Date: Fri, 9 May 2025 14:32:30 +0800

Remove pgd_offset_gate() completely and simply make the single caller use
pgd_offset().

It appears that the gate area resides in the kernel-mapped segment
exclusively on IA64.  Therefore, removing pgd_offset_k is safe since IA64
is now obsolete.

Link: https://lkml.kernel.org/r/tencent_503130C3CD56569191396268CF4D12F09A06@qq.com
Signed-off-by: Feng Lee <379943137@qq.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: bibo mao <maobibo@loongson.cn>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    4 ----
 mm/gup.c                |    5 +----
 2 files changed, 1 insertion(+), 8 deletions(-)

--- a/include/linux/pgtable.h~mm-remove-obsolete-pgd_offset_gate
+++ a/include/linux/pgtable.h
@@ -1164,10 +1164,6 @@ static inline void arch_swap_restore(swp
 }
 #endif
 
-#ifndef __HAVE_ARCH_PGD_OFFSET_GATE
-#define pgd_offset_gate(mm, addr)	pgd_offset(mm, addr)
-#endif
-
 #ifndef __HAVE_ARCH_MOVE_PTE
 #define move_pte(pte, old_addr, new_addr)	(pte)
 #endif
--- a/mm/gup.c~mm-remove-obsolete-pgd_offset_gate
+++ a/mm/gup.c
@@ -1102,10 +1102,7 @@ static int get_gate_page(struct mm_struc
 	/* user gate pages are read-only */
 	if (gup_flags & FOLL_WRITE)
 		return -EFAULT;
-	if (address > TASK_SIZE)
-		pgd = pgd_offset_k(address);
-	else
-		pgd = pgd_offset_gate(mm, address);
+	pgd = pgd_offset(mm, address);
 	if (pgd_none(*pgd))
 		return -EFAULT;
 	p4d = p4d_offset(pgd, address);
_

Patches currently in -mm which might be from 379943137@qq.com are


