Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C3715C145
	for <mm-commits@vger.kernel.org>; Tue, 15 Oct 2024 02:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728958848; cv=none; b=SXp6eR2meGlYowgO8aZsAyN1+uxZG6cVPYf+yUrYKuQ2hBrQOfG98vB0tRjrLEHZaAPepLrghqgjzP8V6I0yPEliQHb2FEb1zP230jWH904/p+T36v8VHhAAFNNdejJ7nPOUCi+TgIHtAQk7r/8Mq2HvWhqSaLS3fNIj+luPdEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728958848; c=relaxed/simple;
	bh=4S95UHWxUpPeufDn5rujU2RGskgVEXtodWTJgddkF/k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YquB6u5PHu2wBv6bocHIsoHb5UIPJUBTa8UcgWmxqqwNkenNC2XnWmig8H4A1RRYrQCooYIkEoDliTs9roLgThyxEzf3M3qY42O54rQZ6FfIwp15n1u1o598L1SviMPXUj2ksjrozqpjTxy7gkRcO4vQ67WgKAWQXXrNGZYMTPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MWrdK5W7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MWrdK5W7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8C1C4CEC6
	for <mm-commits@vger.kernel.org>; Tue, 15 Oct 2024 02:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728958847;
	bh=4S95UHWxUpPeufDn5rujU2RGskgVEXtodWTJgddkF/k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=MWrdK5W7Wzdytxh+dM6UdF5iEiOSgJj8wDctb9+HHp89P+eKIl5YIQ6HAQxbw9yfU
	 f4zAKaobo9YKlUBw9F/qu90WQhseXvuWmTBUZoqTtWVGzdgGAzOb5byK4PW6hUj9si
	 2YIoGsUeaxImqEoveDa3FQq2cD58TMC0dqx6jz0t/852jhIOxHj5c1QTYGDYjQB6Nb
	 Moq2/m+gNXuB5YLMOba6Taxyt5reEPc6N4GQhGIGFgL3P7ISI49hLgatXUSlDHmjbv
	 pVCxtOfUeDuCNqe9dd5btjDmDciZ7AwVinYzXpm01+TkZPsn9xFVFv6xUmebCn8sZu
	 uvuKFxlVj0a6g==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5c984352742so1519769a12.1
        for <mm-commits@vger.kernel.org>; Mon, 14 Oct 2024 19:20:47 -0700 (PDT)
X-Gm-Message-State: AOJu0YwVo+/0z4aMIN7dpxy3iDgzBjMfH15t8/d0HRaNH1Z+JWbyDItZ
	3NHM0zWed2aavmvBSVcrMLLRfXZ+zfGtRwkG6oSrG+NVj+hzRbsZ1mUJNuw8GXk000LAsJij2cd
	8/CqXrfY8W55q+JalxR+5jjUvIJ0=
X-Google-Smtp-Source: AGHT+IGT9vU/dwGqYldy9KprfE7dK37ZgexsE2T1PtxuxTfjbwAYrEWb4zLmg29KZqKMkVG6hA5TbZZXn+pewno7g7U=
X-Received: by 2002:a17:907:3f93:b0:a9a:8a4:e090 with SMTP id
 a640c23a62f3a-a9a08a4e189mr577625066b.50.1728958846165; Mon, 14 Oct 2024
 19:20:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241014201240.DF6F4C4CEC3@smtp.kernel.org>
In-Reply-To: <20241014201240.DF6F4C4CEC3@smtp.kernel.org>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 15 Oct 2024 10:20:35 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5QjycgUOW8R0yY_V27MJMg9k3SRWprBcxTSoA2MAuo7Q@mail.gmail.com>
Message-ID: <CAAhV-H5QjycgUOW8R0yY_V27MJMg9k3SRWprBcxTSoA2MAuo7Q@mail.gmail.com>
Subject: Re: + mm-define-general-function-pxd_init.patch added to mm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, vincenzo.frascino@arm.com, 
	tsbogend@alpha.franken.de, ryabinin.a.a@gmail.com, kernel@xen0n.name, 
	glider@google.com, dvyukov@google.com, andreyknvl@gmail.com, 
	maobibo@loongson.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Andrew,

