Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA2F17557C
	for <mm-commits@vger.kernel.org>; Fri, 18 Oct 2024 03:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729221619; cv=none; b=Gs5X4LgHBFqECDPhQqsjqjaR4QVMpJwLSQrpULIHhZ7x2UwOJiOBLgbCIALUj5Eavaz7a20pRy1wfaIeFllhiBilBSNYqW9RAXmm2BJY+UCBCNQdOSF8rDbLuVOXjp9/hLNwfQURVn1PzxY2WlrQ/TSkLzNADAx6kIAg3EipB6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729221619; c=relaxed/simple;
	bh=L+zg+N5MeqzHLzblLqLZmo5SVqdSYq4UJDexVDktz38=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=glk7ngdPl/cJ72Xar4FMEw/uK5mUSBgLevZ6p7TIpCVleEVYiqXPFnxD1vSITA4sQsrh28yuxr4b9tlvHnvOFVVhZM84qnKA2XZ0DR32V2PbzBDFd/A0aixBPxpGowrv3HNziKIkNPAf9lOG1u/pR3+FtZ8E8KCcus/B40Bl/UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F++Pi1YK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F++Pi1YK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C58C4CED0
	for <mm-commits@vger.kernel.org>; Fri, 18 Oct 2024 03:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729221618;
	bh=L+zg+N5MeqzHLzblLqLZmo5SVqdSYq4UJDexVDktz38=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=F++Pi1YKcpH0iyvy0lCEuFZDZmGRptlsZFeyFLkjTl4veXuDHTVF9QP7f+nxLirNH
	 f4ZgG04ek9mWBSFm+9pB/rd0ZI/CSHcTh1i3apuEZL24YDXyT3HnGn3uIMSmuWwxMc
	 Y5x8riMuwfYsVMEUmngEigRdntT8u3v6aR1KnTen5VPZ0irIcbzwwvsLXRJdELv8BO
	 8jAvJpMwErxNc1wiPEqMzeM2uhj6vEFQZdZEJc9oaOVVWldNjyio3BV24y5wbCmc3j
	 8T00mndxGXPNMsS3REO28PtxLzTGKma1LFUGbQkO681s3iA91VRrDyUB7v4SHMfv51
	 BniCvasS6KHrw==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a9a0472306cso209573366b.3
        for <mm-commits@vger.kernel.org>; Thu, 17 Oct 2024 20:20:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXV9fAfAsdHjJiNaETF/63s1DR52WbshgXnmuf7Rdr/yw2pvRTPvq8C3XgRLgN23LcVHgBZ/MKnjgNb@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2rLEp0HcgOzjIKHtbhVdlRTsDfqmnWNB3NVCj1WawuLFclwgi
	inpqNNJ78dMgmfhiL1IaidalawCTANNOAh2uLGlHE4Ui1YN/ntaXcCMHkNKRTpqZncrIo1lF4x0
	h2MuVZQizZQiIstDKAs7lHJME0U8=
X-Google-Smtp-Source: AGHT+IEm+0yd5n9YAdyt1Xl+MSsIS8Qw5X3R1KkA+H96yKh0PKoZaXSg9XYMZcx06YNOnndwTUTZvyHW6ZRxGVr03PA=
X-Received: by 2002:a17:907:7283:b0:a9a:2c27:68c4 with SMTP id
 a640c23a62f3a-a9a69ba642dmr80076166b.35.1729221616555; Thu, 17 Oct 2024
 20:20:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241014201240.DF6F4C4CEC3@smtp.kernel.org> <CAAhV-H5QjycgUOW8R0yY_V27MJMg9k3SRWprBcxTSoA2MAuo7Q@mail.gmail.com>
 <48458888-26d3-4606-3de2-7736c13cb7b9@loongson.cn>
In-Reply-To: <48458888-26d3-4606-3de2-7736c13cb7b9@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 18 Oct 2024 11:20:04 +0800
X-Gmail-Original-Message-ID: <CAAhV-H62FafZGH1jd84nRRx3h=y=RXc-ks7OigdOwnYXCOGsuw@mail.gmail.com>
Message-ID: <CAAhV-H62FafZGH1jd84nRRx3h=y=RXc-ks7OigdOwnYXCOGsuw@mail.gmail.com>
Subject: Re: + mm-define-general-function-pxd_init.patch added to mm-unstable branch
To: maobibo <maobibo@loongson.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, 
	vincenzo.frascino@arm.com, tsbogend@alpha.franken.de, ryabinin.a.a@gmail.com, 
	kernel@xen0n.name, glider@google.com, dvyukov@google.com, 
	andreyknvl@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Andrew,

