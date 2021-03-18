Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD87CC433E0
	for <mm-commits@archiver.kernel.org>; Thu, 18 Mar 2021 16:16:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B01164F01
	for <mm-commits@archiver.kernel.org>; Thu, 18 Mar 2021 16:16:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbhCRQQC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Mar 2021 12:16:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62362 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232075AbhCRQPq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Thu, 18 Mar 2021 12:15:46 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12IG44f0093863;
        Thu, 18 Mar 2021 12:15:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=z5QOD4aN3B4gbbmyi+4VeIHkic/UQsPMP2xuuFRVWcs=;
 b=BtlwKdNF7Hrx2OXm52cox6CmUhUaPEqw2ebYeHO+LhVdxA3Nu6OQaQhIxciWuCiqbdFV
 n4eSGkI6BWG9Vq4Mr6STd+hJQjXE7DuQdEIRPUziuJlxb2X5f0G50CjBTMG51T1c6TLw
 cdQ2wtgTrAJkiBrbUmS1N4zYObJONdTV3kNXVexPZFVm8oGPeRhjQP6SfI5m2JjRNkBg
 KnX9jIR9Tg2l3fnKfOSgzfvpxQzy4ICPl96W3p8K+A0fq5KaAVntr5vEI5HjuozePzZ3
 Jef5Nfokh96gxP5+HSfce+iT0we/BdzVNZCxBtX8ULwspcn431IlbzF2LzlDKY6BEGsX QQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37bnrfbmg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 12:15:01 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12IG47jY094315;
        Thu, 18 Mar 2021 12:15:00 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37bnrfbmeh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 12:15:00 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12IG9WZU019514;
        Thu, 18 Mar 2021 16:14:56 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 37b6xjgv4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 16:14:56 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12IGEsgm51249596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 16:14:54 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5FE6EAE045;
        Thu, 18 Mar 2021 16:14:54 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD4D4AE055;
        Thu, 18 Mar 2021 16:14:48 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.145.165.64])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 18 Mar 2021 16:14:48 +0000 (GMT)
Date:   Thu, 18 Mar 2021 18:14:46 +0200
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     akpm@linux-foundation.org
Cc:     arnd@arndb.de, bp@alien8.de, catalin.marinas@arm.com, cl@linux.com,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        david@redhat.com, elena.reshetova@intel.com, guro@fb.com,
        hagen@jauu.net, hpa@zytor.com, jejb@linux.ibm.com,
        kirill@shutemov.name, luto@kernel.org, mark.rutland@arm.com,
        mingo@redhat.com, mm-commits@vger.kernel.org,
        mtk.manpages@gmail.com, palmer@dabbelt.com,
        palmerdabbelt@google.com, paul.walmsley@sifive.com,
        peterz@infradead.org, rick.p.edgecombe@intel.com,
        shakeelb@google.com, shuah@kernel.org, tglx@linutronix.de,
        tycho@tycho.ws, viro@zeniv.linux.org.uk, will@kernel.org,
        willy@infradead.org
Subject: Re: + mm-add-definition-of-pmd_page_order.patch added to -mm tree
Message-ID: <YFN8dl3ncdXdxytD@linux.ibm.com>
References: <20210317221512.A39Ft3LQk%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210317221512.A39Ft3LQk%akpm@linux-foundation.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_09:2021-03-17,2021-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 clxscore=1011 spamscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103180112
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi Andrew,

This patch is not required for this version of the set, I've just been
dragging it over from the previous versions.

Can you please just drop it and then we'll sort out DAX vs architectures
dispute unrelated to this series?

Sorry for the hassle.

