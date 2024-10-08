Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AD833986
	for <mm-commits@vger.kernel.org>; Tue,  8 Oct 2024 18:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728411993; cv=none; b=JBdhjPowrArNSv59wT4H0tXat25JTWQJDwozMjN3XdAEJrXkGMC8o/TkJz3KVu9qFiPlC1OeRxl/qsmkQ86reFmpRiqk+UF7Skac99mtt/brZ63/Zu7dmmSiKs0rqUW5aoGKZVkU6lTqUCi6rhhCDQLhqDKP1S3+HYjLms4Jj9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728411993; c=relaxed/simple;
	bh=D8IASTRyrjtK1LCpC9vaW3Oq/psHLLUDUYxm5UWnp3o=;
	h=Date:To:From:Subject:Message-Id; b=Ux8fo1bJa1KCaC11sPL3gX2hHNeOtcB/OTqUN4H8R11+2BPZhk/VGrc3iGC1J4dqZd8KqKDYaSLUcVGIG6/gZS4ZAXsfI9xmHmdrUro9g+DLmlCCBBVkhdBMkpnDz4qHifUjlXbHdLEIuFYuRXYToo6es3ZMRVeCuHRxLy5brc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yndZ3oDx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yndZ3oDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98871C4CEC7;
	Tue,  8 Oct 2024 18:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728411992;
	bh=D8IASTRyrjtK1LCpC9vaW3Oq/psHLLUDUYxm5UWnp3o=;
	h=Date:To:From:Subject:From;
	b=yndZ3oDx1+4OoCt7bpShVF41/b6YcRkHNJThgqH74WrYNfH1sbzqZWltahsLe/lHG
	 FLzbqo5jWJUg4Q2GoDHntuJnYgL/O+8OPlTNt34k6In7CCRphvf06QDwfEBQ0enj4t
	 peC0WZr7JG6e8YlUDxza5K4A3c9tKI6aluqoneUE=
Date: Tue, 08 Oct 2024 11:26:32 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,peterx@redhat.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,lkp@intel.com,donettom@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-consolidate-common-checks-in-hugetlb_get_unmapped_area-fix.patch added to mm-unstable branch
Message-Id: <20241008182632.98871C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-consolidate-common-checks-in-hugetlb_get_unmapped_area-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-consolidate-common-checks-in-hugetlb_get_unmapped_area-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-consolidate-common-checks-in-hugetlb_get_unmapped_area-fix.patch

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
Subject: mm-consolidate-common-checks-in-hugetlb_get_unmapped_area-fix
Date: Tue Oct  8 11:25:48 AM PDT 2024

arch/mips/include/asm/hugetlb.h: remove now-unused local

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202410081210.uNLbf3Jk-lkp@intel.com/
Cc: David Hildenbrand <david@redhat.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/hugetlb.h |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/mips/include/asm/hugetlb.h~mm-consolidate-common-checks-in-hugetlb_get_unmapped_area-fix
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

lib-alloc_tag_module_unload-must-wait-for-pending-kfree_rcu-calls-fix.patch
mm-consolidate-common-checks-in-hugetlb_get_unmapped_area-fix.patch
mm-memoryc-remove-stray-newline-at-top-of-file.patch

