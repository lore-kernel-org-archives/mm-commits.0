Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795562975;
	b=JBxaNhL3RJNQypwjayvbTwyte39UDR2/ldnVY+2BLL/+fzn+gIqBRpFL0ZlgCehwE/K4
	 sLZlDiPWTvlyGEfweIaMiOrUYZFakLn/YCPhvPjTX1vW54hca38IDCoKdduC8M54pU+zq
	 K+WCyMTeBEo/gVAkqDWm83cHK7nvuHNadR7a/O/fCNF0NRXk3w7NXnP2ugxBJJb+MZqCK
	 oEgWp0XqhDbjKUJdnCSeINzee8txpsC7LOs7cz8PJ/UmXqikXBLyLmJ7P7Wh1ggacRCnB
	 417DkuBPG3LwN4Ip7eCpy3xd8rep9sIsgt6nWn46HofKE9kKQgoA96gT0YQlwy8E4ZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795562975;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=t4p3u8d+ae8UVe9PRoAfBUoHdT8H/ibmkp4iTz/PGGA=;
	b=Lmklo7d1OZ/7ubgOmV6CAC5kxcARbT/BrTvCgYuzfW1f0VpHQ7+vxqVxz6GQl6PoxP8u
	 I5wehlUW5DHrixefCTRDTQ9LNjltb8RsRxxMNiu6ZSaae/bEdtodtClc3JUSUHMcpbgqd
	 BQTPN8wCYWjqqDY7/y+uZaD14Kfgaq0baX9G0qTenO7AOX9wYzWzgXQRX/iFTyC1RM/BU
	 ybG0+6nACWNLVIHe7B5t/VdsstaWWB73sCEx4zcKzQu6ruKz7oCBMWfqgrQ06iXQiWhXb
	 ZPaljEqM9Tv2IFhutHnZSi3PsMqL7i60h6pZ7BbFUvX5j+1MKyCB7Uf7UrUfzEN/9gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mCeULJEm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910D4606A326;
	Tue, 24 Nov 2026 23:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mCeULJEm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4B591F000C4;
	Tue, 24 Nov 2026 23:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795562975;
	bh=t4p3u8d+ae8UVe9PRoAfBUoHdT8H/ibmkp4iTz/PGGA=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=mCeULJEmlg6NGkS/L/P0nyr0wr1+i38ZVbS9bypfSVGdKH7CEf5dNn/WpSJ0scI6t
	 gDVj/kdYJTz+x48lChmIfSEm+kkxzN0qa982SAAeMNOlxAOYEZsHWfkV7gdMremYsL
	 21sLUaihViEDJL8C5vtNor3qJSanGCIBbwC5nzGY=
Date: Tue, 24 Nov 2026 15:29:34 -0800
To: mm-commits@vger.kernel.org,xu.xin@linux.dev,willy@infradead.org,
	vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,
	shakeel.butt@linux.dev,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,
	ljs@kernel.org,liam@infradead.org,kees@kernel.org,josef@toxicpanda.com,
	joey.gouly@arm.com,jannh@google.com,hughd@google.com,gourry@gourry.net,
	david@kernel.org,chengming.zhou@linux.dev,catalin.marinas@arm.com,
	bunk@stusta.de,azpijr@gmail.com,a.p.zijlstra@chello.nl,aaw@google.com,
	mason@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261121-some-more-ai-fixes-v1-5-236e925d9b64@kernel.org>
References: <20261121-some-more-ai-fixes-v1-5-236e925d9b64@kernel.org>
Subject: + mm-mremap-apply-the-mmap-offset-limits-on-expansion.patch added to mm-new branch
Message-Id: <20261124232934.D4B591F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mremap: apply the mmap() offset limits on expansion
has been added to the -mm mm-new branch.  Its filename is
     mm-mremap-apply-the-mmap-offset-limits-on-expansion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-apply-the-mmap-offset-limits-on-expansion.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Chris Mason <mason@kernel.org>
Subject: mm/mremap: apply the mmap() offset limits on expansion
Date: Sat, 21 Nov 2026 16:02:31 +0000

Commit be83bbf80682 ("mmap: introduce sane default mmap limits") made
do_mmap() reject file mappings which extend beyond the maximum offset the
file can support, via file_mmap_ok().

However mremap() can expand a file mapping and only checks that the page
offset does not wrap, so a mapping can be grown past the limit that mmap()
would have enforced.

