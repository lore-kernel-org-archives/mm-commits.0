Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672132;
	b=36GSo+CD6g1fx2Iddbw49gJ7CdJOOXYmfP9ipMUUUxQX6jrcI+frNc65SKnesz8DJzUV
	 pPU3/e6+q2iUqyHoTI0zAeYFb9NJHNSoebKJWNE4ZW9dDwkNKBXzBeQDDHay4NLM+W3Kh
	 TKiiuJ/V15vj/m+5xSyM7gz81OArf9YXsVvRAhXgwstsVwh+lO3ZUmbzeO6Aw4VfRDgOf
	 Omhg4g6zTZEbGearOe2nGLucQ32Fq4B8mr7+nP0feLXmsCWLjkjvLprqZJOMhJ+ZTG4JX
	 NJqTUjmyTNtl9Sl1YfZvkZB8SboPipjM1z7f8WZx6J5tg/tY6ENLVgaHGtla8FJuCBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672132;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=217H0WaVDJ/7BVgTwW404m10ZG358RViLdtD9bz8eL4=;
	b=HdJTBriIAKOWLABDhSG3hkjnhE6G/KkqPqpgnjckFqovqDiqRvDWy9vIUiRr6pZ0FaVK
	 s/CK9fKaXIfFXCWVGa4Tan58GYa9kJ2OAaXwVABNS5Z3mgVRp0aGE43LdtplrKVTzH9N+
	 VvmRQwCpC1wViOI1uKSeWZhOia7BCv855mXSXIeldevhat9DUmSCFGPn1AzcWERS8bT8p
	 hOqCBs8eC+H9CVdCCQsHgLVOPH2oCNNfaQkk6n4DFlmQcDB+k3YzBAdFOTnJG1Qb1WBmR
	 h54pLqZA4hBk1yqCVOTl7p7Ym+V39I62TKdMPVEwGJfnEUp7WpcfJ/JUbjZznqz6QsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QJVHiQgx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F74606A337;
	Tue,  3 Nov 2026 02:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QJVHiQgx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7CB1F000C1;
	Tue,  3 Nov 2026 02:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672132;
	bh=217H0WaVDJ/7BVgTwW404m10ZG358RViLdtD9bz8eL4=;
	h=Date:To:From:Subject;
	b=QJVHiQgx4k+PpnxNBEf2L1T9av7/mC8AYvnliNvThDGCRFx5P5SFyjVcZ4LbsVTAg
	 zy7/eH3CY7BB4sr7zIItp21Ana9WXHUG7PA1wzMUBRenPMrKqwwuIjj+lIpYt/3CM4
	 eseW/5cj27aMcqF8hDZzdm64KIdewcELHDkHnj34=
Date: Mon, 02 Nov 2026 18:15:31 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	stable@vger.kernel.org,sj@kernel.org,rppt@kernel.org,pfalcato@suse.de,
	mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kees@kernel.org,
	jannh@google.com,gourry@gourry.net,dave@stgolabs.net,ccross@google.com,
	david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vma-write-lock-source-vma-before-duplicating-it-in-__split_vma.patch removed from -mm tree
Message-Id: <20261103021532.5F7CB1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/vma: write lock source VMA before duplicating it in __split_vma()
has been removed from the -mm tree.  Its filename was
     mm-vma-write-lock-source-vma-before-duplicating-it-in-__split_vma.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/vma: write lock source VMA before duplicating it in __split_vma()
Date: Fri, 23 Oct 2026 14:47:28 +0100

__split_vma() duplicates the source VMA before taking its VMA write lock,
and until the VMA is write-locked, a concurrent thread might set
VMA_MAYBE_GUARD_BIT, resulting in the duplication missing the flag.

If this happens, then fork may fail to duplicate guard markers and, if a
file-backed mapping, THP collapse may also discard the markers.

Resolve this by taking the VMA write lock before vm_area_dup() and, since
all callers of vm_area_dup() now hold the VMA write lock, assert that this
is the case there, and add a comment to explain why it's needed.

[ljs@kernel.org: add VMA write assert in vm_area_dup(), commit message touchup]
Link: https://lore.kernel.org/20261023-fix-vma-atomic-v1-2-8ff4fae1fc85@kernel.org
Fixes: 2ab7f1bbafc9 ("mm/madvise: allow guard page install/remove under VMA lock")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Pedro Falcato <pfalcato@suse.de> 
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jann Horn <jannh@google.com>
Cc: SJ Park <sj@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Colin Cross <ccross@google.com>
Cc: <stable@vger.kernel.org>
---

 mm/vma.c      |    2 +-
 mm/vma_init.c |    3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/mm/vma.c~mm-vma-write-lock-source-vma-before-duplicating-it-in-__split_vma
+++ a/mm/vma.c
@@ -538,6 +538,7 @@ __split_vma(struct vma_iterator *vmi, st
 			return err;
 	}
 
+	vma_start_write(vma);
 	new = vm_area_dup(vma);
 	if (!new)
 		return -ENOMEM;
@@ -568,7 +569,6 @@ __split_vma(struct vma_iterator *vmi, st
 	if (new->vm_ops && new->vm_ops->open)
 		new->vm_ops->open(new);
 
-	vma_start_write(vma);
 	vma_start_write(new);
 
 	init_vma_prep(&vp, vma);
--- a/mm/vma_init.c~mm-vma-write-lock-source-vma-before-duplicating-it-in-__split_vma
+++ a/mm/vma_init.c
@@ -127,6 +127,9 @@ struct vm_area_struct *vm_area_dup(struc
 {
 	struct vm_area_struct *new = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 
+	/* Must hold a write lock to stabilise atomic VMA flags. */
+	vma_assert_write_locked(orig);
+
 	if (!new)
 		return NULL;
 
_

Patches currently in -mm which might be from david@kernel.org are

mm-memory-failure-fix-folio-refcount-leak-and-min_order_for_split-locking.patch

