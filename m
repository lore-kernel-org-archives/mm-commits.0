Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793654689;
	b=fi+1RPXCqxUF+75FH5v84RuwNUotgzcOPyiyQdA+62wAVXFCNmCjw1KJfLi8lMAqz7Ev
	 c8ItXn1Hw8RDBXV2k9zKjBhOZJhUi//58EPKMdh4JF1a43PTD6JKVY8e83Sgssj3D2p9o
	 u0nj3FvoiqIrhXhxmPLr2sShRj111QPNYkSdxNh8f+0uc4keYegvwKUg6xt35shY0Q/UW
	 qHy84mW5+S6Lr9yMo2oPGiZis+Giyg1/cY0OlW9JFCMHtKmHRgTg5WkmawpMkKI2Nf+1q
	 GiI4ViMa4KA3UdUDSQPhj/Z53sHmGv/VzB50/SYM5qTlBWwRA2ocJJdI/8CRs3aHqdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793654689;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=YY1Ls/mR90+K1A9VhlsjBm+3fZXSYQ/fZRtqMUmIZJQ=;
	b=gmn0MGCmlQbssAkv+VcWb4NCM/0CJfylgkHNOvzHzxRnhHsZtzfrU4fi3d8rey6oiN6H
	 gFj+VyYw88mr3hllXfI99tjKg1m6gKmsjesSt+QL+HHIHV/AYvGoUn5x8YuxWma338IBh
	 66XMgcgUK1N01LKWC+gqfe4fWSOMnNziqpHU4IkvXAgp/HKpIaU6SCnafqtVeQTiERg9y
	 9ESTv2lPkOLs3fnpSn8V4S65aJN4d/VL9jjhpZkpeTU1KJijPdzZgo9hGjh222wIT031I
	 FSj3EyDByNONLx8tWUw4obh61b1WRvpWY7Vz/u+yyw+mXtQHWy+FuFNrOQJORGVB/Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ghRCbpUw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9617D606A331
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 21:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ghRCbpUw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167C91F00A18;
	Mon,  2 Nov 2026 21:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793654689;
	bh=YY1Ls/mR90+K1A9VhlsjBm+3fZXSYQ/fZRtqMUmIZJQ=;
	h=Date:To:From:Subject;
	b=ghRCbpUw2T6ouJ4RgJ05GVsEKqrFNULFa68TOGSmSeesc55jpkqyM5xmkQTta2Q3B
	 LSjIxSS7eP09QbjRln5MtPZB6yWG30iuZYmGQHC8NA0gkIAIWghfwdWWXqr7ZTEexm
	 AZ+jIQsSfzBUTmf61A1DIlgiNuP9QsZrbwZoFPNY=
Date: Mon, 02 Nov 2026 13:24:48 -0800
To: mm-commits@vger.kernel.org,yangsongsen@insta360.com,vbabka@kernel.org,
	syzbot+10e72ea5747737bcd2ad@syzkaller.appspotmail.com,pfalcato@suse.de,
	ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,
	david@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-read-anon_vma-carefully-in-validate_mm-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20261102212449.167C91F00A18@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm-vma-read-anon_vma-carefully-in-validate_mm-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vma-read-anon_vma-carefully-in-validate_mm-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-read-anon_vma-carefully-in-validate_mm-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
@@ -669,14 +669,17 @@ static int dup_anon_vma(struct vm_area_s
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
 
@@ -685,11 +688,6 @@ static void validate_mm_anon_rmap(struct
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

mm-hugetlb_vmemmap-map-the-shared-tail-page-writable.patch
mm-vma-read-anon_vma-carefully-in-validate_mm-fix.patch