Fault handlers rely on that limit. For instance dax_iomap_pte_fault()
converts vmf->pgoff into a loff_t, which overflows for such an offset and
defeats its i_size check.

Fix the issue by applying file_mmap_ok() to the expanded range in
check_prep_vma(), failing the mremap() with -EINVAL if it exceeds the
limit.

This means that mremap() now refuses expansions it previously permitted,
however no file can have data at these offsets, and mmap() already refuses
the equivalent mapping.

[ljs@kernel.org: fixed up commit msg]
Link: https://patch.msgid.link/20261121-some-more-ai-fixes-v1-5-236e925d9b64@kernel.org
Fixes: be83bbf80682 ("mmap: introduce sane default mmap limits")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
  Link: https://lore.kernel.org/179536260304.412063.8485838901368834162.b4-reply@b4
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ollie Wild <aaw@google.com>
Cc: Adrian Bunk <bunk@stusta.de>
Cc: Xu Xin <xu.xin@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: <stable@vger.kernel.org>

 mm/internal.h |    2 ++
 mm/mmap.c     |    4 ++--
 mm/mremap.c   |    6 ++++++
 3 files changed, 10 insertions(+), 2 deletions(-)

--- a/mm/internal.h~mm-mremap-apply-the-mmap-offset-limits-on-expansion
+++ a/mm/internal.h
@@ -950,6 +950,8 @@ extern long faultin_page_range(struct mm
 		unsigned long end, bool write, int *locked);
 bool mlock_future_ok(const struct mm_struct *mm, bool is_vma_locked,
 		unsigned long bytes);
+bool file_mmap_ok(struct file *file, struct inode *inode, unsigned long pgoff,
+		  unsigned long len);
 
 /*
  * NOTE: This function can't tell whether the folio is "fully mapped" in the
--- a/mm/mmap.c~mm-mremap-apply-the-mmap-offset-limits-on-expansion
+++ a/mm/mmap.c
@@ -265,8 +265,8 @@ static inline u64 file_mmap_size_max(str
 	return ULONG_MAX;
 }
 
-static inline bool file_mmap_ok(struct file *file, struct inode *inode,
-				unsigned long pgoff, unsigned long len)
+bool file_mmap_ok(struct file *file, struct inode *inode, unsigned long pgoff,
+		  unsigned long len)
 {
 	u64 maxsize = file_mmap_size_max(file, inode);
 
--- a/mm/mremap.c~mm-mremap-apply-the-mmap-offset-limits-on-expansion
+++ a/mm/mremap.c
@@ -1748,6 +1748,7 @@ static int check_prep_vma(struct vma_rem
 	struct mm_struct *mm = current->mm;
 	unsigned long addr = vrm->addr;
 	unsigned long old_len, new_len, pgoff;
+	struct file *file;
 
 	if (!vma)
 		return -EFAULT;
@@ -1827,6 +1828,11 @@ static int check_prep_vma(struct vma_rem
 	if (vma_is_fixed_mapping(vma))
 		return -EFAULT;
 
+	/* The expanded range must obey the same offset limits as mmap(). */
+	file = vma->vm_file;
+	if (file && !file_mmap_ok(file, file_inode(file), pgoff, new_len))
+		return -EINVAL;
+
 	if (!mlock_future_ok(mm, vma_test(vma, VMA_LOCKED_BIT), vrm->delta))
 		return -EAGAIN;
 
_

Patches currently in -mm which might be from mason@kernel.org are

mm-swap-fix-large-swap-in-across-swap-file-extents.patch
hugetlbfs-do-not-grow-a-sealed-file-in-mmap.patch
mm-hugetlb-keep-surplus-folios-that-are-reserved.patch
mm-hugetlb-fix-reservation-leak-on-min_size=-mounts.patch
mm-cachestat-count-each-page-only-once.patch
mm-cachestat-restart-the-walk-after-each-entry.patch
percpu-queue-the-balance-work-on-an-unbound-workqueue.patch
mm-vma-fix-uncharge-after-failed-stack-relocation.patch
mm-mremap-apply-the-mmap-offset-limits-on-expansion.patch
mm-mremap-respect-guard-gaps-on-in-place-expansion.patch
mm-vma-make-brk-mappings-non-executable-under-mdwe.patch