Please drop this patch temporary because I applied another Bibo's
patch which causes conflict in linux-next:
https://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson.g=
it/commit/?h=3Dloongarch-next&id=3D15832255e84494853f543b4c70ced50afc403067

That patch is urgent and should be merged in 6.12 as soon as possible,
while this refactoring patch is in mm-unstable and target for 6.13.

Bibo will update this patch to V2 later. Thanks.

Huacai

On Tue, Oct 15, 2024 at 11:00=E2=80=AFAM maobibo <maobibo@loongson.cn> wrot=
e:
>
>
>
> On 2024/10/15 =E4=B8=8A=E5=8D=8810:20, Huacai Chen wrote:
> > Hi, Andrew,
> >
> > On Tue, Oct 15, 2024 at 4:12=E2=80=AFAM Andrew Morton <akpm@linux-found=
ation.org> wrote:
> >>
> >>
> >> The patch titled
> >>       Subject: mm: define general function pXd_init()
> >> has been added to the -mm mm-unstable branch.  Its filename is
> >>       mm-define-general-function-pxd_init.patch
> >>
> >> This patch will shortly appear at
> >>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/=
tree/patches/mm-define-general-function-pxd_init.patch
> >>
> >> This patch will later appear in the mm-unstable branch at
> >>      git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> >>
> >> Before you just go and hit "reply", please:
> >>     a) Consider who else should be cc'ed
> >>     b) Prefer to cc a suitable mailing list as well
> >>     c) Ideally: find the original patch on the mailing list and do a
> >>        reply-to-all to that, adding suitable additional cc's
> >>
> >> *** Remember to use Documentation/process/submit-checklist.rst when te=
sting your code ***
> >>
> >> The -mm tree is included into linux-next via the mm-everything
> >> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> >> and is updated there every 2-3 working days
> >>
> >> ------------------------------------------------------
> >> From: Bibo Mao <maobibo@loongson.cn>
> >> Subject: mm: define general function pXd_init()
> >> Date: Fri, 11 Oct 2024 17:33:18 +0800
> >>
> >> pmd_init() and pud_init() are duplicated defined in file kasan.c and
> >> sparse-vmemmap.c as weak functions.  Move them to generic header file
> >> pgtable.h, architecture can redefine them.
> >>
> >> Link: https://lkml.kernel.org/r/20241011093318.519432-1-maobibo@loongs=
on.cn
> >> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >> Cc: Alexander Potapenko <glider@google.com>
> >> Cc: Andrey Konovalov <andreyknvl@gmail.com>
> >> Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> >> Cc: Dmitry Vyukov <dvyukov@google.com>
> >> Cc: Huacai Chen <chenhuacai@kernel.org>
> >> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> >> Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
> >> Cc: WANG Xuerui <kernel@xen0n.name>
> >> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >> ---
> >>
> >>   arch/loongarch/include/asm/pgtable.h |    2 ++
> >>   arch/mips/include/asm/pgtable-64.h   |    2 ++
> >>   include/linux/mm.h                   |    2 --
> >>   include/linux/pgtable.h              |   14 ++++++++++++++
> >>   mm/kasan/init.c                      |    8 --------
> >>   mm/sparse-vmemmap.c                  |    8 --------
> >>   6 files changed, 18 insertions(+), 18 deletions(-)
> >>
> >> --- a/arch/loongarch/include/asm/pgtable.h~mm-define-general-function-=
pxd_init
> >> +++ a/arch/loongarch/include/asm/pgtable.h
> >> @@ -267,7 +267,9 @@ extern void set_pmd_at(struct mm_struct
> >>    * Initialize a new pgd / pud / pmd table with invalid pointers.
> >>    */
> >>   extern void pgd_init(void *addr);
> >> +#define pud_init pud_init
> >>   extern void pud_init(void *addr);
> >> +#define pmd_init pmd_init
> >>   extern void pmd_init(void *addr);
> >>
> >>   /*
> >> --- a/arch/mips/include/asm/pgtable-64.h~mm-define-general-function-px=
d_init
> >> +++ a/arch/mips/include/asm/pgtable-64.h
> >> @@ -316,7 +316,9 @@ static inline pmd_t *pud_pgtable(pud_t p
> >>    * Initialize a new pgd / pud / pmd table with invalid pointers.
> >>    */
> >>   extern void pgd_init(void *addr);
> >> +#define pud_init pud_init
> >>   extern void pud_init(void *addr);
> >> +#define pmd_init pmd_init
> >>   extern void pmd_init(void *addr);
> >>
> >>   /*
> >> --- a/include/linux/mm.h~mm-define-general-function-pxd_init
> >> +++ a/include/linux/mm.h
> >> @@ -3821,8 +3821,6 @@ void *sparse_buffer_alloc(unsigned long
> >>   struct page * __populate_section_memmap(unsigned long pfn,
> >>                  unsigned long nr_pages, int nid, struct vmem_altmap *=
altmap,
> >>                  struct dev_pagemap *pgmap);
> >> -void pmd_init(void *addr);
> >> -void pud_init(void *addr);
> >>   pgd_t *vmemmap_pgd_populate(unsigned long addr, int node);
> >>   p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node=
);
> >>   pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node=
);
> >> --- a/include/linux/pgtable.h~mm-define-general-function-pxd_init
> >> +++ a/include/linux/pgtable.h
> >> @@ -90,6 +90,20 @@ static inline unsigned long pud_index(un
> >>   #define pgd_index(a)  (((a) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
> >>   #endif
> >>
> >> +#ifndef pmd_init
> >> +static inline void pmd_init(void *addr)
> >> +{
> >> +}
> >> +#define pmd_init pmd_init
> >> +#endif
> >> +
> >> +#ifndef pud_init
> >> +static inline void pud_init(void *addr)
> >> +{
> >> +}
> >> +#define pud_init pud_init
> >> +#endif
> > For the fallback implementation, from other examples, it seems we
> > usually don't need something like "#define pmd_init pmd_init".
> However for some examples it is used actually, such as:
>
> #ifndef pmd_index
> static inline unsigned long pmd_index(unsigned long address)
> {
>          return (address >> PMD_SHIFT) & (PTRS_PER_PMD - 1);
> }
> #define pmd_index pmd_index
> #endif
>
> #ifndef pud_index
> static inline unsigned long pud_index(unsigned long address)
> {
>          return (address >> PUD_SHIFT) & (PTRS_PER_PUD - 1);
> }
> #define pud_index pud_index
> #endif
>
> Regards
> Bibo Mao
> >
> > Huacai
> >
> >> +
> >>   #ifndef pte_offset_kernel
> >>   static inline pte_t *pte_offset_kernel(pmd_t *pmd, unsigned long add=
ress)
> >>   {
> >> --- a/mm/kasan/init.c~mm-define-general-function-pxd_init
> >> +++ a/mm/kasan/init.c
> >> @@ -139,10 +139,6 @@ static int __ref zero_pmd_populate(pud_t
> >>          return 0;
> >>   }
> >>
> >> -void __weak __meminit pmd_init(void *addr)
> >> -{
> >> -}
> >> -
> >>   static int __ref zero_pud_populate(p4d_t *p4d, unsigned long addr,
> >>                                  unsigned long end)
> >>   {
> >> @@ -181,10 +177,6 @@ static int __ref zero_pud_populate(p4d_t
> >>          return 0;
> >>   }
> >>
> >> -void __weak __meminit pud_init(void *addr)
> >> -{
> >> -}
> >> -
> >>   static int __ref zero_p4d_populate(pgd_t *pgd, unsigned long addr,
> >>                                  unsigned long end)
> >>   {
> >> --- a/mm/sparse-vmemmap.c~mm-define-general-function-pxd_init
> >> +++ a/mm/sparse-vmemmap.c
> >> @@ -196,10 +196,6 @@ pmd_t * __meminit vmemmap_pmd_populate(p
> >>          return pmd;
> >>   }
> >>
> >> -void __weak __meminit pmd_init(void *addr)
> >> -{
> >> -}
> >> -
> >>   pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long add=
r, int node)
> >>   {
> >>          pud_t *pud =3D pud_offset(p4d, addr);
> >> @@ -213,10 +209,6 @@ pud_t * __meminit vmemmap_pud_populate(p
> >>          return pud;
> >>   }
> >>
> >> -void __weak __meminit pud_init(void *addr)
> >> -{
> >> -}
> >> -
> >>   p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long add=
r, int node)
> >>   {
> >>          p4d_t *p4d =3D p4d_offset(pgd, addr);
> >> _
> >>
> >> Patches currently in -mm which might be from maobibo@loongson.cn are
> >>
> >> mm-define-general-function-pxd_init.patch
> >>
>
