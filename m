Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1037F7DA
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104089; cv=none; b=LG2P47eJ8fGFB0/7hDz9sfH0QE6nz5t/EDUVDPv11C9A5Y8hkuquRaNocYepI81DIv8K36lNaIbb3DmngiGQ6DZFafT/pBTCf2WXJgskUyfXXp2YWRKcqiAl9g6PB9kDFbRDbpps9h+TXXwyCeCSl/xCWCQAxqAuWtOSSDVpRcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104089; c=relaxed/simple;
	bh=oM692+WXHdsMHuBj6s3n6AhiqcVEpV5fiWakGpBpW4g=;
	h=Date:To:From:Subject:Message-Id; b=hvokfnPbwRx9+0bFLH40Z0s0m8CfB9Md7ty2ZSgoZ9PkRUqkEL/a1t0xhqPK+0oD5q1HfQcoGom6I+yIF3L9laNdMOyj8Ob++W7xDYQnEjQqq+5JrVCoesPOpv3crsatvKr8OcG4uhaoQQ1dZ2kioI5ZlvKVP4jAoUMuGsMU+Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XKUbL6wh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XKUbL6wh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559C9C113CD;
	Fri, 26 Apr 2024 04:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104089;
	bh=oM692+WXHdsMHuBj6s3n6AhiqcVEpV5fiWakGpBpW4g=;
	h=Date:To:From:Subject:From;
	b=XKUbL6whvoB8mc6IVI7UpLa7axFg+jw1D8rC/b8vYdqonjOkOZQfZC+j7Y37QB28O
	 Z3Zn0NqdxfsbBHdqxaO6fB0V8bmMTvcWhzi9LWkg6t5/acZE4Vjs5YvGMC9n5c5L8Z
	 UBLNLbXnlXZYgllMCywJ1tktIcpmdmHE1fzi4wZA=
Date: Thu, 25 Apr 2024 21:01:28 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterz@infradead.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,luto@kernel.org,Liam.Howlett@oracle.com,kirill.shutemov@linux.intel.com,keescook@chromium.org,James.Bottomley@HansenPartnership.com,hpa@zytor.com,guoren@kernel.org,deller@gmx.de,debug@rivosinc.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,broonie@kernel.org,bp@alien8.de,ast@kernel.org,aneesh.kumar@kernel.org,rick.p.edgecombe@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] parisc-use-initializer-for-struct-vm_unmapped_area_info.patch removed from -mm tree
Message-Id: <20240426040129.559C9C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: parisc: use initializer for struct vm_unmapped_area_info
has been removed from the -mm tree.  Its filename was
     parisc-use-initializer-for-struct-vm_unmapped_area_info.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


