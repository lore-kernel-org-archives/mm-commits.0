Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D315A2147EA;
	Thu, 24 Apr 2025 12:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745496013; cv=none; b=F/mM1rB9iFxOKeEdjMVlRu+NOGlXaqk6MNBzgcBEDd76ceGl41DqbvUyMKoqhS/1H0ABWX7nzTzCZBc3ehZATa9RDogbvXvGNgcLBDr3DxzkUsDL2/ppvS5VTKYvEeCvykEn9RFgdV6H058O/zFHApAFpKb8YZSWRmE3Rndcte4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745496013; c=relaxed/simple;
	bh=uQD5cmbc2PWs1htOxpY1MsyZj1uTaEF+N5MsgddgQ9g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V6Ibt+4HGNAWhMTsOfg9BH5H0+/4EFWt0dUNyfqfcvCHbp0q+7YoEWw9gXAeY5H6VKYq2CMoxaHqqYJ6SQl0Kl1LpyQmu8XqeqXAgzg58RO6nNPoeQ9Iv81NCx0jICsprCxyMzTB2+qAEU2BulUNk7gU8VlQtsl9LNV7aOOiAyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Myiu/oPy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Myiu/oPy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F9EC4CEF5;
	Thu, 24 Apr 2025 12:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745496013;
	bh=uQD5cmbc2PWs1htOxpY1MsyZj1uTaEF+N5MsgddgQ9g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Myiu/oPy4u6fPnlwTzG2NdiNj47PRBHaDDIOImbWecvcNXXmHFQfWx/wsQX2VYVd6
	 khGi53avWcoflsAiXMOwDVNeCeUdZGDFLSuqXvdDi5/o4Gf+RiG2ftnkpY0dHSLFIx
	 Q8efBrvuz8uFPzoY04dkwFhCKkd5p6TGtY4rsqPAb+1tOBU3Zk3GlPjdFckPL3HHgc
	 4V9zrhvWbYwUxST1tKpFDIeP7qt3o5JBiFE4IXVCUHENJRPq3IPULdUEuqZE8dDCn4
	 qrOwEi7Ae1WpyRG5xT5GTOewNRSoLm9r0WiBRPkMQBw+1l7Vm5Icr3WgpGSogic/fb
	 p38xuc5rkOcxQ==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-ace3b03c043so147490966b.2;
        Thu, 24 Apr 2025 05:00:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVkHN/9dp3K9Psu7NCjMymOxBjkkTl8C+Xqco3UiP7CMDpqvYmEf/6eIpCrZt/uPY1FdX6UqO0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqLcvCTT6YzSDFu8Han/WV6EYYB4DJeGEIWmP8D0VjzNed0ofB
	M5Jcm2dt+dsF4BkxstBcM6X9rQvUQL8jaCSzVQ+pTV21v3IMQdy+Ax2RqZWMH6FZqn5rseBWh4j
	42FcqPtluFAosTXoRImLOQQrLGZc=
X-Google-Smtp-Source: AGHT+IHAnAguadmqcpIb6I6CVJVRx1pOBIjszKyCq/LfdlztfFUYUxsPocEYYpdsASF6N6s32jPAe6Tsvbkx4HO7zfY=
X-Received: by 2002:a17:907:3f29:b0:ac7:150b:57b2 with SMTP id
 a640c23a62f3a-ace57494dabmr225223066b.41.1745496011693; Thu, 24 Apr 2025
 05:00:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250423011742.D0806C4CEE9@smtp.kernel.org>
In-Reply-To: <20250423011742.D0806C4CEE9@smtp.kernel.org>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Thu, 24 Apr 2025 20:00:01 +0800
X-Gmail-Original-Message-ID: <CAAhV-H73_Z3RfZNdvMh608Emj_6RLefoRTDy-Gb-S6PqYrVRLA@mail.gmail.com>
X-Gm-Features: ATxdqUHVXdwcr_vqli243qlYjTP_gC3hfUaSvkFjxSxHAY0zCoz8NQlF07Jyr7Q
Message-ID: <CAAhV-H73_Z3RfZNdvMh608Emj_6RLefoRTDy-Gb-S6PqYrVRLA@mail.gmail.com>
Subject: Re: + smaps-fix-crash-in-smaps_hugetlb_range-for-non-present-hugetlb-entries.patch
 added to mm-hotfixes-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, zhanghongchen@loongson.cn, willy@infradead.org, 
	stable@vger.kernel.org, ryan.roberts@arm.com, rientjes@google.com, 
	osalvador@suse.de, nao.horiguchi@gmail.com, mhocko@suse.cz, joern@logfs.org, 
	hughd@google.com, david@redhat.com, christophe.leroy@csgroup.eu, 
	andrii@kernel.org, wangming01@loongson.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Andrew,

Please drop this patch, because there is a better solution:
https://lore.kernel.org/loongarch/20250424083037.2226732-1-wangming01@loong=
son.cn/T/#u

Huacai

