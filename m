Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDF2364053
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388616; cv=none; b=GYp6SsLafmNbA1GqHEjtPM63rkpg2OEiuYZT4kE3/wtBCUAefGL5/llwH8C5Q8IqqaryrF0NXc7Agj77ghIAXX696fAjjobQ+9jOKzv27RPR2nIAyKQDTWkNamJTY39NfWYYXrS8+Wx2HCHCLRcx2gJ4TUGShf7jhud7W4gn6NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388616; c=relaxed/simple;
	bh=+bCgAKMDGh43kqT4ZkF6y+9Jwyty2eiV3/A1BOxdZN4=;
	h=Date:To:From:Subject:Message-Id; b=rVVxQsHaDI3F2egAWZpHO0Uhhmv8kEq3my1ocrBwvWt/YYOaxr7i8on5aRX4VPPJM07LAmaREAPskGJSVQAQ2wPuH6HNHUHP4WJ5tvmYiNiSMdmVt+PSbpT/WZJOkV2n+ZUZ0goKCoKxiuPxcXE88AQBWQPh0xCKNGLY4axP6aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sKh9Gyqc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sKh9Gyqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F41C19424;
	Tue, 24 Mar 2026 21:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388616;
	bh=+bCgAKMDGh43kqT4ZkF6y+9Jwyty2eiV3/A1BOxdZN4=;
	h=Date:To:From:Subject:From;
	b=sKh9GyqcQiY4YkiohAqf5Xj9B+QydATyvX8gq+7YtzvzkUbw7MzRtW7Kc1XA5r+Xp
	 BLjZz96SmHiHUqsMvi9GfXprbynuxdxB+DbEepNfjLiN251pC6fdKBkNYUHx2Q/dJ/
	 dOovCbynBwQH4Rvb/ygATyIbLB1LtGKH8zfLaLTw=
Date: Tue, 24 Mar 2026 14:43:35 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,tglx@kernel.org,surenb@google.com,rppt@kernel.org,rick.p.edgecombe@intel.com,pjw@kernel.org,palmer@dabbelt.com,mingo@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,hpa@zytor.com,debug@rivosinc.com,david@kernel.org,dave.hansen@linux.intel.com,broonie@kernel.org,bp@alien8.de,aou@eecs.berkeley.edu,alex@ghiti.fr,catalin.marinas@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-do-not-map-the-shadow-stack-as-thp.patch removed from -mm tree
Message-Id: <20260324214335.E8F41C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: do not map the shadow stack as THP
has been removed from the -mm tree.  Its filename was
     mm-do-not-map-the-shadow-stack-as-thp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: mm: do not map the shadow stack as THP
Date: Wed, 25 Feb 2026 16:14:02 +0000

The default shadow stack size allocated on first prctl() for the main
thread or subsequently on clone() is either half of RLIMIT_STACK or half
of a thread's stack size (for arm64).  Both of these are likely to be
suitable for a THP allocation and the kernel is more aggressive in
creating such mappings.  However, it does not make much sense to use a
huge page.  It didn't make sense for the normal stacks either, see commit
c4608d1bf7c6 ("mm: mmap: map MAP_STACK to VM_NOHUGEPAGE").

Force VM_NOHUGEPAGE when allocating/mapping the shadow stack.  As per
commit 7190b3c8bd2b ("mm: mmap: map MAP_STACK to VM_NOHUGEPAGE only if THP
is enabled"), only pass this flag if TRANSPARENT_HUGEPAGE is enabled as
not to confuse CRIU tools.

Link: https://lkml.kernel.org/r/20260225161404.3157851-6-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Deepak Gupta <debug@rivosinc.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/util.c~mm-do-not-map-the-shadow-stack-as-thp
+++ a/mm/util.c
@@ -629,14 +629,18 @@ unsigned long vm_mmap_shadow_stack(unsig
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long ret, unused;
+	vm_flags_t vm_flags = VM_SHADOW_STACK;
 
 	flags |= MAP_ANONYMOUS | MAP_PRIVATE;
 	if (addr)
 		flags |= MAP_FIXED_NOREPLACE;
 
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+		vm_flags |= VM_NOHUGEPAGE;
+
 	mmap_write_lock(mm);
 	ret = do_mmap(NULL, addr, len, PROT_READ | PROT_WRITE, flags,
-		      VM_SHADOW_STACK, 0, &unused, NULL);
+		      vm_flags, 0, &unused, NULL);
 	mmap_write_unlock(mm);
 
 	return ret;
_

Patches currently in -mm which might be from catalin.marinas@arm.com are