On Tue, Oct 15, 2024 at 4:12=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
>
> The patch titled
>      Subject: mm: define general function pXd_init()
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-define-general-function-pxd_init.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/mm-define-general-function-pxd_init.patch
>
> This patch will later appear in the mm-unstable branch at
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
> From: Bibo Mao <maobibo@loongson.cn>
> Subject: mm: define general function pXd_init()
> Date: Fri, 11 Oct 2024 17:33:18 +0800
>
> pmd_init() and pud_init() are duplicated defined in file kasan.c and
> sparse-vmemmap.c as weak functions.  Move them to generic header file
> pgtable.h, architecture can redefine them.
>
> Link: https://lkml.kernel.org/r/20241011093318.519432-1-maobibo@loongson.=
cn
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> Cc: Alexander Potapenko <glider@google.com>
> Cc: Andrey Konovalov <andreyknvl@gmail.com>
> Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
> Cc: WANG Xuerui <kernel@xen0n.name>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  arch/loongarch/include/asm/pgtable.h |    2 ++
>  arch/mips/include/asm/pgtable-64.h   |    2 ++
>  include/linux/mm.h                   |    2 --
>  include/linux/pgtable.h              |   14 ++++++++++++++
>  mm/kasan/init.c                      |    8 --------
>  mm/sparse-vmemmap.c                  |    8 --------
>  6 files changed, 18 insertions(+), 18 deletions(-)
>
> --- a/arch/loongarch/include/asm/pgtable.h~mm-define-general-function-pxd=
_init
> +++ a/arch/loongarch/include/asm/pgtable.h
> @@ -267,7 +267,9 @@ extern void set_pmd_at(struct mm_struct
>   * Initialize a new pgd / pud / pmd table with invalid pointers.
>   */
>  extern void pgd_init(void *addr);
> +#define pud_init pud_init
>  extern void pud_init(void *addr);
> +#define pmd_init pmd_init
>  extern void pmd_init(void *addr);
>
>  /*
> --- a/arch/mips/include/asm/pgtable-64.h~mm-define-general-function-pxd_i=
nit
> +++ a/arch/mips/include/asm/pgtable-64.h
> @@ -316,7 +316,9 @@ static inline pmd_t *pud_pgtable(pud_t p
>   * Initialize a new pgd / pud / pmd table with invalid pointers.
>   */
>  extern void pgd_init(void *addr);
> +#define pud_init pud_init
>  extern void pud_init(void *addr);
> +#define pmd_init pmd_init
>  extern void pmd_init(void *addr);
>
>  /*
> --- a/include/linux/mm.h~mm-define-general-function-pxd_init
> +++ a/include/linux/mm.h
> @@ -3821,8 +3821,6 @@ void *sparse_buffer_alloc(unsigned long
>  struct page * __populate_section_memmap(unsigned long pfn,
>                 unsigned long nr_pages, int nid, struct vmem_altmap *altm=
ap,
>                 struct dev_pagemap *pgmap);
> -void pmd_init(void *addr);
> -void pud_init(void *addr);
>  pgd_t *vmemmap_pgd_populate(unsigned long addr, int node);
>  p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
>  pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
> --- a/include/linux/pgtable.h~mm-define-general-function-pxd_init
> +++ a/include/linux/pgtable.h
> @@ -90,6 +90,20 @@ static inline unsigned long pud_index(un
>  #define pgd_index(a)  (((a) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
>  #endif
>
> +#ifndef pmd_init
> +static inline void pmd_init(void *addr)
> +{
> +}
> +#define pmd_init pmd_init
> +#endif
> +
> +#ifndef pud_init
> +static inline void pud_init(void *addr)
> +{
> +}
> +#define pud_init pud_init
> +#endif
For the fallback implementation, from other examples, it seems we
usually don't need something like "#define pmd_init pmd_init".

Huacai

> +
>  #ifndef pte_offset_kernel
>  static inline pte_t *pte_offset_kernel(pmd_t *pmd, unsigned long address=
)
>  {
> --- a/mm/kasan/init.c~mm-define-general-function-pxd_init
> +++ a/mm/kasan/init.c
> @@ -139,10 +139,6 @@ static int __ref zero_pmd_populate(pud_t
>         return 0;
>  }
>
> -void __weak __meminit pmd_init(void *addr)
> -{
> -}
> -
>  static int __ref zero_pud_populate(p4d_t *p4d, unsigned long addr,
>                                 unsigned long end)
>  {
> @@ -181,10 +177,6 @@ static int __ref zero_pud_populate(p4d_t
>         return 0;
>  }
>
> -void __weak __meminit pud_init(void *addr)
> -{
> -}
> -
>  static int __ref zero_p4d_populate(pgd_t *pgd, unsigned long addr,
>                                 unsigned long end)
>  {
> --- a/mm/sparse-vmemmap.c~mm-define-general-function-pxd_init
> +++ a/mm/sparse-vmemmap.c
> @@ -196,10 +196,6 @@ pmd_t * __meminit vmemmap_pmd_populate(p
>         return pmd;
>  }
>
> -void __weak __meminit pmd_init(void *addr)
> -{
> -}
> -
>  pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, i=
nt node)
>  {
>         pud_t *pud =3D pud_offset(p4d, addr);
> @@ -213,10 +209,6 @@ pud_t * __meminit vmemmap_pud_populate(p
>         return pud;
>  }
>
> -void __weak __meminit pud_init(void *addr)
> -{
> -}
> -
>  p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, i=
nt node)
>  {
>         p4d_t *p4d =3D p4d_offset(pgd, addr);
> _
>
> Patches currently in -mm which might be from maobibo@loongson.cn are
>
> mm-define-general-function-pxd_init.patch
>
