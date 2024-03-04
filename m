Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7345FBAE
	for <mm-commits@vger.kernel.org>; Mon,  4 Mar 2024 17:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709572830; cv=none; b=Hzf7+48ydrNW8wZ6ijVZMxJa7Mj+6rmXTb/5z+1uqd13PWLFznqHxwzjC7uzdhySJuW0R2rCvKG88KstExYpQ5p2C6trHfKfQaRinCGj95oMM3LExi41a4dgmVG6ahVJejk1McpafnaeMWemuNIjQcC+L8GhBcJTDTF2GSpC4Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709572830; c=relaxed/simple;
	bh=nd0zVclAtcloDZviDMdeQMQokVQCUp3594Xvf2mMmqo=;
	h=Date:To:From:Subject:Message-Id; b=X4Yq4z7LEWpaUer4++NW/04cGw/U9ygBznvItULAZLKItwaI/b9W+ttYlNLO586zEpph6LdFiQmVxuuN6SIA/b6dPReny/vlEZOhUOAzL+5SqZ7N4K9gX3UeCo8bxtpYLj3/lM0mwCujvwJpZO1z673SC3bYtvKyorUnxfypVVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BgBjXDV9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BgBjXDV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC433C433C7;
	Mon,  4 Mar 2024 17:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709572829;
	bh=nd0zVclAtcloDZviDMdeQMQokVQCUp3594Xvf2mMmqo=;
	h=Date:To:From:Subject:From;
	b=BgBjXDV91SuVmCX+XFjLZ65RiYSbtOF6Bqdcr79jJD+4GXasWwtJgmxK0ChvtNIYv
	 zQo7cTG2dFHlWSqcpCwGva3QBtJ3HVvCMcNdyBTFFkx+0mNngZipHXXrrXSIeyeoH2
	 M7oUPSr45KPiIWfnZJaMssanxDvxe69mRfFZ40J4=
Date: Mon, 04 Mar 2024 09:20:29 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,rppt@kernel.org,muchun.song@linux.dev,imbrenda@linux.ibm.com,hughd@google.com,frankja@linux.ibm.com,david@redhat.com,borntraeger@linux.ibm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pgtable-correct-the-wrong-comment-about-ptdesc-__page_flags.patch added to mm-unstable branch
Message-Id: <20240304172029.CC433C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: pgtable: correct the wrong comment about ptdesc->__page_flags
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pgtable-correct-the-wrong-comment-about-ptdesc-__page_flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pgtable-correct-the-wrong-comment-about-ptdesc-__page_flags.patch

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

mm-userfaultfd-fix-unexpected-change-to-src_folio-when-uffdio_move-fails.patch
mm-pgtable-correct-the-wrong-comment-about-ptdesc-__page_flags.patch
mm-pgtable-add-missing-pt_index-to-struct-ptdesc.patch
s390-supplement-for-ptdesc-conversion.patch

