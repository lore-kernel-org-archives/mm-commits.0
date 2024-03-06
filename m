Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83EC7175AD
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 21:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759113; cv=none; b=JNe6Bfd62gcw0ze97VNZuWEd6Tvc/DbJ4OkKVbGw50bh4BkyUJW7BSizmSU4PYjm87wdyUxuIvh11PZJwS2FKSQ9XS54CRLX1nQbQUma7Zopl8/s/a9mqVONUNG2vLFC/UigE25ilJJywXTfUc3ivccUUOFRnzkR6+/m7XnAN8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759113; c=relaxed/simple;
	bh=qcyGVU0rYgG1rHOUXeRMHhiDrzWTwjQSAFhm/Vf0QVA=;
	h=Date:To:From:Subject:Message-Id; b=UBl6/HNRko6Rie2Jsb0vNKRKrNGxKy/YivgzNGGetXZ+pZ5Q9ydRaWCCfu6aTOzdBH2g6WdpAYe3zz4/r/VSZ9+OYAnQYL95zasj3cnqTs3Lb0rdg5VaRbspraY5VwMzwOgyXVtWOo5OxHzbEhEUHDk5A/P1WtZX4z/kzCHczhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qR/yCp6z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qR/yCp6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6C4C433C7;
	Wed,  6 Mar 2024 21:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709759113;
	bh=qcyGVU0rYgG1rHOUXeRMHhiDrzWTwjQSAFhm/Vf0QVA=;
	h=Date:To:From:Subject:From;
	b=qR/yCp6zpoae2Sp7wWOxzbXBlilndxVBjPNYB7NfYPvgnb2B/LLinZDbIg1TitRHT
	 J88N1xriVbms8HXHYR+0kBPKWEJAJHu3DmV9R/zcM6eVW5gNrfN/5AHV/uUtqhyd6M
	 IQwCoyZsZI4H93WKKudsIXCSbf5XuzO09Z5r0A6E=
Date: Wed, 06 Mar 2024 13:05:12 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,rppt@kernel.org,muchun.song@linux.dev,imbrenda@linux.ibm.com,hughd@google.com,frankja@linux.ibm.com,david@redhat.com,borntraeger@linux.ibm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pgtable-add-missing-pt_index-to-struct-ptdesc.patch removed from -mm tree
Message-Id: <20240306210513.0C6C4C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: pgtable: add missing pt_index to struct ptdesc
has been removed from the -mm tree.  Its filename was
     mm-pgtable-add-missing-pt_index-to-struct-ptdesc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


