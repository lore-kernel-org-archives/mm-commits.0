Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7077F492
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104080; cv=none; b=iH07tcrrk9IWsBAWrfNduPz6xV9/LIM3xuMqUUXJgm3GgVTUP8Ve4oQws+Em5TBZ/9p40rn9vSXJntzZHg4DISrlWpz7BIhTY3fQiStjdVvR9hIi4w38LYSWI6ha4Pc+3bGE/JbJqW4jzIK4seSRisi5q+oA+M29LurUEiKp4OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104080; c=relaxed/simple;
	bh=mX3pFWBIsMqgTCTa3Yq86aYQFDZ1wLWxdfiuDkymEOg=;
	h=Date:To:From:Subject:Message-Id; b=P9a8uuoziMBwyQUW6WfhBaKzyepwiGHtPF16YG+uYxt/H9VC0kcBgBULtnmjfRfH/1KaVJK0k4a8p+PVbHB7NYnDJVK5MduU8M51XfD8Qv8+o1moiJ0RsYnk0+2ICdLNy7piYWcRWlXJ9Er1eqgv1XPrNX5oczrQ2+Lge38Cndg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sxl7U2wg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sxl7U2wg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224B9C113CD;
	Fri, 26 Apr 2024 04:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104080;
	bh=mX3pFWBIsMqgTCTa3Yq86aYQFDZ1wLWxdfiuDkymEOg=;
	h=Date:To:From:Subject:From;
	b=sxl7U2wgoXAX6dXy++Vl1gbiqzWiw+gTKgzn7VfEw6WJUA8WA0X5ty+maPxT5xyyI
	 3MtBOiklR4PcYH0g4UOIzChHD3tXZWoiwZPbv+e5oZom6jpNISVG+kBk2Q7bweV3WK
	 xhdnajpyYaZ1eknjOepWE1zGVaAanLqPJPqViytw=
Date: Thu, 25 Apr 2024 21:01:19 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterz@infradead.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,luto@kernel.org,Liam.Howlett@oracle.com,kirill.shutemov@linux.intel.com,keescook@chromium.org,James.Bottomley@HansenPartnership.com,hpa@zytor.com,guoren@kernel.org,deller@gmx.de,debug@rivosinc.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,broonie@kernel.org,bp@alien8.de,ast@kernel.org,aneesh.kumar@kernel.org,rick.p.edgecombe@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] proc-refactor-pde_get_unmapped_area-as-prep.patch removed from -mm tree
Message-Id: <20240426040120.224B9C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc: refactor pde_get_unmapped_area as prep
has been removed from the -mm tree.  Its filename was
     proc-refactor-pde_get_unmapped_area-as-prep.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: proc: refactor pde_get_unmapped_area as prep
Date: Mon, 25 Mar 2024 19:16:43 -0700

Patch series "Cover a guard gap corner case", v4.

In working on x86’s shadow stack feature, I came across some limitations
around the kernel’s handling of guard gaps.  AFAICT these limitations
are not too important for the traditional stack usage of guard gaps, but
have bigger impact on shadow stack’s usage.  And now in addition to x86,
we have two other architectures implementing shadow stack like features
that plan to use guard gaps.  I wanted to see about addressing them, but I
have not worked on mmap() placement related code before, so would greatly
appreciate if people could take a look and point me in the right
direction.

The nature of the limitations of concern is as follows. In order to ensure 
guard gaps between mappings, mmap() would need to consider two things:
 1. That the new mapping isn’t placed in an any existing mapping’s guard
    gap.
 2. That the new mapping isn’t placed such that any existing mappings are
    not in *its* guard gaps
Currently mmap never considers (2), and (1) is not considered in some 
situations.

When not passing an address hint, or passing one without
MAP_FIXED_NOREPLACE, (1) is enforced.  With MAP_FIXED_NOREPLACE, (1) is
not enforced.  With MAP_FIXED, (1) is not considered, but this seems to be
expected since MAP_FIXED can already clobber existing mappings.  For
MAP_FIXED_NOREPLACE I would have guessed it should respect the guard gaps
of existing mappings, but it is probably a little ambiguous.

In this series I just tried to add enforcement of (2) for the normal (no
address hint) case and only for the newer shadow stack memory (not
stacks).  The reason is that with the no-address-hint situation, landing
next to a guard gap could come up naturally and so be more influencable by
attackers such that two shadow stacks could be adjacent without a guard
gap.  Where as the address-hint scenarios would require more control -
being able to call mmap() with specific arguments.  As for why not just
fix the other corner cases anyway, I thought it might have some greater
possibility of affecting existing apps.


This patch (of 14):

Future changes will perform a treewide change to remove the indirect
branch that is involved in calling mm->get_unmapped_area().  After doing
this, the function will no longer be able to be handled as a function
pointer.  To make the treewide change diff cleaner and easier to review,
refactor pde_get_unmapped_area() such that mm->get_unmapped_area() is
called without being stored in a local function pointer.  With this in
refactoring, follow on changes will be able to simply replace the call
site with a future function that calls it directly.

Link: https://lkml.kernel.org/r/20240326021656.202649-1-rick.p.edgecombe@intel.com
Link: https://lkml.kernel.org/r/20240326021656.202649-2-rick.p.edgecombe@intel.com
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Deepak Gupta <debug@rivosinc.com>
Cc: H. Peter Anvin (Intel) <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Guo Ren <guoren@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N. Rao <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/fs/proc/inode.c~proc-refactor-pde_get_unmapped_area-as-prep
+++ a/fs/proc/inode.c
@@ -451,15 +451,12 @@ pde_get_unmapped_area(struct proc_dir_en
 			   unsigned long len, unsigned long pgoff,
 			   unsigned long flags)
 {
-	typeof_member(struct proc_ops, proc_get_unmapped_area) get_area;
+	if (pde->proc_ops->proc_get_unmapped_area)
+		return pde->proc_ops->proc_get_unmapped_area(file, orig_addr, len, pgoff, flags);
 
-	get_area = pde->proc_ops->proc_get_unmapped_area;
 #ifdef CONFIG_MMU
-	if (!get_area)
-		get_area = current->mm->get_unmapped_area;
+	return current->mm->get_unmapped_area(file, orig_addr, len, pgoff, flags);
 #endif
-	if (get_area)
-		return get_area(file, orig_addr, len, pgoff, flags);
 	return orig_addr;
 }
 
_

Patches currently in -mm which might be from rick.p.edgecombe@intel.com are


