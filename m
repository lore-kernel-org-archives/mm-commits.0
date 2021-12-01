Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BEB3C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  1 Dec 2021 15:35:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235044AbhLAPjL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Dec 2021 10:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234031AbhLAPjK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Dec 2021 10:39:10 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A88C061574
        for <mm-commits@vger.kernel.org>; Wed,  1 Dec 2021 07:35:50 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id g18so24861406pfk.5
        for <mm-commits@vger.kernel.org>; Wed, 01 Dec 2021 07:35:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sVoQLW2O/c7POV+OuqtGhYI0GlJYcvnMhFp9yvw8p1Q=;
        b=ejFItBtDIy5Z6Ozkx1MnBrC9TBvvG9yNM5aR1pS/KFISW31ZdWXM38Y0VUgPcsyX0i
         3JWOwyoa1uQEdWtp6xpSAbnzS7JJmRQ1BgMZ+o7xIVA0LoKWmPCIIeQXm4IzeKhyRb8l
         g8V2nD0RkrlfQdCdRkdSeWm6/WJrRugI8CeTtPCRccqokVI4UTyYwTSNhcidC1pHIXY5
         RIvmB+ysRg6IRheaexCg+IS3E0k+degIxT8XUyNo+TTpWJzdD8+b88geqKPuXPd4Y05S
         sfOTwoOznupCpMMaZAqy8RUoZ8Nf4XhWrlSGaVbTnUZzV/5f5NhPaAFURovC6aD64mcL
         LRqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sVoQLW2O/c7POV+OuqtGhYI0GlJYcvnMhFp9yvw8p1Q=;
        b=jSNxvJmZY0+NA/fu+q8z9GWNTBtaSgaJxYvXrR6IaMLvPJnynBqvBez6RmoJ3bZp1b
         6CI2Hj+FJ9bYrvVz8xb1XnRR+Qh+VYhAFUvoZyjdYYgl5GGOALJUj829NmDt5zZRO4pm
         MHvOzFEJHykC6pw2Z3iPzKCTqTmxe+69KDh69pc4qYt/E28D2v5HI3mtw0KWMFFcW3wz
         hc5mriQMShwwkxh+jeIGvNm+1hTq2QQf1ZsOEMk9xHPMi5CO8Rc30y7PEHry04TJvodW
         RhNOQDjW3NnTzi0RX3WrWHdoLegN1lLGeGIMaM8v6dlDYdj6DNe1mlYb0b8LKB5fDHMt
         J7/A==
X-Gm-Message-State: AOAM5315a9JQxraZ0j3YIuc3cE8II5PEl1XyZtREXuoEK9qOjjlH2AIA
        /W7cVaHuLZr9ArNifK4eadM=
X-Google-Smtp-Source: ABdhPJy7jyeO29YrkiNV2VUPxSaXjdJ0e2qBMHc7kISKrZL+0WflZvDFKPijgvjsLUdAXodzmm5meg==
X-Received: by 2002:a63:f008:: with SMTP id k8mr5141145pgh.189.1638372949493;
        Wed, 01 Dec 2021 07:35:49 -0800 (PST)
Received: from gmail.com (113x33x71x97.ap113.ftth.ucom.ne.jp. [113.33.71.97])
        by smtp.gmail.com with ESMTPSA id t4sm180674pfj.168.2021.12.01.07.35.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 07:35:49 -0800 (PST)
Date:   Thu, 2 Dec 2021 00:35:45 +0900
From:   Akira Kawata <akirakawata1@gmail.com>
To:     akpm@linux-foundation.org
Cc:     adobriyan@gmail.com, ebiederm@xmission.com, keescook@chromium.org,
        lkp@intel.com, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: + fs-binfmt_elf-fix-at_phdr-for-unusual-elf-files.patch added to
 -mm tree
