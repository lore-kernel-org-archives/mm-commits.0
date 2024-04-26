Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3927FBAC
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104090; cv=none; b=NG0yMBF3/Hf4A8Eaob9afAJIzMwJ1BpfI4t0gShBofrJoorYzXx8hH0+aawPfnJyVkZfenjQ4VdPJAU8ntrcbCL3b4GpNx7h93pLBRliQ8zK/FKHrVixtnBAuJV85XBrLgJa4fAglz7uEf9OLiV86YIEuBJlKnhYVY1Nt28f9UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104090; c=relaxed/simple;
	bh=SXj1bcHR7bbEKRI4HdNR+U0P74kRveXncUiLixFMXEQ=;
	h=Date:To:From:Subject:Message-Id; b=kicnDvRneTThM929paHwxOZqG0uouuW9a/XTo4FgtXUyVgDS1WWV4XsXs1YEjLSsquYnR8Oh0OdLB3xA1GPDgiVmEWQgGyuNtl55xPiDS53eLl9T+Wobh/65V7UsdPw4cGoIVk77+Ncwcah8k98ACmFlDyFVpgWHPUDVHwbWHik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o0aDf/AK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o0aDf/AK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E91C113CD;
	Fri, 26 Apr 2024 04:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104090;
	bh=SXj1bcHR7bbEKRI4HdNR+U0P74kRveXncUiLixFMXEQ=;
	h=Date:To:From:Subject:From;
	b=o0aDf/AKBhWXpv0j/bEIrJwO5s74LE4EQb5tVWPryesPWBV+pO8B39fU+njzOKHBb
	 YWis6lv8MlbSntiIINYgKC0zEsvM58/TDT78f7p+tsVtrt9IlQB9Mv1zD6A8WXnenK
	 KM04egAuVmGT44i1p8uM90ko8fs6C8AFQHK+jI6w=
Date: Thu, 25 Apr 2024 21:01:30 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterz@infradead.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,luto@kernel.org,Liam.Howlett@oracle.com,kirill.shutemov@linux.intel.com,keescook@chromium.org,James.Bottomley@HansenPartnership.com,hpa@zytor.com,guoren@kernel.org,deller@gmx.de,debug@rivosinc.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,broonie@kernel.org,bp@alien8.de,ast@kernel.org,aneesh.kumar@kernel.org,rick.p.edgecombe@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-use-initializer-for-struct-vm_unmapped_area_info.patch removed from -mm tree
Message-Id: <20240426040130.A3E91C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc: use initializer for struct vm_unmapped_area_info
has been removed from the -mm tree.  Its filename was
     powerpc-use-initializer-for-struct-vm_unmapped_area_info.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: powerpc: use initializer for struct vm_unmapped_area_info
Date: Mon, 25 Mar 2024 19:16:51 -0700

Future changes will need to add a new member to struct
vm_unmapped_area_info.  This would cause trouble for any call site that
doesn't initialize the struct.  Currently every caller sets each member
manually, so if new members are added they will be uninitialized and the
core code parsing the struct will see garbage in the new member.

It could be possible to initialize the new member manually to 0 at each
call site.  This and a couple other options were discussed, and a working
consensus (see links) was that in general the best way to accomplish this
would be via static initialization with designated member initiators. 
Having some struct vm_unmapped_area_info instances not zero initialized
will put those sites at risk of feeding garbage into vm_unmapped_area() if
the convention is to zero initialize the struct and any new member
addition misses a call site that initializes each member manually.

It could be possible to leave the code mostly untouched, and just change
the line:
struct vm_unmapped_area_info info
to:
struct vm_unmapped_area_info info = {};

However, that would leave cleanup for the members that are manually set to
zero, as it would no longer be required.

So to be reduce the chance of bugs via uninitialized members, instead
simply continue the process to initialize the struct this way tree wide. 
This will zero any unspecified members.  Move the member initializers to
the struct declaration when they are known at that time.  Leave the
members out that were manually initialized to zero, as this would be
redundant for designated initializers.

Link: https://lkml.kernel.org/r/20240326021656.202649-10-rick.p.edgecombe@intel.com
Link: https://lore.kernel.org/lkml/202402280912.33AEE7A9CF@keescook/#t
Link: https://lore.kernel.org/lkml/j7bfvig3gew3qruouxrh7z7ehjjafrgkbcmg6tcghhfh3rhmzi@wzlcoecgy5rs/
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Naveen N. Rao <naveen.n.rao@linux.ibm.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Deepak Gupta <debug@rivosinc.com>
Cc: Guo Ren <guoren@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: H. Peter Anvin (Intel) <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/book3s64/slice.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/arch/powerpc/mm/book3s64/slice.c~powerpc-use-initializer-for-struct-vm_unmapped_area_info
+++ a/arch/powerpc/mm/book3s64/slice.c
@@ -282,12 +282,10 @@ static unsigned long slice_find_area_bot
 {
 	int pshift = max_t(int, mmu_psize_defs[psize].shift, PAGE_SHIFT);
 	unsigned long found, next_end;
-	struct vm_unmapped_area_info info;
-
-	info.flags = 0;
-	info.length = len;
-	info.align_mask = PAGE_MASK & ((1ul << pshift) - 1);
-	info.align_offset = 0;
+	struct vm_unmapped_area_info info = {
+		.length = len,
+		.align_mask = PAGE_MASK & ((1ul << pshift) - 1),
+	};
 	/*
 	 * Check till the allow max value for this mmap request
 	 */
@@ -326,13 +324,13 @@ static unsigned long slice_find_area_top
 {
 	int pshift = max_t(int, mmu_psize_defs[psize].shift, PAGE_SHIFT);
 	unsigned long found, prev;
-	struct vm_unmapped_area_info info;
+	struct vm_unmapped_area_info info = {
+		.flags = VM_UNMAPPED_AREA_TOPDOWN,
+		.length = len,
+		.align_mask = PAGE_MASK & ((1ul << pshift) - 1),
+	};
 	unsigned long min_addr = max(PAGE_SIZE, mmap_min_addr);
 
-	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
-	info.length = len;
-	info.align_mask = PAGE_MASK & ((1ul << pshift) - 1);
-	info.align_offset = 0;
 	/*
 	 * If we are trying to allocate above DEFAULT_MAP_WINDOW
 	 * Add the different to the mmap_base.
_

Patches currently in -mm which might be from rick.p.edgecombe@intel.com are


