Received: from mail.cock.li (mail.cock.li [37.120.193.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1861332909
	for <mm-commits@vger.kernel.org>; Fri, 17 Oct 2025 15:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.120.193.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714413; cv=none; b=NUMF8yv6B4i81QUOdo7OjbDZgN6zb3GSvU0hMs5oH+FPeumVjBBaphGxiT5QpVL1npBaJsSdI61t0FyC/k8osAzkqCTwf1Dsm+e1xq1e+MrEqMAWrJOwmNG2mfV8X+MCLeyYM7U+Npcz1AA1ENNqBoDIX6Org/cNR2B/7d2IXLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714413; c=relaxed/simple;
	bh=4NTx1UQkbR0tyMWsubnZ2BoBIOa2J3axVJXr7vLiCkk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=T4qlQtg5Z0w9CkVqPnM6Ah/o8RnIPtxicmo4B7cmcrSbnuo1Jlqh7vDhCSv/Dd7b3rmHFMZmeUDyShcybMNzyzeZZgocKY6abZUIBsCa6djlTgFdZkY3u7zT/iEJuiBhcbpr27er+46zkjjHcKZS0WJOcVEMKksTV52mT5r6PRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=airmail.cc; spf=pass smtp.mailfrom=airmail.cc; dkim=pass (2048-bit key) header.d=airmail.cc header.i=@airmail.cc header.b=kxA+9Ngf; arc=none smtp.client-ip=37.120.193.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=airmail.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=airmail.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=airmail.cc header.i=@airmail.cc header.b="kxA+9Ngf"
Message-ID: <f81843ae-6480-4351-978a-b936c2a441d4@airmail.cc>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=airmail.cc; s=mail;
	t=1760714403; bh=4NTx1UQkbR0tyMWsubnZ2BoBIOa2J3axVJXr7vLiCkk=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=kxA+9NgfU+E4vDIQSugHNvXGHec+zXrdIPFDpoVKJn5Xi9i/VF9fKpTBgTtO+iMrM
	 Axlf+iF6RrjOXeHE8hktif19Zz2RnhjFfoW8vZNnzHxbPj911xyD3/MyanfN/EGIcK
	 IKkA5R5U4ut9hetay3T3PiKeEHkLXeMXLF+N78ExYEFO6uqUaWr4W7cDp73iA9pxc/
	 R4gD3X+0prHOuWIeTyegK///kl+lnZfTUadXxDSMzbln4pOsyaAW5KRoX/IX5elqxY
	 nbSiwQiBkOTW9aK7WLvF0HTUqvRFUDQKCxidvAOFghCjRNcxxIEc8L73Xv0t63jYZo
	 vxskDti2V4i+Q==
Date: Fri, 17 Oct 2025 15:20:00 +0000
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: +
 ksm-use-range-walk-function-to-jump-over-holes-in-scan_get_next_rmap_item.patch
 added to mm-new branch
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 xu.xin16@zte.com.cn, david@redhat.com, chengming.zhou@linux.dev,
 pedrodemargomes@gmail.com
References: <20251016210756.F006DC4CEF1@smtp.kernel.org>
From: craftfever <craftfever@airmail.cc>
In-Reply-To: <20251016210756.F006DC4CEF1@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



Andrew Morton wrote:
> The patch titled
>       Subject: ksm: use range-walk function to jump over holes in scan_get_next_rmap_item
> has been added to the -mm mm-new branch.  Its filename is
>       ksm-use-range-walk-function-to-jump-over-holes-in-scan_get_next_rmap_item.patch
> 
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ksm-use-range-walk-function-to-jump-over-holes-in-scan_get_next_rmap_item.patch
> 
> This patch will later appear in the mm-new branch at
>      git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Note, mm-new is a provisional staging ground for work-in-progress
> patches, and acceptance into mm-new is a notification for others take
> notice and to finish up reviews.  Please do not hesitate to respond to
> review feedback and post updated versions to replace or incrementally
> fixup patches in mm-new.
> 
> Before you just go and hit "reply", please:
>     a) Consider who else should be cc'ed
>     b) Prefer to cc a suitable mailing list as well
>     c) Ideally: find the original patch on the mailing list and do a
>        reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
> Subject: ksm: use range-walk function to jump over holes in scan_get_next_rmap_item
> Date: Wed, 15 Oct 2025 22:22:36 -0300
> 
> Currently, scan_get_next_rmap_item() walks every page address in a VMA to
> locate mergeable pages.  This becomes highly inefficient when scanning
> large virtual memory areas that contain mostly unmapped regions.
> 
> This patch replaces the per-address lookup with a range walk using
> walk_page_range().  The range walker allows KSM to skip over entire
> unmapped holes in a VMA, avoiding unnecessary lookups.  This problem was
> previously discussed in [1].
> 
> [1] https://lore.kernel.org/linux-mm/423de7a3-1c62-4e72-8e79-19a6413e420c@redhat.com/
> 
> Link: https://lkml.kernel.org/r/20251016012236.4189-1-pedrodemargomes@gmail.com
> Link: https://lore.kernel.org/linux-mm/423de7a3-1c62-4e72-8e79-19a6413e420c@redhat.com/ [1]
> Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
> Reported-by: craftfever <craftfever@airmail.cc>
> Closes: https://lkml.kernel.org/r/020cf8de6e773bb78ba7614ef250129f11a63781@murena.io
> Suggested-by: David Hildenbrand <david@redhat.com>
> Cc: Chengming Zhou <chengming.zhou@linux.dev>
> Cc: xu xin <xu.xin16@zte.com.cn>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   mm/ksm.c |  185 ++++++++++++++++++++++++++++++++++++++---------------
>   1 file changed, 135 insertions(+), 50 deletions(-)
> 
> --- a/mm/ksm.c~ksm-use-range-walk-function-to-jump-over-holes-in-scan_get_next_rmap_item
> +++ a/mm/ksm.c
> @@ -2455,14 +2455,119 @@ static bool should_skip_rmap_item(struct
>   	return true;
>   }
>   
> +struct ksm_walk_private {
> +	struct page *page;
> +	struct folio *folio;
> +	struct vm_area_struct *vma;
> +	unsigned long address;
> +};
> +
> +static int ksm_walk_test(unsigned long addr, unsigned long next, struct mm_walk *walk)
> +{
> +	struct vm_area_struct *vma = walk->vma;
> +	struct ksm_walk_private *private;
> +
> +	if (!(vma->vm_flags & VM_MERGEABLE))
> +		return 1;
> +
> +	private = (struct ksm_walk_private *) walk->private;
> +	private->address = vma->vm_end;
> +
> +	if (!vma->anon_vma)
> +		return 1;
> +
> +	return 0;
> +}
> +
> +static int ksm_pmd_entry(pmd_t *pmd, unsigned long addr,
> +			    unsigned long end, struct mm_walk *walk)
> +{
> +	struct mm_struct *mm = walk->mm;
> +	struct vm_area_struct *vma = walk->vma;
> +	struct ksm_walk_private *private = (struct ksm_walk_private *) walk->private;
> +	struct folio *folio;
> +	pte_t *start_pte, *pte, ptent;
> +	pmd_t pmde;
> +	struct page *page;
> +	spinlock_t *ptl;
> +	int ret = 0;
> +
> +	if (ksm_test_exit(mm))
> +		return 1;
> +
> +	ptl = pmd_lock(mm, pmd);
> +	pmde = pmdp_get(pmd);
> +
> +	if (!pmd_present(pmde))
> +		goto pmd_out;
> +
> +	if (!pmd_trans_huge(pmde))
> +		goto pte_table;
> +
> +	page = vm_normal_page_pmd(vma, addr, pmde);
> +
> +	if (!page)
> +		goto pmd_out;
> +
> +	folio = page_folio(page);
> +	if (folio_is_zone_device(folio) || !folio_test_anon(folio))
> +		goto pmd_out;
> +
> +	ret = 1;
> +	folio_get(folio);
> +	private->page = page + ((addr & (PMD_SIZE - 1)) >> PAGE_SHIFT);
> +	private->folio = folio;
> +	private->vma = vma;
> +	private->address = addr;
> +pmd_out:
> +	spin_unlock(ptl);
> +	return ret;
> +
> +pte_table:
> +	spin_unlock(ptl);
> +
> +	start_pte = pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
> +	if (!start_pte)
> +		return 0;
> +
> +	for (; addr < end; pte++, addr += PAGE_SIZE) {
> +		ptent = ptep_get(pte);
> +		page = vm_normal_page(vma, addr, ptent);
> +
> +		if (!page)
> +			continue;
> +
> +		folio = page_folio(page);
> +		if (folio_is_zone_device(folio) || !folio_test_anon(folio))
> +			continue;
> +
> +		ret = 1;
> +		folio_get(folio);
> +		private->page = page;
> +		private->folio = folio;
> +		private->vma = vma;
> +		private->address = addr;
> +		break;
> +	}
> +	pte_unmap_unlock(start_pte, ptl);
> +
> +	cond_resched();
> +	return ret;
> +}
> +
> +struct mm_walk_ops walk_ops = {
> +	.pmd_entry = ksm_pmd_entry,
> +	.test_walk = ksm_walk_test,
> +	.walk_lock = PGWALK_RDLOCK,
> +};
> +
>   static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
>   {
>   	struct mm_struct *mm;
>   	struct ksm_mm_slot *mm_slot;
>   	struct mm_slot *slot;
> -	struct vm_area_struct *vma;
>   	struct ksm_rmap_item *rmap_item;
> -	struct vma_iterator vmi;
> +	struct ksm_walk_private walk_private;
>   	int nid;
>   
>   	if (list_empty(&ksm_mm_head.slot.mm_node))
> @@ -2527,64 +2632,44 @@ next_mm:
>   
>   	slot = &mm_slot->slot;
>   	mm = slot->mm;
> -	vma_iter_init(&vmi, mm, ksm_scan.address);
>   
>   	mmap_read_lock(mm);
>   	if (ksm_test_exit(mm))
>   		goto no_vmas;
>   
> -	for_each_vma(vmi, vma) {
> -		if (!(vma->vm_flags & VM_MERGEABLE))
> -			continue;
> -		if (ksm_scan.address < vma->vm_start)
> -			ksm_scan.address = vma->vm_start;
> -		if (!vma->anon_vma)
> -			ksm_scan.address = vma->vm_end;
> -
> -		while (ksm_scan.address < vma->vm_end) {
> -			struct page *tmp_page = NULL;
> -			struct folio_walk fw;
> -			struct folio *folio;
> +	while (true) {
> +		struct folio *folio;
>   
> -			if (ksm_test_exit(mm))
> -				break;
> +		walk_private.page = NULL;
> +		walk_private.folio = NULL;
> +		walk_private.address = ksm_scan.address;
> +
> +		walk_page_range(mm, ksm_scan.address, -1, &walk_ops, (void *) &walk_private);
> +		ksm_scan.address = walk_private.address;
> +		if (!walk_private.page)
> +			break;
> +
> +		folio = walk_private.folio;
> +		flush_anon_page(walk_private.vma, walk_private.page, ksm_scan.address);
> +		flush_dcache_page(walk_private.page);
> +		rmap_item = get_next_rmap_item(mm_slot,
> +			ksm_scan.rmap_list, ksm_scan.address);
> +		if (rmap_item) {
> +			ksm_scan.rmap_list =
> +					&rmap_item->rmap_list;
>   
> -			folio = folio_walk_start(&fw, vma, ksm_scan.address, 0);
> -			if (folio) {
> -				if (!folio_is_zone_device(folio) &&
> -				     folio_test_anon(folio)) {
> -					folio_get(folio);
> -					tmp_page = fw.page;
> -				}
> -				folio_walk_end(&fw, vma);
> +			ksm_scan.address += PAGE_SIZE;
> +			if (should_skip_rmap_item(folio, rmap_item)) {
> +				folio_put(folio);
> +				continue;
>   			}
>   
> -			if (tmp_page) {
> -				flush_anon_page(vma, tmp_page, ksm_scan.address);
> -				flush_dcache_page(tmp_page);
> -				rmap_item = get_next_rmap_item(mm_slot,
> -					ksm_scan.rmap_list, ksm_scan.address);
> -				if (rmap_item) {
> -					ksm_scan.rmap_list =
> -							&rmap_item->rmap_list;
> -
> -					if (should_skip_rmap_item(folio, rmap_item)) {
> -						folio_put(folio);
> -						goto next_page;
> -					}
> -
> -					ksm_scan.address += PAGE_SIZE;
> -					*page = tmp_page;
> -				} else {
> -					folio_put(folio);
> -				}
> -				mmap_read_unlock(mm);
> -				return rmap_item;
> -			}
> -next_page:
> -			ksm_scan.address += PAGE_SIZE;
> -			cond_resched();
> +			*page = walk_private.page;
> +		} else {
> +			folio_put(folio);
>   		}
> +		mmap_read_unlock(mm);
> +		return rmap_item;
>   	}
>   
>   	if (ksm_test_exit(mm)) {
> _
> 
> Patches currently in -mm which might be from pedrodemargomes@gmail.com are
> 
> ksm-use-range-walk-function-to-jump-over-holes-in-scan_get_next_rmap_item.patch
> 

https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ksm-use-range-walk-function-to-jump-over-holes-in-scan_get_next_rmap_item.patch

Andrew, please update that patch with recent fix from Pedro related to 
pte_present check, otherwise ksmd would crash and page faults 
system-wide will occur. This is the new version of patch from him (I did 
send it to you but I duplicate):

diff --git a/mm/ksm.c b/mm/ksm.c
index 3aed0478fdce..c8a0a986ccc3 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2455,14 +2455,123 @@ static bool should_skip_rmap_item(struct folio
*folio,
   	return true;
   }

+struct ksm_walk_private {
+	struct page *page;
+	struct folio *folio;
+	struct vm_area_struct *vma;
+	unsigned long address;
+};
+
+static int ksm_walk_test(unsigned long addr, unsigned long next, struct
mm_walk *walk)
+{
+	struct vm_area_struct *vma = walk->vma;
+	struct ksm_walk_private *private;
+
+	if (!(vma->vm_flags & VM_MERGEABLE))
+		return 1;
+
+	private = (struct ksm_walk_private *) walk->private;
+	private->address = vma->vm_end;
+
+	if (!vma->anon_vma)
+		return 1;
+
+	return 0;
+}
+
+static int ksm_pmd_entry(pmd_t *pmd, unsigned long addr,
+			    unsigned long end, struct mm_walk *walk)
+{
+	struct mm_struct *mm = walk->mm;
+	struct vm_area_struct *vma = walk->vma;
+	struct ksm_walk_private *private = (struct ksm_walk_private *)
walk->private;
+	struct folio *folio;
+	pte_t *start_pte, *pte, ptent;
+	pmd_t pmde;
+	struct page *page;
+	spinlock_t *ptl;
+	int ret = 0;
+
+	if (ksm_test_exit(mm))
+		return 1;
+
+	ptl = pmd_lock(mm, pmd);
+	pmde = pmdp_get(pmd);
+
+	if (!pmd_present(pmde))
+		goto pmd_out;
+
+	if (!pmd_trans_huge(pmde))
+		goto pte_table;
+
+	page = vm_normal_page_pmd(vma, addr, pmde);
+
+	if (!page)
+		goto pmd_out;
+
+	folio = page_folio(page);
+	if (folio_is_zone_device(folio) || !folio_test_anon(folio))
+		goto pmd_out;
+
+	ret = 1;
+	folio_get(folio);
+	private->page = page + ((addr & (PMD_SIZE - 1)) >> PAGE_SHIFT);
+	private->folio = folio;
+	private->vma = vma;
+	private->address = addr;
+pmd_out:
+	spin_unlock(ptl);
+	return ret;
+
+pte_table:
+	spin_unlock(ptl);
+
+	start_pte = pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+	if (!start_pte)
+		return 0;
+
+	for (; addr < end; pte++, addr += PAGE_SIZE) {
+		ptent = ptep_get(pte);
+
+		if (!pte_present(ptent))
+			continue;
+
+		page = vm_normal_page(vma, addr, ptent);
+
+		if (!page)
+			continue;
+
+		folio = page_folio(page);
+		if (folio_is_zone_device(folio) || !folio_test_anon(folio))
+			continue;
+
+		ret = 1;
+		folio_get(folio);
+		private->page = page;
+		private->folio = folio;
+		private->vma = vma;
+		private->address = addr;
+		break;
+	}
+	pte_unmap_unlock(start_pte, ptl);
+
+	cond_resched();
+	return ret;
+}
+
+struct mm_walk_ops walk_ops = {
+	.pmd_entry = ksm_pmd_entry,
+	.test_walk = ksm_walk_test,
+	.walk_lock = PGWALK_RDLOCK,
+};
+
   static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
   {
   	struct mm_struct *mm;
   	struct ksm_mm_slot *mm_slot;
   	struct mm_slot *slot;
-	struct vm_area_struct *vma;
   	struct ksm_rmap_item *rmap_item;
-	struct vma_iterator vmi;
+	struct ksm_walk_private walk_private;
   	int nid;

   	if (list_empty(&ksm_mm_head.slot.mm_node))
@@ -2527,64 +2636,44 @@ static struct ksm_rmap_item
*scan_get_next_rmap_item(struct page **page)

   	slot = &mm_slot->slot;
   	mm = slot->mm;
-	vma_iter_init(&vmi, mm, ksm_scan.address);

   	mmap_read_lock(mm);
   	if (ksm_test_exit(mm))
   		goto no_vmas;

-	for_each_vma(vmi, vma) {
-		if (!(vma->vm_flags & VM_MERGEABLE))
-			continue;
-		if (ksm_scan.address < vma->vm_start)
-			ksm_scan.address = vma->vm_start;
-		if (!vma->anon_vma)
-			ksm_scan.address = vma->vm_end;
-
-		while (ksm_scan.address < vma->vm_end) {
-			struct page *tmp_page = NULL;
-			struct folio_walk fw;
-			struct folio *folio;
+	while (true) {
+		struct folio *folio;

-			if (ksm_test_exit(mm))
-				break;
+		walk_private.page = NULL;
+		walk_private.folio = NULL;
+		walk_private.address = ksm_scan.address;

-			folio = folio_walk_start(&fw, vma, ksm_scan.address, 0);
-			if (folio) {
-				if (!folio_is_zone_device(folio) &&
-				     folio_test_anon(folio)) {
-					folio_get(folio);
-					tmp_page = fw.page;
-				}
-				folio_walk_end(&fw, vma);
-			}
+		walk_page_range(mm, ksm_scan.address, -1, &walk_ops, (void *)
&walk_private);
+		ksm_scan.address = walk_private.address;
+		if (!walk_private.page)
+			break;
+
+		folio = walk_private.folio;
+		flush_anon_page(walk_private.vma, walk_private.page, ksm_scan.address);
+		flush_dcache_page(walk_private.page);
+		rmap_item = get_next_rmap_item(mm_slot,
+			ksm_scan.rmap_list, ksm_scan.address);
+		if (rmap_item) {
+			ksm_scan.rmap_list =
+					&rmap_item->rmap_list;

-			if (tmp_page) {
-				flush_anon_page(vma, tmp_page, ksm_scan.address);
-				flush_dcache_page(tmp_page);
-				rmap_item = get_next_rmap_item(mm_slot,
-					ksm_scan.rmap_list, ksm_scan.address);
-				if (rmap_item) {
-					ksm_scan.rmap_list =
-							&rmap_item->rmap_list;
-
-					if (should_skip_rmap_item(folio, rmap_item)) {
-						folio_put(folio);
-						goto next_page;
-					}
-
-					ksm_scan.address += PAGE_SIZE;
-					*page = tmp_page;
-				} else {
-					folio_put(folio);
-				}
-				mmap_read_unlock(mm);
-				return rmap_item;
-			}
-next_page:
   			ksm_scan.address += PAGE_SIZE;
-			cond_resched();
+			if (should_skip_rmap_item(folio, rmap_item)) {
+				folio_put(folio);
+				continue;
+			}
+
+			*page = walk_private.page;
+		} else {
+			folio_put(folio);
   		}
+		mmap_read_unlock(mm);
+		return rmap_item;
   	}

   	if (ksm_test_exit(mm)) {





-----------------
The difference is between 112-113 lines in your patch, after
ptent = ptep_get(pte);

there is new code piece (check for pte_present)

	if (!pte_present(ptent))
			continue;


(Full patch above is present for convenience)
Please, take attention to post fixed patch, that works correctly 
(otherwise crashing will be occur), I noticed, that the file did not 
updated, thanks.
