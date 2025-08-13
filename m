Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0806C2F2905
	for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2025 22:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755124930; cv=none; b=dbOHNr4i2qRYA6TKDol+7HzNVKDxMIXXUhTdWNIrm3cEx+h3rBY/5R2a/TZvCsgthYEeraFNBnMdJUOiXvNJ8zOkC/SLRVCkWQIQpFMjnVBsbsS7otZtAA48macFzdD95miRxwh/syOiiVdgNKs6tzd8QFv0ZEJWGMd4sXXh8Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755124930; c=relaxed/simple;
	bh=Axgu1KI6w8V1EULKsvtS6XeFDLo8/4wHmNucH8vnQPg=;
	h=Date:To:From:Subject:Message-Id; b=sD3EVjGC/KrPgyXzTozw2XaVkAO9vooGG1KrqhnLppTNoLqeqLnDJbxtgRYCwZVq0O1d0Vm5sSKWzYGkduYRa6VdO8M2xkOBbPHl4hDW2w6YAG7C0o/YOw0hqZ+MtNmMw4OtyP2b++pQksKbJ3XJ+nLiKKo2gTZgIP1tuBZYR3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O2snoHcB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O2snoHcB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75AB2C4CEEB;
	Wed, 13 Aug 2025 22:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755124929;
	bh=Axgu1KI6w8V1EULKsvtS6XeFDLo8/4wHmNucH8vnQPg=;
	h=Date:To:From:Subject:From;
	b=O2snoHcBBN+AxkN0xYZL27u10qECOQUx1QUXyww1kKJqYcezw5nPyJXU8HOedo9ut
	 MzQ5GEVqUqOYpWabFUXYE38jp+SVbAUtd5mDzkbGQK8cDROMTYnlhxWO69waXVxbl0
	 of2TDUOJm4k4PCgf4XyTMQKkgunsLELO3wzu4Pfo=
Date: Wed, 13 Aug 2025 15:42:08 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-arch-specific-code-to-mm_flags_-accessors-fix.patch added to mm-unstable branch
Message-Id: <20250813224209.75AB2C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fix typo
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-arch-specific-code-to-mm_flags_-accessors-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-arch-specific-code-to-mm_flags_-accessors-fix.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: fix typo
Date: Wed, 13 Aug 2025 15:08:36 +0100

Link: https://lkml.kernel.org/r/f8ff8fe9-0c89-4742-bf52-d31319d948c1@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202508132154.feFNDPyq-lkp@intel.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/mm/mmap.c~mm-convert-arch-specific-code-to-mm_flags_-accessors-fix
+++ a/arch/s390/mm/mmap.c
@@ -185,7 +185,7 @@ void arch_pick_mmap_layout(struct mm_str
 		mm_flags_clear(MMF_TOPDOWN, mm);
 	} else {
 		mm->mmap_base = mmap_base(random_factor, rlim_stack);
-		mm_flag_set(MMF_TOPDOWN, mm);
+		mm_flags_set(MMF_TOPDOWN, mm);
 	}
 }
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

tools-testing-add-linux-argsh-header-and-fix-radix-vma-tests.patch
mm-mremap-allow-multi-vma-move-when-filesystem-uses-thp_get_unmapped_area.patch
mm-mremap-catch-invalid-multi-vma-moves-earlier.patch
selftests-mm-add-test-for-invalid-multi-vma-operations.patch
mm-add-bitmap-mm-flags-field.patch
mm-add-bitmap-mm-flags-field-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors.patch
mm-convert-prctl-to-mm_flags_-accessors.patch
mm-convert-arch-specific-code-to-mm_flags_-accessors.patch
mm-convert-arch-specific-code-to-mm_flags_-accessors-fix.patch
mm-convert-uprobes-to-mm_flags_-accessors.patch
mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags.patch
mm-correct-sign-extension-issue-in-mmf_-flag-masks.patch
mm-update-fork-mm-flags-initialisation-to-use-bitmap.patch
mm-convert-remaining-users-to-mm_flags_-accessors.patch
mm-replace-mm-flags-with-bitmap-entirely-and-set-to-64-bits.patch

