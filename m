Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794293140;
	b=3v5Naq53Yt0ni7faGVVRvJZGc+cCdmL4JX8ElwYSm8A5PtNA3+62f4PYfO4BsC+ymdgn
	 AzynNf94vKPzC6trNWaH9mYkE3LBSPDIFVPhj711yPDtYLbJBbXl9j4AwMK8fzYh03QHJ
	 cr1zYwVKNc5uQsBC0Z69z7gl1yPt+GngqaWww9pmSc3HiAskflDG/UUKN9trJFpNFtyeE
	 sNWdajp4W7k6CLnPwTlnAjE96ifIfGIxzuBgPTqZk82qRJ+xh2KpL3X2JHJZwguQVPxIA
	 pdnQxFh/aQmTy0KkaRPYz8CqQo/TzpUo0pPgYpswqFUFAwllNlYs5VD+OpHAUXXjKdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794293140;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=X0gvjBTrkdv88HScD0hpGWp7lUBapUqep7QtHNNihtI=;
	b=36Ueoyrt7Epk2WLervy3XLy6c74xGfQShUs2AwN4GLq5PPjQ07OToFqe24BKXHhnPfgg
	 MAmIMqdZAOoUBOkAYoVu4Jw8GIWB+ljcjKd81W30yyFz5IbQAhDo40h8AWg/7FcZgki3b
	 /8K988qV6ZUEgP5Ui020Y3JTkvi1gAgqSuT8QOzimvNQGVQE8lKNWQVrff5GYYbSdceKG
	 +e7auqtBfLNDX5t1oWmes/OMwDTWhzYoGC+8GgtxMlXmyMPA5Qy/oGP7+UN6V6Fo6k7T6
	 FS56DrGrP1KSMi18eODgSWYKEiwVY3Wy+BoonW03+OETbcMeeJDeOgvMzYuI0ughGwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=H9CGLtZE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55ED606CB1D
	for <mm-commits@vger.kernel.org>; Tue, 10 Nov 2026 06:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=H9CGLtZE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710471F0089F;
	Tue, 10 Nov 2026 06:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794293139;
	bh=X0gvjBTrkdv88HScD0hpGWp7lUBapUqep7QtHNNihtI=;
	h=Date:To:From:Subject;
	b=H9CGLtZEsTN7546gPkRgb0wDUgaAfNhJ5MO8LuNJlTqHDmcS3bVCszE8mzmD2KIXO
	 yP6iRfdGSpxPPu2SCqvLYvjDGnXTaiMS48gmMa1oPg9rzLgJFgF8K0TVl/+nVUdFHU
	 pdQnvpSad6B1vcZaL0yzzklWISYPiL6+CCAv+Tjk=
Date: Mon, 09 Nov 2026 22:45:39 -0800
To: mm-commits@vger.kernel.org,yangsongsen@insta360.com,vbabka@kernel.org,
	syzbot+10e72ea5747737bcd2ad@syzkaller.appspotmail.com,pfalcato@suse.de,
	liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,jannh@google.com,
	david@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vma-read-anon_vma-carefully-in-validate_mm.patch removed from -mm tree
Message-Id: <20261110064539.710471F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/vma: read anon_vma carefully in validate_mm()
has been removed from the -mm tree.  Its filename was
     mm-vma-read-anon_vma-carefully-in-validate_mm.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/vma: read anon_vma carefully in validate_mm()
Date: Mon, 02 Nov 2026 10:25:20 +0000

Commit 38564710f443 ("mm: implement and use vma_has_anon_rmap(), silence
KCSAN") rather clumsily converted the read of vma->anon_vma into a
vma_has_anon_rmap() without accounting for the separation between
assignment of anon_vma and later use of it.

vma_has_anon_rmap() is intended as an optimistic check, so doesn't need to
protect against a torn read in vma->anon_vma. The caller is expected to
take care of this themselves if they then in fact access the field.

validate_mm() does indeed then reference the field, so resolve the issue
via READ_ONCE(), and simplify the code by separating this into a new
function validate_mm_anon_rmap().

Finally, add a vma_assert_stabilised() to make it clear the required state
of the VMA.

[kas@kernel.org: reduce ifdeffery]
  Link: https://lore.kernel.org/auhn01dpDzK47igy@thinkstation
Link: https://lore.kernel.org/20261102-fix-validate_mm-v1-1-5c309614ef15@kernel.org
Fixes: 38564710f443 ("mm: implement and use vma_has_anon_rmap(), silence KCSAN")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <syzbot+10e72ea5747737bcd2ad@syzkaller.appspotmail.com>
Closes: https://lore.kernel.org/all/6ae78418.6552420f.2a0efc.005c.GAE@google.com/
Reported-by: Songsen Yang <yangsongsen@insta360.com>
Closes: https://lore.kernel.org/all/20261102074414.10902-1-yangsongsen@insta360.com/
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
---

 include/linux/mm.h |    2 --
 mm/vma.c           |   34 ++++++++++++++++++++++------------
 2 files changed, 22 insertions(+), 14 deletions(-)

--- a/include/linux/mm.h~mm-vma-read-anon_vma-carefully-in-validate_mm
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
--- a/mm/vma.c~mm-vma-read-anon_vma-carefully-in-validate_mm
+++ a/mm/vma.c
@@ -676,6 +676,26 @@ static int dup_anon_vma(struct vm_area_s
 }
 
 #ifdef CONFIG_DEBUG_VM_MAPLE_TREE
+static void validate_mm_anon_rmap(struct vm_area_struct *vma)
+{
+	struct anon_vma *anon_vma;
+	struct anon_vma_chain *avc;
+
+	if (!IS_ENABLED(CONFIG_DEBUG_VM_RB))
+		return;
+
+	vma_assert_stabilised(vma);
+
+	anon_vma = READ_ONCE(vma->anon_vma);
+	if (!anon_vma)
+		return;
+
+	anon_vma_lock_read(anon_vma);
+	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
+		anon_rmap_tree_verify(avc);
+	anon_vma_unlock_read(anon_vma);
+}
+
 void validate_mm(struct mm_struct *mm)
 {
 	int bug = 0;
@@ -685,10 +705,6 @@ void validate_mm(struct mm_struct *mm)
 
 	mt_validate(&mm->mm_mt);
 	for_each_vma(vmi, vma) {
-#ifdef CONFIG_DEBUG_VM_RB
-		struct anon_vma *anon_vma = vma->anon_vma;
-		struct anon_vma_chain *avc;
-#endif
 		unsigned long vmi_start, vmi_end;
 		bool warn = 0;
 
@@ -709,14 +725,8 @@ void validate_mm(struct mm_struct *mm)
 			vma_iter_dump_tree(&vmi);
 		}
 
-#ifdef CONFIG_DEBUG_VM_RB
-		if (vma_has_anon_rmap(vma)) {
-			anon_vma_lock_read(anon_vma);
-			list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
-				anon_rmap_tree_verify(avc);
-			anon_vma_unlock_read(anon_vma);
-		}
-#endif
+		validate_mm_anon_rmap(vma);
+
 		/* Check for a infinite loop */
 		if (++i > mm->map_count + 10) {
 			i = -1;
_

Patches currently in -mm which might be from ljs@kernel.org are


