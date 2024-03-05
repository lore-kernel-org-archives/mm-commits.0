Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4952D175A1
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 17:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709661034; cv=none; b=plfMF4YOeiHZg9gvz8a3cIK2O3Hf9EICfrNVcOsFdTlY+o1nAqkicQuVqpsLs8qbMgq2xMQY6c7KMtncP8l7oTCNhxZ49NwUplGlrKyvoUP0+t/4gR6Cd5u0dOcfsVm2HAuskfyx5a0lp5t/Mt9+S241bJVbW8MpYH92Ve2d2Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709661034; c=relaxed/simple;
	bh=LT41z6dIV73YoIhedbg9DpfuB9fjG7pID6hZQnnGFCg=;
	h=Date:To:From:Subject:Message-Id; b=CIiewMnloqqZz2Y7t0j1lmYj4RPq7VdHNgVmOjb1BhPfrZLFHQTkdKNRQGFdBfNhRG5Zm0uQ+socJyckONONkr0LK9ByCb+imBoN0yuuinfrrGr8+AjFhyPVm1yibxxkbVdDtAW8ijtsjN7XsA5QJ0zN7oGxviv4H9sh6bweP+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=udp1mr0Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="udp1mr0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10AA3C43399;
	Tue,  5 Mar 2024 17:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709661034;
	bh=LT41z6dIV73YoIhedbg9DpfuB9fjG7pID6hZQnnGFCg=;
	h=Date:To:From:Subject:From;
	b=udp1mr0QeoWr+hoCVky7Hs8rxeCSqe0RIy0ns6Y2OAXuRrDc0grnIdimQNaye075J
	 smux5ctcvKtNohgQxolsk3m12ysp9uVjtTRPcvX0SeoserLD3w4y+307byIgRDrIPH
	 quuUVTS00rn9HP184RScsSY+s+8njekM0BauVi6U=
Date: Tue, 05 Mar 2024 09:50:33 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,muchun.song@linux.dev,mpe@ellerman.id.au,mingo@redhat.com,kirill@shutemov.name,jgg@nvidia.com,glider@google.com,dvyukov@google.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,bp@alien8.de,aneesh.kumar@kernel.org,andreyknvl@gmail.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-x86-replace-pgd_large-with-pgd_leaf.patch added to mm-unstable branch
Message-Id: <20240305175034.10AA3C43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/x86: replace pgd_large() with pgd_leaf()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-x86-replace-pgd_large-with-pgd_leaf.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-x86-replace-pgd_large-with-pgd_leaf.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/x86: replace pgd_large() with pgd_leaf()
Date: Tue, 5 Mar 2024 12:37:44 +0800

pgd_leaf() is a global API while pgd_large() is not.  Always use the
global pgd_leaf(), then drop pgd_large().

Link: https://lkml.kernel.org/r/20240305043750.93762-5-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |    4 ++--
 arch/x86/mm/pti.c              |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/pgtable.h~mm-x86-replace-pgd_large-with-pgd_leaf
+++ a/arch/x86/include/asm/pgtable.h
@@ -1418,8 +1418,8 @@ static inline bool pgdp_maps_userspace(v
 	return (((ptr & ~PAGE_MASK) / sizeof(pgd_t)) < PGD_KERNEL_START);
 }
 
-#define pgd_leaf	pgd_large
-static inline int pgd_large(pgd_t pgd) { return 0; }
+#define pgd_leaf	pgd_leaf
+static inline int pgd_leaf(pgd_t pgd) { return 0; }
 
 #ifdef CONFIG_PAGE_TABLE_ISOLATION
 /*
--- a/arch/x86/mm/pti.c~mm-x86-replace-pgd_large-with-pgd_leaf
+++ a/arch/x86/mm/pti.c
@@ -185,7 +185,7 @@ static p4d_t *pti_user_pagetable_walk_p4
 
 		set_pgd(pgd, __pgd(_KERNPG_TABLE | __pa(new_p4d_page)));
 	}
-	BUILD_BUG_ON(pgd_large(*pgd) != 0);
+	BUILD_BUG_ON(pgd_leaf(*pgd) != 0);
 
 	return p4d_offset(pgd, address);
 }
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-ppc-define-pxd_large-with-pxd_leaf.patch
mm-ppc-replace-pxd_is_leaf-with-pxd_leaf.patch
mm-x86-replace-p4d_large-with-p4d_leaf.patch
mm-x86-replace-pgd_large-with-pgd_leaf.patch
mm-x86-drop-two-unnecessary-pud_leaf-definitions.patch
mm-kasan-use-pxd_leaf-in-shadow_mapped.patch
mm-treewide-replace-pmd_large-with-pmd_leaf.patch
mm-treewide-replace-pud_large-with-pud_leaf.patch
mm-treewide-drop-pxd_large.patch
mm-treewide-align-up-pxd_leaf-retval-across-archs.patch

