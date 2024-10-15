Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 165CE535DC
	for <mm-commits@vger.kernel.org>; Tue, 15 Oct 2024 03:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728961209; cv=none; b=LIcVbh108qweCpnoqRpjQF8L2xWwZwyb5OQ+UCuzEKtHzWfQNZ/jgNyjkmUY/VlA3NoOPfFZv2mvEy77+dtT2P6TuM2+Z8H2xw+cft9SAZcyClhdCzMhgI8Y9fBfV7yII0yxf47kZnZfjRYa7ZFJQ8CKlfh7+pX/bFYHBN6R1UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728961209; c=relaxed/simple;
	bh=G/DPZcDgGKWDzSS107QtYRyacGo7jQpGBt2FzZqCf8A=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Tj0Cd1LX2Poi2aA9BSb/coEYkaJLFQs8lrY/aH6pGMsQ0YdJOiTowlz/C6xjd+SRYNmJXAZsabonXTdUq1QcmUkSkb3aObGPQ3XqjpfH02yuplunM3Zxw1cvGop0pwki5yDDGPS/Y6Iw2PK15v+woHBJZFqS42fySglC81XdG08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8AxvvCz2g1nlowcAA--.42206S3;
	Tue, 15 Oct 2024 11:00:03 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMBxXuSs2g1nF1IqAA--.8614S3;
	Tue, 15 Oct 2024 10:59:57 +0800 (CST)
Subject: Re: + mm-define-general-function-pxd_init.patch added to mm-unstable
 branch
To: Huacai Chen <chenhuacai@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
 tsbogend@alpha.franken.de, ryabinin.a.a@gmail.com, kernel@xen0n.name,
 glider@google.com, dvyukov@google.com, andreyknvl@gmail.com
References: <20241014201240.DF6F4C4CEC3@smtp.kernel.org>
 <CAAhV-H5QjycgUOW8R0yY_V27MJMg9k3SRWprBcxTSoA2MAuo7Q@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <48458888-26d3-4606-3de2-7736c13cb7b9@loongson.cn>
Date: Tue, 15 Oct 2024 10:59:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H5QjycgUOW8R0yY_V27MJMg9k3SRWprBcxTSoA2MAuo7Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxXuSs2g1nF1IqAA--.8614S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3Ary8Wr4fWF15CFyxWF48AFc_yoWxCF4DpF
	9IkF1ktw48Jrs3Cwsagw15Cr17Xws3Kr1fKwnrJryrAas0vrsrJr1vqw4S9FW8WrW093WF
	yF4agas3u3WUZrgCm3ZEXasCq-sJn29KB7ZKAUJUUUUx529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1ln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
	xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q
	6rW5McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
	1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jz5lbUUU
	UU=



