Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF85F1EF01
	for <mm-commits@vger.kernel.org>; Sun,  3 Nov 2024 18:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730659559; cv=none; b=s5t/6VNr5Zv5Z9SBoNgcPn+iFM22TCPw1d9XzXLzY9GFdiZ/ZOodqBqHpn7StACTFSqd8VB4beFfIqx6fYYXe6/T25asRaYRIrP4/RrdmkTpwNKNCiRAVrFTnJDEACcYOwU7EZRozwSHF6TUbMgRwHbexhXQVmKU8jMn9Tk/Kek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730659559; c=relaxed/simple;
	bh=rzjUgshswB6s1MbIybX64+evNM7MhKn+Ea1wL8gQJnI=;
	h=Date:To:From:Subject:Message-Id; b=gUl8+CWGc8osNnsl7TW3uH1Vg3gsosE3GVqEvHkCBbumaeV38AVP2vWAyPnodMbSozMvP9Whw8Nx4rLP5JBUpyZ1UDEZGjV7ZibBA+YTbvwYpCeMfxKjJsABsHStGLVE/k20bgFJS1JKNNRJD/44XgIwOJABZZtNU8wpX7yUSbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YU+fY3DH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YU+fY3DH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6344DC4CECD;
	Sun,  3 Nov 2024 18:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730659558;
	bh=rzjUgshswB6s1MbIybX64+evNM7MhKn+Ea1wL8gQJnI=;
	h=Date:To:From:Subject:From;
	b=YU+fY3DHae/UhZPBpRY5i+m00RCKDUYGMBV5YrMGJKjzVupvcqrcbjENdRlc5SeOu
	 usKXo1/aou/jhlRvQMWYJeByniOquDcocLB9R4ZE7KVobR8Zwkm606cVfgGVCOJ59P
	 2Pe9swL4t6AyGmRqMxRS+bZiLRv0PxUx3GSgZe6E=
Date: Sun, 03 Nov 2024 10:45:57 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,weixugc@google.com,stevensd@google.com,seanjc@google.com,rientjes@google.com,pbonzini@redhat.com,oliver.upton@linux.dev,lkp@intel.com,dmatlack@google.com,axelrasmussen@google.com,jthoughton@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-multi-gen-lru-use-pteppmdp_clear_young_notify-fix.patch removed from -mm tree
Message-Id: <20241103184558.6344DC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan.c:3498: undefined reference to `pmdp_test_and_clear_young'
has been removed from the -mm tree.  Its filename was
     mm-multi-gen-lru-use-pteppmdp_clear_young_notify-fix.patch

This patch was dropped because it was folded into mm-multi-gen-lru-use-pteppmdp_clear_young_notify.patch

------------------------------------------------------
From: James Houghton <jthoughton@google.com>
Subject: mm/vmscan.c:3498: undefined reference to `pmdp_test_and_clear_young'
Date: Fri, 25 Oct 2024 19:21:06 +0000

fix link-time error

   ld: mm/vmscan.o: in function `walk_pmd_range_locked':
>> mm/vmscan.c:3498: undefined reference to `pmdp_test_and_clear_young'

Link: https://lore.kernel.org/linux-mm/20241019012940.3656292-3-jthoughton@google.com/
Link: https://lkml.kernel.org/r/20241025192106.957236-1-jthoughton@google.com
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202410252141.djLwbAYF-lkp@intel.com/
Signed-off-by: James Houghton <jthoughton@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Matlack <dmatlack@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: David Stevens <stevensd@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-multi-gen-lru-use-pteppmdp_clear_young_notify-fix
+++ a/mm/vmscan.c
@@ -3480,7 +3480,10 @@ static void walk_pmd_range_locked(pud_t
 		/* don't round down the first address */
 		addr = i ? (*first & PMD_MASK) + i * PMD_SIZE : *first;
 
-		if (pmd_present(pmd[i]) && !pmd_trans_huge(pmd[i])) {
+		if (!pmd_present(pmd[i]))
+			goto next;
+
+		if (!pmd_trans_huge(pmd[i])) {
 			if (!walk->force_scan && should_clear_pmd_young() &&
 			    !mm_has_notifiers(args->mm))
 				pmdp_test_and_clear_young(vma, addr, pmd + i);
_

Patches currently in -mm which might be from jthoughton@google.com are

mm-multi-gen-lru-use-pteppmdp_clear_young_notify.patch
mm-add-missing-mmu_notifier_clear_young-for-mmu_notifier.patch