On Wed, Mar 17, 2021 at 03:15:12PM -0700, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: mm: add definition of PMD_PAGE_ORDER
> has been added to the -mm tree.  Its filename is
>      mm-add-definition-of-pmd_page_order.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/mm-add-definition-of-pmd_page_order.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/mm-add-definition-of-pmd_page_order.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Mike Rapoport <rppt@linux.ibm.com>
> Subject: mm: add definition of PMD_PAGE_ORDER
> 
> Patch series "mm: introduce memfd_secret system call to create "secret" memory areas", v18.
> 
> This is an implementation of "secret" mappings backed by a file
> descriptor.
> 
> The file descriptor backing secret memory mappings is created using a
> dedicated memfd_secret system call The desired protection mode for the
> memory is configured using flags parameter of the system call.  The mmap()
> of the file descriptor created with memfd_secret() will create a "secret"
> memory mapping.  The pages in that mapping will be marked as not present
> in the direct map and will be present only in the page table of the owning
> mm.
> 
> Although normally Linux userspace mappings are protected from other users,
> such secret mappings are useful for environments where a hostile tenant is
> trying to trick the kernel into giving them access to other tenants
> mappings.
> 
> Additionally, in the future the secret mappings may be used as a mean to
> protect guest memory in a virtual machine host.
> 
> For demonstration of secret memory usage we've created a userspace library
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/jejb/secret-memory-preloader.git
> 
> that does two things: the first is act as a preloader for openssl to
> redirect all the OPENSSL_malloc calls to secret memory meaning any secret
> keys get automatically protected this way and the other thing it does is
> expose the API to the user who needs it.  We anticipate that a lot of the
> use cases would be like the openssl one: many toolkits that deal with
> secret keys already have special handling for the memory to try to give
> them greater protection, so this would simply be pluggable into the
> toolkits without any need for user application modification.
> 
> Hiding secret memory mappings behind an anonymous file allows usage of the
> page cache for tracking pages allocated for the "secret" mappings as well
> as using address_space_operations for e.g.  page migration callbacks.
> 
> The anonymous file may be also used implicitly, like hugetlb files, to
> implement mmap(MAP_SECRET) and use the secret memory areas with "native"
> mm ABIs in the future.
> 
> Removing of the pages from the direct map may cause its fragmentation on
> architectures that use large pages to map the physical memory which
> affects the system performance.  However, the original Kconfig text for
> CONFIG_DIRECT_GBPAGES said that gigabyte pages in the direct map "...  can
> improve the kernel's performance a tiny bit ..." (commit 00d1c5e05736
> ("x86: add gbpages switches")) and the recent report [1] showed that "... 
> although 1G mappings are a good default choice, there is no compelling
> evidence that it must be the only choice".  Hence, it is sufficient to
> have secretmem disabled by default with the ability of a system
> administrator to enable it at boot time.
> 
> In addition, there is also a long term goal to improve management of the
> direct map.
> 
> [1] https://lore.kernel.org/linux-mm/213b4567-46ce-f116-9cdf-bbd0c884eb3c@linux.intel.com/
> 
> 
> This patch (of 9):
> 
> The definition of PMD_PAGE_ORDER denoting the number of base pages in the
> second-level leaf page is already used by DAX and maybe handy in other
> cases as well.
> 
> Several architectures already have definition of PMD_ORDER as the size of
> second level page table, so to avoid conflict with these definitions use
> PMD_PAGE_ORDER name and update DAX respectively.
> 
> Link: https://lkml.kernel.org/r/20210303162209.8609-1-rppt@kernel.org
> Link: https://lkml.kernel.org/r/20210303162209.8609-2-rppt@kernel.org
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Christopher Lameter <cl@linux.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Elena Reshetova <elena.reshetova@intel.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: James Bottomley <jejb@linux.ibm.com>
> Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Michael Kerrisk <mtk.manpages@gmail.com>
> Cc: Palmer Dabbelt <palmer@dabbelt.com>
> Cc: Paul Walmsley <paul.walmsley@sifive.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Tycho Andersen <tycho@tycho.ws>
> Cc: Will Deacon <will@kernel.org>
> Cc: Hagen Paul Pfeifer <hagen@jauu.net>
> Cc: Palmer Dabbelt <palmerdabbelt@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/dax.c                |   11 ++++-------
>  include/linux/pgtable.h |    3 +++
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> --- a/fs/dax.c~mm-add-definition-of-pmd_page_order
> +++ a/fs/dax.c
> @@ -49,9 +49,6 @@ static inline unsigned int pe_order(enum
>  #define PG_PMD_COLOUR	((PMD_SIZE >> PAGE_SHIFT) - 1)
>  #define PG_PMD_NR	(PMD_SIZE >> PAGE_SHIFT)
>  
> -/* The order of a PMD entry */
> -#define PMD_ORDER	(PMD_SHIFT - PAGE_SHIFT)
> -
>  static wait_queue_head_t wait_table[DAX_WAIT_TABLE_ENTRIES];
>  
>  static int __init init_dax_wait_table(void)
> @@ -98,7 +95,7 @@ static bool dax_is_locked(void *entry)
>  static unsigned int dax_entry_order(void *entry)
>  {
>  	if (xa_to_value(entry) & DAX_PMD)
> -		return PMD_ORDER;
> +		return PMD_PAGE_ORDER;
>  	return 0;
>  }
>  
> @@ -1471,7 +1468,7 @@ static vm_fault_t dax_iomap_pmd_fault(st
>  {
>  	struct vm_area_struct *vma = vmf->vma;
>  	struct address_space *mapping = vma->vm_file->f_mapping;
> -	XA_STATE_ORDER(xas, &mapping->i_pages, vmf->pgoff, PMD_ORDER);
> +	XA_STATE_ORDER(xas, &mapping->i_pages, vmf->pgoff, PMD_PAGE_ORDER);
>  	unsigned long pmd_addr = vmf->address & PMD_MASK;
>  	bool write = vmf->flags & FAULT_FLAG_WRITE;
>  	bool sync;
> @@ -1530,7 +1527,7 @@ static vm_fault_t dax_iomap_pmd_fault(st
>  	 * entry is already in the array, for instance), it will return
>  	 * VM_FAULT_FALLBACK.
>  	 */
> -	entry = grab_mapping_entry(&xas, mapping, PMD_ORDER);
> +	entry = grab_mapping_entry(&xas, mapping, PMD_PAGE_ORDER);
>  	if (xa_is_internal(entry)) {
>  		result = xa_to_internal(entry);
>  		goto fallback;
> @@ -1696,7 +1693,7 @@ dax_insert_pfn_mkwrite(struct vm_fault *
>  	if (order == 0)
>  		ret = vmf_insert_mixed_mkwrite(vmf->vma, vmf->address, pfn);
>  #ifdef CONFIG_FS_DAX_PMD
> -	else if (order == PMD_ORDER)
> +	else if (order == PMD_PAGE_ORDER)
>  		ret = vmf_insert_pfn_pmd(vmf, pfn, FAULT_FLAG_WRITE);
>  #endif
>  	else
> --- a/include/linux/pgtable.h~mm-add-definition-of-pmd_page_order
> +++ a/include/linux/pgtable.h
> @@ -28,6 +28,9 @@
>  #define USER_PGTABLES_CEILING	0UL
>  #endif
>  
> +/* Number of base pages in a second level leaf page */
> +#define PMD_PAGE_ORDER	(PMD_SHIFT - PAGE_SHIFT)
> +
>  /*
>   * A page table page can be thought of an array like this: pXd_t[PTRS_PER_PxD]
>   *
> _
> 
> Patches currently in -mm which might be from rppt@linux.ibm.com are
> 
> mm-add-definition-of-pmd_page_order.patch
> mmap-make-mlock_future_check-global.patch
> riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch
> set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch
> set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
> mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
> pm-hibernate-disable-when-there-are-active-secretmem-users.patch
> arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch
> secretmem-test-add-basic-selftest-for-memfd_secret2.patch
> 

-- 
Sincerely yours,
Mike.