Message-ID: <20211201153545.wm5neiutzkgzok3s@gmail.com>
References: <20211201025557.06m1gJAyY%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201025557.06m1gJAyY%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Nov 30, 2021 at 06:55:57PM -0800, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: fs/binfmt_elf: Fix AT_PHDR for unusual ELF files
> has been added to the -mm tree.  Its filename is
>      fs-binfmt_elf-fix-at_phdr-for-unusual-elf-files.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/fs-binfmt_elf-fix-at_phdr-for-unusual-elf-files.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/fs-binfmt_elf-fix-at_phdr-for-unusual-elf-files.patch
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
> From: Akira Kawata <akirakawata1@gmail.com>
> Subject: fs/binfmt_elf: Fix AT_PHDR for unusual ELF files
> 
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=197921
> 
> As pointed out in the discussion of buglink, we cannot calculate AT_PHDR
> as the sum of load_addr and exec->e_phoff.
> 
> : The AT_PHDR of ELF auxiliary vectors should point to the memory address of
> : program header. But binfmt_elf.c calculates this address as follows:
> : 
> : NEW_AUX_ENT(AT_PHDR, load_addr + exec->e_phoff);
> : 
> : which is wrong since e_phoff is the file offset of program header and
> : load_addr is the memory base address from PT_LOAD entry.
> : 
> : The ld.so uses AT_PHDR as the memory address of program header.  In normal
> : case, since the e_phoff is usually 64 and in the first PT_LOAD region, it
> : is the correct program header address.
> : 
> : But if the address of program header isn't equal to the first PT_LOAD
> : address + e_phoff (e.g.  Put the program header in other non-consecutive
> : PT_LOAD region), ld.so will try to read program header from wrong address
> : then crash or use incorrect program header.
> 
> This is because exec->e_phoff
> is the offset of PHDRs in the file and the address of PHDRs in the
> memory may differ from it. This patch fixes the bug by calculating the
> address of program headers from PT_LOADs directly.
> 
> Link: https://lkml.kernel.org/r/20211130115906.414176-1-akirakawata1@gmail.com
> Signed-off-by: Akira Kawata <akirakawata1@gmail.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Eric Biederman <ebiederm@xmission.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/binfmt_elf.c |   20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> --- a/fs/binfmt_elf.c~fs-binfmt_elf-fix-at_phdr-for-unusual-elf-files
> +++ a/fs/binfmt_elf.c
> @@ -170,8 +170,8 @@ static int padzero(unsigned long elf_bss
>  
>  static int
>  create_elf_tables(struct linux_binprm *bprm, const struct elfhdr *exec,
> -		unsigned long load_addr, unsigned long interp_load_addr,
> -		unsigned long e_entry)
> +		unsigned long interp_load_addr,
> +		unsigned long e_entry, unsigned long phdr_addr)
>  {
>  	struct mm_struct *mm = current->mm;
>  	unsigned long p = bprm->p;
> @@ -257,7 +257,7 @@ create_elf_tables(struct linux_binprm *b
>  	NEW_AUX_ENT(AT_HWCAP, ELF_HWCAP);
>  	NEW_AUX_ENT(AT_PAGESZ, ELF_EXEC_PAGESIZE);
>  	NEW_AUX_ENT(AT_CLKTCK, CLOCKS_PER_SEC);
> -	NEW_AUX_ENT(AT_PHDR, load_addr + exec->e_phoff);
> +	NEW_AUX_ENT(AT_PHDR, phdr_addr);
>  	NEW_AUX_ENT(AT_PHENT, sizeof(struct elf_phdr));
>  	NEW_AUX_ENT(AT_PHNUM, exec->e_phnum);
>  	NEW_AUX_ENT(AT_BASE, interp_load_addr);
> @@ -823,7 +823,7 @@ static int parse_elf_properties(struct f
>  static int load_elf_binary(struct linux_binprm *bprm)
>  {
>  	struct file *interpreter = NULL; /* to shut gcc up */
> - 	unsigned long load_addr = 0, load_bias = 0;
> +	unsigned long load_addr, load_bias = 0, phdr_addr = 0;
>  	int load_addr_set = 0;
>  	unsigned long error;
>  	struct elf_phdr *elf_ppnt, *elf_phdata, *interp_elf_phdata = NULL;
> @@ -1169,6 +1169,13 @@ out_free_interp:
>  				reloc_func_desc = load_bias;
>  			}
>  		}
> +
> +		if (elf_ppnt->p_offset <= elf_ex->e_phoff &&
> +		    elf_ex->e_phoff < elf_ppnt->p_offset + elf_ppnt->p_filesz) {
> +			phdr_addr = elf_ex->e_phoff - elf_ppnt->p_offset +
> +				    elf_ppnt->p_vaddr;
> +		}
> +
>  		k = elf_ppnt->p_vaddr;
>  		if ((elf_ppnt->p_flags & PF_X) && k < start_code)
>  			start_code = k;
> @@ -1204,6 +1211,7 @@ out_free_interp:
>  	}
>  
>  	e_entry = elf_ex->e_entry + load_bias;
> +	phdr_addr += load_bias;
>  	elf_bss += load_bias;
>  	elf_brk += load_bias;
>  	start_code += load_bias;
> @@ -1267,8 +1275,8 @@ out_free_interp:
>  		goto out;
>  #endif /* ARCH_HAS_SETUP_ADDITIONAL_PAGES */
>  
> -	retval = create_elf_tables(bprm, elf_ex,
> -			  load_addr, interp_load_addr, e_entry);
> +	retval = create_elf_tables(bprm, elf_ex, interp_load_addr,
> +				   e_entry, phdr_addr);
>  	if (retval < 0)
>  		goto out;
>  
> _
> 
> Patches currently in -mm which might be from akirakawata1@gmail.com are
> 
> fs-binfmt_elf-fix-at_phdr-for-unusual-elf-files.patch
> 

Thank you.

Akira