On Wed, Apr 23, 2025 at 9:17=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
>
> The patch titled
>      Subject: smaps: fix crash in smaps_hugetlb_range for non-present hug=
etlb entries
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      smaps-fix-crash-in-smaps_hugetlb_range-for-non-present-hugetlb-entri=
es.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/smaps-fix-crash-in-smaps_hugetlb_range-for-non-present-hugetlb-ent=
ries.patch
>
> This patch will later appear in the mm-hotfixes-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
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
> From: Ming Wang <wangming01@loongson.cn>
> Subject: smaps: fix crash in smaps_hugetlb_range for non-present hugetlb =
entries
> Date: Wed, 23 Apr 2025 09:03:59 +0800
>
> When reading /proc/pid/smaps for a process that has mapped a hugetlbfs
> file with MAP_PRIVATE, the kernel might crash inside
> pfn_swap_entry_to_page.  This occurs on LoongArch under specific
> conditions.
>
> The root cause involves several steps:
>
> 1. When the hugetlbfs file is mapped (MAP_PRIVATE), the initial PMD
>    (or relevant level) entry is often populated by the kernel during
>    mmap() with a non-present entry pointing to the architecture's
>    invalid_pte_table On the affected LoongArch system, this address was
>    observed to be 0x90000000031e4000.
>
> 2. The smaps walker (walk_hugetlb_range -> smaps_hugetlb_range) reads
>    this entry.
>
> 3. The generic is_swap_pte() macro checks `!pte_present() &&
>    !pte_none()`.  The entry (invalid_pte_table address) is not present.
>    Crucially, the generic pte_none() check (`!(pte_val(pte) &
>    ~_PAGE_GLOBAL)`) returns false because the invalid_pte_table address i=
s
>    non-zero.  Therefore, is_swap_pte() incorrectly returns true.
>
> 4. The code enters the `else if (is_swap_pte(...))` block.
>
> 5. Inside this block, it checks `is_pfn_swap_entry()`.  Due to a bit
>    pattern coincidence in the invalid_pte_table address on LoongArch, the
>    embedded generic `is_migration_entry()` check happens to return true
>    (misinterpreting parts of the address as a migration type).
>
> 6. This leads to a call to pfn_swap_entry_to_page() with the bogus
>    swap entry derived from the invalid table address.
>
> 7. pfn_swap_entry_to_page() extracts a meaningless PFN, finds an
>    unrelated struct page, checks its lock status (unlocked), and hits the
>    `BUG_ON(is_migration_entry(entry) && !PageLocked(p))` assertion.
>
> The original code's intent in the `else if` block seems aimed at handling
> potential migration entries, as indicated by the inner
> `is_pfn_swap_entry()` check.  The issue arises because the outer
> `is_swap_pte()` check incorrectly includes the invalid table pointer case
> on LoongArch.
>
> This patch fixes the issue by changing the condition in
> smaps_hugetlb_range() from the broad `is_swap_pte()` to the specific
> `is_hugetlb_entry_migration()`.
>
> The `is_hugetlb_entry_migration()` helper function correctly handles this
> by first checking `huge_pte_none()`.  Architectures like LoongArch can
> provide an override for `huge_pte_none()` that specifically recognizes th=
e
> `invalid_pte_table` address as a "none" state for HugeTLB entries.  This
> ensures `is_hugetlb_entry_migration()` returns false for the invalid
> entry, preventing the code from entering the faulty block.
>
> This change makes the code reflect the likely original intent (handling
> migration) more accurately and leverages architecture-specific helpers
> (`huge_pte_none`) to correctly interpret special PTE/PMD values in the
> HugeTLB context, fixing the crash on LoongArch without altering the
> generic is_swap_pte() behavior.
>
> Link: https://lkml.kernel.org/r/20250423010359.2030576-1-wangming01@loong=
son.cn
> Fixes: 25ee01a2fca0 ("mm: hugetlb: proc: add hugetlb-related fields to /p=
roc/PID/smaps")
> Co-developed-by: Hongchen Zhang <zhanghongchen@loongson.cn>
> Signed-off-by: Hongchen Zhang <zhanghongchen@loongson.cn>
> Signed-off-by: Ming Wang <wangming01@loongson.cn>
> Cc: Andrii Nakryiko <andrii@kernel.org>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Joern Engel <joern@logfs.org>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  fs/proc/task_mmu.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/fs/proc/task_mmu.c~smaps-fix-crash-in-smaps_hugetlb_range-for-non-p=
resent-hugetlb-entries
> +++ a/fs/proc/task_mmu.c
> @@ -1027,7 +1027,7 @@ static int smaps_hugetlb_range(pte_t *pt
>         if (pte_present(ptent)) {
>                 folio =3D page_folio(pte_page(ptent));
>                 present =3D true;
> -       } else if (is_swap_pte(ptent)) {
> +       } else if (is_hugetlb_entry_migration(ptent)) {
>                 swp_entry_t swpent =3D pte_to_swp_entry(ptent);
>
>                 if (is_pfn_swap_entry(swpent))
> _
>
> Patches currently in -mm which might be from wangming01@loongson.cn are
>
> smaps-fix-crash-in-smaps_hugetlb_range-for-non-present-hugetlb-entries.pa=
tch
>
