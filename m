Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_RED,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CA06C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 28 Dec 2020 18:00:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FBCD22AAD
	for <mm-commits@archiver.kernel.org>; Mon, 28 Dec 2020 18:00:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgL1SA2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Dec 2020 13:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728331AbgL1SA0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Dec 2020 13:00:26 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B10C0613D6
        for <mm-commits@vger.kernel.org>; Mon, 28 Dec 2020 09:59:46 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id h16so10460359edt.7
        for <mm-commits@vger.kernel.org>; Mon, 28 Dec 2020 09:59:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ck6rcfso3sn2GdrLOlKXguxLVMHHDgxPWhphhFOCm6M=;
        b=LlQ6/Uhxg/sBeUvln4jLwvh9GGzK0PBu85L4PgB6rL6SvofSuvhC5obYBW9ZOqip/D
         secro/vSGhKM51bsB7KRf78CnsmnUFEsR2HXl5wF55ilTWKbSP91GhyibeqqpXmQz3MA
         837LkLhUNe+hVwcS0CiXRDoE6GAMYo1khG1ekTfKdvWRmUkGPPNUyM1O/+XGay7gWeH7
         g1K8bNpPH2jQXevENEq1KtH5QUt/04IJxku/2vj265mNRezwngXh9h+ZC87U43XZ3XCu
         BPDEDoNy6KL5y8nGc7tI5/Tzgn4vCqOI95PZ+WXtLbDWItr2O6ItxnOVIAd5+q///aaW
         3NTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ck6rcfso3sn2GdrLOlKXguxLVMHHDgxPWhphhFOCm6M=;
        b=PrwFEcwJltij6vY3FV3tn3+9MCFicTt2pj4UcGIEfLtdrbOXvtGRL59KQ+zIclCSwB
         892qAexI2d1OjmA3CDBuTGGUPeC12KsG1SZ+qUGj1LJKHoYc9h1UzAWZ4/NHOpj8w8Lh
         er18OAiz3WEeq9jNnCW7uM0h2lNa8ew7tHVFScn4RTMo3pDg0Kbk8z0MvSGAYCT5BwF1
         LdEedXoVXuMBIrBX1KF3gBbUuiPCed2oW5y/zAO6Ri2iwTQn8u2VpklukQK4SL7av80U
         DxaQXk9rFGqo6YzjnyUGik0aXPWrq47lWr3V1tS07iKMU4qpWYMP/hm6qFToRIKE7TBn
         vhxw==
X-Gm-Message-State: AOAM53364NOmn/rxvDuQIRFSwrcjR+zzkRyrJasu9inszfAv3d7aOXto
        4yYU4QAhGVJC3yzF+05zDrvfCp9niI+1VSTH/6k1Dw==
X-Google-Smtp-Source: ABdhPJw11OpPXV/C7ii4wCX4PmEFrYLmouM2YXQ7jgD6vk7HnfnC5Vj0UW9lc5SdTqzWPzyaHodxKBUp4CVKhvx4WBk=
X-Received: by 2002:a50:b5c5:: with SMTP id a63mr42925069ede.227.1609178385092;
 Mon, 28 Dec 2020 09:59:45 -0800 (PST)
MIME-Version: 1.0
References: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org> <20201215030813.I8VAWZGRf%akpm@linux-foundation.org>
In-Reply-To: <20201215030813.I8VAWZGRf%akpm@linux-foundation.org>
From:   Brian Geffon <bgeffon@google.com>
Date:   Mon, 28 Dec 2020 09:59:09 -0800
Message-ID: <CADyq12wazXkA=puWxs_i8onFVo5YKf6roU_Lh68v_nQ7uSUJZA@mail.gmail.com>
Subject: Re: [patch 086/200] mremap: don't allow MREMAP_DONTUNMAP on
 special_mappings and aio
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     catalin.marinas@arm.com, dan.carpenter@oracle.com,
        dan.j.williams@intel.com, dave.jiang@intel.com, dima@arista.com,
        Hugh Dickins <hughd@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, jhubbard@nvidia.com,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-mm <linux-mm@kvack.org>, linux@armlinux.org.uk,
        luto@kernel.org, Mike Kravetz <mike.kravetz@oracle.com>,
        Minchan Kim <minchan@kernel.org>, mingo@redhat.com,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com,
        tglx@linutronix.de, Linus Torvalds <torvalds@linux-foundation.org>,
        tsbogend@alpha.franken.de, Vlastimil Babka <vbabka@suse.cz>,
        viro@zeniv.linux.org.uk, vishal.l.verma@intel.com,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

I don't think this situation can ever happen MREMAP_DONTUNMAP is
already restricted to anonymous mappings (defined as not having
vm_ops) and vma_to_resize checks that the mapping is anonymous before
move_vma is called.


