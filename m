Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196AF1991B8
	for <mm-commits@vger.kernel.org>; Thu, 10 Oct 2024 20:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728593263; cv=none; b=kmEJ1rl2H8/IHfnyhx4cTf5mCqmAi1MZ1wFJhtrDTz2JX7gYl/4KNV7ehzAn5Usalk9mHK67kR6ZDia4Z1ilo9Ob0SHUjXx+lhvfQyj+co+RM38t4/4pkAqbBzD7JJnc/nSF3B/XWDtgdIkL4+cSGqfLakZ65P+309ihW3GBZsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728593263; c=relaxed/simple;
	bh=+9hkBPW0I0GfDCRePcHKKCXtBIVRNrj4MXwFcR1DLcs=;
	h=Date:To:From:Subject:Message-Id; b=uqIL02BPIhqzWHQk038HTh/H3mXkNYQk+5Q8PtvvhoLfTpuPbGKA6UjFShXgX6a9PI01D8eEmYDdsJfM3GDomoTIk0ROBKVDrXkbVKjpuGqVjMYUvV8528Uu/WPE/pxpRSDPHD6revZKFyAi3zr9B92zUQsG01NJKX9FMEZvaWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uMOa9IJt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uMOa9IJt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA13BC4CEC5;
	Thu, 10 Oct 2024 20:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728593262;
	bh=+9hkBPW0I0GfDCRePcHKKCXtBIVRNrj4MXwFcR1DLcs=;
	h=Date:To:From:Subject:From;
	b=uMOa9IJtZ+xll8BRFnDR1aT7fr2hJDhaJhUx1K3xHiZg1sMhLZcDGoOXFA3Wncxyy
	 GqC1s3joNn94ftmW3Bun1FC5sj7WHgUSlHlPKFntcBJKlfl2dDYo25ZH6p7Lh1Td1s
	 06s1fV04pt6glZ8Z0b13Xiv1aO9gux2mopnjmnEg=
Date: Thu, 10 Oct 2024 13:47:41 -0700
To: mm-commits@vger.kernel.org,w@1wt.eu,vbabka@suse.cz,riel@redhat.com,oleg@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,lkp@intel.com,jannh@google.com,hughd@google.com,deller@gmx.de,ben@decadent.org.uk,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-enforce-a-minimal-stack-gap-even-against-inaccessible-vmas-fix.patch removed from -mm tree
Message-Id: <20241010204742.CA13BC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-enforce-a-minimal-stack-gap-even-against-inaccessible-vmas-fix
has been removed from the -mm tree.  Its filename was
     mm-enforce-a-minimal-stack-gap-even-against-inaccessible-vmas-fix.patch

This patch was dropped because it was folded into mm-enforce-a-minimal-stack-gap-even-against-inaccessible-vmas.patch

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

mm-enforce-a-minimal-stack-gap-even-against-inaccessible-vmas.patch
lib-alloc_tag_module_unload-must-wait-for-pending-kfree_rcu-calls-fix.patch
mm-consolidate-common-checks-in-hugetlb_get_unmapped_area-fix.patch
mm-memoryc-remove-stray-newline-at-top-of-file.patch
bootmem-stop-using-page-index-fix.patch

