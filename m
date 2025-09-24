Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6A0328567;
	Wed, 24 Sep 2025 20:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758745211; cv=none; b=hhrgbdfwhGsU1qbvMG29fdkumeIxYdgcS6/AmLKVYgcv2z2Al0OmBxLf6xubwS09UgQnbXRDJTQVoUFfwegBNC36eMsxbd1BDhWw8B1dYPbIYvfgz9y7tV3N6cC/sipWMiUog/YBwUEcvYpbSjVgdaVakGTd+Iupg/DJE7SJoBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758745211; c=relaxed/simple;
	bh=JCzLikBvnXiDd9fJvwWizgKaYloqQJXWF83znMxFsg0=;
	h=Date:To:From:Subject:Message-Id; b=LvzDjc/F6A5QPJQi5Gjsk06mk+tUxjOPbiuIvaYxOWolXUlHEyG9fDC7PCxsdlHFQzOItJzJSui1dXXOsRH7JMXbM7WJNd6FSWDDaAWWvnqQX4ANaz2311vDAE15yVXrzE3GlavAfGezkImG17HsA5N54tRkCFj6GGygJ+gyPg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C7pZuttA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C7pZuttA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF41C4CEF4;
	Wed, 24 Sep 2025 20:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758745211;
	bh=JCzLikBvnXiDd9fJvwWizgKaYloqQJXWF83znMxFsg0=;
	h=Date:To:From:Subject:From;
	b=C7pZuttAdNgkURjx8L1zeBYjsd/gGiKvRQFHvpGGAa3tIlR5pRdBfvxyNcBLKB8jJ
	 t7Oiq692KACyGsJPVrlzsUwrxD0OCliksLk88dhlyew4pwLEdwsJAYfqHn2JArmZVV
	 Zi3v7Qq9pvakCtHJLfRAFpYL4311bcvnouLBZWjM=
Date: Wed, 24 Sep 2025 13:20:10 -0700
To: mm-commits@vger.kernel.org,zhangpeng.00@bytedance.com,stable@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kasong@tencent.com,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,charan.kalla@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-check-for-stable-address-space-before-operating-on-the-vma.patch added to mm-new branch
Message-Id: <20250924202011.4AF41C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: check for stable address space before operating on the VMA
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-check-for-stable-address-space-before-operating-on-the-vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-check-for-stable-address-space-before-operating-on-the-vma.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Charan Teja Kalla <charan.kalla@oss.qualcomm.com>
Subject: mm: swap: check for stable address space before operating on the VMA
Date: Wed, 24 Sep 2025 23:41:38 +0530

It is possible to hit a zero entry while traversing the vmas in unuse_mm()
called from swapoff path and accessing it causes the OOPS:

Unable to handle kernel NULL pointer dereference at virtual address
0000000000000446--> Loading the memory from offset 0x40 on the
XA_ZERO_ENTRY as address.
Mem abort info:
  ESR = 0x0000000096000005
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x05: level 1 translation fault

The issue is manifested from the below race between the fork() on a
process and swapoff:
fork(dup_mmap())			swapoff(unuse_mm)
---------------                         -----------------
1) Identical mtree is built using
   __mt_dup().

2) copy_pte_range()-->
	copy_nonpresent_pte():
       The dst mm is added into the
    mmlist to be visible to the
    swapoff operation.

3) Fatal signal is sent to the parent
process(which is the current during the
fork) thus skip the duplication of the
vmas and mark the vma range with
XA_ZERO_ENTRY as a marker for this process
that helps during exit_mmap().

				     4) swapoff is tried on the
					'mm' added to the 'mmlist' as
					part of the 2.

				     5) unuse_mm(), that iterates
					through the vma's of this 'mm'
					will hit the non-NULL zero entry
					and operating on this zero entry
					as a vma is resulting into the
					oops.

The proper fix would be around not exposing this partially-valid tree to
others when droping the mmap lock, which is being solved with [1].  A
simpler solution would be checking for MMF_UNSTABLE, as it is set if
mm_struct is not fully initialized in dup_mmap().

Thanks to Liam/Lorenzo/David for all the suggestions in fixing this
issue.


Link: https://lkml.kernel.org/r/20250924181138.1762750-1-charan.kalla@oss.qualcomm.com
Link: https://lore.kernel.org/all/20250815191031.3769540-1-Liam.Howlett@oracle.com/ [1]
Fixes: d24062914837 ("fork: use __mt_dup() to duplicate maple tree in dup_mmap()")
Signed-off-by: Charan Teja Kalla <charan.kalla@oss.qualcomm.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/swapfile.c~mm-swap-check-for-stable-address-space-before-operating-on-the-vma
+++ a/mm/swapfile.c
@@ -2389,6 +2389,8 @@ static int unuse_mm(struct mm_struct *mm
 	VMA_ITERATOR(vmi, mm, 0);
 
 	mmap_read_lock(mm);
+	if (check_stable_address_space(mm))
+		goto unlock;
 	for_each_vma(vmi, vma) {
 		if (vma->anon_vma && !is_vm_hugetlb_page(vma)) {
 			ret = unuse_vma(vma, type);
@@ -2398,6 +2400,7 @@ static int unuse_mm(struct mm_struct *mm
 
 		cond_resched();
 	}
+unlock:
 	mmap_read_unlock(mm);
 	return ret;
 }
_

Patches currently in -mm which might be from charan.kalla@oss.qualcomm.com are

mm-swap-check-for-stable-address-space-before-operating-on-the-vma.patch