On Mon, Dec 14, 2020 at 7:08 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> From: Dmitry Safonov <dima@arista.com>
> Subject: mremap: don't allow MREMAP_DONTUNMAP on special_mappings and aio
>
> As kernel expect to see only one of such mappings, any further operations
> on the VMA-copy may be unexpected by the kernel.  Maybe it's being on the
> safe side, but there doesn't seem to be any expected use-case for this, so
> restrict it now.
>
> Link: https://lkml.kernel.org/r/20201013013416.390574-4-dima@arista.com
> Fixes: commit e346b3813067 ("mm/mremap: add MREMAP_DONTUNMAP to mremap()")
> Signed-off-by: Dmitry Safonov <dima@arista.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Brian Geffon <bgeffon@google.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Cc: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Will Deacon <will@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  arch/x86/kernel/cpu/resctrl/pseudo_lock.c |    2 +-
>  fs/aio.c                                  |    5 ++++-
>  include/linux/mm.h                        |    2 +-
>  mm/mmap.c                                 |    6 +++++-
>  mm/mremap.c                               |    2 +-
>  5 files changed, 12 insertions(+), 5 deletions(-)
>
> --- a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c~mremap-dont-allow-mremap_dontunmap-on-special_mappings-and-aio
> +++ a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
> @@ -1458,7 +1458,7 @@ static int pseudo_lock_dev_release(struc
>         return 0;
>  }
>
> -static int pseudo_lock_dev_mremap(struct vm_area_struct *area)
> +static int pseudo_lock_dev_mremap(struct vm_area_struct *area, unsigned long flags)
>  {
>         /* Not supported */
>         return -EINVAL;
> --- a/fs/aio.c~mremap-dont-allow-mremap_dontunmap-on-special_mappings-and-aio
> +++ a/fs/aio.c
> @@ -324,13 +324,16 @@ static void aio_free_ring(struct kioctx
>         }
>  }
>
> -static int aio_ring_mremap(struct vm_area_struct *vma)
> +static int aio_ring_mremap(struct vm_area_struct *vma, unsigned long flags)
>  {
>         struct file *file = vma->vm_file;
>         struct mm_struct *mm = vma->vm_mm;
>         struct kioctx_table *table;
>         int i, res = -EINVAL;
>
> +       if (flags & MREMAP_DONTUNMAP)
> +               return -EINVAL;
> +
>         spin_lock(&mm->ioctx_lock);
>         rcu_read_lock();
>         table = rcu_dereference(mm->ioctx_table);
> --- a/include/linux/mm.h~mremap-dont-allow-mremap_dontunmap-on-special_mappings-and-aio
> +++ a/include/linux/mm.h
> @@ -558,7 +558,7 @@ struct vm_operations_struct {
>         void (*open)(struct vm_area_struct * area);
>         void (*close)(struct vm_area_struct * area);
>         int (*split)(struct vm_area_struct * area, unsigned long addr);
> -       int (*mremap)(struct vm_area_struct * area);
> +       int (*mremap)(struct vm_area_struct *area, unsigned long flags);
>         vm_fault_t (*fault)(struct vm_fault *vmf);
>         vm_fault_t (*huge_fault)(struct vm_fault *vmf,
>                         enum page_entry_size pe_size);
> --- a/mm/mmap.c~mremap-dont-allow-mremap_dontunmap-on-special_mappings-and-aio
> +++ a/mm/mmap.c
> @@ -3405,10 +3405,14 @@ static const char *special_mapping_name(
>         return ((struct vm_special_mapping *)vma->vm_private_data)->name;
>  }
>
> -static int special_mapping_mremap(struct vm_area_struct *new_vma)
> +static int special_mapping_mremap(struct vm_area_struct *new_vma,
> +                                 unsigned long flags)
>  {
>         struct vm_special_mapping *sm = new_vma->vm_private_data;
>
> +       if (flags & MREMAP_DONTUNMAP)
> +               return -EINVAL;
> +
>         if (WARN_ON_ONCE(current->mm != new_vma->vm_mm))
>                 return -EFAULT;
>
> --- a/mm/mremap.c~mremap-dont-allow-mremap_dontunmap-on-special_mappings-and-aio
> +++ a/mm/mremap.c
> @@ -534,7 +534,7 @@ static unsigned long move_vma(struct vm_
>         if (moved_len < old_len) {
>                 err = -ENOMEM;
>         } else if (vma->vm_ops && vma->vm_ops->mremap) {
> -               err = vma->vm_ops->mremap(new_vma);
> +               err = vma->vm_ops->mremap(new_vma, flags);
>         }
>
>         if (unlikely(err)) {
> _
