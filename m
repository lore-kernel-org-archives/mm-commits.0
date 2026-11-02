Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793654687;
	b=IxUjHlJUzRjcAjmrART51ckecsXckIjD97epXZwELg5EzqD12DOMkt/2Me7Sdj6dlE92
	 i3aPlbn8AI5R4l0ezNcK/3xRFeyVAS9fw1mMvtgoPkix3mMRvEKeBaLw0ZmXRPd13mSCv
	 1hOHWyJvm5UVtf3MvzM0Ogtj7UenPPwBSL8Kr3fpnIGa5QWNtUjcPT6r/543P95uRPBVv
	 UkGCKFcdhFXYuH5SSCaq7yi3HcQQruzTc7efr+Ck/2a9C+H9/p2NfpLlKUfp24Z8ZPUof
	 mYaAZzFBQTiesa0lpdkofYCTVUz8218VAtRaZRwl79OowuBodixhS7mSxjy6n6e0oBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793654687;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=IuBwMgnRYny/hZl2zEgU/509z2Oyglvq+/AUq8vBnhI=;
	b=GWIhGZs3WShooavphniNtJkayxHDPwRr3n5sPmMj23hFyiqxmZRE0BEQD8MG9x79MSFc
	 9CYZFZkxaSuERPUJ8beDxih0MQElB48Lnjmf+68gMtgscWkaoijja4vaArooxeSqH5DfI
	 wdoO3dds93jlSzG9P33k4Y3/bJCPpqax6uEMjAwZTE3wlv1kg9iYzoHaEqz3wNd3lIJff
	 5clqMD50rcG49e5jfzffNg576ZIpHE38D67V2KwizyfXHWswzOUNKt8F03P6xnUIHPE+E
	 4R66jsevSbiZ02H0vf2wHr8bR6KsLbR21YD0QdH3ey4LtZ5X88dFy0M7DMvswvDeuCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Lo+AiVID;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9940C606A32C
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 21:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Lo+AiVID
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E231F00A1A;
	Mon,  2 Nov 2026 21:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793654687;
	bh=IuBwMgnRYny/hZl2zEgU/509z2Oyglvq+/AUq8vBnhI=;
	h=Date:To:From:Subject;
	b=Lo+AiVIDS0E/TZ2drs+OfI99ntvPup+2QoYMQDWPmHp7/o7Day7hZxn3Q5xepqU44
	 By+LgUstv4QXdTNG+LAD8qAWF2GCZkw/TJj5+jLGQtajKIUIASS91WK4K4XGJOhHoy
	 9rcAkaAeOuKVZ9+6ZxCMemX1EK/+X6XmEY32Wgyw=
Date: Mon, 02 Nov 2026 13:24:46 -0800
To: mm-commits@vger.kernel.org,yangsongsen@insta360.com,vbabka@kernel.org,
	syzbot+10e72ea5747737bcd2ad@syzkaller.appspotmail.com,pfalcato@suse.de,
	liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,jannh@google.com,
	david@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-read-anon_vma-carefully-in-validate_mm.patch added to mm-hotfixes-unstable branch
Message-Id: <20261102212447.21E231F00A1A@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/vma: read anon_vma carefully in validate_mm()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vma-read-anon_vma-carefully-in-validate_mm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-read-anon_vma-carefully-in-validate_mm.patch

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

 mm/vma.c |   36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

--- a/mm/vma.c~mm-vma-read-anon_vma-carefully-in-validate_mm
+++ a/mm/vma.c
@@ -669,6 +669,28 @@ static int dup_anon_vma(struct vm_area_s
 }
 
 #ifdef CONFIG_DEBUG_VM_MAPLE_TREE
+#ifdef CONFIG_DEBUG_VM_RB
+static void validate_mm_anon_rmap(struct vm_area_struct *vma)
+{
+	struct anon_vma *anon_vma = READ_ONCE(vma->anon_vma);
+	struct anon_vma_chain *avc;
+
+	vma_assert_stabilised(vma);
+
+	if (!anon_vma)
+		return;
+
+	anon_vma_lock_read(anon_vma);
+	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
+		anon_rmap_tree_verify(avc);
+	anon_vma_unlock_read(anon_vma);
+}
+#else
+static void validate_mm_anon_rmap(struct vm_area_struct *vma)
+{
+}
+#endif
+
 void validate_mm(struct mm_struct *mm)
 {
 	int bug = 0;
@@ -678,10 +700,6 @@ void validate_mm(struct mm_struct *mm)
 
 	mt_validate(&mm->mm_mt);
 	for_each_vma(vmi, vma) {
-#ifdef CONFIG_DEBUG_VM_RB
-		struct anon_vma *anon_vma = vma->anon_vma;
-		struct anon_vma_chain *avc;
-#endif
 		unsigned long vmi_start, vmi_end;
 		bool warn = 0;
 
@@ -702,14 +720,8 @@ void validate_mm(struct mm_struct *mm)
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

mm-vma-fix-expansion-of-vma_mixedmap_bit-vmas.patch
mm-do-not-unintentionally-overwrite-atomic-vma-flags.patch
mm-vma-avoid-losing-atomic-vma-flags-when-setting-sticky-vma-flags.patch
mm-vma-update-vma-iterator-state-on-error-in-new-vma-merge.patch
fs-proc-task_mmu-fix-missed-vmas-when-reading-proc-pid-maps-and-friends.patch
mm-vma-read-anon_vma-carefully-in-validate_mm.patch

