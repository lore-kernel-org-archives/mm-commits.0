Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5483E1CFEBF
	for <mm-commits@vger.kernel.org>; Wed, 30 Oct 2024 23:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730330455; cv=none; b=qx0QJhEMtVfCyJbbUkpMeohCFBj5LUO8mQX9e9ah0noSw4S5Qps1ZCvnqbKfV3UMkwkP7NNby1pW4qxSS9yv8abMd3fKsxPR1YNJrsGRaDzkCMLfHauxJYM/lh7QFqhIYhxKDszC6OMRCW3LwEMscBKti7riHOv/3TM5hpO1bD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730330455; c=relaxed/simple;
	bh=bKV099k3T9z5YkUkCC3c2C9wmx13r1P02O1bOPzmSF0=;
	h=Date:To:From:Subject:Message-Id; b=LSpIiQ5O+BmkhJqyDkVTMlYVfM/qosVkVO9o7UZXSnJJN14P8bZZoP1BUp+jvxX+O8jMR7SyA33qGXkN9uTiiMUGLpfXn/OfvnEm7HGOq/RLhqVewL5o2Nw1WUxPPwdph6ctzDotJ/kM9bs+F24dp10U6Bg76QPqd6HWi/Ej39I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ueqpK5vP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ueqpK5vP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0DFBC4CECF;
	Wed, 30 Oct 2024 23:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730330454;
	bh=bKV099k3T9z5YkUkCC3c2C9wmx13r1P02O1bOPzmSF0=;
	h=Date:To:From:Subject:From;
	b=ueqpK5vPkNi5Rfrmrjq5aFisYhTKKTqzKA/8ioqwVMPkVvs+Pf2NbsPuaUcP0kb0Y
	 gZcoB0PQqAMsTDEg1bWy1aktIxtBeBDYjAVEaRglhT59xyn4uR+3CwJYMKOi6/xLN6
	 hSyjDYFceL5Ufiw1oOQtOkYi9agtEbkmEpu2hnNE=
Date: Wed, 30 Oct 2024 16:20:54 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,catalin.marinas@arm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20241030232054.B0DFBC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling-fix
Date: Wed Oct 30 04:20:15 PM PDT 2024

fix whitespace, per Catalin

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mman.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mman.h~mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling-fix
+++ a/include/linux/mman.h
@@ -158,7 +158,7 @@ calc_vm_flag_bits(struct file *file, uns
 	       _calc_vm_trans(flags, MAP_LOCKED,     VM_LOCKED    ) |
 	       _calc_vm_trans(flags, MAP_SYNC,	     VM_SYNC      ) |
 	       _calc_vm_trans(flags, MAP_STACK,	     VM_NOHUGEPAGE) |
-		arch_calc_vm_flag_bits(file, flags);
+	       arch_calc_vm_flag_bits(file, flags);
 }
 
 unsigned long vm_commit_limit(void);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-keep-track-of-free-highatomic-fix.patch
mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling-fix.patch
mm-consolidate-common-checks-in-hugetlb_get_unmapped_area-fix.patch
mm-memoryc-remove-stray-newline-at-top-of-file.patch
bootmem-stop-using-page-index-fix.patch
mm-kasan-kmsan-copy_from-to_kernel_nofault-fix.patch
tools-mm-free-the-allocated-memory-fix.patch
memcg-v1-no-need-for-memcg-locking-for-mglru-fix.patch
mm-vma-the-pgoff-is-correct-if-can_merge_right-fix.patch
memcg-workingset-remove-folio_memcg_rcu-usage-fix.patch
fs-proc-kcorec-fix-coccinelle-reported-error-instances-fix.patch

