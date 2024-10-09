Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312011A0BD7
	for <mm-commits@vger.kernel.org>; Wed,  9 Oct 2024 21:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728508112; cv=none; b=iB0fEkxqkjy2ud+u0Lq3xHgdj/l7nPcSSpvV3ZdBcF53UMEaN/uVpc5VBHfph8qdIRVvSbaGFfrbitedYKgZVKTjocC9DTN/e53BCSEsiLS5AnUvi/QFZPdcwndF4eMhw/g9iFMNUornsp2I68L3svgu/OGpz6Wl3ZmARv8NvAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728508112; c=relaxed/simple;
	bh=wPy8ZQ+AZ3/QynFoZmTuODvU9WAUOtSLbXt8yL1v8DM=;
	h=Date:To:From:Subject:Message-Id; b=sGpFZcYfkbVO8VjCTvZRX1VvpWWYAUVclWV6Vtp+qDBn8ps2XdOac2sGPuC24g82CMH7ZbVb0mrpoHrHb/hnF7VKXsGAypAMIJrUCNH0NY1M0jKFyFNNguw2O1fKre5wVztuYn15rdffgXhr2B3XZ+ax+0e6G/U5I8YxkE8bpwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JHnHQV4Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JHnHQV4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15A8C4CEC3;
	Wed,  9 Oct 2024 21:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728508111;
	bh=wPy8ZQ+AZ3/QynFoZmTuODvU9WAUOtSLbXt8yL1v8DM=;
	h=Date:To:From:Subject:From;
	b=JHnHQV4YwBFHMhrWf4bc5RfwCu5NYq3CwtY7jCGCBU90106aCThriCUxpZ6/1wIdy
	 OPKg+cXjzb2fNDcr2nS1BFfjbV7Yjm+wUScYC5xkKCzYNroeI2jbi1yMjcZcziOTQn
	 YrjZljPR7a+vh4seTAKfPa6peYdsRByXbhxtfBBM=
Date: Wed, 09 Oct 2024 14:08:31 -0700
To: mm-commits@vger.kernel.org,w@1wt.eu,vbabka@suse.cz,riel@redhat.com,oleg@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,lkp@intel.com,jannh@google.com,hughd@google.com,deller@gmx.de,ben@decadent.org.uk,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-enforce-a-minimal-stack-gap-even-against-inaccessible-vmas-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20241009210831.A15A8C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-enforce-a-minimal-stack-gap-even-against-inaccessible-vmas-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-enforce-a-minimal-stack-gap-even-against-inaccessible-vmas-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-enforce-a-minimal-stack-gap-even-against-inaccessible-vmas-fix.patch

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
Subject: mm-enforce-a-minimal-stack-gap-even-against-inaccessible-vmas-fix
Date: Wed Oct  9 02:05:13 PM PDT 2024

/sprev/next/ in !CONFIG_STACK_GROWSUP section, per Lorenzo

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202410090632.brLG8w0b-lkp@intel.com/
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Helge Deller <deller@gmx.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap.c~mm-enforce-a-minimal-stack-gap-even-against-inaccessible-vmas-fix
+++ a/mm/mmap.c
@@ -1066,7 +1066,7 @@ static int expand_upwards(struct vm_area
 	next = find_vma_intersection(mm, vma->vm_end, gap_addr);
 	if (next && !(next->vm_flags & VM_GROWSUP)) {
 		/* see comments in expand_downwards() */
-		if (vma_is_accessible(prev))
+		if (vma_is_accessible(next))
 			return -ENOMEM;
 		if (address == next->vm_start)
 			return -ENOMEM;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-enforce-a-minimal-stack-gap-even-against-inaccessible-vmas-fix.patch
lib-alloc_tag_module_unload-must-wait-for-pending-kfree_rcu-calls-fix.patch
mm-consolidate-common-checks-in-hugetlb_get_unmapped_area-fix.patch
mm-memoryc-remove-stray-newline-at-top-of-file.patch

