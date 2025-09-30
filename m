Received: from mail-pg1-f195.google.com (mail-pg1-f195.google.com [209.85.215.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317672CCC5
	for <mm-commits@vger.kernel.org>; Tue, 30 Sep 2025 04:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759206835; cv=none; b=Q+idftM2lpJtKUfqiERF/XmNfODIxcxrsIwHbrEMrR/n2v8dtWg7thTK89mVkTWjPE4rtcOTXRfcn8rbJ9z3M/PyZs3D5eG03jBmmSQ8+TgkdqHie+GFSVs85h7USpHUNoGXpl7GfsuSP3z9GpWmm7n+aZNI/TK/PM+0WH1/P5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759206835; c=relaxed/simple;
	bh=Ibg60QH7RiUFUq4lrxjaiyfQXmzSCCgSztJX5g6Llgs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Hp9TXLcdlmG8YplckiZLwUD7mIGA1VgFCOlw0OOlsIkDQAV1nHPcMPIIyoplC2ATrj+audK6lHq9xq4Ny8jDm377onbos9JxDEIJ54K9o+eK19npHYn0U0iEFJMTUzlw8ZZ+W3JoY8s31/KkldtaUPAqZZa50T6x58/OKe76M/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R//eNnhe; arc=none smtp.client-ip=209.85.215.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R//eNnhe"
Received: by mail-pg1-f195.google.com with SMTP id 41be03b00d2f7-b57bf560703so4070087a12.2
        for <mm-commits@vger.kernel.org>; Mon, 29 Sep 2025 21:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759206832; x=1759811632; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fZfgpwubH+MeGkh3iChN8UsFvd4H952KyFMhRez2y1g=;
        b=R//eNnheBA3yzxHjdhnJS+C0BKpt6tchqpnH6HMelDNNOZ400Oh4Awyxl2Q4IKxpFj
         fnRk6uBCCUj7yZb8Xq0k9O6FQ+C5MhQqY32s5dudm7v6BAJPnIaGCix4auHY0oyqM40/
         2UBS7LJVAPOT4mdAXojZeiO2x98zghDnUL4jMgdz8ylnkLaaOOG6kPZDH4EKRBrW6zRX
         YY21rdK/CKtgru/8U7/ut+yiL6V2vPe1Nc4grlmbCr4qpEdtbx6qS8LFH7pMYb6Mql4Z
         DjjcGGbGvfkzNx2teTYR7Nv2MtAq1N219dI2Q0OIFrmw7FZi3sqJbbXOIV8QX8Y2l/Un
         jfww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759206832; x=1759811632;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fZfgpwubH+MeGkh3iChN8UsFvd4H952KyFMhRez2y1g=;
        b=gCjzhBG0A3q3iM+Hd3UnqaNxMPvhZOS2MWn15olmuO5XpJExjnDdcpuU9YcH8Y36zf
         /Y+8UzMJinXjN75K66k0L3IoN+OIedmZeZTRNkmM2RYD4Yi89byutNC6b5VOPJgXo11j
         +oZAXRLirArdANKyMzy6cJWxSZlrq6UhBKCrXmqiFLsdOBmSgkKHultdqVRvlGfw+rFa
         Oii/o6BFxswHUQeVEvXH7TNPEEmsJ7DpQM7/EKp/Ynm11FLu1NyYo1X3ODEpGJxhEkGD
         k1OoFLAOMAYOJB0VqYJA7cKAiiBBtHVxyQTm5y6LlrqnXzM/bPN0ceUrZTT+a5Jk8lBJ
         PFqw==
X-Gm-Message-State: AOJu0YxAVAHHVWkZtZvsHJKuBwsQ9QxFg6Vd/EW4kVs7iviuEJiTWXl5
	hkf/PlKejoXfkmxPixJhh6Q2fmHlyIjqhuI8e8P+lXr9Lz1h+15WPG2SuKaujygM0GzhuaKQNqX
	wqKPX9J/rt54ESO1Zyyn6Gj1un2ZBueY=
X-Gm-Gg: ASbGncvYbdBBLGzV+bWUaGVYBibTLOBwWqR0EZvGd4bzlBVNl4yMozvpHmR06iZtTjS
	XweVVVQymKvOUOw9IuIVJItp6TfO+JwD9JKY1yGLtO5Ruf6MXmjWdzdoVw+9A7kJNxoXD937jnO
	ShzRwUXZchdZF/13bUhJ9fYfeNfyzPhk34OyqYq4ep8iqvQbEQrzhVntrQEz3y4IYdLkPyI89Op
	ofjy0lQpMXUJ/2hExNFN3/zarXgMjPNR8vy9OaXk0Y=
X-Google-Smtp-Source: AGHT+IEbwQzze4lo5fcPsUJFLNWSUGM5IWZ+irZHXNqAo2EmmdgDIEK9Sk9dzlTGlkTcUrrZy7upZnS2JHpbgzDIdqU=
X-Received: by 2002:a17:902:d2c1:b0:269:96db:94f with SMTP id
 d9443c01a7336-27ed4ac8880mr241724305ad.49.1759206832449; Mon, 29 Sep 2025
 21:33:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250929230959.3E2DFC113D0@smtp.kernel.org>
In-Reply-To: <20250929230959.3E2DFC113D0@smtp.kernel.org>
From: Jianyun Gao <jianyungao89@gmail.com>
Date: Tue, 30 Sep 2025 12:33:45 +0800
X-Gm-Features: AS18NWCQFGKjBi9iD_OqkzKBIeP6lW1Y3tiX-dP0NTbHRUSXXJDJGnWxL7aRA8Q
Message-ID: <CAHP3+4D9X24Zyw6CCNMPsJCoMwfvBmOHtuDtf6k72Pv4W=BKWg@mail.gmail.com>
Subject: Re: + mm-fix-some-typos-in-mm-module.patch added to mm-new branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, sj@kernel.org, richard.weiyang@gmail.com, 
	Liam.Howlett@oracle.com, dev.jain@arm.com, chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Ok, I get it. Thank you very much!

On Tue, Sep 30, 2025 at 7:10=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
>
> The patch titled
>      Subject: mm: Fix some typos in mm module
> has been added to the -mm mm-new branch.  Its filename is
>      mm-fix-some-typos-in-mm-module.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/mm-fix-some-typos-in-mm-module.patch
>
> This patch will later appear in the mm-new branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> Note, mm-new is a provisional staging ground for work-in-progress
> patches, and acceptance into mm-new is a notification for others take
> notice and to finish up reviews.  Please do not hesitate to respond to
> review feedback and post updated versions to replace or incrementally
> fixup patches in mm-new.
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testi=
ng your code ***
>
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
>
> ------------------------------------------------------
> From: "jianyun.gao" <jianyungao89@gmail.com>
> Subject: mm: Fix some typos in mm module
> Date: Mon, 29 Sep 2025 08:26:08 +0800
>
> Below are some typos in the code comments:
>
>   intevals =3D=3D> intervals
>   addesses =3D=3D> addresses
>   unavaliable =3D=3D> unavailable
>   facor =3D=3D> factor
>   droping =3D=3D> dropping
>   exlusive =3D=3D> exclusive
>   decription =3D=3D> description
>   confict =3D=3D> conflict
>   desriptions =3D=3D> descriptions
>   otherwize =3D=3D> otherwise
>   vlaue =3D=3D> value
>   cheching =3D=3D> checking
>   exisitng =3D=3D> existing
>   modifed =3D=3D> modified
>   differenciate =3D=3D> differentiate
>   refernece =3D=3D> reference
>   permissons =3D=3D> permissions
>   indepdenent =3D=3D> independent
>   spliting =3D=3D> splitting
>
> Just fix it.
>
> Link: https://lkml.kernel.org/r/20250929002608.1633825-1-jianyungao89@gma=
il.com
> Signed-off-by: jianyun.gao <jianyungao89@gmail.com>
> Reviewed-by: SeongJae Park <sj@kernel.org>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Acked-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  mm/damon/sysfs.c     |    2 +-
>  mm/gup.c             |    2 +-
>  mm/hugetlb.c         |    6 +++---
>  mm/hugetlb_vmemmap.c |    6 +++---
>  mm/kmsan/core.c      |    2 +-
>  mm/ksm.c             |    2 +-
>  mm/memory-tiers.c    |    2 +-
>  mm/memory.c          |    4 ++--
>  mm/secretmem.c       |    2 +-
>  mm/slab_common.c     |    2 +-
>  mm/slub.c            |    2 +-
>  mm/swapfile.c        |    2 +-
>  mm/userfaultfd.c     |    2 +-
>  mm/vma.c             |    4 ++--
>  14 files changed, 20 insertions(+), 20 deletions(-)
>
> --- a/mm/damon/sysfs.c~mm-fix-some-typos-in-mm-module
> +++ a/mm/damon/sysfs.c
> @@ -1264,7 +1264,7 @@ enum damon_sysfs_cmd {
>         DAMON_SYSFS_CMD_UPDATE_SCHEMES_EFFECTIVE_QUOTAS,
>         /*
>          * @DAMON_SYSFS_CMD_UPDATE_TUNED_INTERVALS: Update the tuned moni=
toring
> -        * intevals.
> +        * intervals.
>          */
>         DAMON_SYSFS_CMD_UPDATE_TUNED_INTERVALS,
>         /*
> --- a/mm/gup.c~mm-fix-some-typos-in-mm-module
> +++ a/mm/gup.c
> @@ -2710,7 +2710,7 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
>   *
>   *  *) ptes can be read atomically by the architecture.
>   *
> - *  *) valid user addesses are below TASK_MAX_SIZE
> + *  *) valid user addresses are below TASK_MAX_SIZE
>   *
>   * The last two assumptions can be relaxed by the addition of helper fun=
ctions.
>   *
> --- a/mm/hugetlb.c~mm-fix-some-typos-in-mm-module
> +++ a/mm/hugetlb.c
> @@ -2954,7 +2954,7 @@ typedef enum {
>          * NOTE: This is mostly identical to MAP_CHG_NEEDED, except
>          * that currently vma_needs_reservation() has an unwanted side
>          * effect to either use end() or commit() to complete the
> -        * transaction.  Hence it needs to differenciate from NEEDED.
> +        * transaction. Hence it needs to differentiate from NEEDED.
>          */
>         MAP_CHG_ENFORCED =3D 2,
>  } map_chg_state;
> @@ -6020,7 +6020,7 @@ void __unmap_hugepage_range(struct mmu_g
>         /*
>          * If we unshared PMDs, the TLB flush was not recorded in mmu_gat=
her. We
>          * could defer the flush until now, since by holding i_mmap_rwsem=
 we
> -        * guaranteed that the last refernece would not be dropped. But w=
e must
> +        * guaranteed that the last reference would not be dropped. But w=
e must
>          * do the flushing before we return, as otherwise i_mmap_rwsem wi=
ll be
>          * dropped and the last reference to the shared PMDs page might b=
e
>          * dropped as well.
> @@ -7206,7 +7206,7 @@ long hugetlb_change_protection(struct vm
>                 } else if (unlikely(is_pte_marker(pte))) {
>                         /*
>                          * Do nothing on a poison marker; page is
> -                        * corrupted, permissons do not apply.  Here
> +                        * corrupted, permissions do not apply. Here
>                          * pte_marker_uffd_wp()=3D=3Dtrue implies !poison
>                          * because they're mutual exclusive.
>                          */
> --- a/mm/hugetlb_vmemmap.c~mm-fix-some-typos-in-mm-module
> +++ a/mm/hugetlb_vmemmap.c
> @@ -75,7 +75,7 @@ static int vmemmap_split_pmd(pmd_t *pmd,
>         if (likely(pmd_leaf(*pmd))) {
>                 /*
>                  * Higher order allocations from buddy allocator must be =
able to
> -                * be treated as indepdenent small pages (as they can be =
freed
> +                * be treated as independent small pages (as they can be =
freed
>                  * individually).
>                  */
>                 if (!PageReserved(head))
> @@ -684,7 +684,7 @@ static void __hugetlb_vmemmap_optimize_f
>                 ret =3D hugetlb_vmemmap_split_folio(h, folio);
>
>                 /*
> -                * Spliting the PMD requires allocating a page, thus lets=
 fail
> +                * Splitting the PMD requires allocating a page, thus let=
's fail
>                  * early once we encounter the first OOM. No point in ret=
rying
>                  * as it can be dynamically done on remap with the memory
>                  * we get back from the vmemmap deduplication.
> @@ -715,7 +715,7 @@ static void __hugetlb_vmemmap_optimize_f
>                 /*
>                  * Pages to be freed may have been accumulated.  If we
>                  * encounter an ENOMEM,  free what we have and try again.
> -                * This can occur in the case that both spliting fails
> +                * This can occur in the case that both splitting fails
>                  * halfway and head page allocation also failed. In this
>                  * case __hugetlb_vmemmap_optimize_folio() would free mem=
ory
>                  * allowing more vmemmap remaps to occur.
> --- a/mm/kmsan/core.c~mm-fix-some-typos-in-mm-module
> +++ a/mm/kmsan/core.c
> @@ -33,7 +33,7 @@ bool kmsan_enabled __read_mostly;
>
>  /*
>   * Per-CPU KMSAN context to be used in interrupts, where current->kmsan =
is
> - * unavaliable.
> + * unavailable.
>   */
>  DEFINE_PER_CPU(struct kmsan_ctx, kmsan_percpu_ctx);
>
> --- a/mm/ksm.c~mm-fix-some-typos-in-mm-module
> +++ a/mm/ksm.c
> @@ -389,7 +389,7 @@ static unsigned long ewma(unsigned long
>   * exponentially weighted moving average. The new pages_to_scan value is
>   * multiplied with that change factor:
>   *
> - *      new_pages_to_scan *=3D change facor
> + *      new_pages_to_scan *=3D change factor
>   *
>   * The new_pages_to_scan value is limited by the cpu min and max values.=
 It
>   * calculates the cpu percent for the last scan and calculates the new
> --- a/mm/memory.c~mm-fix-some-typos-in-mm-module
> +++ a/mm/memory.c
> @@ -4371,7 +4371,7 @@ static inline bool should_try_to_free_sw
>          * If we want to map a page that's in the swapcache writable, we
>          * have to detect via the refcount if we're really the exclusive
>          * user. Try freeing the swapcache to get rid of the swapcache
> -        * reference only in case it's likely that we'll be the exlusive =
user.
> +        * reference only in case it's likely that we'll be the exclusive=
 user.
>          */
>         return (fault_flags & FAULT_FLAG_WRITE) && !folio_test_ksm(folio)=
 &&
>                 folio_ref_count(folio) =3D=3D (1 + folio_nr_pages(folio))=
;
> @@ -5448,7 +5448,7 @@ vm_fault_t do_set_pmd(struct vm_fault *v
>
>  /**
>   * set_pte_range - Set a range of PTEs to point to pages in a folio.
> - * @vmf: Fault decription.
> + * @vmf: Fault description.
>   * @folio: The folio that contains @page.
>   * @page: The first page to create a PTE for.
>   * @nr: The number of PTEs to create.
> --- a/mm/memory-tiers.c~mm-fix-some-typos-in-mm-module
> +++ a/mm/memory-tiers.c
> @@ -519,7 +519,7 @@ static inline void __init_node_memory_ty
>          * for each device getting added in the same NUMA node
>          * with this specific memtype, bump the map count. We
>          * Only take memtype device reference once, so that
> -        * changing a node memtype can be done by droping the
> +        * changing a node memtype can be done by dropping the
>          * only reference count taken here.
>          */
>
> --- a/mm/secretmem.c~mm-fix-some-typos-in-mm-module
> +++ a/mm/secretmem.c
> @@ -227,7 +227,7 @@ SYSCALL_DEFINE1(memfd_secret, unsigned i
>         struct file *file;
>         int fd, err;
>
> -       /* make sure local flags do not confict with global fcntl.h */
> +       /* make sure local flags do not conflict with global fcntl.h */
>         BUILD_BUG_ON(SECRETMEM_FLAGS_MASK & O_CLOEXEC);
>
>         if (!secretmem_enable || !can_set_direct_map())
> --- a/mm/slab_common.c~mm-fix-some-typos-in-mm-module
> +++ a/mm/slab_common.c
> @@ -256,7 +256,7 @@ out:
>   * @object_size: The size of objects to be created in this cache.
>   * @args: Additional arguments for the cache creation (see
>   *        &struct kmem_cache_args).
> - * @flags: See the desriptions of individual flags. The common ones are =
listed
> + * @flags: See the descriptions of individual flags. The common ones are=
 listed
>   *         in the description below.
>   *
>   * Not to be called directly, use the kmem_cache_create() wrapper with t=
he same
> --- a/mm/slub.c~mm-fix-some-typos-in-mm-module
> +++ a/mm/slub.c
> @@ -2409,7 +2409,7 @@ bool slab_free_hook(struct kmem_cache *s
>                 memset((char *)kasan_reset_tag(x) + inuse, 0,
>                        s->size - inuse - rsize);
>                 /*
> -                * Restore orig_size, otherwize kmalloc redzone overwritt=
en
> +                * Restore orig_size, otherwise kmalloc redzone overwritt=
en
>                  * would be reported
>                  */
>                 set_orig_size(s, x, orig_size);
> --- a/mm/swapfile.c~mm-fix-some-typos-in-mm-module
> +++ a/mm/swapfile.c
> @@ -1677,7 +1677,7 @@ static bool swap_entries_put_map_nr(stru
>
>  /*
>   * Check if it's the last ref of swap entry in the freeing path.
> - * Qualified vlaue includes 1, SWAP_HAS_CACHE or SWAP_MAP_SHMEM.
> + * Qualified value includes 1, SWAP_HAS_CACHE or SWAP_MAP_SHMEM.
>   */
>  static inline bool __maybe_unused swap_is_last_ref(unsigned char count)
>  {
> --- a/mm/userfaultfd.c~mm-fix-some-typos-in-mm-module
> +++ a/mm/userfaultfd.c
> @@ -1578,7 +1578,7 @@ static int validate_move_areas(struct us
>
>         /*
>          * For now, we keep it simple and only move between writable VMAs=
.
> -        * Access flags are equal, therefore cheching only the source is =
enough.
> +        * Access flags are equal, therefore checking only the source is =
enough.
>          */
>         if (!(src_vma->vm_flags & VM_WRITE))
>                 return -EINVAL;
> --- a/mm/vma.c~mm-fix-some-typos-in-mm-module
> +++ a/mm/vma.c
> @@ -109,7 +109,7 @@ static inline bool is_mergeable_vma(stru
>  static bool is_mergeable_anon_vma(struct vma_merge_struct *vmg, bool mer=
ge_next)
>  {
>         struct vm_area_struct *tgt =3D merge_next ? vmg->next : vmg->prev=
;
> -       struct vm_area_struct *src =3D vmg->middle; /* exisitng merge cas=
e. */
> +       struct vm_area_struct *src =3D vmg->middle; /* existing merge cas=
e. */
>         struct anon_vma *tgt_anon =3D tgt->anon_vma;
>         struct anon_vma *src_anon =3D vmg->anon_vma;
>
> @@ -798,7 +798,7 @@ static bool can_merge_remove_vma(struct
>   * Returns: The merged VMA if merge succeeds, or NULL otherwise.
>   *
>   * ASSUMPTIONS:
> - * - The caller must assign the VMA to be modifed to @vmg->middle.
> + * - The caller must assign the VMA to be modified to @vmg->middle.
>   * - The caller must have set @vmg->prev to the previous VMA, if there i=
s one.
>   * - The caller must not set @vmg->next, as we determine this.
>   * - The caller must hold a WRITE lock on the mm_struct->mmap_lock.
> _
>
> Patches currently in -mm which might be from jianyungao89@gmail.com are
>
> mm-fix-some-typos-in-mm-module.patch
>
