Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB2F175AD
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 21:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759112; cv=none; b=JM1djMfnbmv2iopcNPn/QoBjySgGfVCccaobka6iW7B1DXCZv1hfep2eyLCA/inmFGWAodSVkmH565znBpiKR9GVvgZTkZL3vk0VNjDwndUegW01y1h+BKyqa8SKoQ/EabIbJB+1Cf8O/6q6BNc0prTadulkttuQQeJlo8RYtmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759112; c=relaxed/simple;
	bh=saya3nJCka4q24TnTDea/5CTwdR1DL9IYcRs3/9iHxc=;
	h=Date:To:From:Subject:Message-Id; b=Amhxx22tCFHZz5Ax6BtjL3jXLuUMt7DK6jGyeTOySR5UaJPw+AWhptWzb5DKBfuI2N/8tb6+KP12J4tjpxV6AtUFlgLB0jaROohQDAEFvjF3dkfe8dUq/TakLEk+yV6owmdUW+eUhnXupQp4ZdApkHPFlwmJ/z4NMxlXy9mI5NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DToWsr0p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DToWsr0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFB9C43390;
	Wed,  6 Mar 2024 21:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709759112;
	bh=saya3nJCka4q24TnTDea/5CTwdR1DL9IYcRs3/9iHxc=;
	h=Date:To:From:Subject:From;
	b=DToWsr0pp7GmFiURctJZRBb3+WdoedrGDu8BAZFoL3sLgoOIbEikjPKGrER2chTNv
	 DpQvTn91nkIwlXWGOxiQOOemkLfNIlRjtLxwl5abwUA+x2nzq5xpx2p9p/CqYknD41
	 K65Ii7IsVeoealqBRPH04cJgtDecw4jGRZ6aF/C4=
Date: Wed, 06 Mar 2024 13:05:11 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,rppt@kernel.org,muchun.song@linux.dev,imbrenda@linux.ibm.com,hughd@google.com,frankja@linux.ibm.com,david@redhat.com,borntraeger@linux.ibm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pgtable-correct-the-wrong-comment-about-ptdesc-__page_flags.patch removed from -mm tree
Message-Id: <20240306210512.1EFB9C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: pgtable: correct the wrong comment about ptdesc->__page_flags
has been removed from the -mm tree.  Its filename was
     mm-pgtable-correct-the-wrong-comment-about-ptdesc-__page_flags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: pgtable: correct the wrong comment about ptdesc->__page_flags
Date: Mon, 4 Mar 2024 19:07:18 +0800

Patch series "minor fixes and supplement for ptdesc".

In this series, the [PATCH 1/3] and [PATCH 2/3] are fixes for some issues
discovered during code inspection.

The [PATCH 3/3] is a supplement to ptdesc conversion in s390, I don't know
why this is not done in the commit 6326c26c1514 ("s390: convert various
pgalloc functions to use ptdescs"), maybe I missed something.  And since I
don't have an s390 environment, I hope kernel test robot can help compile
and test, and this is why I did not fold [PATCH 2/3] and [PATCH 3/3] into
one patch.


This patch (of 3):

The commit 32cc0b7c9d50 ("powerpc: add pte_free_defer() for pgtables
sharing page") introduced the use of PageActive flag to page table
fragments tracking, so the ptdesc->__page_flags is not unused, so correct
the wrong comment.

Link: https://lkml.kernel.org/r/cover.1709541697.git.zhengqi.arch@bytedance.com
Link: https://lkml.kernel.org/r/cc42d5915fd98fd802f920de243f535efcfe01db.1709541697.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm_types.h~mm-pgtable-correct-the-wrong-comment-about-ptdesc-__page_flags
+++ a/include/linux/mm_types.h
@@ -419,7 +419,7 @@ FOLIO_MATCH(compound_head, _head_2a);
 
 /**
  * struct ptdesc -    Memory descriptor for page tables.
- * @__page_flags:     Same as page flags. Unused for page tables.
+ * @__page_flags:     Same as page flags. Powerpc only.
  * @pt_rcu_head:      For freeing page table pages.
  * @pt_list:          List of used page tables. Used for s390 and x86.
  * @_pt_pad_1:        Padding that aliases with page's compound head.
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


