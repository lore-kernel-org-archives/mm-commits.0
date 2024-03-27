Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE12B1514F1
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 20:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711570303; cv=none; b=B5dCFqgvwunyx1qMPWWt1W4K6RIJPkeectMOuOxyQtFyANCbzCoSKIj2jlM/ucqOhtZYAvvJY0Rp/zO0k93LmTcVtxZa/nU69TXzseRCi7kC6APNjSVpzp1PFbpt00puyPethCK118cIi2fKoEcbvdtZqu+7qa67NdrFDoF7zro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711570303; c=relaxed/simple;
	bh=a2vYaKVpTVs6SzNk7JeJTTmiV+d/0RnICuiOcsccqoc=;
	h=Date:To:From:Subject:Message-Id; b=C4tPbu+lhtqVr0tx5P8cCFd5QtitXLL16IqyuR9O26knJXzYrjiSPXGRxXp9YFYNtpXz+UqprHMlFc2URhwFlSDa0lAg7VpGb3l+U+WGEB0+KoGgQDD/laNUTDlVvafouIgJ4JIfAmT/3mdGAZ8srjq5fzi27yo/1xHwsKdPHe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=McTeqy6j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="McTeqy6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6ABC433F1;
	Wed, 27 Mar 2024 20:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711570302;
	bh=a2vYaKVpTVs6SzNk7JeJTTmiV+d/0RnICuiOcsccqoc=;
	h=Date:To:From:Subject:From;
	b=McTeqy6jupmj/59VWBUR05yeSvO6zSRUA/Kl8vVFDGKnIwA7XYlhjvttol3qISic0
	 iHzv+bvQPQq8Qqyfxrr7s799jTBjZm58xhBnzeF3qqzyJHAsUrmZ6IAy9FkFb3ZyNc
	 q8lNpaFq5O2FacMGBGfz6cQNYl0mkwqTeiFva+Ik=
Date: Wed, 27 Mar 2024 13:11:41 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterz@infradead.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,luto@kernel.org,Liam.Howlett@oracle.com,kirill.shutemov@linux.intel.com,keescook@chromium.org,James.Bottomley@HansenPartnership.com,hpa@zytor.com,guoren@kernel.org,deller@gmx.de,debug@rivosinc.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,broonie@kernel.org,bp@alien8.de,ast@kernel.org,aneesh.kumar@kernel.org,rick.p.edgecombe@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + parisc-use-initializer-for-struct-vm_unmapped_area_info.patch added to mm-unstable branch
Message-Id: <20240327201142.3E6ABC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: parisc: use initializer for struct vm_unmapped_area_info
has been added to the -mm mm-unstable branch.  Its filename is
     parisc-use-initializer-for-struct-vm_unmapped_area_info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/parisc-use-initializer-for-struct-vm_unmapped_area_info.patch

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
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: parisc: use initializer for struct vm_unmapped_area_info
Date: Mon, 25 Mar 2024 19:16:50 -0700

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

However, that would leave cleanup for the members that are manually set
to zero, as it would no longer be required.

So to be reduce the chance of bugs via uninitialized members, instead
simply continue the process to initialize the struct this way tree wide. 
This will zero any unspecified members.  Move the member initializers to
the struct declaration when they are known at that time.  Leave the
members out that were manually initialized to zero, as this would be
redundant for designated initializers.

Link: https://lkml.kernel.org/r/20240326021656.202649-9-rick.p.edgecombe@intel.com
Link: https://lore.kernel.org/lkml/202402280912.33AEE7A9CF@keescook/#t
Link: https://lore.kernel.org/lkml/j7bfvig3gew3qruouxrh7z7ehjjafrgkbcmg6tcghhfh3rhmzi@wzlcoecgy5rs/
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Acked-by: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Deepak Gupta <debug@rivosinc.com>
Cc: Guo Ren <guoren@kernel.org>
Cc: H. Peter Anvin (Intel) <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N. Rao <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/sys_parisc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/parisc/kernel/sys_parisc.c~parisc-use-initializer-for-struct-vm_unmapped_area_info
+++ a/arch/parisc/kernel/sys_parisc.c
@@ -104,7 +104,9 @@ static unsigned long arch_get_unmapped_a
 	struct vm_area_struct *vma, *prev;
 	unsigned long filp_pgoff;
 	int do_color_align;
-	struct vm_unmapped_area_info info;
+	struct vm_unmapped_area_info info = {
+		.length = len
+	};
 
 	if (unlikely(len > TASK_SIZE))
 		return -ENOMEM;
@@ -139,7 +141,6 @@ static unsigned long arch_get_unmapped_a
 			return addr;
 	}
 
-	info.length = len;
 	info.align_mask = do_color_align ? (PAGE_MASK & (SHM_COLOUR - 1)) : 0;
 	info.align_offset = shared_align_offset(filp_pgoff, pgoff);
 
@@ -160,7 +161,6 @@ static unsigned long arch_get_unmapped_a
 		 */
 	}
 
-	info.flags = 0;
 	info.low_limit = mm->mmap_base;
 	info.high_limit = mmap_upper_limit(NULL);
 	return vm_unmapped_area(&info);
_

Patches currently in -mm which might be from rick.p.edgecombe@intel.com are

proc-refactor-pde_get_unmapped_area-as-prep.patch
mm-switch-mm-get_unmapped_area-to-a-flag.patch
mm-introduce-arch_get_unmapped_area_vmflags.patch
mm-remove-export-for-get_unmapped_area.patch
mm-use-get_unmapped_area_vmflags.patch
thp-add-thp_get_unmapped_area_vmflags.patch
csky-use-initializer-for-struct-vm_unmapped_area_info.patch
parisc-use-initializer-for-struct-vm_unmapped_area_info.patch
powerpc-use-initializer-for-struct-vm_unmapped_area_info.patch
treewide-use-initializer-for-struct-vm_unmapped_area_info.patch
mm-take-placement-mappings-gap-into-account.patch
x86-mm-implement-have_arch_unmapped_area_vmflags.patch
x86-mm-care-about-shadow-stack-guard-gap-during-placement.patch
selftests-x86-add-placement-guard-gap-test-for-shstk.patch

