Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5641F60264
	for <mm-commits@vger.kernel.org>; Mon,  4 Mar 2024 17:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709572833; cv=none; b=DfLJjV2SkCR3xVJv7cC72uUUABnMIld6eYrqoQFcD/lQRKnijcOkLQm+Pc+1hAHemTdlh3EUVcwlrDmcC1KcRZYv5DuNkBjL7RtXNJ8Tl4WTjTF3qbmNKVLfIpyh9fHKceClFkGh4dxgJo85Cm4Jza2+QndrhM3SdCvxroms4RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709572833; c=relaxed/simple;
	bh=pxYimLmcra0aeputRikFH+4z+IO/gnxQPQM4uhu+wXA=;
	h=Date:To:From:Subject:Message-Id; b=FpY4ZV7uh2If415JStLYv0HXe1FNvEwWhK8s9YtMKECYzrri15rpUHi/hcJiKID7E4OjNWI+jaNRdUZmL/QE57yJqyrMnhp2kuFppJNYfaugbs1I9+snkQKrqRYAQ1jVYlNW6i7sDGaOdq7dFBMFExp9VKqj8fBYXKdh/1mKpzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z6C7D1R5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z6C7D1R5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4250C433F1;
	Mon,  4 Mar 2024 17:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709572831;
	bh=pxYimLmcra0aeputRikFH+4z+IO/gnxQPQM4uhu+wXA=;
	h=Date:To:From:Subject:From;
	b=z6C7D1R5DiS3LoF0jEs+cXfbl84zJYaGdQdUhmuG33dn3enoaWfahCIl7kDEUdj/6
	 vx3ovNXGFwWIlIXv7eP8DHIkIHiqRucBgkMveQDcOPOfo6Yobvq+qrkKf5STszinXs
	 vyNYcbcYJB8OMdEaj8uQGhJi4tWHNTsf/XhGIGcc=
Date: Mon, 04 Mar 2024 09:20:31 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,rppt@kernel.org,muchun.song@linux.dev,imbrenda@linux.ibm.com,hughd@google.com,frankja@linux.ibm.com,david@redhat.com,borntraeger@linux.ibm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pgtable-add-missing-pt_index-to-struct-ptdesc.patch added to mm-unstable branch
Message-Id: <20240304172031.C4250C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: pgtable: add missing pt_index to struct ptdesc
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pgtable-add-missing-pt_index-to-struct-ptdesc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pgtable-add-missing-pt_index-to-struct-ptdesc.patch

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
Subject: mm: pgtable: add missing pt_index to struct ptdesc
Date: Mon, 4 Mar 2024 19:07:19 +0800

In s390, the page->index field is used for gmap (see gmap_shadow_pgt()),
so add the corresponding pt_index to struct ptdesc and add a comment to
clarify this.

Link: https://lkml.kernel.org/r/283624c2af45fb2090b41a6b1b5481bb0a45bad7.1709541697.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/mm_types.h~mm-pgtable-add-missing-pt_index-to-struct-ptdesc
+++ a/include/linux/mm_types.h
@@ -425,6 +425,7 @@ FOLIO_MATCH(compound_head, _head_2a);
  * @_pt_pad_1:        Padding that aliases with page's compound head.
  * @pmd_huge_pte:     Protected by ptdesc->ptl, used for THPs.
  * @__page_mapping:   Aliases with page->mapping. Unused for page tables.
+ * @pt_index:         Used for s390 gmap.
  * @pt_mm:            Used for x86 pgds.
  * @pt_frag_refcount: For fragmented page table tracking. Powerpc only.
  * @_pt_pad_2:        Padding to ensure proper alignment.
@@ -450,6 +451,7 @@ struct ptdesc {
 	unsigned long __page_mapping;
 
 	union {
+		pgoff_t pt_index;
 		struct mm_struct *pt_mm;
 		atomic_t pt_frag_refcount;
 	};
@@ -475,6 +477,7 @@ TABLE_MATCH(flags, __page_flags);
 TABLE_MATCH(compound_head, pt_list);
 TABLE_MATCH(compound_head, _pt_pad_1);
 TABLE_MATCH(mapping, __page_mapping);
+TABLE_MATCH(index, pt_index);
 TABLE_MATCH(rcu_head, pt_rcu_head);
 TABLE_MATCH(page_type, __page_type);
 TABLE_MATCH(_refcount, __page_refcount);
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-userfaultfd-fix-unexpected-change-to-src_folio-when-uffdio_move-fails.patch
mm-pgtable-correct-the-wrong-comment-about-ptdesc-__page_flags.patch
mm-pgtable-add-missing-pt_index-to-struct-ptdesc.patch
s390-supplement-for-ptdesc-conversion.patch

