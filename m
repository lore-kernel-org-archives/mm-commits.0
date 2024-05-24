Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE7F381C6
	for <mm-commits@vger.kernel.org>; Fri, 24 May 2024 19:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716577855; cv=none; b=Kl+LZKeRP72qSbjF8gKvvVNGso1QPRRUJaIZ9kzFBJHa6glmxWdRfFVYnZouIYERmhdvmBKhVspRJA+WNKit4itu0bEZ7mjNe98tTUBW1GdHKgzufOmF5asbB+RX6E3cpZBYPHfdGJPuyJg7MUI4MKpCBFd09i5z8PQq5dWl9SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716577855; c=relaxed/simple;
	bh=E7JHZCWDYi7iFsmqV3y12esvdSltqucRRmgHNW2uqSk=;
	h=Date:To:From:Subject:Message-Id; b=svCb7UwReLbRSlpyVR3bjuCz0y6LoAcoTAsjyZDh8VbKlKeKs4niPyqbyQYrnu6pgXSYqRpOdVb8ron4XFV6pKZZZ7in+iLAFhNXsJrAYAUMZwz03HRTHeXonk2JEwDzWHR4gEpw5C1H4ivMKEw2JKs4vjPSqj1f/3eBETA8mr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SlsZgPXx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SlsZgPXx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D9CC2BBFC;
	Fri, 24 May 2024 19:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716577854;
	bh=E7JHZCWDYi7iFsmqV3y12esvdSltqucRRmgHNW2uqSk=;
	h=Date:To:From:Subject:From;
	b=SlsZgPXxBnd7r7rDare1tzX5r1vq403EWQCH9i6gtBNryBnq11I1AddJIXXwOPefq
	 25dm05i1xt7s9D+SGAfMde54YKZy35aIzLYsPeiSo+VpMsfygqogVMtRd2P2zOsJS0
	 bdA5qVcky04gLuzOuSMUk+RK1dNCkiOhLQJDue8g=
Date: Fri, 24 May 2024 12:10:53 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,xiehuan09@gmail.com,will@kernel.org,wangkefeng.wang@huawei.com,songmuchun@bytedance.com,shy828301@gmail.com,ryan.roberts@arm.com,peterx@redhat.com,minchan@kernel.org,mhocko@suse.com,ioworker0@gmail.com,fengwei.yin@intel.com,david@redhat.com,chrisl@kernel.org,catalin.marinas@arm.com,baolin.wang@linux.alibaba.com,21cnbao@gmail.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-arm64-fix-the-out-of-bounds-issue-in-contpte_clear_young_dirty_ptes.patch added to mm-hotfixes-unstable branch
Message-Id: <20240524191054.60D9CC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: arm64: Fix the out-of-bounds issue in contpte_clear_young_dirty_ptes
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-arm64-fix-the-out-of-bounds-issue-in-contpte_clear_young_dirty_ptes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-arm64-fix-the-out-of-bounds-issue-in-contpte_clear_young_dirty_ptes.patch

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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: arm64: Fix the out-of-bounds issue in contpte_clear_young_dirty_ptes
Date: Fri, 24 May 2024 12:54:44 +1200

We are passing a huge nr to __clear_young_dirty_ptes() right now.  While
we should pass the number of pages, we are actually passing CONT_PTE_SIZE.
This is causing lots of crashes of MADV_FREE, panic oops could vary
everytime.

Link: https://lkml.kernel.org/r/20240524005444.135417-1-21cnbao@gmail.com
Fixes: 89e86854fb0a ("mm/arm64: override clear_young_dirty_ptes() batch helper")
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Lance Yang <ioworker0@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Jeff Xie <xiehuan09@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/contpte.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/mm/contpte.c~mm-arm64-fix-the-out-of-bounds-issue-in-contpte_clear_young_dirty_ptes
+++ a/arch/arm64/mm/contpte.c
@@ -376,7 +376,7 @@ void contpte_clear_young_dirty_ptes(stru
 	 * clearing access/dirty for the whole block.
 	 */
 	unsigned long start = addr;
-	unsigned long end = start + nr;
+	unsigned long end = start + nr * PAGE_SIZE;
 
 	if (pte_cont(__ptep_get(ptep + nr - 1)))
 		end = ALIGN(end, CONT_PTE_SIZE);
@@ -386,7 +386,7 @@ void contpte_clear_young_dirty_ptes(stru
 		ptep = contpte_align_down(ptep);
 	}
 
-	__clear_young_dirty_ptes(vma, start, ptep, end - start, flags);
+	__clear_young_dirty_ptes(vma, start, ptep, (end - start) / PAGE_SIZE, flags);
 }
 EXPORT_SYMBOL_GPL(contpte_clear_young_dirty_ptes);
 
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-huge_mm-fix-undefined-reference-to-mthp_stats-for-config_sysfs=n.patch
mm-arm64-fix-the-out-of-bounds-issue-in-contpte_clear_young_dirty_ptes.patch

