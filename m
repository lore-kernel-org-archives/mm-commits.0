Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACD113B59E
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 20:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725480469; cv=none; b=q+AXjPcn2QcICvgoZxKQZk4ps3nLJhfBToSLK/k4VM1wyANrJOAXe/cG5SyFYwwcyywdoqB91PBzZNNCVZiKeAasNBDK+hYDvEuWTQ3vkum4VHlk8Cqzzej9jaVeseesxAgNmCTOfsk7DOoZOiDHZdfJ6+Gdx3Tp5LQzlRMBv8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725480469; c=relaxed/simple;
	bh=Ijs//BE7vX2ccwDESy/c2qQL00/GvGOdyIOVxMaOdSM=;
	h=Date:To:From:Subject:Message-Id; b=DISEWSp0EB4kORrDyLCzIl/bf0qOH2J3k5qVnWxob8ol0IUiUbku2OOdyrOAk+7DcYQBzQWN8WS/Q4oFk1XAUnuuBp7DFE74yr8yrJkQ5IyhhStDwESaluGEyhX9FHic0GVCFb5KagSF2P2q70yQgpGSsLE/xcmgfhPAxE0SWFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JXYxsEQc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JXYxsEQc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A31C4CEC2;
	Wed,  4 Sep 2024 20:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725480469;
	bh=Ijs//BE7vX2ccwDESy/c2qQL00/GvGOdyIOVxMaOdSM=;
	h=Date:To:From:Subject:From;
	b=JXYxsEQcXGbL/weJEAlGXlf3wCCpxhMuu4gwRQtaZQ5HrSm7yWpVmLqQJSAYCE7yY
	 GoEDFLdBh8MyQjgF4tAqMEcK5MIZvJuAwqyd2TshKD6z+QnM2geoyNw+WHM5Klv9Ap
	 kJv8j7zyTyUtILnRLHfB98ROcLLkPR4DpgE+xxU0=
Date: Wed, 04 Sep 2024 13:07:48 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,vgupta@kernel.org,vbabka@suse.cz,tsbogend@alpha.franken.de,tglx@linutronix.de,svens@linux.ibm.com,rick.p.edgecombe@intel.com,richard.henderson@linaro.org,npiggin@gmail.com,naveen@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,mattst88@gmail.com,lorenzo.stoakes@oracle.com,linux@armlinux.org.uk,Liam.Howlett@Oracle.com,kernel@xen0n.name,jcmvbkbc@gmail.com,James.Bottomley@HansenPartnership.com,ink@jurassic.park.msu.ru,hpa@zytor.com,hca@linux.ibm.com,guoren@kernel.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,gerald.schaefer@linux.ibm.com,deller@gmx.de,davem@davemloft.net,dave.hansen@linux.intel.com,dalias@libc.org,chris@zankel.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,andreas@gaisler.com,agordeev@linux.ibm.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-care-about-shadow-stack-guard-gap-when-getting-an-unmapped-area.patch added to mm-unstable branch
Message-Id: <20240904200749.48A31C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: care about shadow stack guard gap when getting an unmapped area
has been added to the -mm mm-unstable branch.  Its filename is
     mm-care-about-shadow-stack-guard-gap-when-getting-an-unmapped-area.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-care-about-shadow-stack-guard-gap-when-getting-an-unmapped-area.patch

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
From: Mark Brown <broonie@kernel.org>
Subject: mm: care about shadow stack guard gap when getting an unmapped area
Date: Wed, 04 Sep 2024 17:58:01 +0100

As covered in the commit log for c44357c2e76b ("x86/mm: care about shadow
stack guard gap during placement") our current mmap() implementation does
not take care to ensure that a new mapping isn't placed with existing
mappings inside it's own guard gaps.  This is particularly important for
shadow stacks since if two shadow stacks end up getting placed adjacent to
each other then they can overflow into each other which weakens the
protection offered by the feature.

On x86 there is a custom arch_get_unmapped_area() which was updated by the
above commit to cover this case by specifying a start_gap for allocations
with VM_SHADOW_STACK.  Both arm64 and RISC-V have equivalent features and
use the generic implementation of arch_get_unmapped_area() so let's make
the equivalent change there so they also don't get shadow stack pages
placed without guard pages.  x86 uses a single page guard, this is also
sufficient for arm64 where we either do single word pops and pushes or
unconstrained writes.

Architectures which do not have this feature will define VM_SHADOW_STACK
to VM_NONE and hence be unaffected.

Link: https://lkml.kernel.org/r/20240904-mm-generic-shadow-stack-guard-v2-3-a46b8b6dc0ed@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Chris Zankel <chris@zankel.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Guo Ren <guoren@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N Rao <naveen@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/mm/mmap.c~mm-care-about-shadow-stack-guard-gap-when-getting-an-unmapped-area
+++ a/mm/mmap.c
@@ -703,6 +703,18 @@ retry:
 }
 
 /*
+ * Determine if the allocation needs to ensure that there is no
+ * existing mapping within it's guard gaps, for use as start_gap.
+ */
+static inline unsigned long stack_guard_placement(vm_flags_t vm_flags)
+{
+	if (vm_flags & VM_SHADOW_STACK)
+		return PAGE_SIZE;
+
+	return 0;
+}
+
+/*
  * Search for an unmapped address range.
  *
  * We are looking for a range that:
@@ -763,6 +775,7 @@ generic_get_unmapped_area(struct file *f
 	info.length = len;
 	info.low_limit = mm->mmap_base;
 	info.high_limit = mmap_end;
+	info.start_gap = stack_guard_placement(vm_flags);
 	return vm_unmapped_area(&info);
 }
 
@@ -812,6 +825,7 @@ generic_get_unmapped_area_topdown(struct
 	info.length = len;
 	info.low_limit = PAGE_SIZE;
 	info.high_limit = arch_get_mmap_base(addr, mm->mmap_base);
+	info.start_gap = stack_guard_placement(vm_flags);
 	addr = vm_unmapped_area(&info);
 
 	/*
_

Patches currently in -mm which might be from broonie@kernel.org are

mm-make-arch_get_unmapped_area-take-vm_flags-by-default.patch
mm-pass-vm_flags-to-generic_get_unmapped_area.patch
mm-care-about-shadow-stack-guard-gap-when-getting-an-unmapped-area.patch

