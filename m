Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C72332E692
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622281; cv=none; b=FWZFz/glUbSAsiUlD+maenVRApfXFLpdsE+9A+V0NQaw3D4jDoEktYaYcEFEPoybvhxLcjaJmC5qJfBKrMhLXi4nEWxZfR1mnVucpv6z4ZPPmbzheSDMjjv/byxiWclrVXliB2Moa7Wm6nfHSkb7f14A3K8+quF0xedO7RCV9FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622281; c=relaxed/simple;
	bh=SIE5N4lFO3/DJeTWiBMnNuW/S0t7q3NQrpVFXF7qeEE=;
	h=Date:To:From:Subject:Message-Id; b=sXULxMGJ/seCNCxVxPOY2hPNDYa0+xjSaq19bEqzxRI1eYOEPywOcAOUACkgE+XcRUsGapUKcXQWOFP1rsBjbMoynGADAh2XWm7+FwYRB5PpMUt1TfrraZ+5ZfRZ8Swnrm0tEDNjkpxDgoY6FS77INpMP0LpTqhLDnkGnijaEa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=fail (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NVzRMYr0 reason="signature verification failed"; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NVzRMYr0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15931F000E9;
	Tue, 25 Aug 2026 01:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622279;
	bh=f/Kg3bf3MTxAr4Wt4Fw/NBLH9/kumWyaIaK4WhO3+WE=;
	h=Date:To:From:Subject;
	b=NVzRMYr0xsYc6zzdAfOsWxV9kmiPQjj10OmPdl/f/cZ57GSb0NWWSyuKSbhMOoJGb
	 h9l+1xAiDEHmDi87bCsmm7udHcr7dkS6sCf9K+M8Q/04ngwav8RoAnB7RyUmMHg42M
	 yfTA/VrqHWqWWC1VUpYYq5lLUyZ4PfyMBIpvBOEs=
Date: Mon, 24 Aug 2026 18:44:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,xu.xin16@zte.com.cn,willy@infradead.org,vbabka@kernel.org,tzimmermann@suse.de,thomas.hellstrom@linux.intel.com,svens@linux.ibm.com,surenb@google.com,steven.price@arm.com,shikemeng@huaweicloud.com,ryan.roberts@arm.com,rppt@kernel.org,rodrigo.vivi@intel.com,riel@surriel.com,Ray.Huang@amd.com,rakie.kim@sk.com,pfalcato@suse.de,peterz@infradead.org,peterx@redhat.com,osalvador@suse.de,oleg@redhat.com,nphamcs@gmail.com,npache@redhat.com,nao.horiguchi@gmail.com,namhyung@kernel.org,muchun.song@linux.dev,mripard@kernel.org,mingo@redhat.com,mhocko@suse.com,mhiramat@kernel.org,matthew.brost@intel.com,matthew.auld@intel.com,mark.rutland@arm.com,maarten.lankhorst@linux.intel.com,liviu.dudau@arm.com,linmiaohe@huawei.com,liam@infradead.org,lance.yang@linux.dev,kees@kernel.org,kasong@tencent.com,joshua.hahnjy@gmail.com,jolsa@kernel.org,jhubbard@nvidia.com,jgg@ziepe.ca,jannh@google.com,james.clark@linaro.org,jack@suse.cz,iroger
 s@google.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,harry@kernel.org,gregkh@linuxfoundation.org,gourry@gourry.net,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,dev.jain@arm.com,david@kernel.org,christian.koenig@amd.com,chrisl@kernel.org,chengming.zhou@linux.dev,byungchul@sk.com,borntraeger@linux.ibm.com,boris.brezillon@collabora.com,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,arnd@arndb.de,apopple@nvidia.com,alexander.shishkin@linux.intel.com,alexander.deucher@amd.com,airlied@gmail.com,agordeev@linux.ibm.com,adrian.hunter@intel.com,acme@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-fix-self-merge-check-in-copy_vma.patch removed from -mm tree
Message-Id: <20260825014439.D15931F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: fix self-merge check in copy_vma()
has been removed from the -mm tree.  Its filename was
     mm-vma-fix-self-merge-check-in-copy_vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/vma: fix self-merge check in copy_vma()
Date: Thu, 13 Aug 2026 18:32:24 +0100

The existing logic is very confusing so improve things.  Firstly rename
the confusing faulted_in_anon_vma variable to can_self_merge and update
this when the page offset is updated.

What is being checked for is a 'self-merge' - that is between the VMA
being remapped and its prior VMA (remember that this is copy_vma() - if a
non-MREMAP_DONTUNMAP remap the original VMA is only removed afterwards).

This can happen if the VMA is moved immediately adjacent to itself, either
before or after it:

		|----------------|----------------|
		|		 |                |
		v		 |		  v
	|...............||---------------||...............|
	|      new      ||      old      ||      new      |
	|...............||---------------||---------------|

In these cases the old VMA is simply expanded to cover the new range.

It is also possible for the move to both self-merge and merge with a prior
VMA if it is placed between a preceding VMA and its old self:

				|---------------|
				|		|
				v		|
	|---------------||...............||---------------|
	|      prev     ||     new       ||     old       |
	|---------------||...............||---------------|

In this case, the old VMA is removed and 'prev' is expanded and replaces
it.

Since copy_vma_and_data() which calls copy_vma() intends to reference the
old VMA after the merge, it must have this pointer updated.

This kind of self-merge is not possible with a succeeding merge, as the
merge always prefers to expand the preceding VMA if possible.

copy_vma() accounts for this by explicitly checking to see if a self-merge
occurred and updating the vmap pointer if so.  However it incorrect did so
even for a subsequent merge (this is simply a noop so it had no impact).

So change this to only check for the case which matters - a backwards
merge - and rearrange the parameters to make it clearer we're doing that -
i.e.  check new_vma->vm_start < old_vma_start (having already renamed
vma_start to old_vma_start to make it clear this is the previous VMA).

Also update the existing wall-of-text comment to be a lot clearer.

While we're here, replace the VM_BUG_ON_VMA() with a VM_WARN_ON_ONCE_VMA()
and update the VMA userland tests accordingly.

No functional change intended.

Link: https://lore.kernel.org/20260813-b4-scalable-cow-virt-pgoff-v5-7-c21581c0c3c8@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Deucher <alexander.deucher@amd.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christan König <christian.koenig@amd.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gregory Price (Meta) <gourry@gourry.net>
Cc: Harry Yoo <harry@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huang Ray <Ray.Huang@amd.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Liviu Dudau <liviu.dudau@arm.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Namhyung kim <namhyung@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c                         |   35 +++++++++++++----------------
 tools/testing/vma/vma_internal.h |    1 
 2 files changed, 17 insertions(+), 19 deletions(-)

--- a/mm/vma.c~mm-vma-fix-self-merge-check-in-copy_vma
+++ a/mm/vma.c
@@ -1911,10 +1911,10 @@ struct vm_area_struct *copy_vma(struct v
 	bool *need_rmap_locks)
 {
 	struct vm_area_struct *vma = *vmap;
-	unsigned long vma_start = vma->vm_start;
+	unsigned long old_vma_start = vma->vm_start;
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *new_vma;
-	bool faulted_in_anon_vma = true;
+	bool can_self_merge = false;
 	VMA_ITERATOR(vmi, mm, addr);
 	VMG_VMA_STATE(vmg, &vmi, NULL, vma, addr, addr + len);
 
@@ -1924,7 +1924,7 @@ struct vm_area_struct *copy_vma(struct v
 	 */
 	if (unlikely(vma_is_anonymous(vma) && !vma->anon_vma)) {
 		pgoff = addr >> PAGE_SHIFT;
-		faulted_in_anon_vma = false;
+		can_self_merge = true;
 	}
 
 	/*
@@ -1944,24 +1944,21 @@ struct vm_area_struct *copy_vma(struct v
 	new_vma = vma_merge_copied_range(&vmg);
 
 	if (new_vma) {
-		/*
-		 * Source vma may have been merged into new_vma
-		 */
-		if (unlikely(vma_start >= new_vma->vm_start &&
-			     vma_start < new_vma->vm_end)) {
+		/* Self-merged and VMA replaced. */
+		if (unlikely(new_vma->vm_start < old_vma_start &&
+			     new_vma->vm_end > old_vma_start)) {
 			/*
-			 * The only way we can get a vma_merge with
-			 * self during an mremap is if the vma hasn't
-			 * been faulted in yet and we were allowed to
-			 * reset the dst vma->vm_pgoff to the
-			 * destination address of the mremap to allow
-			 * the merge to happen. mremap must change the
-			 * vm_pgoff linearity between src and dst vmas
-			 * (in turn preventing a vma_merge) to be
-			 * safe. It is only safe to keep the vm_pgoff
-			 * linear if there are no pages mapped yet.
+			 * The only way a VMA can both self-merge and be
+			 * replaced is if the remap places the new VMA
+			 * immediately prior to its old self ('next') and
+			 * immediately after another VMA ('prev') causing the
+			 * next to be removed and prev to be expanded to cover
+			 * the entire range.
+			 *
+			 * This should only be possible if the page offset was
+			 * updated, i.e. the VMA is unfaulted.
 			 */
-			VM_BUG_ON_VMA(faulted_in_anon_vma, new_vma);
+			VM_WARN_ON_ONCE_VMA(!can_self_merge, new_vma);
 			*vmap = vma = new_vma;
 		}
 		*need_rmap_locks =
--- a/tools/testing/vma/vma_internal.h~mm-vma-fix-self-merge-check-in-copy_vma
+++ a/tools/testing/vma/vma_internal.h
@@ -53,6 +53,7 @@ typedef __bitwise unsigned int vm_fault_
 
 #define VM_WARN_ON(_expr) (WARN_ON(_expr))
 #define VM_WARN_ON_ONCE(_expr) (WARN_ON_ONCE(_expr))
+#define VM_WARN_ON_ONCE_VMA(_expr, _vma) (WARN_ON_ONCE(_expr))
 #define VM_WARN_ON_VMG(_expr, _vmg) (WARN_ON(_expr))
 #define VM_BUG_ON(_expr) (BUG_ON(_expr))
 #define VM_BUG_ON_VMA(_expr, _vma) (BUG_ON(_expr))
_

Patches currently in -mm which might be from ljs@kernel.org are


