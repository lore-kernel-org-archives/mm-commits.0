Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644D718F2CF
	for <mm-commits@vger.kernel.org>; Fri, 18 Oct 2024 09:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729244943; cv=none; b=k9gRCnM+tMldLvIsUDtvkaM4N5I23/8EW48rRsZuj1O1gWGo/DMb3K2G9BmQ/HvSjKc6xWI0Zp+ZQ9bXYkQ4qCnYiGDdR535BFXYbyIOGgdBmF7XaZgSckv1IgOxY+qw0+Da+uqIMAwW5e1HsC3GT8Vg+DMQDBWD2aMBG7m+x40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729244943; c=relaxed/simple;
	bh=3WVXqQZQAJuZ1G42X+xwClsRkOX4RJwuje9Yixnzxxs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lTw7mA8bLDZCBr0fKjNVEco0o09x78Ny1ljA+6cI4J5E/CW8FV8RD38KgZPqsXLN1u8UJJpCzJLlmxlqaovhAwULzJrPt0Y87los8BVzqaVdzlO/P19+BHDV2bR5zFJP3V2KNWAB1bO475IgqIRlNUdRl4n/Ag/JhVVuQp4F/II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DrBW3+2w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DrBW3+2w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0049BC4CED1
	for <mm-commits@vger.kernel.org>; Fri, 18 Oct 2024 09:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729244943;
	bh=3WVXqQZQAJuZ1G42X+xwClsRkOX4RJwuje9Yixnzxxs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=DrBW3+2w0aBQCySPJA/VNVJaG6tFEghvcylnFv8yXVhJPupWnt0YQBN/BgWOxQhN0
	 t1BdB0Q8yDT97Agh9ZgGAHYBwWQsBarOFskOv8MC4NKvhIPrFcz7Mh9mSExx/9Koh+
	 vggeiLSPp52sVz2KswRZyATz3vaubXiQNwxy1OXVFN40iWNq4tWDSajJ7Ts9mFuf8e
	 kg8ItYoph7el9XeUIhEnpB/b9mIpyz8ET1OEoc0znEgIbT5f3dstU6SARU8VeNfDqN
	 W9XCl7RClz/h5o1V+0y2FwO8FncO2R8CSNlWU76YxX+WufUCvP40rgv35WqWdbukEv
	 pZGGgZkhFdw+Q==
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-539f1292a9bso2515259e87.2
        for <mm-commits@vger.kernel.org>; Fri, 18 Oct 2024 02:49:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXbZX0i136I/M8mxdqf7KSqQrK18dQ2/hIfhveQ3hFx+8kRJkOcLOXzhJ3KRWPDjhAQ/6RgrlqQKUS7@vger.kernel.org
X-Gm-Message-State: AOJu0YxVzD5BUneYFWAoI1fqO6nReCUpFbjHIBGceyWWaGAVcdAD4YNB
	WHwpVFF75F81VMbQ+EO/DTwP+5ofhvGy1IHndZ6msrQQw8/1fFC2V4Z6NhP/SaAfrstuaHnDnwO
	kZenkMHI6jxa8QLV886HlIMXwTy8=
X-Google-Smtp-Source: AGHT+IFK46vc6ZoH+xM3CfgIe1LwrFXlTc2FDjAJ2Zdv9QD9kz5iYk6b9a99H3fgBZM8ZlOoAMYmSq+G3dvQx5jyIq8=
X-Received: by 2002:a05:6512:1294:b0:539:f607:1d2b with SMTP id
 2adb3069b0e04-53a15341038mr1275983e87.7.1729244941316; Fri, 18 Oct 2024
 02:49:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241014201240.DF6F4C4CEC3@smtp.kernel.org> <CAAhV-H5QjycgUOW8R0yY_V27MJMg9k3SRWprBcxTSoA2MAuo7Q@mail.gmail.com>
 <48458888-26d3-4606-3de2-7736c13cb7b9@loongson.cn> <CAAhV-H62FafZGH1jd84nRRx3h=y=RXc-ks7OigdOwnYXCOGsuw@mail.gmail.com>
 <692d5696-5008-39c3-83e2-343691573d98@loongson.cn>
