Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672130;
	b=rdn7v15BXItPv+hSzOcY+BFF/yXSq8eZUGdKEdnKPQT8i55siapgN4ujSGyKWYU6Mt8z
	 6ZigtmZncGnJ0KN8sOIX/vuSWs9UsOFjG0T//5jbIW+pL5eQiMo+dWozqSa2J1ikGUgj4
	 4RC6qRCcSaYq3XlbY1/i6DQQ9MhNAjx/HnVRU18cQj81oj4khKxQ2iVt5OVabSt2SLGQ6
	 DDIZMjKXa7/05fQmYGRAMwyvLWNGHOqt4GS3VHlv52eCVl0wLm2VD/nUlnlFNSAzuKtQ4
	 xeYMnzC/kobT4tYT14+eLZhq8mpKL1iTX586Gc3Va1vfNbTp+KwdzOfRjh0ltQroDww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672130;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=MQ1HzEm2PQVD6xjtjV2vORDGvBlcpLWbJsj1oqJY6p4=;
	b=PWdTC8IPGJjSNPwwoc28E/JzzXSMohq8UH6umjxGgxFGCAFfn36kbTgQXszesoBCNeMB
	 Umkmo+FA2WstSDjbtdreIh9S49qWVYY4uC0m7neInpF7l/eiVqKDGKrir43CmUwnMcCCd
	 ZAOOgNyOpAE4fRtMfeYzIE1MAscqYcUQaDfW6eXrNQg35zNcZ+CcM698xlaisTgUYY4w+
	 92VF0KXBhkom8fkfXjnU5ybS9Ie+wYYf8aQRanodPug5TBU8/5dH1iAJbjBcUdCvrai4W
	 oZQAI5+d7aEPR8+hoHJjATTxrLuiVd2sfhD8ilRmDwx4Wj2NiKqc/jAfdIN4XkCZZMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=swPCSfJ8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48717606A324;
	Tue,  3 Nov 2026 02:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=swPCSfJ8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A9EE1F000C1;
	Tue,  3 Nov 2026 02:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672130;
	bh=MQ1HzEm2PQVD6xjtjV2vORDGvBlcpLWbJsj1oqJY6p4=;
	h=Date:To:From:Subject;
	b=swPCSfJ8W7upaaQBgLPXsPpJVOUWS6WNnd3ipV377IgvC34mx6j/dyCRwOipYiAof
	 ASTNkj2M6avHw9RY+Vfw/6pSh3UN1wA46rFJerC8TW06Uoby8A53qojdi0BzItL2nW
	 fHcEGKVApqb3rAK1Fu3ZRuKSk2UzO9G6e+ZjJyng=
Date: Mon, 02 Nov 2026 18:15:29 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,
	pfalcato@suse.de,matenajakub@gmail.com,luizcap@redhat.com,liam@infradead.org,
	jannh@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vma-fix-expansion-of-vma_mixedmap_bit-vmas.patch removed from -mm tree
Message-Id: <20261103021530.1A9EE1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/vma: fix expansion of VMA_MIXEDMAP_BIT VMAs
has been removed from the -mm tree.  Its filename was
     mm-vma-fix-expansion-of-vma_mixedmap_bit-vmas.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/vma: fix expansion of VMA_MIXEDMAP_BIT VMAs
Date: Fri, 23 Oct 2026 16:17:31 +0100

Commit ca3d76b0aa80 ("mm: add merging after mremap resize") combined
merging with expansion of mremap()'d VMAs, however it also unintentionally
disallowed the expansion of unmergeable VMAs.

Previously it was possible to expand a mixed mapping which mremap() had
already ensured was a legal expansion.

This is clearly seen in the mremap() logic, as it checks
vma_is_fixed_mapping() to determine legality of an expansion rather than
vma_can_merge().

Additionally, copy_vma() allows for a failed merge to result in a new VMA
being instantiated if MREMAP_MAYMOVE is specified.

However, this is not attempted, as a failure in vma_merge_extend() is
assumed to be an -ENOMEM failure.

Since vma_merge_extend() is used exclusively by mremap() to perform a merge
and/or expansion, resolve the issue by invoking vma_expand() for
unmergeable VMAs there.

Explicitly assert that the VMA is both non-fixed and a mixed mapping.
This provides double insurance against broken changes in future.

Note that khugepaged_enter_vma() (which vma_merge_new_range() runs) is
redundant in this case, as a mixed mapping is not subject to khugepaged.

Also update the VMA userland tests to add a required predicate.

Link: https://lore.kernel.org/20261023-vma-expansion-fix-v1-1-6142baf1f46b@kernel.org
Fixes: ca3d76b0aa80 ("mm: add merging after mremap resize")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Luiz Capitulino <luizcap@redhat.com>
Closes: https://lore.kernel.org/all/20261023023106.515365-1-luizcap@redhat.com/
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jakub Matěna <matenajakub@gmail.com>
Cc: <stable@vger.kernel.org>
---

 mm/vma.c                        |   19 ++++++++++++++++---
 tools/testing/vma/include/dup.h |    5 +++++
 2 files changed, 21 insertions(+), 3 deletions(-)

--- a/mm/vma.c~mm-vma-fix-expansion-of-vma_mixedmap_bit-vmas
+++ a/mm/vma.c
@@ -1851,12 +1851,25 @@ struct vm_area_struct *vma_merge_extend(
 					struct vm_area_struct *vma,
 					unsigned long delta)
 {
-	VMG_VMA_STATE(vmg, vmi, vma, vma, vma->vm_end, vma->vm_end + delta);
+	const unsigned long start =
+		vma_can_merge(vma) ? vma->vm_end : vma->vm_start;
+	VMG_VMA_STATE(vmg, vmi, vma, vma, start, vma->vm_end + delta);
 
-	vmg.next = vma_iter_next_rewind(vmi, NULL);
 	vmg.middle = NULL; /* We use the VMA to populate VMG fields only. */
 
-	return vma_merge_new_range(&vmg);
+	if (vma_can_merge(vma)) {
+		vmg.next = vma_iter_next_rewind(vmi, NULL);
+		return vma_merge_new_range(&vmg);
+	}
+
+	/* Mixed mappings are permitted to be expanded, not merged. */
+	VM_WARN_ON_ONCE(vma_is_fixed_mapping(vma));
+	VM_WARN_ON_ONCE(!vma_test(vma, VMA_MIXEDMAP_BIT));
+	vma_prev(vmi); /* Reposition to start of VMA. */
+	vmg.target = vma;
+	if (vma_expand(&vmg))
+		return NULL;
+	return vma;
 }
 
 void unlink_file_vma_batch_init(struct unlink_vma_file_batch *vb)
--- a/tools/testing/vma/include/dup.h~mm-vma-fix-expansion-of-vma_mixedmap_bit-vmas
+++ a/tools/testing/vma/include/dup.h
@@ -1727,3 +1727,8 @@ static inline bool vma_flags_can_merge(c
 	 */
 	return !vma_flags_is_hugetlb(flags);
 }
+
+static inline bool vma_can_merge(const struct vm_area_struct *vma)
+{
+	return vma_flags_can_merge(&vma->flags);
+}
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-read-anon_vma-carefully-in-validate_mm.patch

