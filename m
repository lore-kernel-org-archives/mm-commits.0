Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFEC3BB44
	for <mm-commits@vger.kernel.org>; Mon, 16 Jun 2025 23:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750115044; cv=none; b=nJc9nhthyGoqKAMC+bnVEGD/ZFlKU9daSYVGym6Xbt3dcpJyBqeUvNtu6K4r8H1sWyV/Rjqcq0DtYqOePeSrdUWpl6PvM9fOkNHzasprAUY4m2/FDOVghk+ZzcBD5aZ1Rkg7ldy6gc33l35x4z1uPXetKkMRdubHwHDWz/zhW+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750115044; c=relaxed/simple;
	bh=XTtmQMkZGF5AMsYmmCl+vpC8/Z1ezv9x2ygy4kTqUkA=;
	h=Date:To:From:Subject:Message-Id; b=RfLKtpIUImju/o4AP4DD501tFVF+mA5HBYS7VYsILR8xlVb3G6q3SMGXSDG7jzQMgs99oclZaN5QiMzn6/KXgnYxxoNF6fMDAu3+MQSFkOsT6fCTjwR6V7vrG4Tm0ib1ekDAvi0XMeKfCPd6JMfbDB8Flptr/UGOTu5ksHk4o08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oCMgaFNS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oCMgaFNS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5781C4CEEA;
	Mon, 16 Jun 2025 23:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750115044;
	bh=XTtmQMkZGF5AMsYmmCl+vpC8/Z1ezv9x2ygy4kTqUkA=;
	h=Date:To:From:Subject:From;
	b=oCMgaFNSm12xC6gLE+FmXZnQWmwYLjXnY2Ak7L9wT5jI/dbUT5Y1b+MmA16zeAlak
	 SlBtjc+SW0r7sR+eKpBh4eqTTTWHktaT5JGJkLsiUJubEKDR+U+6fGbA56+XW27pgZ
	 gVkXXv/VcxJiRsLRXXX/pwI5hJ1nNG+YcDRV2xZw=
Date: Mon, 16 Jun 2025 16:04:03 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,shakeel.butt@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-missing-mm-workingsetc-file-to-mm-reclaim-section.patch added to mm-hotfixes-unstable branch
Message-Id: <20250616230403.E5781C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add missing mm/workingset.c file to mm reclaim section
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-missing-mm-workingsetc-file-to-mm-reclaim-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-missing-mm-workingsetc-file-to-mm-reclaim-section.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add missing mm/workingset.c file to mm reclaim section
Date: Mon, 16 Jun 2025 21:16:43 +0100

The working set logic belongs very much to the reclaim section and is
otherwise not assigned to any other MAINTAINERS section so add it here.

Link: https://lkml.kernel.org/r/20250616201643.561626-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-missing-mm-workingsetc-file-to-mm-reclaim-section
+++ a/MAINTAINERS
@@ -15871,6 +15871,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/pt_reclaim.c
 F:	mm/vmscan.c
+F:	mm/workingset.c
 
 MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)
 M:	Andrew Morton <akpm@linux-foundation.org>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-missing-mm-workingsetc-file-to-mm-reclaim-section.patch
docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon.patch
mm-mremap-add-mremap_must_relocate_anon.patch
mm-mremap-add-mremap_relocate_anon-support-for-large-folios.patch
tools-uapi-update-copy-of-linux-mmanh-from-the-kernel-sources.patch
tools-testing-selftests-add-sys_mremap-helper-to-vm_utilh.patch
tools-testing-selftests-add-mremap-cases-that-merge-normally.patch
tools-testing-selftests-add-mremap_relocate_anon-merge-test-cases.patch
tools-testing-selftests-expand-mremap-tests-for-mremap_relocate_anon.patch
tools-testing-selftests-have-cow-self-test-use-mremap_relocate_anon.patch
tools-testing-selftests-test-relocate-anon-in-split-huge-page-test.patch
tools-testing-selftests-add-mremap_relocate_anon-fork-tests.patch
secretmem-remove-uses-of-struct-page-fix.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge.patch