On 2024/10/15 上午10:20, Huacai Chen wrote:
> Hi, Andrew,
> 
> On Tue, Oct 15, 2024 at 4:12 AM Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>>
>> The patch titled
>>       Subject: mm: define general function pXd_init()
>> has been added to the -mm mm-unstable branch.  Its filename is
>>       mm-define-general-function-pxd_init.patch
>>
>> This patch will shortly appear at
>>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-define-general-function-pxd_init.patch
>>
>> This patch will later appear in the mm-unstable branch at
>>      git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>
>> Before you just go and hit "reply", please:
>>     a) Consider who else should be cc'ed
>>     b) Prefer to cc a suitable mailing list as well
>>     c) Ideally: find the original patch on the mailing list and do a
>>        reply-to-all to that, adding suitable additional cc's
>>
>> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>>
>> The -mm tree is included into linux-next via the mm-everything
>> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>> and is updated there every 2-3 working days
>>
>> ------------------------------------------------------
>> From: Bibo Mao <maobibo@loongson.cn>
>> Subject: mm: define general function pXd_init()
>> Date: Fri, 11 Oct 2024 17:33:18 +0800
>>
>> pmd_init() and pud_init() are duplicated defined in file kasan.c and
>> sparse-vmemmap.c as weak functions.  Move them to generic header file
>> pgtable.h, architecture can redefine them.
>>
>> Link: https://lkml.kernel.org/r/20241011093318.519432-1-maobibo@loongson.cn
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> Cc: Alexander Potapenko <glider@google.com>
>> Cc: Andrey Konovalov <andreyknvl@gmail.com>
>> Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
>> Cc: Dmitry Vyukov <dvyukov@google.com>
>> Cc: Huacai Chen <chenhuacai@kernel.org>
>> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
>> Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
>> Cc: WANG Xuerui <kernel@xen0n.name>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>
>>   arch/loongarch/include/asm/pgtable.h |    2 ++
>>   arch/mips/include/asm/pgtable-64.h   |    2 ++
>>   include/linux/mm.h                   |    2 --
>>   include/linux/pgtable.h              |   14 ++++++++++++++
>>   mm/kasan/init.c                      |    8 --------
>>   mm/sparse-vmemmap.c                  |    8 --------
>>   6 files changed, 18 insertions(+), 18 deletions(-)
>>
>> --- a/arch/loongarch/include/asm/pgtable.h~mm-define-general-function-pxd_init
>> +++ a/arch/loongarch/include/asm/pgtable.h
>> @@ -267,7 +267,9 @@ extern void set_pmd_at(struct mm_struct
>>    * Initialize a new pgd / pud / pmd table with invalid pointers.
>>    */
>>   extern void pgd_init(void *addr);
>> +#define pud_init pud_init
>>   extern void pud_init(void *addr);
>> +#define pmd_init pmd_init
>>   extern void pmd_init(void *addr);
>>
>>   /*
>> --- a/arch/mips/include/asm/pgtable-64.h~mm-define-general-function-pxd_init
>> +++ a/arch/mips/include/asm/pgtable-64.h
>> @@ -316,7 +316,9 @@ static inline pmd_t *pud_pgtable(pud_t p
>>    * Initialize a new pgd / pud / pmd table with invalid pointers.
>>    */
>>   extern void pgd_init(void *addr);
>> +#define pud_init pud_init
>>   extern void pud_init(void *addr);
>> +#define pmd_init pmd_init
>>   extern void pmd_init(void *addr);
>>
>>   /*
>> --- a/include/linux/mm.h~mm-define-general-function-pxd_init
>> +++ a/include/linux/mm.h
>> @@ -3821,8 +3821,6 @@ void *sparse_buffer_alloc(unsigned long
>>   struct page * __populate_section_memmap(unsigned long pfn,
>>                  unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
>>                  struct dev_pagemap *pgmap);
>> -void pmd_init(void *addr);
>> -void pud_init(void *addr);
>>   pgd_t *vmemmap_pgd_populate(unsigned long addr, int node);
>>   p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
>>   pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
>> --- a/include/linux/pgtable.h~mm-define-general-function-pxd_init
>> +++ a/include/linux/pgtable.h
>> @@ -90,6 +90,20 @@ static inline unsigned long pud_index(un
>>   #define pgd_index(a)  (((a) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
>>   #endif
>>
>> +#ifndef pmd_init
>> +static inline void pmd_init(void *addr)
>> +{
>> +}
>> +#define pmd_init pmd_init
>> +#endif
>> +
>> +#ifndef pud_init
>> +static inline void pud_init(void *addr)
>> +{
>> +}
>> +#define pud_init pud_init
>> +#endif
> For the fallback implementation, from other examples, it seems we
> usually don't need something like "#define pmd_init pmd_init".
However for some examples it is used actually, such as:

#ifndef pmd_index
static inline unsigned long pmd_index(unsigned long address)
{
         return (address >> PMD_SHIFT) & (PTRS_PER_PMD - 1);
}
#define pmd_index pmd_index
#endif

#ifndef pud_index
static inline unsigned long pud_index(unsigned long address)
{
         return (address >> PUD_SHIFT) & (PTRS_PER_PUD - 1);
}
#define pud_index pud_index
#endif

Regards
Bibo Mao
> 
> Huacai
> 
>> +
>>   #ifndef pte_offset_kernel
>>   static inline pte_t *pte_offset_kernel(pmd_t *pmd, unsigned long address)
>>   {
>> --- a/mm/kasan/init.c~mm-define-general-function-pxd_init
>> +++ a/mm/kasan/init.c
>> @@ -139,10 +139,6 @@ static int __ref zero_pmd_populate(pud_t
>>          return 0;
>>   }
>>
>> -void __weak __meminit pmd_init(void *addr)
>> -{
>> -}
>> -
>>   static int __ref zero_pud_populate(p4d_t *p4d, unsigned long addr,
>>                                  unsigned long end)
>>   {
>> @@ -181,10 +177,6 @@ static int __ref zero_pud_populate(p4d_t
>>          return 0;
>>   }
>>
>> -void __weak __meminit pud_init(void *addr)
>> -{
>> -}
>> -
>>   static int __ref zero_p4d_populate(pgd_t *pgd, unsigned long addr,
>>                                  unsigned long end)
>>   {
>> --- a/mm/sparse-vmemmap.c~mm-define-general-function-pxd_init
>> +++ a/mm/sparse-vmemmap.c
>> @@ -196,10 +196,6 @@ pmd_t * __meminit vmemmap_pmd_populate(p
>>          return pmd;
>>   }
>>
>> -void __weak __meminit pmd_init(void *addr)
>> -{
>> -}
>> -
>>   pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node)
>>   {
>>          pud_t *pud = pud_offset(p4d, addr);
>> @@ -213,10 +209,6 @@ pud_t * __meminit vmemmap_pud_populate(p
>>          return pud;
>>   }
>>
>> -void __weak __meminit pud_init(void *addr)
>> -{
>> -}
>> -
>>   p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node)
>>   {
>>          p4d_t *p4d = p4d_offset(pgd, addr);
>> _
>>
>> Patches currently in -mm which might be from maobibo@loongson.cn are
>>
>> mm-define-general-function-pxd_init.patch
>>