In-Reply-To: <692d5696-5008-39c3-83e2-343691573d98@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 18 Oct 2024 17:48:46 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5kZucJuH=GF7gXG_31N4qJgpybATDVXujpvkkGFRUVog@mail.gmail.com>
Message-ID: <CAAhV-H5kZucJuH=GF7gXG_31N4qJgpybATDVXujpvkkGFRUVog@mail.gmail.com>
Subject: Re: + mm-define-general-function-pxd_init.patch added to mm-unstable branch
To: maobibo <maobibo@loongson.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, 
	vincenzo.frascino@arm.com, tsbogend@alpha.franken.de, ryabinin.a.a@gmail.com, 
	kernel@xen0n.name, glider@google.com, dvyukov@google.com, 
	andreyknvl@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 18, 2024 at 11:50=E2=80=AFAM maobibo <maobibo@loongson.cn> wrot=
e:
>
>
>
> On 2024/10/18 =E4=B8=8A=E5=8D=8811:20, Huacai Chen wrote:
> > Hi, Andrew,
> >
> > Please drop this patch temporary because I applied another Bibo's
> > patch which causes conflict in linux-next:
> > https://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongs=
on.git/commit/?h=3Dloongarch-next&id=3D15832255e84494853f543b4c70ced50afc40=
3067
> >
> > That patch is urgent and should be merged in 6.12 as soon as possible,
> > while this refactoring patch is in mm-unstable and target for 6.13.
> >
> > Bibo will update this patch to V2 later. Thanks.
> No, it is not urgent since it exists for years. We need know HW details
> and give proper solution.
It has existed for years but just be found recently. A bug is usually
urgent and should be fixed asap.

>
> Huacai,
>
> Obviously you do not know LoongArch MM subsystem, I am doubt about your
> ability on it. Please hold on until it is verified on more HW platforms.
Of course I can't know everything, but at least I have double checked
every line of a patch. This is why I can find the mistake about KASAN
in your patch but you cannot (though you are the author).

Huacai

