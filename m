Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF671917D5
	for <mm-commits@vger.kernel.org>; Tue, 30 Jul 2024 23:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722382190; cv=none; b=oUv/RluPLl9zVIl3z7UK2u6a2sljUnwHkPnUKe0bzdeH7hMX9eew25U6u5zoBJ+czomg9Bgf+zyVcFYIkGXiY49YFnBU96jN3j30VyLdPAptVnnI8s++SZpZhQs2Jhc9erEVI71gi3x+6uYAAADikL+NH+YBMPYVKsSM5S4GTRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722382190; c=relaxed/simple;
	bh=uHmQp+Lshgeq6FO85bLgJi0JRZA7lHwaih6vxR7I6xo=;
	h=Date:To:From:Subject:Message-Id; b=i8m65SwMpGfnKaA2xaH0q77fpEKr/hTIXcLeCaq8xxZDwvP+06RtM/EP2/bEmnvnIKkTERrwJyHwykpC/wKMSH9GSec8B42liOziK2Hunhp71lmDb025w0Uu2fvIf8EQ/PAqf2CvsdFunInJCQf2BLbmjw4THhFY3/GMTUntAL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iWSv0npL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iWSv0npL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3995AC32782;
	Tue, 30 Jul 2024 23:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722382189;
	bh=uHmQp+Lshgeq6FO85bLgJi0JRZA7lHwaih6vxR7I6xo=;
	h=Date:To:From:Subject:From;
	b=iWSv0npLIufrJDUVHv1PlfUdMetaTj3FMMcKAz5FZd6xYNvCbX39NDjtCzcVxFikL
	 Eev93GLN5TzOvl+LjHegx5U/zgDuwgZ7EJeqczFyJRN2pauKzFmD3fxFHoKnmai40F
	 Jl/v8/A6C1QugOqiZaffo19KMbTxG3ylzQOd4V1k=
Date: Tue, 30 Jul 2024 16:29:48 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,peterx@redhat.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lkp@intel.com,donettom@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-consolidate-common-checks-in-hugetlb_mmap_check_and_align-fix.patch added to mm-unstable branch
Message-Id: <20240730232949.3995AC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-consolidate-common-checks-in-hugetlb_mmap_check_and_align-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-consolidate-common-checks-in-hugetlb_mmap_check_and_align-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-consolidate-common-checks-in-hugetlb_mmap_check_and_align-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-consolidate-common-checks-in-hugetlb_mmap_check_and_align-fix
Date: Tue Jul 30 04:28:00 PM PDT 2024

fix unused local warning

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202407301708.tn4PRNvn-lkp@intel.com/
Cc: David Hildenbrand <david@redhat.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/hugetlb.h |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/mips/include/asm/hugetlb.h~mm-consolidate-common-checks-in-hugetlb_mmap_check_and_align-fix
+++ a/arch/mips/include/asm/hugetlb.h
@@ -17,7 +17,6 @@ static inline int prepare_hugepage_range
 					 unsigned long len)
 {
 	unsigned long task_size = STACK_TOP;
-	struct hstate *h = hstate_file(file);
 
 	if (len > task_size)
 		return -ENOMEM;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-consolidate-common-checks-in-hugetlb_mmap_check_and_align-fix.patch

