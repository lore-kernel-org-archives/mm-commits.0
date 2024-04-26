Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3827FBC3
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104088; cv=none; b=GA8+4iYSaGuw29XEJ60v130wAs9EkBw9A91rLakxD7Xp2eBj9V1xr6q7QjJtwr6rPRFfYyPBgfT8QuR29ZXZTuLpbdgNW1QtwJmnYcXfAvL2cOdYA7YqCcp8paerfLoXMjYTNMk7/ZbKaJQ13R9BB2IVDVLHYC9PwpDly83B0Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104088; c=relaxed/simple;
	bh=SAoqiTr1j+rTzNoVMedLIuENjwg8S/TY9AjqI+HY8bQ=;
	h=Date:To:From:Subject:Message-Id; b=lws8Ajr53YTgkmkbhSK7Zzi+sSD4q/0TpgQO0VtSg36aga9FZbI2VOWh8SprORjlsupBGw4TuUo9f/WIL5xRlyEQMRj20SbCx0P/RDgMRVGEjoeo0xIf/UrKLpcYMRbWAaPV+RrzVuaxvca3SxYqo/5tPiOXnCVzgWzIQClRWT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NZYoubkc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NZYoubkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04839C116B1;
	Fri, 26 Apr 2024 04:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104088;
	bh=SAoqiTr1j+rTzNoVMedLIuENjwg8S/TY9AjqI+HY8bQ=;
	h=Date:To:From:Subject:From;
	b=NZYoubkcQogpJDAp0uOAYCE/SrhMxOMIctnFApk6VM5b1W0Dx3Ds1uGMXup+LnJPI
	 ipUnyDKwUJAjCFu/uOsczoXlsdBc8LiJWWpLmia3P2l1HQk/fm4HGowA/rXmFwxNwk
	 khGYG4kjaFOxPFdQh/whnOg5YhuEKzHFsHMraPWY=
Date: Thu, 25 Apr 2024 21:01:27 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterz@infradead.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,luto@kernel.org,Liam.Howlett@oracle.com,kirill.shutemov@linux.intel.com,keescook@chromium.org,James.Bottomley@HansenPartnership.com,hpa@zytor.com,guoren@kernel.org,deller@gmx.de,debug@rivosinc.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,broonie@kernel.org,bp@alien8.de,ast@kernel.org,aneesh.kumar@kernel.org,rick.p.edgecombe@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] csky-use-initializer-for-struct-vm_unmapped_area_info.patch removed from -mm tree
Message-Id: <20240426040128.04839C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: csky: use initializer for struct vm_unmapped_area_info
has been removed from the -mm tree.  Its filename was
     csky-use-initializer-for-struct-vm_unmapped_area_info.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: csky: use initializer for struct vm_unmapped_area_info
Date: Mon, 25 Mar 2024 19:16:49 -0700

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

Link: https://lkml.kernel.org/r/20240326021656.202649-8-rick.p.edgecombe@intel.com
Link: https://lore.kernel.org/lkml/202402280912.33AEE7A9CF@keescook/#t
Link: https://lore.kernel.org/lkml/j7bfvig3gew3qruouxrh7z7ehjjafrgkbcmg6tcghhfh3rhmzi@wzlcoecgy5rs/
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Guo Ren <guoren@kernel.org>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Guo Ren <guoren@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Deepak Gupta <debug@rivosinc.com>
Cc: Helge Deller <deller@gmx.de>
Cc: H. Peter Anvin (Intel) <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
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

 arch/csky/abiv1/mmap.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/csky/abiv1/mmap.c~csky-use-initializer-for-struct-vm_unmapped_area_info
+++ a/arch/csky/abiv1/mmap.c
@@ -28,7 +28,12 @@ arch_get_unmapped_area(struct file *filp
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	int do_align = 0;
-	struct vm_unmapped_area_info info;
+	struct vm_unmapped_area_info info = {
+		.length = len,
+		.low_limit = mm->mmap_base,
+		.high_limit = TASK_SIZE,
+		.align_offset = pgoff << PAGE_SHIFT
+	};
 
 	/*
 	 * We only need to do colour alignment if either the I or D
@@ -61,11 +66,6 @@ arch_get_unmapped_area(struct file *filp
 			return addr;
 	}
 
-	info.flags = 0;
-	info.length = len;
-	info.low_limit = mm->mmap_base;
-	info.high_limit = TASK_SIZE;
 	info.align_mask = do_align ? (PAGE_MASK & (SHMLBA - 1)) : 0;
-	info.align_offset = pgoff << PAGE_SHIFT;
 	return vm_unmapped_area(&info);
 }
_

Patches currently in -mm which might be from rick.p.edgecombe@intel.com are


