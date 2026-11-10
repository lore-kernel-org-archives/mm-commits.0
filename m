Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794292883;
	b=QYVUXBeoVVzg7HZdwh6baYyme8mf1BLtG8GxX8viN15Ch7vW5Jhw3Uc9GelLD5RZZ/yD
	 KlFlT8Nw/F58yhSrVLH6gGqU+jgOIikW4LalzZA5XrlxNJ+NYVcS0QoMK/jeSmycF/mmi
	 JQ1vPaeUIcZDpToahY05dlb2pd27r49pX1XCp0dGoubJ8wSR3N19ECLRDFa4wcAFrlf5X
	 /dVVBxOd25AMtJfLk1F0N+KuZHqbHule0nV8iakZRDMHpmqhDGjeFd3+xu6yzu/I4fbRt
	 B7M6VbXDfxc/p+8tHZ0PKwcUBpWO7YKDU8X22bVNtMAZVHYbHy0Wzdm78S7GE0cZKVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794292883;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=dW2Ol3QhjS7Jy8Ejjkz9LDnSIISpjfswgystIeE0q68=;
	b=qmE6Wz8YxSUuIs0Ns0Gyh3v70ApTZgHZqxI1eIuuWdXb53mm+EXUlR/T5J3HE1Oni5SF
	 c4Kph2QKaGRiqNYwkzZvfswhjHT/rzHGJGZMmzb9E5D5tXlRvGq9ucEnkL+18ct/ErE/6
	 TRHEzle7pF5C7FpE5FTpl7lcwvr1lSK2/qvBGNJA16fMM+g+iUK0zBvwHpmLMduqa5UkE
	 DYqHjKNC4QFL8uprT0CA+q5RTkrsqwptSx7vbvSY5k8983DXZXak4OxmXecSS7pbu+Uw1
	 qrh2+73kbMp/BVrRbvLScz6jo9scHydzU2Im9W/F3FeQlgdwJZZvuPI6Qiutm9tmYEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ODuFZGjP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F57B60A6F4E
	for <mm-commits@vger.kernel.org>; Tue, 10 Nov 2026 06:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ODuFZGjP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01851F008BC;
	Tue, 10 Nov 2026 06:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794292882;
	bh=dW2Ol3QhjS7Jy8Ejjkz9LDnSIISpjfswgystIeE0q68=;
	h=Date:To:From:Subject;
	b=ODuFZGjPmfyZFQM2QwOOnaN17oDzIUbTKYM3ZcSb73rpgC3/PCmlbu+/vnXxgScot
	 NRIuyWqpJ21CSyWQnUDdrrUP8LOhRBaOALGRuo0pfrVr5ZN+1U7JgP2V9XofNaOlCw
	 utVAmzfhcV+oigQnyy1N3oSIS7sXkGz39U6lLRZs=
Date: Mon, 09 Nov 2026 22:41:22 -0800
To: mm-commits@vger.kernel.org,yangsongsen@insta360.com,vbabka@kernel.org,
	syzbot+10e72ea5747737bcd2ad@syzkaller.appspotmail.com,pfalcato@suse.de,
	ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,
	david@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vma-read-anon_vma-carefully-in-validate_mm-fix.patch removed from -mm tree
Message-Id: <20261110064122.C01851F008BC@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm-vma-read-anon_vma-carefully-in-validate_mm-fix
has been removed from the -mm tree.  Its filename was
     mm-vma-read-anon_vma-carefully-in-validate_mm-fix.patch

This patch was dropped because it was folded into mm-vma-read-anon_vma-carefully-in-validate_mm.patch

------------------------------------------------------
From: Kiryl Shutsemau <kas@kernel.org>
Subject: mm-vma-read-anon_vma-carefully-in-validate_mm-fix
Date: Mon, 2 Nov 2026 10:48:45 +0000

reduce ifdeffery

Link: https://lore.kernel.org/auhn01dpDzK47igy@thinkstation
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Songsen Yang <yangsongsen@insta360.com>
Cc: <syzbot+10e72ea5747737bcd2ad@syzkaller.appspotmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 include/linux/mm.h |    2 --
 mm/vma.c           |   12 +++++-------
 2 files changed, 5 insertions(+), 9 deletions(-)

--- a/include/linux/mm.h~mm-vma-read-anon_vma-carefully-in-validate_mm-fix
+++ a/include/linux/mm.h
@@ -4370,9 +4370,7 @@ anon_rmap_tree_iter_first(struct anon_vm
 struct anon_vma_chain *
 anon_rmap_tree_iter_next(struct anon_vma_chain *avc,
 			 pgoff_t pgoff_start, pgoff_t pgoff_last);
-#ifdef CONFIG_DEBUG_VM_RB
 void anon_rmap_tree_verify(struct anon_vma_chain *avc);
-#endif
 
 #define anon_rmap_tree_foreach(avc, anon_vma, pgoff_start, pgoff_last)		 \
 	for (avc = anon_rmap_tree_iter_first(anon_vma, pgoff_start, pgoff_last); \
--- a/mm/vma.c~mm-vma-read-anon_vma-carefully-in-validate_mm-fix
+++ a/mm/vma.c
@@ -676,14 +676,17 @@ static int dup_anon_vma(struct vm_area_s
 }
 
 #ifdef CONFIG_DEBUG_VM_MAPLE_TREE
-#ifdef CONFIG_DEBUG_VM_RB
 static void validate_mm_anon_rmap(struct vm_area_struct *vma)
 {
-	struct anon_vma *anon_vma = READ_ONCE(vma->anon_vma);
+	struct anon_vma *anon_vma;
 	struct anon_vma_chain *avc;
 
+	if (!IS_ENABLED(CONFIG_DEBUG_VM_RB))
+		return;
+
 	vma_assert_stabilised(vma);
 
+	anon_vma = READ_ONCE(vma->anon_vma);
 	if (!anon_vma)
 		return;
 
@@ -692,11 +695,6 @@ static void validate_mm_anon_rmap(struct
 		anon_rmap_tree_verify(avc);
 	anon_vma_unlock_read(anon_vma);
 }
-#else
-static void validate_mm_anon_rmap(struct vm_area_struct *vma)
-{
-}
-#endif
 
 void validate_mm(struct mm_struct *mm)
 {
_

Patches currently in -mm which might be from kas@kernel.org are

mm-vma-read-anon_vma-carefully-in-validate_mm.patch

