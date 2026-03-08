Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCBA1D47B4
	for <mm-commits@vger.kernel.org>; Sun,  8 Mar 2026 21:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773004215; cv=none; b=uYt/fUx0ZQx90ASHIs+Rmz9qKbnsPr/vVh3EKRmr8ayqHWLO54lk2cy4hshB+QLb8O7YOSZNsR1RaAHoFBUZF9IIRLBzC3nvFx08WGkL8qtU7K39rwxVRq8pZhSNrB0Eww9z5Ds1oAgXD+vPHv5oDunmcx1Aj64/lgqgPoa42to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773004215; c=relaxed/simple;
	bh=3FEoRSeyFX0YhWMWlVnsC7HbrVSie2tC4mIThTaPXYw=;
	h=Date:To:From:Subject:Message-Id; b=Kc1myCCcvK0BqRZe/BAMZtPoqEtW6vPUz3reu8cjw8ievv1bMgnoOIR6wevhX5lcFG6X0IS4h8xypps5B+1t74slDP8ZXPHsoolTQzZ9Q1wIm1+1bGwGvRSc0Lv1ma4x2zMTaxdLxsE/GlVQTzG5apjuc4/ciM9wMVUtTqQmFxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dhsArl4U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dhsArl4U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9DCC116C6;
	Sun,  8 Mar 2026 21:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773004214;
	bh=3FEoRSeyFX0YhWMWlVnsC7HbrVSie2tC4mIThTaPXYw=;
	h=Date:To:From:Subject:From;
	b=dhsArl4UiJjWZPcVJyIz7gBI390JIGJSqTdG3ydi1WHnRTlh2skc1VH37RQ5a7F0l
	 hn2wntkpyEDk08+iPsuc3t9lD7N2o1+1v1qeaWxv1jDhdxqpeOwxV+iK6C3co8Hnqi
	 mP+AUIncmh94jjzbzjibSWVpGfm+T34gHWY7Alqk=
Date: Sun, 08 Mar 2026 14:10:13 -0700
To: mm-commits@vger.kernel.org,xemul@parallels.com,rppt@kernel.org,peterx@redhat.com,osalvador@suse.de,muchun.song@linux.dev,ljs@kernel.org,JonasZhou@zhaoxin.com,hillf.zj@alibaba-inc.com,dgilbert@redhat.com,david@kernel.org,aarcange@redhat.com,jianhuizzzzz@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-fix-hugetlb-fault-mutex-hash-calculation-v2.patch added to mm-hotfixes-unstable branch
Message-Id: <20260308211014.8F9DCC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/userfaultfd: fix hugetlb fault mutex hash calculation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-userfaultfd-fix-hugetlb-fault-mutex-hash-calculation-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-fix-hugetlb-fault-mutex-hash-calculation-v2.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Jianhui Zhou <jianhuizzzzz@gmail.com>
Subject: mm/userfaultfd: fix hugetlb fault mutex hash calculation
Date: Sat, 7 Mar 2026 22:35:39 +0800

remove unnecessary vma_hugecache_offset() stub

Link: https://lkml.kernel.org/r/20260307143542.179953-1-jianhuizzzzz@gmail.com
Fixes: 60d4d2d2b40e ("userfaultfd: hugetlbfs: add __mcopy_atomic_hugetlb for huge page UFFDIO_COPY")
Reported-by: syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f525fd79634858f478e7
Signed-off-by: Jianhui Zhou <jianhuizzzzz@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: JonasZhou <JonasZhou@zhaoxin.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/include/linux/hugetlb.h~mm-userfaultfd-fix-hugetlb-fault-mutex-hash-calculation-v2
+++ a/include/linux/hugetlb.h
@@ -1208,12 +1208,6 @@ static inline unsigned int huge_page_shi
 	return PAGE_SHIFT;
 }
 
-static inline pgoff_t vma_hugecache_offset(struct hstate *h,
-		struct vm_area_struct *vma, unsigned long address)
-{
-	return linear_page_index(vma, address);
-}
-
 static inline bool hstate_is_gigantic(struct hstate *h)
 {
 	return false;
_

Patches currently in -mm which might be from jianhuizzzzz@gmail.com are

mm-userfaultfd-fix-hugetlb-fault-mutex-hash-calculation.patch
mm-userfaultfd-fix-hugetlb-fault-mutex-hash-calculation-v2.patch