>
> Regards
> Bibo Mao
> >
> > Huacai
> >
> > On Tue, Oct 15, 2024 at 11:00=E2=80=AFAM maobibo <maobibo@loongson.cn> =
wrote:
> >>
> >>
> >>
> >> On 2024/10/15 =E4=B8=8A=E5=8D=8810:20, Huacai Chen wrote:
> >>> Hi, Andrew,
> >>>
> >>> On Tue, Oct 15, 2024 at 4:12=E2=80=AFAM Andrew Morton <akpm@linux-fou=
ndation.org> wrote:
> >>>>
> >>>>
> >>>> The patch titled
> >>>>        Subject: mm: define general function pXd_init()
> >>>> has been added to the -mm mm-unstable branch.  Its filename is
> >>>>        mm-define-general-function-pxd_init.patch
> >>>>
> >>>> This patch will shortly appear at
> >>>>        https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.g=
it/tree/patches/mm-define-general-function-pxd_init.patch
> >>>>
> >>>> This patch will later appear in the mm-unstable branch at
> >>>>       git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> >>>>
> >>>> Before you just go and hit "reply", please:
> >>>>      a) Consider who else should be cc'ed
> >>>>      b) Prefer to cc a suitable mailing list as well
> >>>>      c) Ideally: find the original patch on the mailing list and do =
a
> >>>>         reply-to-all to that, adding suitable additional cc's
> >>>>
> >>>> *** Remember to use Documentation/process/submit-checklist.rst when =
testing your code ***
> >>>>
> >>>> The -mm tree is included into linux-next via the mm-everything
> >>>> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> >>>> and is updated there every 2-3 working days
> >>>>
> >>>> ------------------------------------------------------
> >>>> From: Bibo Mao <maobibo@loongson.cn>
> >>>> Subject: mm: define general function pXd_init()
> >>>> Date: Fri, 11 Oct 2024 17:33:18 +0800
> >>>>
> >>>> pmd_init() and pud_init() are duplicated defined in file kasan.c and
> >>>> sparse-vmemmap.c as weak functions.  Move them to generic header fil=
e
> >>>> pgtable.h, architecture can redefine them.
> >>>>
> >>>> Link: https://lkml.kernel.org/r/20241011093318.519432-1-maobibo@loon=
gson.cn
> >>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >>>> Cc: Alexander Potapenko <glider@google.com>
> >>>> Cc: Andrey Konovalov <andreyknvl@gmail.com>
> >>>> Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> >>>> Cc: Dmitry Vyukov <dvyukov@google.com>
> >>>> Cc: Huacai Chen <chenhuacai@kernel.org>
> >>>> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> >>>> Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
> >>>> Cc: WANG Xuerui <kernel@xen0n.name>
> >>>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >>>> ---
> >>>>
> >>>>    arch/loongarch/include/asm/pgtable.h |    2 ++
> >>>>    arch/mips/include/asm/pgtable-64.h   |    2 ++
> >>>>    include/linux/mm.h                   |    2 --
> >>>>    include/linux/pgtable.h              |   14 ++++++++++++++
> >>>>    mm/kasan/init.c                      |    8 --------
> >>>>    mm/sparse-vmemmap.c                  |    8 --------
> >>>>    6 files changed, 18 insertions(+), 18 deletions(-)
> >>>>
> >>>> --- a/arch/loongarch/include/asm/pgtable.h~mm-define-general-functio=
n-pxd_init
> >>>> +++ a/arch/loongarch/include/asm/pgtable.h
> >>>> @@ -267,7 +267,9 @@ extern void set_pmd_at(struct mm_struct
> >>>>     * Initialize a new pgd / pud / pmd table with invalid pointers.
> >>>>     */
> >>>>    extern void pgd_init(void *addr);
> >>>> +#define pud_init pud_init
> >>>>    extern void pud_init(void *addr);
> >>>> +#define pmd_init pmd_init
> >>>>    extern void pmd_init(void *addr);
> >>>>
> >>>>    /*
> >>>> --- a/arch/mips/include/asm/pgtable-64.h~mm-define-general-function-=
pxd_init
> >>>> +++ a/arch/mips/include/asm/pgtable-64.h
> >>>> @@ -316,7 +316,9 @@ static inline pmd_t *pud_pgtable(pud_t p
> >>>>     * Initialize a new pgd / pud / pmd table with invalid pointers.
> >>>>     */
> >>>>    extern void pgd_init(void *addr);
> >>>> +#define pud_init pud_init
> >>>>    extern void pud_init(void *addr);
> >>>> +#define pmd_init pmd_init
> >>>>    extern void pmd_init(void *addr);
> >>>>
> >>>>    /*
> >>>> --- a/include/linux/mm.h~mm-define-general-function-pxd_init
> >>>> +++ a/include/linux/mm.h
> >>>> @@ -3821,8 +3821,6 @@ void *sparse_buffer_alloc(unsigned long
> >>>>    struct page * __populate_section_memmap(unsigned long pfn,
> >>>>                   unsigned long nr_pages, int nid, struct vmem_altma=
p *altmap,
> >>>>                   struct dev_pagemap *pgmap);
> >>>> -void pmd_init(void *addr);
> >>>> -void pud_init(void *addr);
> >>>>    pgd_t *vmemmap_pgd_populate(unsigned long addr, int node);
> >>>>    p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int n=
ode);
> >>>>    pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int n=
ode);
> >>>> --- a/include/linux/pgtable.h~mm-define-general-function-pxd_init
> >>>> +++ a/include/linux/pgtable.h
> >>>> @@ -90,6 +90,20 @@ static inline unsigned long pud_index(un
> >>>>    #define pgd_index(a)  (((a) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
> >>>>    #endif
> >>>>
> >>>> +#ifndef pmd_init
> >>>> +static inline void pmd_init(void *addr)
> >>>> +{
> >>>> +}
> >>>> +#define pmd_init pmd_init
> >>>> +#endif
> >>>> +
> >>>> +#ifndef pud_init
> >>>> +static inline void pud_init(void *addr)
> >>>> +{
> >>>> +}
> >>>> +#define pud_init pud_init
> >>>> +#endif
> >>> For the fallback implementation, from other examples, it seems we
> >>> usually don't need something like "#define pmd_init pmd_init".
> >> However for some examples it is used actually, such as:
> >>
> >> #ifndef pmd_index
> >> static inline unsigned long pmd_index(unsigned long address)
> >> {
> >>           return (address >> PMD_SHIFT) & (PTRS_PER_PMD - 1);
> >> }
> >> #define pmd_index pmd_index
> >> #endif
> >>
> >> #ifndef pud_index
> >> static inline unsigned long pud_index(unsigned long address)
> >> {
> >>           return (address >> PUD_SHIFT) & (PTRS_PER_PUD - 1);
> >> }
> >> #define pud_index pud_index
> >> #endif
> >>
> >> Regards
> >> Bibo Mao
> >>>
> >>> Huacai
> >>>
> >>>> +
> >>>>    #ifndef pte_offset_kernel
> >>>>    static inline pte_t *pte_offset_kernel(pmd_t *pmd, unsigned long =
address)
> >>>>    {
> >>>> --- a/mm/kasan/init.c~mm-define-general-function-pxd_init
> >>>> +++ a/mm/kasan/init.c
> >>>> @@ -139,10 +139,6 @@ static int __ref zero_pmd_populate(pud_t
> >>>>           return 0;
> >>>>    }
> >>>>
> >>>> -void __weak __meminit pmd_init(void *addr)
> >>>> -{
> >>>> -}
> >>>> -
> >>>>    static int __ref zero_pud_populate(p4d_t *p4d, unsigned long addr=
,
> >>>>                                   unsigned long end)
> >>>>    {
> >>>> @@ -181,10 +177,6 @@ static int __ref zero_pud_populate(p4d_t
> >>>>           return 0;
> >>>>    }
> >>>>
> >>>> -void __weak __meminit pud_init(void *addr)
> >>>> -{
> >>>> -}
> >>>> -
> >>>>    static int __ref zero_p4d_populate(pgd_t *pgd, unsigned long addr=
,
> >>>>                                   unsigned long end)
> >>>>    {
> >>>> --- a/mm/sparse-vmemmap.c~mm-define-general-function-pxd_init
> >>>> +++ a/mm/sparse-vmemmap.c
> >>>> @@ -196,10 +196,6 @@ pmd_t * __meminit vmemmap_pmd_populate(p
> >>>>           return pmd;
> >>>>    }
> >>>>
> >>>> -void __weak __meminit pmd_init(void *addr)
> >>>> -{
> >>>> -}
> >>>> -
> >>>>    pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long =
addr, int node)
> >>>>    {
> >>>>           pud_t *pud =3D pud_offset(p4d, addr);
> >>>> @@ -213,10 +209,6 @@ pud_t * __meminit vmemmap_pud_populate(p
> >>>>           return pud;
> >>>>    }
> >>>>
> >>>> -void __weak __meminit pud_init(void *addr)
> >>>> -{
> >>>> -}
> >>>> -
> >>>>    p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long =
addr, int node)
> >>>>    {
> >>>>           p4d_t *p4d =3D p4d_offset(pgd, addr);
> >>>> _
> >>>>
> >>>> Patches currently in -mm which might be from maobibo@loongson.cn are
> >>>>
> >>>> mm-define-general-function-pxd_init.patch
> >>>>
> >>
>
